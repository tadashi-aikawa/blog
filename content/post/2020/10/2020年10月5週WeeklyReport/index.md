---
title: 2020年10月5週 Weekly Report
slug: 2020-10-5w-weekly-report
date: 2020-11-03T19:24:29+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

Input/Output共、久々にガッツリRustと向き合った1週間でした。  
GitHub/Mkdocs/Netlifyなど環境整備にも力を入れました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【TypeScript】リリースノート v3.3

TypeScript v3.3のリリースノートをまとめ終わりました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/releases/3.3/">}}

2つだけですが`--build`と`--watch`が同時に使えるようになったのはポイントですね。


学んだこと
----------

### OpenAPI Specification

OpenAPIの仕様書をサラっとですが眺めてみました。

{{<summary "https://swagger.io/specification/">}}

以前はstoplight studioを使って仕様書を作成していました。

{{<summary "https://stoplight.io/studio/">}}

ただ、仕様を把握してJSON/YAMLをいじることがなかったので、この機会に..という感じです。  
JetBrains公式でPluginも出しており、JetBrains IDEならプレビュー出しながら編集も可能です。

{{<summary "https://plugins.jetbrains.com/plugin/14394-openapi-specifications">}}

### 【Rust】thiserrorとanyhowのエラーハンドリングについて

Rustのエラーハンドリングについて、`thiserror`と`anyhow`の使い分けを学びました。

#### 厳密にエラー定義するthiserrorはライブラリに

`thiserror`は様々なエラーから新しく定義したエラーにマッピングする機能を持ちます。  
これはライブラリなどで厳密なエラー定義をしたい場合に使えると思いました。

{{<summary "https://docs.rs/thiserror/1.0.21/thiserror/">}}

[ATLrusで書いたコード例]から重要な部分だけを抜き出しました。

[ATLrusで書いたコード例]: https://github.com/tadashi-aikawa/atlrus/blob/7ff472e/src/external/bitbucket/v1api.rs

{{<file "v1api.rs">}}
```rust
use std::collections::HashMap;
use std::env;

use anyhow::Result;
use reqwest::StatusCode;
use serde::Deserialize;
use thiserror::Error;

const URL: &str = "https://api.bitbucket.org/1.0";

lazy_static! {
    static ref CLIENT: reqwest::Client = reqwest::Client::new();
    static ref USER_NAME: String =
        env::var("ATLRUS_USER_NAME").expect("You must specify ATLRUS_USER_NAME");
    static ref APP_PASSWORD: String =
        env::var("ATLRUS_APP_PASSWORD").expect("You must specify ATLRUS_APP_PASSWORD");
}

/// Actually.. there are more properties.
#[derive(Deserialize, Debug)]
pub struct PostGroupsResponse {
    pub name: String,
    pub slug: String,
}

#[derive(Error, Debug)]
pub enum PostGroupError {
    #[error("group already exists")]
    GroupAlreadyExists,
    #[error("Client error: {status:?}.  detail: {detail:?}")]
    ClientError { status: StatusCode, detail: String },
    #[error("Server error: {status:?}.  detail: {detail:?}")]
    ServerError { status: StatusCode, detail: String },
    #[error(transparent)]
    ReqwestError(#[from] reqwest::Error),
}

/// Create a group in specified workspace.
pub async fn post_groups(
    workspaces_uuid: &str,
    group_name: &str,
) -> Result<PostGroupsResponse, PostGroupError> {
    let url = format!(
        "{base_url}/groups/{workspace}",
        base_url = URL,
        workspace = workspaces_uuid,
    );

    let mut params = HashMap::new();
    params.insert("name", group_name);

    let res = CLIENT
        .post(&url)
        .basic_auth(USER_NAME.to_string(), Some(APP_PASSWORD.to_string()))
        .form(&params)
        .send()
        .await?;

    match res.status() {
        StatusCode::BAD_REQUEST => Err(PostGroupError::GroupAlreadyExists),
        s if s.is_client_error() => Err(PostGroupError::ClientError {
            status: s,
            detail: res.text().await?,
        }),
        s if s.is_server_error() => Err(PostGroupError::ServerError {
            status: s,
            detail: res.text().await?,
        }),
        _ => Ok(res.json::<PostGroupsResponse>().await?),
    }
}
```
{{</file>}}

`post_groups`はエラーとして新たに定義した`PostGroupError`を返します。

```rust
#[derive(Error, Debug)]
pub enum PostGroupError {
    #[error("group already exists")]
    GroupAlreadyExists,
    #[error("Client error: {status:?}.  detail: {detail:?}")]
    ClientError { status: StatusCode, detail: String },
    #[error("Server error: {status:?}.  detail: {detail:?}")]
    ServerError { status: StatusCode, detail: String },
    #[error(transparent)]
    ReqwestError(#[from] reqwest::Error),
}
```

`PostGroupError`は`enum`でいくつかのエラーが定義されており、パターンマッチでそれぞれマッピングして返しています。

```rust
    match res.status() {
        StatusCode::BAD_REQUEST => Err(PostGroupError::GroupAlreadyExists),
        s if s.is_client_error() => Err(PostGroupError::ClientError {
            status: s,
            detail: res.text().await?,
        }),
        s if s.is_server_error() => Err(PostGroupError::ServerError {
            status: s,
            detail: res.text().await?,
        }),
        _ => Ok(res.json::<PostGroupsResponse>().await?),
    }
```

`reqwest`のメソッドは`reqwest::Error`を返すため、`send()`に失敗した場合でも`ReqwestError`にマッピングされます。  
`post_groups`の処理で発生するエラーは`reqwest::Error`だけであるため、`Result<PostGroupsResponse, PostGroupError>`の返却型を担保できます。

```rust
    let res = CLIENT
        .post(&url)
        .basic_auth(USER_NAME.to_string(), Some(APP_PASSWORD.to_string()))
        .form(&params)
        .send()
        .await?;
```

このように`thiserror`は面倒ですが、それぞれのエラーと真剣に向き合う堅牢な実装が可能です。

#### ふんわりエラーを捌くanyhowはアプリケーションに

一方`anyhow`は様々なエラーをシンプルな記述でまとめて扱えます。  
詳細には興味がなく、シンプルにスッキリ管理したいとき便利です。

{{<summary "https://docs.rs/anyhow/1.0.32/anyhow/">}}

[ATLrusで書いたコード例]から重要な部分だけを抜き出しました。

[ATLrusで書いたコード例]: https://github.com/tadashi-aikawa/atlrus/blob/7ff472e/src/main.rs

{{<file "main.rs">}}
```rust
#[macro_use]
extern crate anyhow;
#[macro_use]
extern crate lazy_static;
#[macro_use]
extern crate log;

use std::fs;
use std::path::PathBuf;

use anyhow::Result;
use env_logger::Env;
use serde::Deserialize;
use structopt::StructOpt;

use bitbucket::v1api::PostGroupError::GroupAlreadyExists;
use bitbucket::v1api::PutGroupMemberError::{AlreadyExists, NotFound};
use external::bitbucket;

mod external;

#[derive(Deserialize, Debug)]
struct Group {
    slug: String,
    emails: Vec<String>,
}

#[derive(Deserialize, Debug)]
struct CreateGroupsOperation {
    workspace_uuid: String,
    group_names: Vec<String>,
}

#[derive(Deserialize, Debug)]
struct InviteMembersOperation {
    /// Ex: tadashi-aikawa/x-viewer
    repository: String,
    /// Ex: read, write
    permission: String,
    emails: Vec<String>,
}

#[derive(Deserialize, Debug)]
struct AddGroupMembersOperation {
    workspace_uuid: String,
    groups: Vec<Group>,
}

#[derive(Deserialize, Debug)]
struct Operation {
    create_groups: Option<CreateGroupsOperation>,
    invite_members: Option<InviteMembersOperation>,
    add_group_members: Option<AddGroupMembersOperation>,
}

#[derive(Debug, StructOpt)]
struct Args {
    /// Input parameter json file
    #[structopt(parse(from_os_str))]
    input: PathBuf,
}

#[tokio::main]
async fn main() -> Result<()> {
    env_logger::from_env(Env::default().default_filter_or("info")).init();

    let args: Args = Args::from_args();
    let json_str = fs::read_to_string(&args.input)?;
    let operation = serde_json::from_str::<Operation>(&json_str)?;

    if let Some(op) = operation.create_groups {
        info!(">>>>>>>>>> Create groups");
        do_create_groups(&op).await
    }

    if let Some(op) = operation.invite_members {
        info!(">>>>>>>>>> Invite members");
        do_invite_members(&op).await
    }

    if let Some(op) = operation.add_group_members {
        info!(">>>>>>>>>> Add members to groups");
        do_add_group_members(&op).await
    }

    Ok(())
}

async fn do_create_groups(op: &CreateGroupsOperation) {
    for group_name in op.group_names.iter() {
        match bitbucket::v1api::post_groups(&op.workspace_uuid, &group_name).await {
            Ok(group) => info!("🟢 Create a new group: {}.", group.name),
            Err(err) => match err {
                GroupAlreadyExists => info!("🟤 Group `{}` already exists.", group_name),
                _ => error!("🔴 Fail to create a new group: {}.  {}", group_name, err),
            },
        }
    }
}

async fn do_invite_members(op: &InviteMembersOperation) {
    for email in op.emails.iter() {
        match bitbucket::v1api::post_invitations(&op.repository, &op.permission, &email).await {
            Ok(_) => info!("🟢 Invite {}.", &email),
            Err(err) => error!("🔴 Fail to invite {}.  {}", &email, err),
        }
    }
}

async fn do_add_group_members(op: &AddGroupMembersOperation) {
    for group in op.groups.iter() {
        for email in group.emails.iter() {
            match bitbucket::v1api::put_group_member(&op.workspace_uuid, &group.slug, email).await {
                Ok(_) => info!("🟢 Add {} to {}.", &email, &group.slug),
                Err(err) => match err {
                    AlreadyExists { .. } => {
                        info!("🟤 `{}` already exists in {}.", &email, &group.slug)
                    }
                    NotFound { .. } => warn!(
                        "🟡 At least either `{}` or `{}` is not found.",
                        &group.slug, &email
                    ),
                    _ => error!("🔴 Fail to add {} to {}.", &email, &group.slug),
                },
            }
        }
    }
}
```
{{</file>}}

ポイントは`main`関数の部分です。  
`fs::read_to_string`と`serde_json::from_str`は異なるErrorを返しますが、anyhowの`Result<()>`はそれらをまとめて1つのインタフェースで処理できます。

```rust
#[tokio::main]
async fn main() -> Result<()> {
    env_logger::from_env(Env::default().default_filter_or("info")).init();

    let args: Args = Args::from_args();
    let json_str = fs::read_to_string(&args.input)?;
    let operation = serde_json::from_str::<Operation>(&json_str)?;

    //...

}
```

`anyhow`は以前のレポートでも紹介しているので、よろしければそちらもどうぞ。

{{<summary "https://blog.mamansoft.net/2020/08/24/2020-08-4w-weekly-report/#rustcli%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%A6%E3%81%BF%E3%81%9F">}}


### 【Rust】useで絶対パスを指定する

こんな構成のときに`module_a/mod1.rs`から`module_b/mod2.rs`をuseしたいときの書き方が分からなかったので調べていました。

```
  src
├──   main.rs
├──   module_a.rs
├──   module_b.rs
├──   module_a
│  └──   mod1.rs
└──   module_b
   └──   mod2.rs
```

IntelliJ IDEAが教えてくれました。`crate::`から始めればOK。

```
use crate::module_b::mod2;
```

これがbetterなのかは分かりませんが..。


読んだこと/聴いたこと
---------------------

### JetBrains 開発者サーベイから見る日本のソフトウェア開発（2020年版）

JetBrainsの利用者向けアンケート結果から、日本の特徴を抽出した記事です。

{{<summary "https://blog.jetbrains.com/ja/2020/10/24/deveco20worldvsjp/">}}

いくつか興味深い点があったので列挙します。

> JetBrains IDE 以外をみると、人気のあるVS Code、Vim、Emacs の利用者の割合が世界平均と比べ高いのが特徴的です。特に世界平均と比較した際に、Vimを愛する人の割合の多さが突出しています

日本はVim愛好者が世界平均より多いのですね、これは少し意外でした。

> 世界と比較すると、スクラムの割合が低く、None（なし）の割合が多いのが特徴的です。日本におけるアジャイル開発の普及率の低さと関連しているのでしょうか。

どっちつかずの中途半端な管理が多い印象です。  
ポジティブな表現をすれば臨機応変、ネガティブな表現をすれば新しい文化を取り入れようとする努力(忍耐)が足りないかなと。

新しいことを取り入れた直後、一時的にアウトプットが下がるのは当たり前です。  
とはいえ、期待値がこれ以上伸びない方法にいつまでも固執してはいけないと思っています。

> 日本のエンジニアの回答の特徴としては、ドキュメント&APIが少なく、本が多いのが特徴のようです。

公式ドキュメントを読もうとせず、本やWebサイトの二次情報に頼る印象が強いですね。  
公式が最強なんですけどね.. 提供する側にならないと分かりにくいことかもしれません。

> エンジニアの余暇の過ごし方として代表的なのは、プログラミングとゲームというのは世界共通のようです。日本からの回答は「読書」と「寝る」が多く、あまりアクティブではない印象があります。
> 個人的には納得の数字ですが、この結果だけ見ると、他の国の人達から「日本人エンジニアは真面目すぎて疲れていないか」と心配されそうです。

これは心配になる..w

### 全然伸びていかない「残念な英語学習者」がやりがちな4つのこと。

英語だけでなくプラグラミング言語でも同じだと思いました。言語だけに。

{{<summary "https://studyhacker.net/english-learning-channel-4bad-ways">}}

先月から[Quizlet]を使って以下のような学習をしています。

* エンジニアリングに関する英語の記事を1日1記事程度読む (前から)
* 自信をもって理解できなかった単語を[Quizlet]に登録
* 1～2日以内に新しい単語の学習
* 同じタイミングで全単語のテスト

これを1～2週間取り組んだところ、新しい記事を読んでいる最中に『あ、これ[Quizlet]でやったやつだ！』と言えるシーンが増えてきました。  
単語の反復学習と英文読解の繰り返しこそが基礎力UPのポイントだと痛感しています。

学生時代、もっと真剣に取り組んでいればこんなことには...orz😅

[Quizlet]: https://quizlet.com/

### いますぐやめて！「勉強中の4つのムダ」 つくるべきは “まとめノート” ではなく “○○ノート”

勉強のアンチパターン集かなと思っています。  
ノートとは関係ない項目も多いですが、とてもイイ内容でした。

{{<summary "https://studyhacker.net/study-waste">}}

『黙読だけでなぜ学んだ気になれるのか!?』は完全同意です。無理です..。  
インプット過多にも気をつけたいですね。アウトプットは疲れるのでサボリがちです..。

### Typescriptの次はRustかもしれない

TypeScriptをメインで使っているWebエンジニア目線から語るRust。

{{<summary "https://zenn.dev/akfm/articles/81713d4c1275ac64a75c">}}

この記事の著者と状況が似ているので全体的に共感しまくりでした..。  
なんとなくRustに惹かれていた部分を丁寧に言語化していただいた気分です。

特に、Wasmを使ったReactライクなクライアントWebアプリケーションフレームワークであるYewが気になりました。  
未来へ投資するためにも一度触っておきたいですね。

{{<summary "https://github.com/yewstack/yew">}}

### For Complex Applications, Rust is as Productive as Kotlin

Rustに関する以下2プロダクトの開発に携わった方のKotlin/Rust比較記事です。

* JetBrainsプラットフォームのRustプラグイン『IntelliJ Rust (Kotlin製)』
* RustのLSP『rust-analyzer (Rust製)』

{{<summary "https://ferrous-systems.com/blog/rust-as-productive-as-kotlin/">}}

比較内容以上にRustを学ぶメリットとして以下を挙げていたことが印象深かったです。

* 大抵の場合、仕事に適したツールは既に使っているものである
    * なぜなら、異なるツールの利用はコンテキストスイッチの切り替えコストがかかるから
* Rustは以下の特徴をもつ
    * ベアメタルの下流レイヤーからアプリケーションの上流レイヤーまで適応できる
    * パフォーマンスや安全性、エコシステムをはじめ必要な能力を兼ね備えてる

つまり、Rustを学べばコンテキストスイッチの切り替えコストから解放され、品質の高いものが作れるというわけですね👍


試したこと
----------

### 【Node.js】Fastify

Nodeのサーバフレームワークで最速と言われるFastifyを試してみました。

{{<summary "https://www.fastify.io/">}}

今回はTypeScriptを使ったので以下を参考にしました。

{{<summary "https://www.fastify.io/docs/latest/TypeScript/">}}

ほぼ書かれている通りですがインストールコマンドです。

```
npm init -y
npm i fastify
npm i -D typescript @types/node
```

{{<file "package.json">}}
```json
{
  "name": "nefertiti",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "dev": "tsc -p tsconfig.json && node index.js | pino-pretty",
    "build": "tsc -p tsconfig.json",
    "start": "node index.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "fastify": "^3.7.0"
  },
  "devDependencies": {
    "@types/node": "^14.14.5",
    "prettier": "^2.1.2",
    "typescript": "^4.0.5"
  }
}
```
{{</file>}}

{{<file "tsconfig.json">}}
```json
{
  "compilerOptions": {
    "target": "es5",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  }
}
```
{{</file>}}

`npm run dev`して`http://localhost:8080/ping`にアクセスすれば画面が表示されました。

型に関するポイントは以下の通り。

* `server.get<T>(...)`の`T`部分にObject形式で指定
* path parameterは`Params`
* query parameterは`QueryString`
* request headerは`Headers`

コードの一例です。

```typescript
import * as fs from "fs";
import fastify from "fastify";
import path from "path";

interface IParams {
  company: string;
  file: string;
}

const server = fastify({ logger: true });

server.get<{
  Params: IParams;
}>("/data/:company/:file", async (request, reply) => {
  const { company, file } = request.params;
  // 中略
});

server.listen(8080, (err, address) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(`Server listening at ${address}`);
});
```

### 【Node.js】Pino

とても高速なロガーです。  
Fastifyのデフォルトロガーでもあります。

{{<summary "https://github.com/pinojs/pino">}}

Fastifyでのログ出力は`server.log.warn("hogehoge")`のように書きます。  
`server`は`fastify({...})`の結果です

pino-prettyを使うと、JSONではなく人間に読みやすい出力が可能です。

{{<summary "https://github.com/pinojs/pino-pretty">}}

ただ、本番環境での利用は非推奨となっています。開発時だけ。  
そのためpipeを通して表示を変換する方法が推奨されています。

先ほどの`package.json`だと以下の部分ですね。

```json
  "scripts": {
    "dev": "tsc -p tsconfig.json && node index.js | pino-pretty",
  }
```

### 【Google Chrome】Toby

標準ブックマークより優れたタブ管理を提供するGoogle Chrome拡張です。  
利用企業にGoogleやfacebookの名前があるの凄いですね..!!

{{<summary "https://www.gettoby.com/">}}

私はタブをすぐに閉じる派なので、このような機能が必要と感じたことはありません。  
しかし、これだけ使われているなら何か新たな発見があるのでは..と思い入れてみました。

ブックマーク管理というより、直近でもう一度開く可能性があるタブの管理に使えるかなと思い始めています。  
それらをブックマークするのは少し面倒ですし、都度履歴から開いたりSlackのメモを見返したりするのも面倒ですしね。


調べたこと
----------

### 【TypeScript】AxiosでUTF-8以外のデータを扱う

cp932のデータをHTTPで取得し、UTF-8の文字列として表示する処理が必要だったので..。  
結論だけ言うと、このサイトの導きによって解決しました。

{{<summary "https://blog.sakaki333.com/blog/view/29">}}

siteの方にも重要なポイントだけまとめておきました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/axios/faq/#shift-jis">}}

### 【Rust】env_loggerの出力をカスタマイズする

`env_logger`のデフォルトフォーマットを変更したかったのですが、特にColor設定が面倒でかなり苦戦していました。  
以下サイトのサンプルコードを使わせていただきました🙇‍♂️

{{<summary "https://blog.ymgyt.io/entry/2019/08/09/Rust_env_logger%E3%81%AE%E5%87%BA%E5%8A%9B%E3%81%AB%E8%89%B2%E3%82%92%E3%81%A4%E3%81%91%E3%82%8B">}}

実際に書いたコードは以下です。

```rust
fn init_logger() {
    env_logger::from_env(Env::default().default_filter_or("info"))
        .format(|buf, record| {
            let level_color = match record.level() {
                Level::Trace => Color::White,
                Level::Debug => Color::Blue,
                Level::Info => Color::Green,
                Level::Warn => Color::Yellow,
                Level::Error => Color::Red,
            };
            let mut level_style = buf.style();
            level_style.set_color(level_color);

            writeln!(
                buf,
                "[{timestamp}] {level}: {args}",
                timestamp = buf.timestamp(),
                level = level_style.value(record.level()),
                args = record.args()
            )
        })
        .init();
}
```


整備したこと
------------

### 【Rust】GitHub Actionsでmusl build

GitHub ActionsでRustのプロダクトをmusl buildできるようにしました。  
今回対象としたリポジトリはATLrusです。

{{<summary "https://github.com/tadashi-aikawa/atlrus">}}

Bitbucket Pipelineでは同様のことを実施済みだったため、GitHub Actionsでもコンテナイメージを指定すれば簡単にできると思っていました。はじめは。  
これは`bitbucket-pipelines.yml`です。

```yaml
image: ekidd/rust-musl-builder

pipelines:
  custom:
    package:
      - step:
          name: Packaging
          caches:
            - cargo
          script:
            - "git clone --depth 1 https://github.com/tadashi-aikawa/atlrus.git"
            - cd atlrus
            - cargo build --release
          artifacts:
            - 'atlrus/target/x86_64-unknown-linux-musl/release/atlrus'

definitions:
  caches:
    cargo: /usr/local/cargo
```

調べてみるとGitHub Actionsではコンテナイメージの指定ができなそうでした..。  
そのため`docker`コマンドを直接実行する方法に切り替えましたが、Permission Errorが消えず..。

```
Status: Downloaded newer image for ekidd/rust-musl-builder:latest
    Updating crates.io index
error: failed to write /home/rust/src/Cargo.lock
Caused by:
  failed to open: /home/rust/src/Cargo.lock
Caused by:
  Permission denied (os error 13)
Error: Process completed with exit code 101.
```

Issueを漁ってみたのですが、解決しなかったので先人の力を頼ることにしました。  

{{<summary "https://github.com/marketplace/actions/rust-musl-static-binary-builder-for-alpine">}}

v0.0.1なのでどうなるかは分かりませんが..これでビルドできました！ 感謝🙏  
yamlファイルの関係箇所は以下の通りです。

```yaml
name: Release

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
      
    - name: Build static
      uses: stevenleadbeater/rust-musl-builder@master
      with:
          args: /bin/bash -c "cargo build --release --target=x86_64-unknown-linux-musl"

    - uses: actions/upload-artifact@v2
      with:
        name: atlrus
        path: target/x86_64-unknown-linux-musl/release/atlrus
```

これでartifactからダウンロードできるようになりました👍

### 【Netlify】キャッシュを使って差分ビルド

ポートフォリオサイトのmimizou-roomはNetlifyを使っています。

{{<summary "https://mimizou.mamansoft.net/">}}

ビルド時にはリンクやカードを作成するため大量のURLにアクセスします。  
その時間を短縮するため、`requests_cache`を使いsqliteにキャッシュを貯めています。

{{<summary "https://pypi.org/project/requests-cache/">}}

Netlifyのビルド時はこのsqliteファイルが無いため、毎回フルビルドしていました。  
この時間を削減するため、sqliteファイルをキャッシュするようにしました。

{{<warn "この方法は公式でサポートされていません">}}
ドキュメントに記載されていない方法です。  
いつ使えなくなっても構わない方のみお試しください。
{{</warn>}}

`netlify.toml`はこんな感じです。  
ポイントは **`/opt/build/cache`** 配下はキャッシュとして扱われることです。

```toml
[build]
command = """
mv /opt/build/cache/sqlite/mimizou_room.sqlite .

mkdocs build -d site

mkdir -p /opt/build/cache/sqlite
mv mimizou_room.sqlite /opt/build/cache/sqlite/
"""
publish = "site"
```

ビルド前にキャッシュからsqliteファイルを取得し、ビルド後に戻しています。  
これで、ビルドを跨ぎ同一のsqliteファイルを使い回すことができます。

上記によって4分かかっていたビルド時間は1分30秒まで削減されました😁

### 【Mkdocs】prebuild.indexで検索体験を向上する

Mkdocsの`prebuild_index`機能を使ってみました。

{{<summary "https://www.mkdocs.org/user-guide/configuration/#prebuild_index">}}

`prebuild_index`は予めインデックスを作成してデプロイするオプションです。  
私が管理しているMimizou Roomは検索窓を開いてから検索可能になるまで数秒かかるため、その待ち時間を少しでも減らしたくて`prebuild_index`を使うことにしました。

テーマはMaterial for MkDocsを使っていますので、そちらのドキュメントを参考に設定しました。

{{<summary "https://squidfunk.github.io/mkdocs-material/setup/setting-up-site-search/#built-in-search">}}

`macros`プラグインを使っているため、以下のように設定しています。

```
plugins:
  - search:
      lang:
        - en
      prebuild_index: true
  - macros
```

切り替え直後は依然として検索前に待機時間がありました。  
キャッシュが残っていたのか、初期処理に時間がかかるのかは分かりません。  
ただ、1日後には待たされることなく検索できるようになりました。

また、想定していなかったのですが検索結果の質が向上しました。

----

`prebuild_index: false`の場合
{{<himg "resources/0a08ee3e.jpeg">}}
{{<himg "resources/f4ebc8b9.jpeg">}}

----

`prebuild_index: true`の場合
{{<himg "resources/5ab7e793.jpeg">}}
{{<himg "resources/49e4b5ee.jpeg">}}

----

誰が見ても`prebuild_index: true`の方が良い結果と言えますね。これは嬉しい😄


### 【GitHub】リリースタグが付けられたらリリースジョブを実行する

リリースタグがpushされたらReleaseジョブを実行するようにしました。

yamlファイルでは以下の部分を追加しました。  
ここでは`v`からはじまるタグをリリースタグとしています。

```yaml
on:
  push:
    tags:
      - "v*"
```

以下の設定では動きませんでした。

`クォーテーションで囲まれていない`

```yaml
on:
  push:
    tags:
      - v*
```

`正規表現として記載している`

```yaml
on:
  push:
    tags:
      - "v.*"
```

この辺の細かなところをいつも忘れてハマってしまいます。。

{{<github "How to run GitHub Actions Workflow only for new tags" "https://github.community/t/how-to-run-github-actions-workflow-only-for-new-tags/16075">}}



今週のリリース
--------------

### ATLrus v0.2.0

ATLrusをバージョン管理し始めましたので、本コーナーでも紹介していきます。

{{<summary "https://github.com/tadashi-aikawa/atlrus">}}

#### ログ出力の改善

アクションごとにセクションを区切り、個々の操作をカラーサークルやアイコンでログ表示するようにしました。

{{<himg "resources/a4dd4763.jpeg">}}

また、ステータスコード404や409をErrorではなくWarningにし、必要な情報を表示するようにしました。


その他
------

### ダイの大冒険アニメ

色々始動することは知っていましたが、いつの間にかアニメが開始されておりビックリしました。

{{<summary "https://news.livedoor.com/lite/article_detail/18992478/">}}

ダイの大冒険は青春時代 魂のバイブルなので是非見たい..!!  
テレビがないので、別のメディアを使って一気に見たいなと思ってます。

そして↑のインタビュー記事..原作愛のあるキャストばかりでアツイですね😆  
ゲームの方も楽しみにしています..!!

{{<summary "https://www.dqdai-is.com/">}}

### Quizletの単語数

本日時点での単語数は68です。

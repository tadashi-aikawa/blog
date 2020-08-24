---
title: 2020年8月4週 Weekly Report
slug: 2020-08-4w-weekly-report
date: 2020-08-24T21:26:29+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - rust
  - chrome
  - todoist
  - idea
  - git
  - typescript
  - delta
  - togowl
---

📰 **Topics**

今週はレポートの半分がRustでCLIツールを作って学んだことです。  
給電とHDMI出力を兼ねた高性能なUSB TYpe-Cハブもオススメ。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

なし。


学んだこと
----------

### 【Rust】CLIを作ってみた

RustでAtLrusというCLIツールを作ってみました。  
READMEに説明もなく、バージョニングもしていませんが以下がリポジトリです。

{{<summary "https://github.com/tadashi-aikawa/atlrus">}}

開発を通していくつかのことを学びました。

#### 引数のパース

structoptを使います。

{{<summary "https://docs.rs/structopt/0.3.16/structopt/">}}

構造体にコマンドライン引数の仕様を宣言すると、`Args::from_args()`すればOK。  

```rust
use std::path::PathBuf;
use structopt::StructOpt;

// ... 中略

#[derive(Debug, StructOpt)]
struct Args {
    /// Input parameter json file
    #[structopt(parse(from_os_str))]
    input: PathBuf,
}

#[tokio::main]
async fn main() -> Result<()> {
    // ... 中略

    let args: Args = Args::from_args();
    let json_str = fs::read_to_string(&args.input)?;

    // ... 中略
}
```

今回のツールは入力のjsonファイルパスだけですが、引数が増えると便利です。

#### JSONのパース

`serde-rs/json`を使います。

{{<summary "https://github.com/serde-rs/json">}}

別途`serde`のインストールも必要です。

{{<summary "https://serde.rs/derive.html">}}

`serde`のSerialize/Deserializeを使うため、`Cargo.toml`のfeatures指定が必要です。

```toml
serde_json = "1.0.57"
serde = { version = "1.0.115", features = ["derive"] }
```

{{<refer "https://serde.rs/feature-flags.html#-feature-derive">}}

JSONの構造を`#[derive(Deserialize)]`のついたstructで定義します。  
`serde_json::from_str`を使って指定した型に変換できます。

```rust
use serde::Deserialize;

// ... 中略

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

#[tokio::main]
async fn main() -> Result<()> {
    // ... 中略

    let args: Args = Args::from_args();
    let json_str = fs::read_to_string(&args.input)?;
    let operation = serde_json::from_str::<Operation>(&json_str)?;

    if let Some(op) = operation.create_groups {
        info!(">>>>>>>>>> Create groups");
        do_create_groups(&op).await
    }

    // ... 中略
}
```

#### APIにリクエストしてレスポンスJSONを取得

reqwestを使います。

{{<summary "https://docs.rs/reqwest/0.10.7/reqwest/">}}

JSONを扱うので`Cargo.toml`のfeatures指定をします。

```toml
reqwest = { version = "0.10.7", features = ["json"] }
```

{{<refer "https://docs.rs/reqwest/0.10.7/reqwest/#optional-features">}}

`reqwest::Client = reqwest::Client::new()`で作成したクライアントを使います。  
メソッドチェーンで爽やかに書けますね😁

先ほどのserdeを使った構造体を指定して`.json`とすればレスポンスJSONを変換できます。  
`res.json::<PostGroupsResponse>(...)`の部分です。

```rust
use std::env;

use anyhow::Result;
use serde::Deserialize;
use std::collections::HashMap;

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

/// Create a group in specified workspace.
pub async fn post_groups(workspaces_uuid: &str, group_name: &str) -> Result<PostGroupsResponse> {
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
        s if s.is_client_error() => bail!("Client error: {}. detail: {}", s, res.text().await?),
        s if s.is_server_error() => bail!("Server error: {}. detail: {}", s, res.text().await?),
        _ => Ok(res.json::<PostGroupsResponse>().await?),
    }
}
```

#### async/awaitで非同期処理

上記コードを見てみましょう。  
`async`/`await`で非同期処理を実現しています。

JavaScriptで使う`Promise`に似た概念として、Rustでは`Future`があります。  
`async`関数は常に`Future`トレイトを返し、`await`は`Future::poll`が`Poll::Ready`を返すまで待ちます。

JavaScriptとの違いは`await`の位置です。  
`await futureImplemented`ではなく`futureImplemented.await`のように書きます。

複数の非同期処理をメソッドチェーンするケースではクールなコードになります😎  
JavaScriptだと

```javascript
const hoge = (await (await aaa).bbb).ccc;
```

これがRustだと

```rust
let hoge = aaa.await.bbb.await.ccc;
```

非同期処理は失敗を含むケースが多いので、実際には`await?`を使いますけど😜  
reqwestのレスポンスは`text()`や`json::<T>()`も非同期処理なので`awai?t`を使います。

#### asyncなmain関数

`main`をasync関数にする場合は非同期ランタイムが必要です。  
拘りはなかったのでtokioを使いました。

{{<summary "https://docs.rs/tokio/0.2.22/tokio/">}}

`#[tokio::main]`を使いたいので`Cargo.toml`にfeaturesを指定します。

```toml
tokio = { version = "0.2.22", features = ["macros"] }
```

{{<refer "https://docs.rs/tokio/0.2.22/tokio/#feature-flags">}}

あとはmain関数に`#[tokio::main]`を付けるだけ。  
よく見ると、先ほどまでのコードサンプルにも付いていますよ👍

#### エラー処理の統一

エラー型ライブラリごとに異なります。  
都度変換するのは辛すぎるため、anyhowを使います。

{{<summary "https://docs.rs/anyhow/1.0.32/anyhow/">}}

これも先ほどのコード例に登場しています。  
`use anyhow::Result;`と宣言するだけ。

これで、`Result`は`std::error::Error`トレイトを実装するエラーをすべて同様に扱えます。  
つまり`hoge?`構文をすべて受け入れてくれるわけです。太っ腹🍜

他にも`bail`マクロを使っています。  
`bail!("...")`と書くだけでanyhowが扱えるエラーを作成できます。

```rust
    match res.status() {
        s if s.is_client_error() => bail!("Client error: {}. detail: {}", s, res.text().await?),
        s if s.is_server_error() => bail!("Server error: {}. detail: {}", s, res.text().await?),
        _ => Ok(res.json::<PostGroupsResponse>().await?),
    }
```

今回は使いませんでしたが、条件を満たさない場合にエラーを返す`ensure`マクロも便利だと思いました。

#### 遅延初期化でシングルトン

コンパイル時には確定しないけど、一度だけの初期化処理を書きたい..  
そんなときにlazy_staticです👏

{{<summary "https://docs.rs/lazy_static/1.4.0/lazy_static/">}}

先ほどのコードにもしれっと入れてました。  
`lazy_static! { ... }`の中に書くだけでお手軽！

```rust
#[macro_use]
extern crate lazy_static;

lazy_static! {
    static ref CLIENT: reqwest::Client = reqwest::Client::new();
    static ref USER_NAME: String =
        env::var("ATLRUS_USER_NAME").expect("You must specify ATLRUS_USER_NAME");
    static ref APP_PASSWORD: String =
        env::var("ATLRUS_APP_PASSWORD").expect("You must specify ATLRUS_APP_PASSWORD");
}
```

#### ロガーでログを吐く

いつまでも`print!`だとつらいのでロガーを入れます。  
logを使います。

{{<summary "https://docs.rs/log/0.4.11/log/">}}

logの実装は切り離されているため、以下のいずれかを使います。  
社内勉強会でも話題に上がったenv_loggerにします。

{{<summary "https://docs.rs/env_logger/0.7.1/env_logger/">}}

{{<refer "https://docs.rs/log/0.4.11/log/#available-logging-implementations">}}

`env_logger::init()`で初期化したら`info!`や`error!`と呼び出すだけです。ラクチン😄  
以下はデフォルトログレベルを`INFO`にするため`env_logger::from_env`を使っていますが。

```rust
#[macro_use]
extern crate log;

// ... 中略

#[tokio::main]
async fn main() -> Result<()> {
    env_logger::from_env(Env::default().default_filter_or("info")).init();

    // ... 中略
}

// ... 中略

async fn do_create_groups(op: &CreateGroupsOperation) {
    for group_name in op.group_names.iter() {
        match bitbucket::v1api::post_groups(&op.workspace_uuid, &group_name).await {
            Ok(group) => info!("Create a new group, {}!!", group.name),
            Err(err) => {
                error!("Fail to create a new group, {}..", group_name);
                error!("{}", err)
            }
        }
    }
}

// ... 中略
```

#### あとがき

結構なボリュームになったので、後ほど1つの記事として切り出すかもしれません。  
for文を使わずにasync/awaitする方法とかもっとオシャレにできそうな気はしてます..。

そして、予想以上にJavaScriptの非同期処理と似てて親しみが沸きました。


読んだこと/聴いたこと
---------------------

### Rustの非同期プログラミングをマスターする

Rustの非同期処理と歴史について、とても丁寧で分かりやすく説明されています。

{{<summary "https://tech-blog.optim.co.jp/entry/2019/11/08/163000">}}

駆け出しRustエンジニアとしてはすべてを理解できませんが、歴史的な経緯はTypeScript/JavaScriptのPromise -> async/awaitに近い印象を受けました。

### 開発体験を変える! Chrome DevTools Tips 7選

Chromeでデバッグするときの便利な手法が紹介されています。

{{<summary "https://qiita.com/ryo2132/items/d02863bddbd0c86efa4a">}}

`Exceptionの発生箇所で自動停止`は知らなかった..。

### TodoistにBoards機能が追加

ベータ版ですがカンバンボード機能が投入されました。  
テスター募集されているので気になる方は是非💪

{{<twitter "1296090819758297088">}}

カンバンの列はセクションと一致します。  
また、Board表示とList表示はいつでも切り替えられます。

{{< youtube x_6n_FNHdvE >}}

私はTodoリストにステータスを求めないので、恐らく使わないと思います。  
ステータス管理が必要になる場合は細分化が足りないと思っているため。

### なぜTaskChute Cloudの時間管理が窮屈ではないのか？

分単位のタスク管理は窮屈と思えるでしょう。私にもそんな時代がありました。  
この記事はその疑問にしっかり言語された回答を教えてくれます。

{{<summary "https://jmatsuzaki.com/archives/26681">}}

導入部の文がすべてを物語っています。

> 休日にこのような”何もしない”などという拷問を甘んじて受け入れる人はまず居ないでしょう。結局のところ、何も決めず、何もしないと事前に決めたところで、いざそのときになったら何かしらを選択せずにはいられません。

是非、記事を最後まで読んでみて下さい😁

### 世界一のコーチですら「素直じゃない人は放っておけばいい」と思っていた。

コーチングは受ける側の問題であるという少し過激な記事です。  
とはいえ、私も『他人は変えられない』を信じているタマなので同感です。

{{<summary "https://blog.tinect.jp/?p=66220">}}

コーチングや他人を変えることを仕事にしている場合はその限りでもないと思いますが..。


試したこと
----------

### IDEAでdatabaseと連携

DBeaver使っているからいらないかな..と思っていましたが気になったので試してみました。

{{<summary "https://pleiades.io/help/idea/relational-databases.html#first-steps-with-goland">}}

私がDBeaverで必要な機能はほとんど実装されている印象..。

* ER図の表示/ジャンプ
* SQLフォーマット
* 補完
* SQLエディタ
* View
* Windowsを独立させて複数画面使用

それに加えてJetBrains製品ならではの特徴もあります。  
※ 対象リソースに接続する必要があります

* ソースコード(jsファイルなど)内のSQL文でも補完/検査
* ソースコードとの連携によるテーブルなどの呼び出し履歴
* Vim操作が可能..そう[IdeaVim]が使えるからね!!

[IdeaVim]: https://github.com/JetBrains/ideavim

知らないだけで他にもメリットはあるでしょう。  
個人的には[IdeaVim]の力でVim操作できることが盲点であり、感動しましたw


調べたこと
----------

### 【Git】git diffの行末に『^M』が表示される

WindowsでCR改行の差分が表示されるためでした。  
`core.whitespace = cr-at-eol`を指定すると解消されます。

{{<summary "https://happyquality.com/2011/09/22/1327.htm">}}

以下にもまとめました。

{{<summary "https://mimizou.mamansoft.net/it_note/tools/git/faq/#git-diffm">}}


### 【TypeScript】sqliteパッケージをv4にアップデートしたらビルドできない。

v3からv4にメジャーアップデートしたら当たり前のようにビルドできなくなりました。

{{<summary "https://www.npmjs.com/package/sqlite">}}

影響があったのは以下4点です。

* `db.all`の型引数を`T`から`T[]`に変わった
* `db.get`が`undefined`を返すようになった
* ドライバとwrapperが分離された

明示的に`sqlite3`をドライバとしてインストールする必要があります。

```
npm i sqlite3
```

READMEにあるとおり、初期化の方法も変わっています。

```js
import sqlite3 from 'sqlite3'
import { open } from 'sqlite'

(async () => {
  const db = await open({
    filename: "./db_system/database.sqlite",
    driver: sqlite3.Database,
  });
})();
```

なお、importを`import sqlite from 'sqlite'`にして`await sqlite.open(...)`ではなぜか動きませんでした..。

### 【Git】Gitの管理化では改行コードをLFにしたい

`.gitattributes`で改行コードにLFを強制します。  
これならば`autocrlf`の設定にかかわらずLF改行を強制させることができます。

```
* text=auto eol=lf
```

CRLFが必要なファイルは別途設定します。

```
*.bat text eol=crlf
```

### 【Rust】Optionの値が存在する場合のみ非同期処理を実行したい

非同期処理ではmapによるメソッドチェーンが難しそうだったため、こう書いていました。

```rust
if operation.create_groups.is_some() {
    do_create_group(&operation.create_groups.unwrap()).await
}
```

しかし、これはかなり冗長です。  
operation.create_groupsがSomeと分かった時点で、中身だけが欲しい..。

let式とパターンマッチでシンプルにかけました。GOOD😄

```rust
if let Some(op) = operation.create_groups {
    do_create_group(&op).await
}
```


整備したこと
------------

### 【ターミナル】delta

Rustで書かれたオシャレなdiff CLIのdeltaを導入しました。

{{<summary "https://github.com/dandavison/delta">}}

Windowsでも動きます。さらには`cmd.exe`でも実用的に表示されます！

{{<himg "resources/delta-cmd.png">}}

### USB Type-C で給電とHDMI出力を兼ねる

ノートパソコンのUSB Type-Cポートが動かなくなってしまい、USB Type-C接続の2560x1440ディスプレイが使えなくなりました。  
もう1つのType-CポートはACアダプタからの給電だったので使うわけにはいかず..。

#### USBと給電の知識

USB PDという概念をはじめて知りました。

{{<summary "https://www.rohm.co.jp/electronics-basics/usb-pd/usbpd_what1">}}


#### 製品を探す

そこで以下の要件を満たす製品を探しました。

* 経由してPCに給電できる (PCに給電が必要)
* 60Hzで2560x1440画面出力できる (30Hzではカクカク)
* 給電可能でWi-fiルータに接続できる (USB-A)

特に60Hzの画面出力は対応製品が少なく、最終的に以下製品を購入しました。  
お値段はそれなりですが、製品説明も丁寧で信頼できそうだったからです。

{{<summary "https://www.amazon.co.jp/gp/product/B08351PQ87/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1">}}

> Club 3D CSV-1592 は、USB タイプ C 7-in-1 ハブ to HDMI 4K60Hz /SD-TF カードスロット / 2x USB タイプ A / USB タイプ C PD / RJ45のハブです。USB タイプ Cホストから映像・音楽の視聴、周辺デバイスへの充電、データ通信が行えます。HDMIの最大解像度を4K60Hzで使用するためのは、ご使用のホストがDP 1.4 Alt mode をサポートしている必要があります。

`HDMIの最大解像度を4K60Hz`とあるので画面出力はできそう。  
30Hzはカクカクで耐えられませんからね😜

> アップストリームは、ホスト接続用のUSB タイプ-C オス コネクタです。ダウンストリームは HDMI メスコネクタ、USB タイプ-A 3.0が二つ（一つはBC 1.2充電機能付き）、PD充電およびデータ通信可能なUSB タイプ-Cメスコネクタ、Micro SD カードスロット１基、SD カードスロット１基、RJ45ギガイーサネットです。サイズは、13.6 x 3.4 x 1.4 cmです。重さは69gです。

`USB タイプ-A 3.0が二つ（一つはBC 1.2充電機能付き）`とあるのでWi-fiルータにも接続できそうです。

> USB タイプ-Aの帯域は5Gbpsで、USBタイプ-Aの二つのポートのうち一つが、最大7.5W（5V@1.5A）充電のBC1.2をサポートしています。USB タイプ-C PDは、データ通信と充電が行え、100W（20V/5A）まで充電できます。データ通信はできません。SD/Micro SDは、セキュアデジタルv3.0 UHS-I をサポートサポートします。RJ45ギガビットイーサーネットは、10Mbps/100Mbps/1000Mbpsをサポートします。

`USB タイプ-C PDは、データ通信と充電が行え、100W（20V/5A）まで充電できます`とあるので給電もいけます。

#### 実際どうだったか?

今のところ、予想通り動いています👍  
しばらく使ってみないと分かりませんが、一旦画面が蘇って満足😁

ちなみに接続先のディスプレイは以下です。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:504px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:240px"><a href="https://hb.afl.rakuten.co.jp/ichiba/0ef94cae.e2829df1.0ef94caf.dd6ba885/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbiccamera%2F4995047049838%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0ef94cae.e2829df1.0ef94caf.dd6ba885/?me_id=1269553&item_id=11815494&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbiccamera%2Fcabinet%2Fproduct%2F2479%2F00000003512896_a04.jpg%3F_ex%3D240x240&s=240x240&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a></td><td style="vertical-align:top;width:248px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/ichiba/0ef94cae.e2829df1.0ef94caf.dd6ba885/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbiccamera%2F4995047049838%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  >EIZO　エイゾー 液晶モニター FlexScan ブラック EV2780-BK [27型 /ワイド /WQHD(2560×1440）][27インチ 液晶ディスプレイ EV2780BK]</a><br><span >価格：98540円（税込、送料別)</span> <span style="color:#BBB">(2020/8/20時点)</span></p><div style="margin:10px;"><a href="https://hb.afl.rakuten.co.jp/ichiba/0ef94cae.e2829df1.0ef94caf.dd6ba885/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbiccamera%2F4995047049838%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:0"></a><a href="https://hb.afl.rakuten.co.jp/ichiba/0ef94cae.e2829df1.0ef94caf.dd6ba885/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbiccamera%2F4995047049838%2F%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ==" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><div style="float:right;width:41%;height:27px;background-color:#bf0000;color:#fff !important;font-size:12px;font-weight:500;line-height:27px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td></tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>


今週のリリース
--------------


### Togowl v2.13.0 ～ 2.13.2

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### タスク、エントリ、プロジェクトなどをリロードするボタンを追加

通信エラーやデータ不整合が発生したとき、アプリケーションのリロードなしに復帰できます。  
また、タスクのロード中は常にインジケーターブロックを表示するようにしました。

{{<mp4 "resources/togowl_v2.13.0.mp4">}}


その他
------

遂にRustで動くモノを作れたことは大きな一歩だと思っています。

家のメインディスプレイが使えなくなったときは予想以上に絶望を感じました。  
普段当たり前にある環境..そのことに感謝する気持ちを忘れないようにと思いましたね

そして日本FALCOMの軌跡シリーズ最新作..創の軌跡がいよいよ今週発売です！

{{<summary "https://www.falcom.co.jp/hajimari/">}}

{{<youtube "LuPkbBSSQF0">}}

Togowlの背景画像[^1]にも設定してテンションを上げつつ、木金は休みをとったので準備もOK。  
今週/来週は寂しいレポートになると思いますがご了承ください😅

[^1]: Togowlは任意の背景画像を設定可能であり、リソースに利用しているわけではありません

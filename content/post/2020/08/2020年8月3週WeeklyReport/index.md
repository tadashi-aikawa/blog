---
title: 2020年8月3週 Weekly Report
slug: 2020-08-3w-weekly-report
date: 2020-08-18T07:31:01+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - rust
  - typescript
  - npm
  - bitbucket
  - atlassian
  - idea
  - jetbrains
  - cargo
  - ipad
  - javascript
  - wsl
  - owlelia
  - togowl
---

📰 **Topics**

『佐々木さん。記録って何の役に立つんですか？』のプチ書評や、iPad Proでトラックパッドを操作できない問題の対処方法などオススメです。  
また、WSL2 + JetBrainsツールでRustの本格開発する環境を整えました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

今週はありません。

勉強したこと
------------

### 【Rust】The book 3章~

{{<summary "https://doc.rust-lang.org/book/">}}

#### 3. Common Programming Concepts

変数や関数は他言語と違うクセもあり、なかなか楽しかったです。  
コメントや制御構文は大体同じ。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/rust/thebook/3_common_programming_concepts/">}}


読んだこと/聴いたこと
---------------------

### 佐々木さん。記録って何の役に立つんですか？

意識して行動するために記録が必要という話です。  
私も大方同じ意見で、一部新しい発見もあり楽しめました😄

{{<summary "https://www.amazon.co.jp/%E4%BD%90%E3%80%85%E6%9C%A8%E3%81%95%E3%82%93%E3%80%81%E8%A8%98%E9%8C%B2%E3%81%A3%E3%81%A6%E4%BD%95%E3%81%AE%E5%BD%B9%E3%81%AB%E7%AB%8B%E3%81%A4%E3%82%93%E3%81%A7%E3%81%99%E3%81%8B%EF%BC%9F-%E3%81%94%E3%82%8A%E3%82%85%E3%81%94cast-%E4%BD%90%E3%80%85%E6%9C%A8%E6%AD%A3%E6%82%9F-ebook/dp/B08C9YCFLK">}}

個人的に印象に残ったセクションの感想を紹介します。

> 記録することで記憶の精度が高くなる

記録することにより情報へのindexが張られるイメージです。  
私もSlack(times)に感じたことや情報をリアルタイムに発信していますね👍

> 記録することは切り替えを意識すること

これは完全同意です！  
よく『PCの操作内容とかを解析して自動で記録したい』みたいな相談されますが、私からすると『意識的な記録によって集中力を上げることが一番の旨味なのに..何を言っているのだ。。』といつも思ってしまいます😅

> 無意識な行動は自由じゃない

この考え方は目にうろこでした..無意識行動の方が自由だと思っていたので。  
『ある行動をするために、やる気が出るのを待たなければいけないから自由じゃない』..なるほどです。

> セミナーで話すことを思いつくのはセミナー中であるべき

これは万人に当てはまる内容ではない気がします..。  
訓練されたできる人だからこそ言える至高の領域..。

> 90%の時間は「絶対にやること」の繰り返し

時間にして1日あたり9～10時間分もあるから忘れるに決まっている。  
「絶対にやること」だから忘れないと思っているならそれは幻想である。

> 「絶対にやること」を忘れない意味

以下の部分が完全に同意です！  
障害を起こさない人は表面上大したことをやってなさそうに見えるけど、実は凄いことをしてる..に似てると思いました。

```
タスクシュートユーザーの言っていることが傍目で見ていてわかりにくいのは、何も問題が起こっていないというただそれだけなので、時間を得したような感じとか、すごいことを成し遂げたような感じがまったく見えてこないからです。でも年間の節約時間は馬鹿にならない。
```

『記録は時間の無駄なのでやめました』みたいな話を(過去の自分含め)よく聞きますがもったいない！  
大抵それはやり方の問題な気がします。  
私も自身が開発しているツールTogowlを使うようになってから、ようやくメリットを実感しはじめました。

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

> 記録するはずのことがあらかじめ書いてある

タスクリストではなくて、これからやるであろうことのサジェストという考え方。  
自分のGTDベースの考え方なので同意できない部分はありつつ、面白い考え方だと思いました。

> 面倒くさいことに意味がある

最後のセクションです。  
言葉だけを見ると仕事のできない人に見えますが、本質をつくラストにふさわしい言葉だと思いました。

なぜそう思うのか..!?  
本書を最後まで読めば分かると思いますので是非👍

### 朝起きてバッターボックスに立つまで完璧にルーティン化することを何故みんなやらないのか？

私も毎朝、自宅および会社で作業を始めるまえのルーチンがあります。  
プロスポーツ選手がやっていることをなぜ我々がやらないのかというお話。

{{<summary "https://jmatsuzaki.com/archives/26604">}}

ルーチンは精神安定効果が高く、気が乗らないときでも作業を始めさせる力があると信じています。

### Announcing TypeScript 4.0 RC | TypeScript

以前にも触れたTypeScript4.0について、RC版が出ました。

{{<summary "https://devblogs.microsoft.com/typescript/announcing-typescript-4-0-rc/">}}

現時点で使いたい機能は以下です。

* Variadic Tuple Types
* Labeled Tuple Elements
* Class Property Inference from Constructors
* `/** @deprecated */ Support`

最初、`Labeled Tuple Elements`を使うならObjectを使えばいいのでは..?と思っていました。  
しかしTupleの使い方を学ぶうちに以下の用途で必要なことが分かりました。

* Tupleの持つ順序性が、関数引数や部分配列を表現するのに必須である
* 名前を付けることで分割代入が不要
* 名前を付けることで可読性が上がる

機会を見つけたら積極的に利用していきたいですね😄

### コロナ禍で重要性を増す“社内広報”の心得

社内への情報伝達をどうすべきか..というAtlassianの記事です。

{{<summary "https://atlassian-teambook.jp/_ct/17383426?utm_source=twitter&utm_medium=social&utm_campaign=TTB_17383426">}}

コロナのときは社内でも真偽性の怪しい情報が沢山飛び交いました。誰も悪意はないのに。  
TOPからの情報伝達が遅れると、情報が欲しくなる真理が作りだした特異点なのかもしれません。

### npm v7 Series - Beta Release! And: SemVer-Major Changes in npm v7

npmのv7について、`npx`が非推奨になり`npm exec`になるそうです。  
`npx`はもともと違和感あったので個人的には歓迎☺️

{{<summary "https://blog.npmjs.org/post/626173315965468672/npm-v7-series-beta-release-and-semver-major">}}

###  Introducing Workspaces to Bitbucket Cloud

Bitbucket CloudのWorkspacesについて紹介されています。

{{<summary "https://bitbucket.org/blog/introducing-workspaces">}}

> Everyone who has access to your repos in your workspace is now considered a "member" of the Workspace.

アカウントはBitbucket Cloud全体で共通だけど、Workspaceという概念が別途ある..と。  
Workspaceに属するリポジトリへ招かれた人はWorkspaceの一員とみなされるようです。

これはSlackやMiroのモデルに近い印象を受けました。

> We will be slowly rolling out new changes in several phases to build towards this new Workspace model.

もともとはTeamという概念だったけど、徐々にWorkspaceの概念へと移行していくようです。  
しばらくはBreaking changesがないか..しっかり見張った方がよさそうですね。

### Working with code problems in IntelliJ IDEA

2020.2から導入されたProblems関連の機能強化について紹介されています。

{{<summary "https://blog.jetbrains.com/idea/2020/08/working-with-code-problems-in-intellij-idea/">}}

今後さらに改善していく予定とのことで楽しみですね😁  
問題を制すものは開発を制すとも言いますし。

### ep.57 Vue 3 Study 『よりよい Directive を求めて』

Custom directiveについて知識がなかったので勉強になりました。

{{<summary "https://uit-inside.linecorp.com/episode/57">}}

なるほど.. DOMに対してよく行う処理には便利ですねえ..。  
今までrefでしか実装しなかったので選択肢が増えました。

{{<summary "https://jp.vuejs.org/v2/guide/custom-directive.html">}}


試したこと
----------

### 【Atlassian】Atlassian Cloud API

Atlassian Cloud製品のAPIを使う必要が出てきたので試してみました。  
Bitbucketで以下3つのオペレーションを自動化するのが目的。

* ユーザの登録
* グループの作成
* グループへのユーザ追加

REST APIのページを調べると、『v1はdeprecatedになったからv2を使え』とのこと。

{{<summary "https://support.atlassian.com/bitbucket-cloud/docs/use-bitbucket-rest-api-version-1/">}}

一方、今回やりたかったことはまだv2に対応していないようです。  
deprecated文のすぐ下に記述があります。

> Temporary support for limited 1.0 API resources  
>  
> The 2.0 REST API will rely on the Atlassian Cloud Admin API for user and group management, but those API endpoints are not yet available. Until the Atlassian platform services are fully available in Bitbucket we will continue to support these 1.0 REST endpoints:  
>  
>   ・/1.0/groups  
>   ・/1.0/group-privileges  
>   ・/1.0/invitations  
>   ・/1.0/users/{accountname}/invitations  

それぞれ以下のAPIを使ってできました。  
ユーザ登録という概念はなく、リポジトリへユーザを追加する際に招待することになります。

| オペレーション           | 関連API                                                                                                                                  |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| リポジトリへユーザを招待 | [POST send an invite](https://support.atlassian.com/bitbucket-cloud/docs/invitations-endpoint/#invitationsEndpoint-POSTsendaninvite)     |
| グループの作成           | [POST a new group](https://support.atlassian.com/bitbucket-cloud/docs/groups-endpoint/#groupsEndpoint-POSTanewgroup)                     |
| グループへのユーザ追加   | [PUT new member into a group](https://support.atlassian.com/bitbucket-cloud/docs/groups-endpoint/#groupsEndpoint-PUTnewmemberintoagroup) |

別途認証を通過する必要があります。今回はアプリパスワードを使いました。

{{<summary "https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/">}}

Basic認証でOK。

### 【Rust】cargo-edit

Cargoでも`npm install`のようにCLIからcrateをプロジェクトへ追加できます。  
そう..cargo-editを使えば。

{{<summary "https://github.com/killercup/cargo-edit">}}

`cargo install cargo-edit`でインストールします。  
少し時間がかかります。

インストールが終われば以下のコマンドでcrateを追加できます🎉

```
cargo add structopt
```

[IntelliJ Rust]を使っていると`Cargo.toml`の補完が効くため必須ではないと思っています。

{{<himg "resources/cargo.gif">}}

[IntelliJ Rust]: (https://intellij-rust.github.io/)


調べたこと
----------

### iPad ProのMagic Keyboardでトラックパッドが効かなくなる

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:504px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:240px"><a href="https://hb.afl.rakuten.co.jp/ichiba/18ebd111.49c0c72f.18ebd112.395b55ce/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fthinkrich%2Fj02364%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/18ebd111.49c0c72f.18ebd112.395b55ce/?me_id=1333995&item_id=10034964&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fthinkrich%2Fcabinet%2Fmuryou_11%2Fs11028.jpg%3F_ex%3D240x240&s=240x240&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a></td><td style="vertical-align:top;width:248px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/ichiba/18ebd111.49c0c72f.18ebd112.395b55ce/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fthinkrich%2Fj02364%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  >Apple Magic Keyboard 11インチiPad Pro 第1世代と第2世代 日本語 JIS MXQT2J/A 2020年モデル 送料無料 【SK11028】</a><br><span >価格：36760円（税込、送料無料)</span> <span style="color:#BBB">(2020/8/12時点)</span></p><div style="margin:10px;"><a href="https://hb.afl.rakuten.co.jp/ichiba/18ebd111.49c0c72f.18ebd112.395b55ce/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fthinkrich%2Fj02364%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:0"></a><a href="https://hb.afl.rakuten.co.jp/ichiba/18ebd111.49c0c72f.18ebd112.395b55ce/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fthinkrich%2Fj02364%2F%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ==" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><div style="float:right;width:41%;height:27px;background-color:#bf0000;color:#fff !important;font-size:12px;font-weight:500;line-height:27px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td></tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

トラックパッドのポインタが画面に現れず、操作しても反応がない状態です。  
週に1回くらい発生します。。

{{<summary "https://discussions.apple.com/thread/251419128">}}

上記サイトに書かれている方法でなおりました。

1. USB-C をMagic Keybaordから外す
2. iPad ProをMagic Keyboardから外す
3. もう一度つける
4. Track Padをいじっていると画面の隅からポインタが登場する

### 【JavaScript】placeholderにin句を指定できない

以下のような書き方ができないという問題です。

```
SQL`select * from hoge where status not in ${"(1, 2)"}`
// SELECT * FROM company WHERE status NOT IN '(1, 2)'
//  -> 文字列として扱われてしまう..
```

下記の記事はJavaに対するものですが、prepared statementに含まれる`?`の数が動的であるなら都度statementを作るのが正攻法のようですね。

{{<summary "https://www.it-swarm.dev/ja/java/in%E5%8F%A5%E3%81%AB%E3%83%91%E3%83%A9%E3%83%A1%E3%83%BC%E3%82%BF%E3%81%AE%E3%83%AA%E3%82%B9%E3%83%88%E3%82%92%E5%90%AB%E3%82%80preparedstatement/969788552/">}}

ベタですがこんな感じにしました。

```
  db.all<Company>(
    `SELECT * FROM company WHERE status NOT IN (${statusIds.map(_ => '?').join(',')})`,
    ...statusIds,
  );
}
```

### 【npm】npmコマンドが動かなくなった

`npm i -g npm`に失敗したあとに`npm`コマンドを実行したらエラーに..。  
Windows環境でscoopを使っており、`nodejs-lts`をインストールしなおしてもダメでした。

```
$ npm
internal/modules/cjs/loader.js:968
  throw err;
  ^
Error: Cannot find module 'C:\Users\syoum\scoop\apps\nodejs-lts\current\bin\node_modules\npm\bin\npm-cli.js'
    at Function.Module._resolveFilename (internal/modules/cjs/loader.js:965:15)
    at Function.Module._load (internal/modules/cjs/loader.js:841:27)
    at Function.executeUserEntryPoint [as runMain] (internal/modules/run_main.js:71:12)
    at internal/main/run_main_module.js:17:47 {
  code: 'MODULE_NOT_FOUND',
  requireStack: []
}
```

確認したところ`bin`ディレクトリが`persist`配下を指していました。  
`nodejs-lts`をアンインストールしても消えないため変わらないのですね。

```
$ cd C:\Users\syoum\scoop\apps\nodejs-lts\current
$ ll
---------- 1 somebody somegroup    54928 2020-07-22 23:58 CHANGELOG.md
---------- 1 somebody somegroup    81641 2020-07-22 23:58 LICENSE
---------- 1 somebody somegroup    27903 2020-07-22 23:58 README.md
l--------- 1 somebody somegroup        0 2020-08-15 17:13 bin -> C:\Users\syoum\scoop\persist\nodejs-lts\bin
l--------- 1 somebody somegroup        0 2020-08-15 17:13 cache -> C:\Users\syoum\scoop\persist\nodejs-lts\cache
```

`persist`配下の`nodejs-lts\bin`を削除したところ無事動きました。


整備したこと
------------

### 【Rust】WSL2でのRust開発環境構築

やはりWindowsだと不安なため、RustはWSLで開発することにしました。  
WSL2の環境整備をしておいてよかったです。

{{<summary "https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/">}}
{{<summary "https://blog.mamansoft.net/2020/07/26/efficient-wsl2-with-ubuntu2/">}}

rustupのインストールは[公式推奨のコマンド](https://rustup.rs/)を使います。  
設定はdefaultを使うのでそのままEnter。

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

以下のツールチェインがインストールされます。

* cargo
* clippy
* rust-docs
* rust-std
* rustc
* rustfmt

cargo-editも別途入れました。  
実はWindows環境でビルドできなかったんですよねコレ。。

```
cargo install cargo-edit
```

あとは全てがフツーに動きます。Windowsで遭遇したmsvs周りの苦労はなんだったんだという..😓

### 【JetBrains】WSL2でJetBrains Toolboxを使う

Windowsにも導入したJetBrains ToolboxをWSL2環境に入れました。  
そのため、Ansibleからumakeを使ったIDEAインストールの記載を削除しました。

{{<summary "https://www.jetbrains.com/ja-jp/toolbox-app/">}}

導入の理由は2つです。

* 製品とバージョン管理が楽 (ハマりポイントも少ない)
* ToolboxのUIからIDEAの起動が簡単にできる

WSL環境のディストリビューションはDesktop環境を使っていないため、ランチャー形式のGUIは思いのほか便利だったりします。


今週のリリース
--------------

### Owlelia v0.15.0 ～ v0.16.0

{{<summary "https://github.com/tadashi-aikawa/owlelia">}}

#### yyyyMMddHHmmssの追加

日時を`20200815200214`のような形式で出力するプロパティを追加しました。

#### DateTime.validate()の追加

日時をあらわす文字列が正当かどうかを判断できます。  
フォーマットだけでなく`2020-01-32`のようなケースも弾けます。

### Togowl v2.12.0

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### プロジェクトセレクタの表示順をよく選択される順に変更

タスク追加/編集ダイアログで表示されるタスクプロジェクトセレクタの表示順を『選択された回数が多い順』に変更しました。

{{<himg "resources/57c69ede.png">}}

選択回数は端末/ブラウザ毎に記録されるため、スマホとPCでは表示順が異なります。  
端末によって選択されるプロジェクトに偏りが生じる可能性があるため。

#### カレンダーのズームレベルを細分化

カレンダーのズームレベルを今までより細分化しました。  
キャプチャを撮る場合に最適なサイズを選びやすくなります。


その他
------

遂にRustでツールの開発をはじめました。  
来週はRustの多いレポートになると思います🥳

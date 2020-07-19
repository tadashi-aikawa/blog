---
title: 2020年7月3週 Weekly Report
slug: 2020-07-3w-weekly-report
date: 2020-07-14T06:56:38+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - rust
  - typescript
  - tauri
  - DDD
  - git
  - bash
  - wsl
  - github
  - ubuntu
  - idea
  - gmail
  - togowl
  - owlelia
  - dayjs
  - ipad
---

📰 **Topics**

twadaさん回の[fukabori.fm](https://fukabori.fm/)を中心にインプットの多い週でした。

またBash-itやvcxsrvによるWSL2/Ubuntu環境整備も必見です😉  
どちらも単体で記事が書けるレベル、時間を見つけて書きたいですね。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

今週はありません。  
ブログを1記事書きたかった。。


読んだこと/聴いたこと
---------------------

### 27. 論理削除とは何か？どのような解法があるのか？ w/ twada

fukabori.fmでt-wadaさんがDBの論理削除について話されていました。

{{<summary "https://fukabori.fm/episode/27">}}

心に残ったポイントです。

* 思考停止してすべてのテーブルに削除フラグを付けるのはアンチパターン
* ドメインで論理削除という言葉が出る場合はドメインモデルを疑った方がいい

また、削除フラグを使いたい場合の代替案についても紹介されていました。

1. ステータスを使う
2. アーカイブテーブルを使う
3. UPDATEやDELETEのないImmutableチックな設計を使う
4. 遅延レプリケーションでUNDOできるようにする

3と4の発想はなかったので大変参考になりました。


### 28. 技術選定の審美眼(1) w/ twada

同じくfukabori.fmでt-wadaさんが話されていました。  
複数回の長編となっており、その第1回です。

{{<summary "https://fukabori.fm/episode/28">}}

『ベテランエンジニアの数少ない強みは、一回り前の螺旋をリアルタイムで感じていたことだ。』というフレーズが印象に残っています。

* 技術トレンドは常に新しいものが出るわけでない
  * 一回り前にトレンドとなったものが改良されて再び出現する
* 再度トレンドとなるには理由がある
  * 一回り前で課題になっていたことが解消されているケースが多い
* ベテランは一回り前に現場でリアルな経験を積んでいることが多い
  * 一回り前との差分を見極めやすいその経験は強みである

そして、変わらない技術には共通点があるということも。  
『制約が強く、シンプルで、1つの共通概念に抽象化されている』ということ。

この続きは是非本編をご覧下さい🤣


### 月収100万円のUberEats配達員が大切にする「たったひとつのこと」

どの分野でも成果を上げる人がやることは同じですね。  
基本に忠実にストイックに無駄を無くせるか。

{{<summary "https://tabi-labo.com/296235/ubereats-interview">}}

### Rust for JavaScript Developers

JavaScript開発者向けのRust紹介記事です。  
エコシステムや仕様とをJSと紐付けて説明されているので非常に分かりやすいです。

{{<summary "http://www.sheshbabu.com/posts/rust-for-javascript-developers-tooling-ecosystem-overview/">}}
{{<summary "http://www.sheshbabu.com/posts/rust-for-javascript-developers-variables-and-data-types/">}}

個人的に印象に残っているポイント。

* `cargo install`はグローバルインストールなので`cargo-edit`を使う
* タスクランナーは`Make`を使う
* `cargo-watch`
* constはコンパイル時に定数となる

### Tauri

フロントエンドをHTML/JS/CSS、バックエンドをRustで作るデスクトッププラットフォームのフレームワークです。

{{<summary "https://github.com/tauri-apps/tauri">}}

TypeScriptもサポートされるのであれば非常に気になるプロダクトです。  
Electronの後釜候補の1つとして期待できるかもしれません。

### 命名のプロセス

暗黙知とされることが多い命名のプロセスが詳しく書かれています。必見👀

{{<summary "https://scrapbox.io/kawasima/%E5%91%BD%E5%90%8D%E3%81%AE%E3%83%97%E3%83%AD%E3%82%BB%E3%82%B9">}}

特に以下の文が好きです。

> 設計とは、自分が見ている場所が「このテストを書くのがどれほど大変だったか」で、名前を変えることでその気付きを書きとめるループである。(通常これは「正しいことをする」名前に修正するステップである)

本文はかなり長いですが、最後の方でDDDの話が出てきてテンション上がります☺️  
『名前をつけることがプログラミングの7割、キャッシュが2割であとはオマケ』とは言ったもので、名前だけ見ればコードの品質が分かるというのも納得ですね😜


試したこと
----------

### 【GitHub】ユーザに紐づくREADME

ユーザ名と同じリポジトリを作成して`README.md`を書くとトップページに表示される機能を試しました。

{{<summary "https://github.com/tadashi-aikawa">}}

こんな感じに表示されます。

{{<himg "resources/fef046e8.jpeg">}}


### 【Rust】cargo-watch

Rustのコードを変更すると、自動でビルドや処理を実行してくれます。  
`cargo install cargo-watch`でインストールする必要があります。

{{<summary "https://github.com/passcod/cargo-watch">}}

変更時にビルドしてそのまま実行するコマンドです。  
`-x`オプションでcargoコマンドを指定します。

```
cargo watch -x run
```

### 【TypeScript】mockdate

現在日時を任意の値に指定できるMockを作成できます。

{{<summary "https://github.com/boblauer/MockDate">}}

dayjsの作者が案内していたので使ってみましたがシンプルで便利でした。

{{<summary "https://github.com/iamkun/dayjs/blob/dev/test/parse.test.js#L6">}}



調べたこと
----------

### 【Git】公開鍵のフォーマットが不正な警告

多分、Gitをバージョンアップしてからこの警告が出るようになりました。  
Gitの動作には問題ありませんでした。

```
load pubkey "/c/Users/syoum/.ssh/id_rsa_github": invalid format
```

もう一度`ssh-keygen`でキーを作成/登録しなおしたら消えました。

{{<summary "https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent">}}

秘密鍵のヘッダとフッタが変わっていたのでこれが影響してそう。

```
- -----BEGIN RSA PRIVATE KEY-----
+ -----BEGIN OPENSSH PRIVATE KEY-----
- -----END RSA PRIVATE KEY-----
+ -----END OPENSSH PRIVATE KEY-----
```

以下の記事で簡単に説明されていましたので、気になる方はそちらをどうぞ。

{{<summary "https://amasuda.xyz/post/2019-07-27-ssh-keygen-openssh-to-pem/">}}


整備したこと
------------

### Bash-it

Bash-itはBashコミュニティが提供するBashのコマンド/スクリプト群です。  
主にプロンプトの見た目/挙動を変更する目的でこちらを導入しました。

{{<summary "https://github.com/Bash-it/bash-it">}}

READMEの手順に沿うよう、Ansibleのroleを作りました。

```yaml
- name: "Clone"
  git:
    repo: https://github.com/Bash-it/bash-it.git
    dest: ~/.bash_it
    depth: 1

- name: Install
  shell: ~/.bash_it/install.sh
```

{{<warn "~/bash_it/install.shを実行すると.bashrcが上書きされるので注意">}}
インストールをすると既存の`.bashrc`が完全に上書きされます。  
追記ではありません。

上書き前のファイルは`~/.bashrc.bak`として保存されています。  
`/bashrc`をカスタマイズしている場合はインストール後に設定をマージしましょう。
{{</warn>}}

プロンプトテーマは既存のものを参考に自作しました。  
コードを整備したら、公開する予定です。

{{<himg "resources/1b964c93.png">}}

### WSL2のUbuntuからIntelliJ IDEAを使う

以下の記事でインストールしたvcxsrvを使って、IntelliJ IDEAをウィンドウで立ち上げます。

{{<summary "https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/">}}

フォントのインストールなどは必要ですが普通に動きました。  
ただ、日本語入力ができないので対策が必要です。

### スマホからGmailをアンインストール

以下の記事に影響を受けて、スマートフォンからGMailを消しました。

{{<summary "https://forbesjapan.com/articles/detail/35779">}}

理由は以下の通りです。

* Gmailで急ぎ *返信* が必要な用事はない
* Gmailで急ぎ *連絡* が必要な用事はない

急に必要になった場合は、iPadやPCで送信すればいいかと。


今週のリリース
--------------

### Togowl v0.16.3

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### 期限変更カレンダーの開始曜日を月曜日に変更

Todoistも会社のカレンダーも月曜日なのであわせました。

{{<himg "resources/cd8a9eee.jpeg">}}

### Owlelia v0.11.0 ～ v0.12.0

{{<summary "https://github.com/tadashi-aikawa/owlelia">}}

#### datetimeモジュールの追加

Owleliaの`ValueObject`を実装した日付型のvoを追加しました。  
内部ではdayjsを使った薄いラッパーとなっています。

{{<summary "https://github.com/iamkun/dayjs">}}

ドメイン駆動開発をする上で、日付型はほぼ必ず登場するため同梱することにしました。  
DDDのコアで使うモジュールではありませんが例外的に。

サンプルコードです。

```typescript
import { DateTime } from "owlelia";

console.log(DateTime.now().rfc3339);
// -> 2020-07-18T11:50:11+09:00

console.log(DateTime.of("2020-01-01").rfc3339);
// -> 2020-01-01T00:00:00+09:00

console.log(DateTime.of("2020/01/01").plusDays(3).rfc3339);
// -> 2020-01-04T00:00:00+09:00

console.log(
  DateTime.of("2020-01-15 13:00:00").between(
    DateTime.of("2020-01-15 12:00:00"),
    DateTime.of("2020-01-15 14:00:00"),
  )
);
// -> true

console.log(
  DateTime.of("2020-01-15 13:00:00").between(
    DateTime.of("2020-01-15 13:00:00"),
    DateTime.of("2020-01-15 14:00:00"),
    {
      includeBegin: false,
      includeEnd: false,
      ignoreTime: false,
    }
  )
);
// -> false

console.log(
  DateTime.of("2020-01-15 13:00:00").between(
    DateTime.of("2020-01-15 13:00:00"),
    DateTime.of("2020-01-15 14:00:00"),
    {
      includeBegin: true,
      includeEnd: false,
      ignoreTime: false,
    }
  )
);
// -> true
```

今後[テストケース]に一通り追加していくので、詳しくはそちらをご覧下さい。

[テストケース]: https://github.com/tadashi-aikawa/owlelia/blob/master/src/bundle/datetime.spec.ts


その他
------

### iPad Proの標準メモは最強なのではないか

iPadでApple Pencilを使ったメモツールは色々あります。  
私も以下のツールを状況に応じて使い分けてきました。

* [メモ]
* [GoodNotes](https://apps.apple.com/jp/app/goodnotes-5/id1444383602)
* [ThinkSpace](https://apps.apple.com/jp/app/thinkspace/id1335574515)
* [Miro](https://miro.com/)
* [Jamboard](https://gsuite.google.co.jp/intl/ja/products/jamboard/)

[メモ]: https://support.apple.com/ja-jp/guide/ipad/ipad99e3f0bb/ipados

しかし、最近になってこの中の1つを使うことが多くなりました。  
それは[メモ]です。プリインストールされているアプリです。

他のツールに比べて機能は劣りますが、逆にそのシンプルさが最大の魅力です。  
やはりメモたるもの、気軽に直感的にサッと使えなくていけません。

私が[メモ]を気に入っている点は以下9点です。

* ロック画面でApple Pencilをダブルタッチするとすぐに使える
* エンピツの書き心地がよい
* ツールチップがオシャレ
* ペンの傾きに応じて使い心地が変わる.. 特にエンピツと消しゴムは必見!!
* 紙に書いていると錯覚するほど遅延やペン先のズレがない
* 横幅は固定だが縦のサイズは伸ばせる (無限?)
* ロングタップをすると描画領域全体を画像としてコピーできる
* 自由範囲を選択して移動/複製/コピーができる
* Apple Pencil以外反応しない

一方、微妙な部分もあります。

* 1画面に沢山の文字(ベクターデータ)を書くと突然重くなる
* キャンバスの拡大/縮小、ベクターデータの拡大/縮小ができない
* 図形描画などはできない
* 横幅が固定
* 画像と手書きを共存させるのが難しい (画像データに書き込みはできる)
* 共同編集ができない

とはいえ問題にならないケースも多いので、その場合は他のツールを使えば十分です。  
現実世界のA4用紙にメモを書くのと同じ感覚で使えるのが気持ちいいですね😁

メモでラフに書いてコピーした画像をSlackで共有..よくします👍


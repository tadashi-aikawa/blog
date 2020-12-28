---
title: 2020年9月3週 Weekly Report
slug: 2020-09-3w-weekly-report
date: 2020-09-23T08:05:07+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

Angularをバージョンアップして1年ぶりにMiroirをリリースしました。  
またWSL2環境にDockerをインストールしました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【Golang】やりたいこと

やりたいことのコード例が頭にすぐ浮かんでこないのでFAQに書きました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/golang/faq/">}}


学んだこと
----------

特になし


読んだこと/聴いたこと
---------------------

### 【Vue】vue3リリース

とうとうリリースされました！🎉

{{<summary "https://github.com/vuejs/vue-next/releases/tag/v3.0.0">}}

Vuetifyなど依存ライブラリの問題ですぐに使うことはできませんがめでたい☺️

### 睡眠を最高品質に保つためにやってること【保存版】

良質な睡眠を得るための優先度リスト。  
私の趣向ともよく似ており、新しくチャレンジしてみたいものもありました。

{{<summary "https://jmatsuzaki.com/archives/26744">}}

私の状況と比較してみました。

| 優先順位 | 項目                             | 実施しようとしてる? | 実施できてる?                           |
| -------- | -------------------------------- | ------------------- | --------------------------------------- |
| 1        | 22時前就寝                       | 〇                  | △ (23時～24時になることが多い)         |
| 2        | 7〜8時間睡眠確保                 | 〇                  | 〇 (7時間はギリギリ)                    |
| 3        | バイブで起床（アラームではなく） | 〇                  | ◎ (バイブもつけない)                   |
| 4        | コーヒーは午前中に1杯まで        | △                  | △ (飲み終えるのが午後になることが多い) |
| 5        | 日中10分のランニング             | ✘                  | ✘ (運動は8000歩の歩行)                 |
| 6        | 1日20分の昼寝                    | ✘                  | ✘ (昼寝できる場所がなくなった..)       |
| 7        | 1日5食たべる（うち2回間食）      | △                  | △ (三食以外に分散しようとはしてる)     |
| 8        | 寝る前にトイレ                   | ✘                  | ✘ (行きたければ行けばいい)             |
| 9        | 寝る前に心配事を書き出す         | ✘                  | ✘ (心配事で眠れなくなることはない)     |
| 10       | アルコールはワイン少量           | ✘                  | ✘ (アルコール弱いので)                 |

やはり上位3つが非常に大事で、その他は人によると思いました。

### Evernote vs Notion vs ScrapBox vs Roam Research vs Obsidian

最近のメモ/ノートアプリについて比較されています。

{{<summary "https://jmatsuzaki.com/archives/26765">}}

この中ではObsidianが気になりました。

{{<summary "https://obsidian.md/features">}}

私のベストはSlack(times)です。  
ObsidianはSlack(times)にある大きなメリットがあります。

* 場所やデバイスを選ばずに投稿/閲覧できる (クラウド/マルチプラットフォーム)
* 画像や動画なども投稿できる
* ソースコードなども投稿できる
* 時系列を簡単に追える
* 他サービスとの連携も容易
* 指定した範囲に公開できる
* フィードバックをもらえる
* 会社のSlackを使っている場合、投稿NGの内容がほとんどない
    * 業務情報とそれ以外の情報を一元化できる (会社による)

Obsidianはこれらの要件を満たしていなそうなため少し様子見しようと思います。

デメリットはMarkdownや検索に弱いことでしょうか。

### ITエンジニア採用の難しさを要素分解・図示してみた 2020

エンジニアの力は不可欠だけど、それはエンジニアのメイン業務ではないから難しいという話。  

{{<summary "https://note.com/makaibito/n/n3cda7279e012">}}

全員がほんの少しずつ協力することが大切だと思いました。  
未来の同僚を決めるので他人事ではいられないはずです。


試したこと
----------

### 【Rust】ATLrusのmuslビルド

Rustで開発しているAtlassianツール向けCLIのATLrusをmuslビルドしてみました。

{{<summary "https://github.com/tadashi-aikawa/atlrus">}}

muslについては以前の記事をご覧下さい。  
少し古いですが本質は変わっていないはずです。

{{<summary "https://blog.mamansoft.net/2018/08/20/rust-linux-single-binary/#musl%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%9F%E5%AE%8C%E5%85%A8%E3%81%AA%E9%9D%99%E7%9A%84%E3%83%AA%E3%83%B3%E3%82%AF">}}

コマンドも変わっていませんでした。  
実行例に`alias`がついて読みやすくなっただけです。

```
$ alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder'
$ rust-musl-builder cargo build --release
```

{{<github "emk/rust-musl-builder" "https://github.com/emk/rust-musl-builder">}}


調べたこと
----------

なし


整備したこと
------------

### 【IDEA】ツールのデフォルトエンコーディングをUTF-8に戻す

下記対応で泣く泣く`-Dfile.encoding=UTF-8`を除外し頑張っっていたのですが、完全に修正されたようなので元に戻しました。

{{<summary "https://blog.jetbrains.com/ja/2020/03/24/2872/">}}

設定変更はメニューの`Help` > `Edit Custom VM Options..`からできます。

### 【Docker】WSL2にDockerをインストールする

適当に`apt`でインストールしたら認識されませんでした..。

```
docker: unrecognized service
```

ので公式の手順に従います。

{{<summary "https://docs.docker.com/engine/install/ubuntu/">}}

2020-09-20時点では以下のコマンドでインストールできました。

```
# 不要なものを消す
$ sudo apt-get remove docker docker-engine docker.io containerd runc

# インストール作業に必要な依存関係の構築
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# リポジトリの準備
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Docker一式をインストール
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Dockerサービスを起動して動作確認します。

```
# サービス起動
$ sudo service docker start
   * Starting Docker: docker

# 確認
$ sudo docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

root以外のユーザでdockerを実行する場合は以下のコマンドが必要です。  
実行は1度だけでいいはず。

```
sudo cgroupfs-mount
```

`systemd`を使っている場合、cgroup階層の構成は管理されているためこれは不要です。  
WSLは`systemd`を使っていないため、`cgroupfs-mount`を使う必要があるとのこと。

{{<summary "https://github.com/tianon/cgroupfs-mount">}}


今週のリリース
--------------

### Miroir v1.1.0

{{<summary "https://tadashi-aikawa.github.io/miroir/#/releases/1.1.0">}}

#### POSTリクエストでrawを表示できるようになった

以下のようにPOST Bodyに文字列をraw stringとして指定したものが参照できるようになりました。

{{<himg "https://tadashi-aikawa.github.io/miroir/releases/resources/1.1.0_detail-dialog.jpeg">}}

#### Angular8 -> 9にバージョンアップ

先週レポートしたAngularバージョンアップの対応はMiroirに対して行ったものです。

{{<summary "https://blog.mamansoft.net/2020/09/14/2020-09-2w-weekly-report/#angularangular8%E3%81%8B%E3%82%899%E3%81%B8%E3%81%AE%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%82%A2%E3%83%83%E3%83%97">}}


その他
------

4連休でなんとか創の軌跡をクリアしました😆  
これで休日のインプット/アウトプット時間を取り戻せそうです。

{{<summary "https://www.falcom.co.jp/hajimari/">}}

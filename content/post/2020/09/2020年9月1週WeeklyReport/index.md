---
title: 2020年9月1週 Weekly Report
slug: 2020-09-1w-weekly-report
date: 2020-09-02T07:07:31+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - sqlite
  - atlassian
  - jira
  - confluence
  - slack
  - wsl
  - idea
  - vim
  - jumeaux
---

📰 **Topics**

なんとなく使っていたSQLiteのロック周りについて理解を深めました。  
Atlassian Cloud版とSlack連携で強化された機能も試してみました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

なし。


学んだこと
----------

### 【SQLite】ロックについて

仕事でSQLiteを使ったプロダクトがたまに`SQLITE_BUSY`エラーを吐いていたので調べてみました。  
以下のサイトが非常に分かりやすかったです😄 (6年前なので古くなっている情報はあるかもしれません)

{{<summary "https://www.antun.net/tips/api/sqlite.html">}}

特に重要だと感じたポイントをまとめてみます。

#### 操作による影響と条件

| 操作     | sqlite3ファイル | sqlite3-journalファイル | 開始に必要な条件              |
| -------- | --------------- | ----------------------- | ----------------------------- |
| 読みこみ | READ            |                         | コミット中ではない            |
| 書き込み |                 | WRITE                   | 書き込み中/コミット中ではない |
| コミット | WRITE           | READ/DELETE             | 読みこみ中ではない            |

開始条件を満たさない場合は待機が必要で、その時間が一定時間を越えると`SQLITE_BUSY`エラーになります。

#### 暗黙的なトランザクション開始とコミットのタイミング

| 操作                 | オートコミット有効 | オートコミット無効          |
| -------------------- | ------------------ | --------------------------- |
| トランザクション開始 | 書き込み処理の直前 | 書き込み処理の直前          |
| コミット             | 書き込み処理の直後 | I/U/D/R/S 以外のSQL実行直前 |

明示的にBEGIN/COMMITした場合はそちらが優先されます。

#### ロックのタイミング

トランザクション分離レベルがデフォルトだと`DEFERRED`になるようです。  
トランザクション開始後にはじめて更新SQL文が発行されたタイミングでロックがかかる(他の書き込み処理を待機させる)。

#### 今回のケースでは..

エラーとなっていたのは書き込み処理のSQLでした。

書き込み処理に必要な開始条件は『書き込み中/コミット中ではない』ことです。  
つまり、別のSQLによる同DB(ファイル)への更新処理に時間がかかっている..ということです。

ところが、同じ時間帯に書き込み処理はありませんでした。  
このことから、問題は『書き込み処理のロック』ではなく『コミットのロック』.. すなわち『時間のかかる読みこみ処理』ではないかと推測しています。


読んだこと/聴いたこと
---------------------

### 【イベント参加レポート】Builders Box ON AIR #1 レガシーコードからの脱却

豪華なメンバで開催された初めてのイベントについてまとめられたレポート。  
とても現実的で興味深い話が紹介されています。

{{<summary "https://note.com/dora_e_m/n/nb5eec7a69f20">}}

> TDDで得られるのは、20分ごとにフィードバックをくれるエンジニアがそばにいる体験

これとても分かります。  
テストは動作確認以上に、最適な設計へ導いてくれるレビュアーだと常々思っています。

テストが書きにくい場合、大抵インタフェースや設計に問題があります。  
インタフェースはツールやライブラリの使いやすさ、設計は保守性に影響します。

### 良い組織を作るために w/ yunon_phys

組織作りについて、とても現実的な為になる話がされています。

{{<summary "https://fukabori.fm/episode/38">}}


試したこと
----------

### 【Atlassian】Jira/ConfluenceとSlackの連携

Jira CloudとConfluence Cloudについて、Slackとの連携を試してみました。

{{<summary "https://www.atlassian.com/partnerships/slack">}}

気に入った機能を簡潔にピックアップします。

#### JiraやConfluenceで特定のイベントが発生したときSlackへ通知する

最も重要な機能はやはりこれですね！  
JiraやConfluenceのPluginを使わなくても、各自でSlack通知設定できます👍

#### SlackにJiraの課題番号を含めるとプレビューが表示される

`JUMEAUX-15の不具合を確認してもらえますか?`のようにSlackメッセージが課題番号を含むと、そのpreviewがSlack投稿の下に表示されます。  
しかもそこから直接課題を操作できます。

* ウォッチ
* 担当割り当て
* トランジション
* コメント

もちろんリンク(URL)を貼り付けてもプレビューは表示されます。

#### SlackにConfluenceのリンクを含めるとプレビューが表示される

URLのコンテンツを展開してプレビュー表示するのはSlackの標準機能ですね。  
それがConfluenceにも適応されます。

タイトルやスペース、最終更新者/最終更新日を別途記載する必要がなくてGOODです。  
残念ながら、こちらはSlackから直接操作できないようです。

#### Confluenceのコメントに返信する

ConfluenceでコメントがつけられたときSlack通知するようにしている場合、通知の投稿から直接コメントに返信することができます。  
Confluenceを開いてコメントを書く手間が省けます。

#### Jiraの課題を作成する機能

`/jira create タイトル`でSlackからJiraの課題を作成できます。

ただし、その後にSlack上でプロジェクトや課題タイプなどを指定しなければいけません。  
指定できない項目がほとんどなため、Jira本体から作成した方が早いケースも多いでしょう。

以下のような利用シーンが考えられます。

* スマートフォンなどSlackで簡潔させた方が早い場合
* 細かい情報入力が不要な場合
* Slackで議論の流れを記録したい場合

このあたりはChatOpsの落とし所をどこに持ってくるか..という深い話かなと。

あるChannelから一度目の作成はプロジェクトや課題タイプを指定する必要があるため少し面倒ですが、2回目以降はデフォルト値が設定されるのでスムーズに使えそうですね。


調べたこと
----------

### 【WSL】wslコマンドやUbuntu立ち上げでエラーになる

こんなエラーです。

```
Installing, this may take a few minutes...
WslRegisterDistribution failed with error: 0x800701bc
Error: 0x800701bc WSL 2 ???????????? ??????????????????????? https://aka.ms/wsl2kernel ?????????
Press any key to continue...
```

WSL2のLinuxカーネルを更新したらなおりました。

{{<qiita "WSL2の初歩メモ" "https://qiita.com/rubytomato@github/items/a290ecef2ea86ea8350f#wsl2%E3%82%92%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88%E3%81%AB%E8%A8%AD%E5%AE%9A">}}

{{<summary "https://docs.microsoft.com/ja-jp/windows/wsl/wsl2-kernel">}}


整備したこと
------------

### 【IDEA】IdeaVimの`vim-highlighedyank`プラグインエミュレーション

8月末のリリースで追加されたエミュレーション機能です。  
yankした範囲をvisual feedbackしてくれます。

{{<summary "https://github.com/JetBrains/ideavim/blob/master/CHANGES.md#059-2020-08-25">}}

`.ideavimrc`には以下の設定をします。

```
set highlightedyank
```

Visualモードを使わなくても分かりやすいです😄

{{<mp4 "resources/ideavim-highlightedyank.mp4">}}



今週のリリース
--------------

### Jumeaux v2.5.0

{{<summary "https://github.com/tadashi-aikawa/jumeaux">}}

#### POSTリクエストでrawを指定できるようになった

`content-type`を指定せずにPOSTするデータを流し込めるようになりました。  
以前は`application/json`か`x-www-form-urlencoded`しか指定できなかったです。

{{<summary "https://tadashi-aikawa.github.io/jumeaux/ja/releases/v2/#250">}}


その他
------

土日は創の軌跡に時間を奪われてしまっているため、インプット/アウトプットが減りますね..。  
まあこれは物事の優先順位です😅

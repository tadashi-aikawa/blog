---
title: "SlackをエゴサーチするSlackegoを作ってみた"
slug: create-slackego
date: 2018-04-15T20:52:00+09:00
thumbnailImage: https://cdn.svgporn.com/logos/slack.svg
categories:
  - engineering
tags:
  - python
  - slack
  - 情報収集
---

Slackに投稿された内容を対象としてエゴサーチするツール、Slackegoを作ってみました。

<!--more-->

{{<summary "https://github.com/tadashi-aikawa/slackego">}}

<!--toc-->


なぜ作ったのか
--------------

ツールの説明の通り、Slackでエゴサーチをしたかったからです。

同じことを考えている方はいるだろうと思ってググってみましたが、意外にもSlackエゴサーチツールが見つからなかったので作ってしまいました。  
(もし既に同様のツールをご存知の方いらっしゃればコッソリ教えて下さい..)


なぜSlackでエゴサーチをしたかったのか
-------------------------------------

特定の事柄に関連する情報を半リアルタイムに受け取りたかったからです。  
例えば、私が作成したツールの感想などです。


### Publicのchannelにjoinするだけではダメな理由

Slackはpublicなchannelにjoinすることで、自分に必要な情報をリアルタイムに受け取ることができます。  
しかし、この方法では以下の問題が発生します。

* joinしていないchannelの関連情報を取得できない
* 関連度の薄い情報が大量に流れてノイズになる

ハイライトの設定を『特定ワードを含む場合』にすれば、ノイズは解決するかもしれません。  
ただ、本当に必要な情報がjoinしていないchannelにあることも多いです。

これら点を繋ぐ線のような情報網、まとめwikiのようなものを作るにはエゴサーチが必要です。


### Slackの検索機能ではダメな理由

Slackの検索機能を使えば、全channelを横断して検索することができます。  
しかしこれにも同様にいくつか問題があります。

* 自分自身の投稿が結果に表示されてしまう
* 同じ投稿が複数回表示される
* UIが狭く、数も少なくて見にくい (個人差あると思います)
* push型ではなくpull型の情報収集になってしまう

必要なとき能動的に検索するだけなら問題ありませんが、常に情報を取得するためにはエゴサーチが必要です。


Slackego
--------

作成期間は2～3日であり、バージョンは0.1.0です。  
動作にはPython3.6の環境が必要です。

{{<summary "https://github.com/tadashi-aikawa/slackego">}}

インストール方法はREADMEをご覧下さい。使い方は少し補足します。  
実行する前に`Preparation`を忘れず確認して下さい。


### 機能

以下の機能に対応しています。内部ではSlackのSearch APIを使用しています。

* 検索ワードの指定
* 検索期間の指定
* 一定時間ごとの実行
* 結果をSlackに通知する
* 任意のユーザの投稿を結果から除外する
* 任意のchannelの投稿を結果する除外する
* 個人宛のメンションを無効にする (@hereや@channelは有効)

1つ1つ順番に説明します。

{{<alert "warning">}}
Version 0.1.0時点の仕様に準拠しています。  
Versionが上がると情報が事実とは異なる可能性がありますのでご注意下さい。
{{</alert>}}


#### 使い方

`slackego`コマンドを実行するとUsageが表示されます。

```
$ slackego
Usage:
  slackego search <words>... --minutes=<minutes> [--notify=<notify>] [--forever]
```

#### 検索ワードの指定

`slackego search`の後に検索ワードを指定すると、そのワードで検索します。  
以下の例は`mimizou`で検索しています。

```
$ slackego search mimizou
```

複数のワードを指定すると、各ワードに対してそれぞれ個別に検索を行います。  

```
$ slackego search mimizou tatsuwo
```

AND検索にしたい場合はダブルコーテーションで括る必要があります。

```
$ slackego search "mimizou tatsuo"
```

#### 検索期間の指定

`--minutes`の後に検索期間(分)を指定すると、その期間内で検索します。  
以下の例は10分以内の期間で`mimizou`を検索しています。

```
$ slackego search mimizoun --minutes 10
```

#### 一定時間ごとの実行

`--forever`を付けることで`--minutes`で指定した時間ごとに実行することができます。  
以下の例は10分ごとに`mimizou`のエゴサーチをしています。

```
$ slackego search mimizou --minutes 10 --forever
```

#### 結果をSlackに通知する

`--notify`の後にchannel名を指定すると、結果をSlackに通知することができます。  
以下の例は検索結果を`#times_tadashi-aikawa`に転送しています。

```
$ slackego search mimizou --minutes 10 --notify times_tadashi-aikawa
```

{{<alert "warning">}}
`#`は付かないので注意してください。
{{</alert>}}

{{<alert "info">}}
`--notify`で指定したchannelはエゴサーチの対象から外れます。  
通知の無限ループを避けるためです。
{{</alert>}}

#### 任意のユーザの投稿を結果から除外する

主に自分自身の投稿を除外するための機能です。(自分の投稿をサーチする必要はありませんから..)

Configファイルの`exclude.usernames`に指定します。

```yaml
exclude:
  usernames:
    - tadashi-aikawa
```

#### 任意のchannelの投稿を除外する

主に自分が参加しているchannelの投稿を除外するための機能です。  
ユーザの除外とは異なり、用途によって指定する場合としない場合があると思います。

Configファイルの`exclude.channels`に指定します。  
先ほどのユーザ指定とあわせて以下の様になります。

```yaml
exclude:
  usernames:
    - tadashi-aikawa
  channels:
    - times_tadashi-aikawa
```

{{<alert "warning">}}
`#`は付かないので注意してください。
{{</alert>}}


### 設定ファイル

上記説明以外にもいくつか設定項目があります。  
yamlにコメントする形で補足します。

```yaml
exclude:
  # 除外するユーザ名
  usernames:
    - tadashi-aikawa
  # 除外するchannel名 (#は不要)
  channels:
    - times_tadashi-aikawa
# 結果に表示する時間のTimeZone
timezone: Asia/Tokyo
# Slackに結果を通知する場合の情報
user:
  # Slackユーザ名
  name: 'Slackego'
  # Slackユーザのアイコン
  icon_url: https://dl.dropboxusercontent.com/s/a3hilt8vch5zsei/owlmage.jpg
# Slackに結果を通知する場合の表示テンプレート
template: |
  --------------------------------------
  | :house: <{link}|{channel}>
  | :woman: {user}
  | :timer_clock: {datetime}
  | :eyes: {search_word}
  --------------------------------------
  {text}
```

`template`には以下のプロパティを指定することができます。

| プロパティ  | 意味                         | 例                                                               |
|-------------|------------------------------|------------------------------------------------------------------|
| user        | 投稿したユーザ名             | tadashi-aikawa                                                   |
| channel     | 投稿されたchannel            | times_tadashi-aikawa                                             |
| datetime    | 投稿された時間               | 2018-04-15 20:51:09                                              |
| text        | 投稿内容                     | フクロウはいいぞ                                                 |
| link        | 投稿へのパーマリンク         | https://mamansoft.slack.com/archives/C1QPNHCGK/p1523580249000084 |
| search_word | Slackegoで指定した検索ワード | フクロウ                                                         |

{{<alert "warning">}}
Version 0.1.0時点の仕様に準拠しています。  
Versionが上がった場合に情報が事実ではなくなる可能性がありますのでご注意下さい。
{{</alert>}}


今後の展望
----------

ノイズを削除するためのオプションを追加しようと思っています。

例えばワードにJiraやConfluenceを指定して検索をしたとき、JiraやConfluenceのURLが大量にヒットします。  
本当に欲しい情報はURLではないので、それらをフィルタリングする方法を考える必要があります。

参考までに、現時点で私が使っているエゴサーチコマンドは以下になります。

```
$ slackego search jumeaux miroir --minutes 10 --notify times_tadashi-aikawa --forever
```

私がOSSとして作成中のリグレッションテストツール、JumeauxとMiroirのエゴサーチに使っています。

{{<summary "https://tadashi-aikawa.github.io/jumeaux/">}}

{{<summary "https://tadashi-aikawa.github.io/miroir/">}}


総括
----

Slackでエゴサーチできるツール、Slackegoを作成しました。  
今のところ大きな機能追加の予定はありませんが、本当に必要な情報のみを取得できるよう改良を続けていきます。


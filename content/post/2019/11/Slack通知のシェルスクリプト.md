---
title: Slack通知のシェルスクリプト
slug: slack-notification-shell-script
date: 2019-11-27T21:48:55+09:00
thumbnailImage: https://cdn.svgporn.com/logos/slack-icon.svg
categories:
  - engineering
tags:
  - slack
  - shell
  - bash
  - windows
  - linux
---

WindowsとLinuxの両方で動くSlack通知用シェルスクリプトを書いてみました。

<!--more-->


<!--toc-->


はじめに
--------

### 動作環境

以下の環境で動作することを確認済みです。

|                 環境                 |                        バージョン                         |
| ------------------------------------ | --------------------------------------------------------- |
| git bash(Windows 10 Home 10.0.18362) | GNU bash, version 4.4.23(1)-release (x86_64-pc-msys)      |
| bash (Ubuntu 18.04.2 LTS)            | GNU bash, version 4.4.20(1)-release (x86_64-pc-linux-gnu) |

### 前提

Incoming Webhooksのレガシーカスタムインテグレーション を使っています。

{{<summary "https://api.slack.com/custom-integrations/incoming-webhooks">}}

冒頭に記載のあるとおり、**この方法は非推奨です。**  
しかし、**通知先のchannelをパラメータで指定したかったから**敢えてこれを使用しています。

{{<info "非推奨な仕組みを使いたくない場合は">}}
推奨される新しい方法を利用する場合は以下ページを参考にしてください。

{{<summary "https://api.slack.com/messaging/webhooks">}}

その場合、Jsonのスキーマに若干変更があります。
{{</info>}}


実行
----

```
export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/..............
./slack.sh "#your_channel" "スマイル一番"
```

こんな感じに通知されます。

{{<himg "https://dl.dropboxusercontent.com/s/icokye4q8nfv18s/20191127_1.png">}}


実装
----

### ソースコード

以下のような`slack.sh`を作成します。

```bash
#!/bin/bash

set -eu

post_slack() {
  # ex: "#times_hoge"
  channel=$1
  # ex: "hoge"
  user=$2
  # ex: "smile"
  emoji=$3
  # ex: "ほげほげ"
  message=${4//'"'/'\"'}
  # list: good / danger
  color=$5

  file=$(mktemp)
  trap 'rm ${file}' EXIT

  cat << EOJ > "$file"
    {
      "link_names": 1,
      "channel": "${channel}",
      "username": "${user}",
      "icon_emoji": ":${emoji}:",
      "attachments": [
        {
          "color": "${color}",
          "text": "${message}"
        }
      ]
    }
EOJ

  curl -s -S -X POST -d @"$file" "${SLACK_WEBHOOK_URL}"
}

post_slack "$1" smile_bot smile "$2" good
```

{{<warn "上記コードについて">}}
ブログ執筆時のコードです。  
最新のページをご覧下さい。

{{<summary "https://mimizou.mamansoft.net/it_note/services/slack/snippets/#bash">}}

{{</warn>}}


### ポイント

実装にあたり、いくつかポイントがあります。

#### 日本語のメッセージを送信できるようにする

_Windowsの場合のみ日本語メッセージが送れない_..という問題がありました。  
以下はそのときの`curl`コマンドです。

```
curl -s -S -X POST --data-urlencode 'payload={"link_names": 1, "channel": "'"${channel}"'", "username": "'"${user}"'", "icon_emoji": "'":${emoji}:"'", "attachments": [{"color": "'"${color}"'", "text": "'"${message}"'"}]}' ${SLACK_WEBHOOK_URL}
```

`curl -X POST --data-urlencode`でマルチバイト文字をPOSTできます。  
しかし、Windowsの場合はエンコーディングが`CP932`に強制されてしまいます。  
SlackのAPIは`UTF-8`を要求するため、POSTしたJSONが正しくparseされずエラーになります。

解決策として、JSONをUTF-8エンコードした一時ファイルを作成し、`curl --data-binary @{file}`でファイルを指定するようにしました。

```bash
file=$(mktemp)

echo 'payload={"link_names": 1, "channel": "'"${channel}"'", "username": "'"${user}"'", "icon_emoji": "'":${emoji}:"'", "attachments": [{"color": "'"${color}"'", "text": "'"${message}"'"}]}' > "$file"

curl -s -S -X POST --data-binary @"$file" ${SLACK_WEBHOOK_URL}
```

#### JSONを読みやすくする

1行で書かれたJSONは読みにくいです。
`curl --data-binary`の代わりに`curl -d`を使うと改行の含むJSONをPOSTできます。

また、ヒアドキュメントを使うことで`"'"`といった複雑なコーテーションを排除しました。

```bash
file=$(mktemp)

cat << EOJ > "$file"
  {
    "link_names": 1,
    "channel": "${channel}",
    "username": "${user}",
    "icon_emoji": ":${emoji}:",
    "attachments": [
      {
        "color": "${color}",
        "text": "${message}"
      }
    ]
  }
EOJ

curl -s -S -X POST -d @"$file" ${SLACK_WEBHOOK_URL}
```

#### 一時ファイルが残らないようにする

`rm -rf ${file}`を最後に実行すれば問題ないでしょうか?  
途中でエラーが発生したり、強制終了されたら一時ファイルがゴミとして残ってしまいますね😅

`mktemp`で作られるファイルパスはテンポラリー領域を指します。  
放っておいても定期的に削除されるかもしれませんが、すぐ削除した方が安心です。

`trap`コマンドで`EXIT`シグナルを受け取ったとき、ファイルを削除するようにしました。

```bash
file=$(mktemp)
trap 'rm ${file}' EXIT

cat << EOJ > "$file"
  {
    "link_names": 1,
    "channel": "${channel}",
    "username": "${user}",
    "icon_emoji": ":${emoji}:",
    "attachments": [
      {
        "color": "${color}",
        "text": "${message}"
      }
    ]
  }
EOJ

curl -s -S -X POST -d @"$file" ${SLACK_WEBHOOK_URL}
```

`set -x slack.sh`でデバッグ出力すると、必ず最後に`rm ${file}`が実行されることを確認できます。

#### ダブルクォーテーションの考慮

{{<update "2020-02-07: ダブルクォーテションの考慮について追記しました">}}
{{</update>}}

`message`にダブルクォーテーションを含むと、ivalid payloadエラーになります。  
そのため変数代入時に`"`を`\"`に置換して代入する必要があります。

```bash
  # ex: "ほげほげ"
  message=${4//'"'/'\"'}
```


総括
----

Windows(git bash)とLinux(bash)の両方で動くSlack通知用シェルスクリプトを紹介しました。  
文字コードや使えるコマンドの制限など、Linuxだけのときに比べて気をつける必要があります。

しばらくの間は安心してSlack通知ができそうです😄

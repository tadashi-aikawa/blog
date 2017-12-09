---
title: "React Storybookを使用したVisual regression testingの導入"
date: 2017-11-16
thumbnailImage: https://dl.dropboxusercontent.com/s/huwknua0ma443cr/20171116_1.png
categories:
  - engineering
tags:
  - react
  - typeScript
  - test
---

React Storybookに登録したコンポーネントに対し、継続的にVisual regression testing(画像差分比較)する仕組みを導入しました。

<!--more-->

{{<himg "https://dl.dropboxusercontent.com/s/jvvkdv9qtuw41wq/20171116_2.png">}}

<!--toc-->


はじめに
--------

### 前提条件

本記事では実現にあたり以下の技術を使用しています。  
本質以外の説明を省くため、ほとんどの技術については説明すら行いませんのでご注意下さい。

|           名称           |             求めるスキルレベル              | 本記事での説明 |
| ------------------------ | ------------------------------------------- | -------------- |
| Docker                   | Dockerfileが理解できること                  | なし           |
| Git                      | 概念を理解しており一通り使えること          | なし           |
| Google chrome (Headless) | 概念を理解していること                      | なし           |
| AWS S3                   | 概念を理解していること                      | なし           |
| Jenkins                  | 概念を理解していること                      | なし           |
| React Storybook          | 利用したことがあること                      | なし           |
| npm 5                    | `package.json`のscriptsコマンドが読めること | なし           |
| Python                   | SimpleHTTPServerを知っていること            | なし           |
| NodeJS 8                 | 特になし                                    | なし           |
| LOKI                     | 特になし                                    | あり           |
| REG-SUIT                 | 特になし                                    | あり           |
| Owlora                   | 特になし                                    | あり           |


### 全体の流れ

まず、今回使用するメインツールであるLOKIとREG-SUITの紹介をします。  
次に目指す全体像を共有し、最後にそれを実現するための方法を説明します。


利用技術の説明
--------------

### LOKI

Visualized Testを実施するためにはStorybookのページにアクセスし、キャプチャする仕組みが必要です。  
この機能を持ったツールがLOKIです。

{{<summary "https://github.com/oblador/loki">}}

上記に `Visual Regression Testing for Storybook` とある通り、LOKIはリグレッションテストまで実施することのできるツールです。  
しかし、以下の理由から差分比較部分は別のツールを使うことにしています。

* 画像をGitにコミットしなくてはいけない
* 出力結果が画像のみのため結果が一目で分からない
* 差分の表示方法が好みではない


### REG-SUIT

CUIでVisual regression testingを実施するツールです。

{{<summary "https://github.com/reg-viz/reg-suit">}}

LOKIとの大きな違いは **画像が存在する前提であること** です。  
なので、画像の作成は別のツールで行う必要があります。(React Storybookには依存しません)

私がREG-SUITのリグレッションテスト機能を選んだ理由は以下の通りです。

* 画像をGitにコミットする必要がない
* 結果レポートが非常に見やすい
* GitHubフローとの親和性が高い

画像やレポートの保存にはAWS S3を使用しますので、Gitにコミットする必要はありません。  
コミットせずに比較対象の画像をどう特定するかは後ほど説明します。


### Owlora

今回、Visual regression testingを導入する対象プロジェクトです。  

{{<summary "https://github.com/tadashi-aikawa/owlora">}}

OwloraはTodoistのデータを使用して、Todoistが苦手としている1週間～1ヶ月という中期タスク管理をサポートするツールです。  
まだ発展途上にあるため、マニュアルなどは整備しておりませんが興味ありましたらお声がけ下さい。  
TodoistとGoogleのアカウントがあれば利用可能です。

Owloraは以下の技術を使用しています。

* TypeScript
* React, React Storybook
* Redux, Redux Saga
* Webpack
* Firebase
* Jest (Structual testing)


全体の流れ
----------

今回実施する作業の全体像を説明します。

{{<himg "https://dl.dropboxusercontent.com/s/huwknua0ma443cr/20171116_1.png">}}

① Dockerイメージの作成  
② Storybookのキャプチャ画像を作成  
③ 前回のキャプチャと比較してレポートを作成  
④ レポートをアップロードして確認  

1の作業に入る前に対象プロジェクトをCloneしておきます。ここではOwloraです。


Dockerイメージの作成
--------------------

①の部分です。

環境をクリーンに保ち、依存関係を薄くするためにDockerを使用します。  
以下のDockerfileを作成しましょう。

```ruby
# NodeJS 8 と npm 5を含むイメージを使用
FROM node:8

# 基本モジュールの整理
RUN apt-get update && apt-get install -y wget git

# Install Google chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get -y install gconf-service \
                       libasound2 \
                       libatk1.0-0 \
                       libcups2 \
                       libdbus-1-3 \
                       libgconf-2-4 \
                       libgtk-3-0 \
                       libnspr4 \
                       libx11-xcb1 \
                       libxss1 \
                       fonts-liberation \
                       libappindicator1 \
                       libnss3 \
                       lsb-release \
                       xdg-utils
RUN dpkg -i google-chrome-stable_current_amd64.deb

WORKDIR /usr/src/app

# 依存モジュールに変更があった場合はインストールし直す
# React Storybook, LOKI, REG-SUITはここでインストールされる
COPY package-lock.json /usr/src/app/
COPY package.json /usr/src/app/
RUN npm install

# node_modulesを含む全ての情報をコピー
COPY . /usr/src/app
```

上記のDockerfileを実行すれば、必要なモジュールは全てDockerイメージに含まれます。  
作成されたイメージからビルドやテストを実行することができます。

{{<alert success>}}
Pythonはベースイメージに含まれるため明示的にインストールしていません。
{{</alert>}}

`docker build` はもう少し待って下さい。  
LOKIとREG-SUITを使用するため、該当プロジェクト(Owlora)に変更を加える必要があるためです。


Storybookのキャプチャ画像を作成
-------------------------------

②の部分です。大きく分けて以下の2ステップがあります。

1. Storybookをビルドして静的ページを作成する
2. LOKIを実行してキャプチャ画像を作成する

### Storybookをビルドして静的ページを作成するための設定

`package.json`のscriptsコマンドにビルドコマンドを定義しておきましょう。  
これでStorybookをビルドすることができます。

```json
"scripts": {
    .
    .
    "build-storybook": "build-storybook",
    .
    .
}
```

#### Storybookのビルドに失敗する場合

UglifyJsPluginがES2015に未対応であるため、targetがES2015以降の場合にビルドできない場合があります。  
その問題を回避するため、Storybookで参照している設定ファイルを以下の様にしました。

```js
const merge = require('webpack-merge')
const baseConfig = require('../webpack.config');

module.exports = (storybookBaseConfig, configType) => {
  if (configType === 'PRODUCTION') {
    // see https://github.com/storybooks/storybook/issues/1570
    storybookBaseConfig.plugins = storybookBaseConfig.plugins.filter(plugin => plugin.constructor.name !== 'UglifyJsPlugin')
  }

  const extension = {
    resolve: {
      extensions: baseConfig.resolve.extensions
    },
    module: {
      rules: baseConfig.module.rules
    },
    plugins: baseConfig.plugins
  };

  return merge(storybookBaseConfig, extension);
};
```

PRODUCTIONビルドの時以外はUglifyJSPluginを使用しないようにすることで問題を回避しています。  
`extension`に代入する値は、1つ上の階層にある `../webpack.config` の設定次第で変更する必要があります。

{{<alert warning>}}
webpack-mergeのインストールが別途必要です。

```
$ npm i -D webpack-merge
```
{{</alert>}}

あまりキレイな方法では無いため代替案が望まれます。


### LOKIの初期設定1

LOKIのインストールとセットアップをしましょう。

```
$ npm i -D tadashi-aikawa/loki#master
$ npx loki init
```

`init` コマンドによる変更点は以下2点です。

* `package.json`に`loki`プロパティが追加される
* `.storybook/config.js`に`import 'loki/configure-react';`が追加される

#### `npm i -D loki` ではない理由

オリジナル版では表示の途中でキャプチャされてしまうため、正確なテストが行えませんでした。  
以下のIssueに起票しています。

{{<summary "https://github.com/oblador/loki/issues/32">}}

上記問題を解決するためにforkを行い、以下の機能を追加しました。

* kindとstoryの値によって、ブラウザのロード完了からキャプチャまでの間に待ち時間を設定できる

{{<summary "https://github.com/oblador/loki/pull/33">}}

{{<alert info>}}
2017/12/09 追記

上記のプルリクエストは採用されませんでしたが、代わりに下記の機能を入れて頂きました。  
記述量は増えますが、同様のことができるようです。
{{<summary "https://github.com/oblador/loki/pull/37">}}
{{</alert>}}


### LOKIの初期設定2

#### pacakge.json

`package.json`にはLOKIの設定が記述されています。以下のように変更します。

```json
  "loki": {
    "configurations": {
      "chrome.laptop": {
        "target": "chrome.app",
        "waitBeforeCapture": [
          {
            "kind": "^DailyCard$",
            "story": "^Summary$",
            "millSec": 10000
          },
          {
            "kind": ".+",
            "story": ".+",
            "millSec": 1000
          }
        ],
        "width": 1920,
        "height": 0
      }
    }
  }
```

`height`はStoryによって高さを自動的に増やすため、0にしています。  
`waitBeforeCapture`はforkして作成した機能のプロパティであり、上記は以下の意味を持ちます。

* kindがDailyCard, storyがSummaryに一致する場合はキャプチャ直前に10秒待つ
* 上記以外の場合はキャプチャ直前に1秒待つ

`DailyCard > Summary`は1つ目のStoryです。  
初回のアクセスは数秒経つまで全てが表示されないため、10秒にしています。

#### .gitignore

以下をバージョン管理下から外しましょう。

* Storybookの静的ページが作成されるディレクトリ`storybook-static`
* キャプチャ画像の出力先`.captures`


### LOKIを実行してキャプチャ画像を作成するコマンドの設定

`capture-images`コマンドを作成します。

{{<alert danger>}}
色々ハマリポイントがありました。
理由が分からないものもあり、対策が適切でない可能性があります。
{{</alert>}}

```json
"scripts": {
    .
    .
    "capture-images": "(cd storybook-static && python -m SimpleHTTPServer 6006) & CI=yes loki --chromeConcurrency 1 --output .captures --chromeFlags='--headless --disable-gpu --hide-scrollbars --no-sandbox'; pkill python",
    .
    .
}
```

#### SimpleHTTPServerを実行している理由

LOKIは本来、静的なStorybookに対してキャプチャする機能を備えています。  
ただ、今回のようなDocker環境下において、ブラウザへの接続が全く成功しなかったため、代わりにSimpleHTTPServerを使用することにしました。

#### `CI=yes`を環境変数に設定している理由

`CI`が未指定の場合に実行すると以下のエラーになります。

```
docker: Error response from daemon: linux seccomp: seccomp profiles are not supported on this daemon, you cannot specify a custom seccomp profile.
```

このエラーの意味をちゃんと理解していませんが、CI実行時には`CI`を設定すべきと書かれていたので、設定することで回避するようにしました。

#### `--chromeConcurrency -1`を指定している理由

これはテストの並列実行数です。Chromeのプロセス、Windows、タブ.. どの単位で並列になるかまでは確認していません。  
ただ、並列実行すると一定確率でデッドロックが発生し、度々テストに失敗していたため1に制限するようにしました。

並列実行の方が完了も早いので、デフォルト設定の4に戻したいですね。

#### `--chromeFlags`を指定している理由

`--no-sandbox`を指定しなければ動作しない場合があり、指定するためです。  
デフォルトは`--chromeFlags='--headless --disable-gpu --hide-scrollbars'`となっており、`--no-sandbox`が含まれません。

`--no-sandbox`オプションを付けるとなぜ回避できるのか理由は分かりません。  
安全性は少し下がるみたいですが、テスト時のみコンテナ内での実行なので許容できるかなと思っています。


前回のキャプチャと比較してレポートを作成
----------------------------------------

③と④の部分です。作成は概ね③であり、④はレポートをS3にPutしているだけです。

### REG-SUITの初期設定

REG-SUITの初期化コマンドを実行しましょう。

```
$ npx reg-suit init
```

インストールするプラグインは以下を選択します。

* reg-keygen-git-hash-plugin
  * スナップショットのkeyにgit hashを使うことができる
* reg-publish-s3-plugin
  * S3をストレージとして使用することができる

いくつか質問されますので回答します。

> Working directory of reg-suit. (.reg)

作業ディレクトリは`.reg`で問題ありませんのでEnterを押します。

> Directory contains actual images. (directory_contains_actual_images)

現在の画像が格納されたディレクトリを指定します。  
LOKIの出力先は`.captures`としていましたので、`.captures`と入力してEnterを押します。

> Threshold, ranges from 0 to 1. Smaller value makes the comparison more sensitive. (0)

比較をどれだけ正確に実施するかの閾値です。  
数値が1に近づくほど、実際は差分があっても差分無しと判断するようになります。

0より大きくすると小さな差分を見逃してしまうので、デフォルト値0のままEnterを押します。

> Create a new S3 bucket (Y/n)

S3にBucketを今作成するかどうかです。  
**Bucketをパブリックにして問題ある場合は作成しないよう`n`を選択しましょう。**  
パブリックで問題ない場合は、そのままEnterを押せばBucketが作成されます。

> Existing bucket name

Bucketを作成しなかった場合は使用するBucketの名前を入力しましょう。

> Update configuration file

上記回答結果から設定ファイルを作成しますのでEnterを押します。

> Copy sample images to working dir

作業ディレクトリ`.reg`にサンプル画像を配置するかどうかです。  
必要ないので`n`を入力してEnterを押します。

作成された`regconfig.json`は以下のようになりました。

```json
{
  "core": {
    "workingDir": ".reg",
    "actualDir": ".capture",
    "threshold": 0
  },
  "plugins": {
    "reg-keygen-git-hash-plugin": true,
    "reg-publish-s3-plugin": {
      "bucketName": "hogehoge"
    }
  }
}
```


### 前回のキャプチャと比較してレポートを作成するコマンドの設定

`package.json`に以下のコマンドを追加します。

```json
"scripts": {
    .
    .
    "compare-images": "reg-suit sync-expected && reg-suit compare",
    .
    .
}
```

`reg-suit sync-expected`は比較対象画像をS3から作業ディレクトリにフェッチします。  

比較対象画像は、Gitのコミットグラフを解析して選ばれた最適な対象(ハッシュ)を元にフェッチされます。  
③のコミットグラフでは、カレントブランチ`feature`が`master`の分岐元となる`abcde1`を選んでいます。

`reg-suit compare`は比較対象画像と現在の画像を比較してレポートを作成します。  
実際のレポートはHTMLファイルだけでなく、jsファイルや比較結果画像も含まれます。


### レポートと現在の画像をS3にアップロードする設定

`package.json`に以下のコマンドを追加します。

```json
"scripts": {
    .
    .
    "publish-report": "reg-suit publish",
    .
    .
}
```

`reg-suit publish`は比較結果を現在の画像と一緒にS3へアップロードします。

### 補足

#### reg-suit run を使用しない理由

`reg-suit run`は`reg-suit sync-expected && reg-suit compare && reg-suit publish -n`と同じ意味です。   
`scripts`を1つのコマンドにすることもできますが、比較(③)だけを行いアップロード(④)をしたくないケースがあるため分けています。

#### reg-suit コマンドを実行する場合の注意

`reg-suit`コマンドは **GitのWorking directoryに変更が無い状態** で行って下さい。  
現在の状態としてHEADのハッシュを利用するため、変更がある状態で実行すると、同じハッシュで異なる結果が生成されてしまいます。


①～④を実行
------------

長い準備お疲れ様でした。それでは実行してみましょう。

...とその前にタスクランナーとして実行したいので、`Makefile`を作成します。

```bash
DOCKER_PREFIX ?=
DOCKER_IMAGE ?= tadashi-aikawa/owlora

define run-npm-command
	$(DOCKER_PREFIX) docker run --rm \
	  -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
	  -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
	  -t $(DOCKER_IMAGE) \
	  npm run $(1)
endef

build-image: ## Build docker image
	@echo 'Starting $@'
	$(DOCKER_PREFIX) docker build -t $(DOCKER_IMAGE) .
	@echo 'Finished $@'

visualized-test: build-image ## Visualized test. Need to set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
	@echo 'Staring $@' 
	@$(call run-npm-command,visualized-test)
	@echo 'Finished $@'
```

`package.json`に最後のコマンドを追加します。今までの集大成ですね。

```json
"scripts": {
    .
    "clean-visualized-test": "rm -rf .captures .reg",
    "visualized-test": "run-s build-storybook clean-visualized-test capture-images compare-images publish-report",
    .
    .
}
```

`run-s`は`npm-run-all`の機能で、指定したscriptsコマンドを直列に実行します。  
使用していない場合は`npm i -D npm-run-all`でインストールしておいてください。

`make visualized-test` を実行して成功すればOKです。  
最後に表示されるURLにアクセスして、レポートが表示されることを確認してみましょう。


Advanced
--------

### Slack通知について

REG-SUITの`reg-notify-slack-plugin`を使用すればSlackに通知することができます。  
メッセージのカスタマイズはできないため、その場合は自分で通知するようにしましょう。

OwloraはMakefileの中でSlackへの通知を行っています。

<blockquote class="embedly-card"><a href="https://github.com/tadashi-aikawa/owlora/blob/master/Makefile">tadashi-aikawa/owlora</a><p>Contribute to owlora development by creating an account on GitHub.</p></blockquote>

{{<alert danger>}}
Slack Webhook URLはコミットしないようにしましょう。
Owloraでは`make visualized-test-init`を実行することで、都度`regconfig.json`を作成するようにしています。
{{</alert>}}


### Jenkinsについて

JenkinsでCIを実施する場合、設定で注意する点を紹介します。

#### ソースコード管理

* `ビルドするブランチ > ブランチ指定子` には `**` を指定
    * pushされた場合に必ず実行するため (Branchが作成される可能性が0のコミットに対しては実施しなくてもOK)
* `追加処理`には以下を追加
    * Clean before checkout
      * バージョン管理化に無いものを削除するため
    * Prune stale remote-tracking branches
      * 削除済みremoteブランチを削除するため
    * Check out to specific local branch
      * HEADでチェックアウトされると、REG-SUITが比較対象ハッシュを導出できないため
      * ブランチ名は空白
        * `origin/xxx`のブランチでhookしたとき、`xxx`とチェックアウトしてくれる

#### バインディング

秘密情報を使用するため、秘密テキストとして以下を設定しています。

|          秘密情報           |              変数に設定する用途              |
| --------------------------- | -------------------------------------------- |
| S3バケット名                | `regconfig.json`の作成に必要                 |
| Slack Webhook URL           | `regconfig.json`の作成に必要                 |
| AWSアクセスキーID           | Dockerコンテナ内に環境変数を設定するため必要 |
| AWSシークレットアクセスキー | Dockerコンテナ内に環境変数を設定するため必要 |

#### ビルド

シェルコマンドは以下の1行です。

```
$ make visualized-test-init visualized-test
```


### レポートの公開範囲について

デフォルトではACLが`public-read`になるため、全世界の人が閲覧可能です。  
公開範囲を狭めたい場合は、`regconfig.js`のオプションに`"acl: private"`を設定しましょう。

ACLの設定はプルリクエスト作成してマージしていただきました。ありがとうございました。

{{<summary "https://github.com/reg-viz/reg-suit/pull/97">}}


総括
----

React Storybookを使用してVisual regression testingを実現する手法を紹介しました。  
REG-SUITは画像比較に特化しているため、LOKIの部分をSeleniumなどに置き換えればStorybook以外のケースでも快適なテスト環境を構築することができそうです。

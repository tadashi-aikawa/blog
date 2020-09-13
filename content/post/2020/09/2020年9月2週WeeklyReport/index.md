---
title: 2020年9月2週 Weekly Report
slug: 2020-09-2w-weekly-report
date: 2020-09-14T07:58:21+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - typescript
  - idea
  - golang
  - vscode
  - slack
  - cobra
  - viper
  - zerolog
  - angular
---

📰 **Topics**

Go言語に集中した1週間でした。  
Project ReferencesやAngularバージョンアップなどTypeScriptにも取り組みました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【TypeScript】リリースノート v3.0

TypeScript v3.0のリリースノートをまとめ終わりました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/2.9/">}}

Project Referencesの理解に苦しみました。  
先にビルドモードから入ることでメリットをすんなり理解できたので、構成をそのように変えています。

### 【IDEA】プロジェクト内のシンボル検索

以前執筆した『必ず使ってほしいIntelliJ IDEAのAction』にプロジェクト内のシンボル検索を追加しました。

{{<summary "https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E5%86%85%E3%81%AE%E3%82%B7%E3%83%B3%E3%83%9C%E3%83%AB%E6%A4%9C%E7%B4%A2">}}

こんな機能です。

{{<himg "https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/resources/20190518_13.gif">}}

名前だけ分かるけどシンボルの種類が分からないときにオススメです。


学んだこと
----------

### 【Golang】プログラミング言語Go完全入門

tenntennさんが作成されているGo言語の入門スライドを読み始めました。

{{<summary "https://docs.google.com/presentation/d/1RVx8oeIMAWxbB7ZP2IcgZXnbZokjCmTUca-AbIpORGk/edit">}}


#### 1. Goに触れる

エコシステム周りは特に最前線の方による情報が重宝します。

{{<summary "https://docs.google.com/presentation/d/1Z5b5fIA5vqVII7YoIc4IesKuPWNtcU00cWgW08gfdjg/edit">}}

#### 2. 基本構文

こちらは以前の思い出し..という感じで読んでみました。

{{<summary "https://docs.google.com/presentation/d/1CIMDenDLZ7NPNgzmfbCNH_W3dYjaTEBdUYfUuXXuMHk/edit">}}

### 【TypeScript】リリースノートチェックにはVS Codeを使った方がいい

自分の知識向上を目的として、過去のTypeScriptリリースノートをまとめています。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/">}}

今までIntelliJ IDEAとターミナルで動作確認をしていましたが、v3.1の`Mapped types on tuples and arrays`に関する動作を確認しようとしたときハマりました。。  
リリースノートの内容とIntelliJ IDEAの補完内容とが噛み合っていなかったのです。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/3.1/#mapped-types-on-tuples-and-arrays">}}

VS Codeを使って確認することにより、この問題は解決しました。  
やはり、リリースノートのような細かな内容を確認するときはVS Codeが良さそうです。  
開発元が同一である強みですね。

※ IntelliJ IDEAもLanguage Server使っているので問題ない気はするのですが..🤔


読んだこと/聴いたこと
---------------------

### チート（みんな楽したい）：行動経済学とデザイン30｜ジマタロ

チート戦略、習慣化戦略、意識化戦略と名付けられた3つの戦略について説明している記事。

{{<summary "https://note.com/designstrategy/n/n0adc9d52aecc">}}

特に大事だと思ったのが以下。

> ただし注意が１つあります。ユーザーは楽チンなものに高額なお金を支払うわけではなく、あくまでも同じ価格帯の中で楽チンな方を選びます。

楽チンであることはお金を払う理由にはならないということ。  
価値が提供できることは大前提ですね。

> ３つ目は、面倒なものを愛そうという文化が生まれます。車が普及するとランニングが人気になったり、家電が普及するとキャンプが人気になったり、スマホが進化するとマニュアルカメラ愛好家が増えたり。この観点は『意味のイノベーション』にもつながると思います。

この発想は面白いですね。たしかに。

### 仕事がサクサク進む！「タスク管理上手になるための4つの極意」

タスク管理における非常に重要なポイントが紹介されています。

{{<summary "https://limo.media/articles/-/19173">}}

『Todoリストは意味が無い』という方.. 使い方を見直すだけで価値も変わりますのでオススメ。

### 【TypeScript】TypeScript 4.0: What I’m most excited about

TypeScriptの主な変更点について、利用者目線でアツく語られています。

{{<summary "https://blog.bitsrc.io/typescript-4-0-what-im-most-excited-about-4ee89693e02e">}}

公式リリースノートより感情移入しやすくオススメ。


試したこと
----------

### 【Golang】Cobra

仕事でGo言語を使ったCLIツールを作ることになったので、CLIフレームワークを調べてみました。  
その結果、Cobraが良さそうということに。

{{<summary "https://github.com/spf13/cobra">}}

#### 選んだ理由

* 欲しい機能が一通りある (サブコマンド、Usageの表示、ドキュメント)
* 使い方が直感的
* スターが多い(2万弱)
* メンテされている形跡がある(1ヶ月以内)
* 名だたるツールで[利用実績]がある(Docker, GitHub, Hugo, Kubernetes.. etc)

[利用実績]: https://github.com/spf13/cobra/blob/master/projects_using_cobra.md

#### cobraのCLIコマンドをインストールする

cobraのCLIコマンドを使うため、グローバルにインストールします。

```
go get -u github.com/spf13/cobra/cobra@v1.0.0
```

{{<why "なぜバージョンを指定するのか?">}}
2020-09-09現在ではバージョン未指定だと以下のエラーが出るためです。

```
$ go get -u github.com/spf13/cobra/cobra
go: github.com/spf13/cobra/cobra upgrade => v0.0.0-20200826151851-02a0d2fbc9e6
go get github.com/spf13/cobra/cobra: ambiguous import: found package github.com/spf13/cobra/cobra in multiple modules:
    github.com/spf13/cobra v1.0.0 (/Users/jimbrannlund/go/pkg/mod/github.com/spf13/cobra@v1.0.0/cobra)
    github.com/spf13/cobra/cobra v0.0.0-20200826151851-02a0d2fbc9e6 (/Users/jimbrannlund/go/pkg/mod/github.com/spf13/cobra/cobra@v0.0.0-20200826151851-02a0d2fbc9e6)
```

Issueではバージョン指定の回避策が紹介されていました。

{{<github "#1215 'ambiguous import'-error when trying to 'go get' cobra" "https://github.com/spf13/cobra/issues/1215">}}
{{</why>}}

#### cobraでCLIプロジェクトを作る

cobraのCLIコマンドを使うことで、雛形をすぐに作成できます。  
以下を参考に進めます。

{{<summary "https://github.com/spf13/cobra/blob/master/cobra/README.md">}}

`init`コマンドでアプリケーションディレクトリを作成します。  
パッケージ名は適当に`work/sandbox/golang/cobra-use`としました。

```
$ cobra init --pkg-name work/sandbox/golang/cobra-use cobra-use
Your Cobra applicaton is ready at
C:\Users\syoum\work\sandbox\golang/cobra-use
```

作成されたディレクトリの構成は以下の通り。

```
  ./cobra-use
├──   cmd
│  └──   root.go
├──   LICENSE
└──   main.go
```

`cobra-use`に移動してModuleの初期化をします。

```
$ go mod init work/sandbox/golang/cobra-use
go: creating new go.mod: module work/sandbox/golang/cobra-use
```

そしてcobraをプロジェクトの依存関係に設定します。

```
go get -u github.com/spf13/cobra/cobra@v1.0.0
```

`main.go`を実行するとデフォルトのメッセージが表示されます。

```
$ go run main.go
A longer description that spans multiple lines and likely contains
examples and usage of using your application. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.
```

#### showコマンドを追加する

`show --message ほげ`で『ほげ』と表示されるコマンドを作ってみます。  
`cobra add`でコマンドを追加できます。

```
$ cobra add show
show created at C:\Users\syoum\work\sandbox\golang\cobra-use
```

`cmd`ディレクトリ配下に`show.go`が追加されました。

```
  ./cobra-use
├──   cmd
│  ├──   root.go
│  └──   show.go
├──   go.mod
├──   go.sum
├──   LICENSE
└──   main.go
```

`show.go`の中身から英語コメントを削除して日本語コメントで補足するとこんな感じです。

```go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var showCmd = &cobra.Command{
	Use:   "show",
	Short: "showコマンドの短い説明",
	Long: `showコマンドの長い説明`,
	Run: func(cmd *cobra.Command, args []string) {
		// コマンド実行時の挙動を書く
		fmt.Println("show called")
	},
}

// コマンド初期化処理
func init() {
	// rootに対してshowコマンドを追加する = main command
	rootCmd.AddCommand(showCmd)

	// このコマンドおよび全てのサブコマンドで利用できるフラグはPersistentFlag
	// showCmd.PersistentFlags().String("foo", "", "A help for foo")

	// このコマンドだけで利用できるフラグはLocalFlag
	// showCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
```

`show --message <message>`の実装をしてみます。

```go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// フラグで参照する変数を宣言
var message string

var showCmd = &cobra.Command{
	Use:   "show",
	Short: "showコマンドの短い説明",
	Long:  `showコマンドの長い説明`,
	Run: func(cmd *cobra.Command, args []string) {
		// messageを表示. コマンドで指定した値はfuncの引数に入ってくるわけでない
		fmt.Println(message)
	},
}

// コマンド初期化処理
func init() {
	// rootに対してshowコマンドを追加する = main command
	rootCmd.AddCommand(showCmd)

	// -m / --message で指定した文字列が message変数 に入る.
	showCmd.Flags().StringVarP(&message, "message", "m", "", "表示するメッセージ (required)")
	// このフラグは必須 (任意の場合は↑のStringVarPでvalueにデフォルト値を設定する)
	_ = showCmd.MarkFlagRequired("message")
}
```

#### コマンドをビルドして実行する

ビルドしてコマンドを実行してみます。せっかくなのでexeで。  
ドサクサに紛れて`root.go`も少しいじりました。

```terminal
$ go build

$ .\cobra-use.exe
cobraを使ったCLIの実験用プロジェクト

Usage:
  cobra-use [command]

Available Commands:
  help        Help about any command
  show        showコマンドの短い説明

Flags:
      --config string   config file (default is $HOME/.cobra-use.yaml)
  -h, --help            help for cobra-use
  -t, --toggle          Help message for toggle

Use "cobra-use [command] --help" for more information about a command.


$ .\cobra-use.exe show -h
showコマンドの長い説明

Usage:
  cobra-use show [flags]

Flags:
  -h, --help             help for show
  -m, --message string   表示するメッセージ (required)

Global Flags:
      --config string   config file (default is $HOME/.cobra-use.yaml)


$ .\cobra-use.exe show --message ほげ
ほげ


$ .\cobra-use.exe show -m ほげ
ほげ


$ .\cobra-use.exe show --hoge ほげ
Error: unknown flag: --hoge
Usage:
  cobra-use show [flags]

Flags:
  -h, --help             help for show
  -m, --message string   表示するメッセージ (required)

Global Flags:
      --config string   config file (default is $HOME/.cobra-use.yaml)

unknown flag: --hoge


$ .\cobra-use.exe show
Error: required flag(s) "message" not set
Usage:
  cobra-use show [flags]

Flags:
  -h, --help             help for show
  -m, --message string   表示するメッセージ (required)

Global Flags:
      --config string   config file (default is $HOME/.cobra-use.yaml)

required flag(s) "message" not set
```

他にもサブコマンドや色々な機能があります..がキリがないので今日はこの辺で。

### 【Golang】zerolog

Go言語の標準ロガーが機能不足なので、`zerolog`を使ってみました。

{{<summary "https://github.com/rs/zerolog">}}

デフォルトではJSON形式のログが生成されるため解析に向いています。

```go
package main

import (
	"github.com/rs/zerolog/log"
)

func main() {
	log.Info().Msg("INFO")
	log.Error().Str("Reason", "unknown").Msg("ERROR")
}
```

`出力結果`
```
{"level":"info","time":"2020-09-12T14:00:39+09:00","message":"INFO"}
{"level":"error","Reason":"unknown","time":"2020-09-12T14:00:39+09:00","message":"ERROR"}
```

#### ログレベルの設定

`SetGlobalLevel`でログレベルをWARNにするとINFOログは出力されなくなります。

```go
package main

import (
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	zerolog.SetGlobalLevel(zerolog.WarnLevel)

	log.Info().Msg("INFO")
	log.Error().Str("Reason", "unknown").Msg("ERROR")
}
```

`出力結果`
```
{"level":"error","Reason":"unknown","time":"2020-09-12T14:03:21+09:00","message":"ERROR"}
```

#### 人間に見やすい出力結果にする

`ConsoleWrite`を使うとCLIアプリケーションに優しい出力になります。

```go
package main

import (
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"os"
)

func main() {
	// TimeFormatを指定しないと `5:09AM` のようになり日時と秒が表示されない
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stderr,
		TimeFormat: "2006/1/2 15:04:05",
	})

	log.Info().Msg("INFO")
	log.Error().Str("Reason", "unknown").Msg("ERROR")
}
```

{{<himg "resources/b21f196d.png">}}



### 【Golang】Slackに通知する

Incoming Webhook URLを使ってSlackに通知する方法です。  

#### Slackのアプリケーション作成

`Create New App`でアプリケーションを作る必要があります。

{{<summary "https://api.slack.com/apps">}}

FeatureとしてIncoming Webhooksの設定をします。  
そこで取得できるIncoming Webhook URLをあとで使います。

#### Slackで通知内容を作る

UIはBlock Kit Builderを使ってラクラク編集できます。

{{<summary "https://app.slack.com/block-kit-builder">}}

サイドバーから雛形を挿入し、JSONをいじってカスタマイズします。  
今回はこんな感じ。

{{<himg "resources/487f07ad.jpeg">}}

JSONは以下。

```json
{
	"blocks": [
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "てすとです"
			},
			"accessory": {
				"type": "image",
				"image_url": "https://avatars1.githubusercontent.com/u/9500018",
				"alt_text": "みみぞう"
			}
		}
	]
}
```

#### Goの実装

`slack-go/slack`を使います。

{{<summary "https://github.com/slack-go/slack">}}

Slackの仕様を知っているならソースコードを見れば分かると思います。

{{<github "https://github.com/slack-go/slack/blob/master/webhooks.go">}}

先ほど作成した通知内容をコードにしてみました。

```go
package main

import "github.com/slack-go/slack"

func main() {
	const URL = "TODO: Incoming Webhook URLを指定してください"
	const IMAGE_URL = "https://avatars1.githubusercontent.com/u/9500018"

	slack.PostWebhook(URL, &slack.WebhookMessage{
		Blocks: &slack.Blocks{
			BlockSet: []slack.Block{
				slack.NewSectionBlock(
					slack.NewTextBlockObject("mrkdwn", "てすとです", false, false),
					nil,
					slack.NewAccessory(slack.NewImageBlockElement(IMAGE_URL, "みみぞう")),
				),
			},
		},
	})
}
```

通知するだけならこんな感じです。  
Factoryを使うところと使わないところがあり、階層も深いので初めは戸惑うかもしれません。

実行するとSlackに通知されるはずです。

{{<himg "resources/6dd87485.png">}}

ウホ! 🦍

### 【Angular】Angular8から9へのバージョンアップ

Angular8.2から9.1にバージョンアップしました。  
アップデートガイドを使います。  

{{<summary "https://update.angular.io/">}}

{{<file "バージョン">}}
```
$ ng version
Angular CLI: 8.3.29
Node: 12.18.3
OS: win32 x64
Angular: 8.2.14
... animations, common, compiler, compiler-cli, core, forms
... language-service, platform-browser, platform-browser-dynamic
... router

Package                           Version
-----------------------------------------------------------
@angular-devkit/architect         0.803.29
@angular-devkit/build-angular     0.803.29
@angular-devkit/build-optimizer   0.803.29
@angular-devkit/build-webpack     0.803.29
@angular-devkit/core              8.3.29
@angular-devkit/schematics        8.3.29
@angular/cdk                      8.2.3
@angular/cli                      8.3.29
@angular/http                     7.2.16
@angular/material                 8.2.3
@angular/platform-server          2.0.0-rc.6
@ngtools/webpack                  8.3.29
@schematics/angular               8.3.29
@schematics/update                0.803.29
rxjs                              6.6.3
typescript                        3.5.3
webpack                           4.39.2
```
{{</file>}}

#### Before Updating

実施されることの説明です。事前作業は必要ありません。

> Instead of importing from @angular/material, you should import deeply from the specific component. E.g. @angular/material/button. ng update will do this automatically for you.

コンポーネントを個別importするようになるそうです。  
たとえば以下のような風に。

```diff
- import { MatDialogRef, MatSnackBar } from '@angular/material';
+ import { MatDialogRef } from '@angular/material/dialog';
+ import { MatSnackBar } from '@angular/material/snack-bar';
```

> For lazy loaded modules via the router, make sure you are using dynamic imports. Importing via string is removed in v9. ng update should take care of this automatically. Learn more on angular.io.

ルーター経由の遅延読込とdynamic import周りで影響ありそうですが、使っていないと思うので分からず..。

#### During the Update

> Make sure you are using Node 10.13 or later.

12.18.3なので問題なし。

> Run `ng update @angular/core@8 @angular/cli@8` in your workspace directory to update to the latest 8.x version of @angular/core and @angular/cli and commit these changes.

coreとCLIを最新にアップデートしてコミットします。

```
ng update @angular/core@8 @angular/cli@8
git commit -m "Update angular@8"
```

> Run `ng update @angular/core@9 @angular/cli@9` which should bring you to version 9 of Angular.

v9にバージョンアップします。

{{<file "ng update @angular/core@9 @angular/cli@9">}}
```
$ ng update @angular/core@9 @angular/cli@9
Fetching dependency metadata from registry...
                  Package "@angular/compiler-cli" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "@angular/animations" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "@angular/common" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "@ng-select/ng-select" has an incompatible peer dependency to "@angular/common" (requires ">=6.0.0 <8.0.0" (extended), would install "9.1.12").
                  Package "@angular/compiler" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "angular2-toaster" has an incompatible peer dependency to "@angular/compiler" (requires "^7.0.0" (extended), would install "9.1.12").
                  Package "@angular/core" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "@angular/http" has an incompatible peer dependency to "@angular/core" (requires "7.2.16" (extended), would install "9.1.12").
                  Package "@angular/forms" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "@ng-select/ng-select" has an incompatible peer dependency to "@angular/forms" (requires ">=6.0.0 <8.0.0" (extended), would install "9.1.12").
                  Package "@angular/platform-browser" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "@angular/http" has an incompatible peer dependency to "@angular/platform-browser" (requires "7.2.16" (extended), would install "9.1.12").
                  Package "@angular/platform-browser-dynamic" has a missing peer dependency of "tslib" @ "^1.10.0".
                  Package "@angular/router" has a missing peer dependency of "tslib" @ "^1.10.0".
× Migration failed: Incompatible peer dependencies found.
Peer dependency warnings when installing dependencies means that those dependencies might not work correctly together.
You can use the '--force' option to ignore incompatible peer dependencies and instead address these warnings later.
  See "C:\Users\syoum\AppData\Local\Temp\ng-hyJ5Ia\angular-errors.log" for further details.
```
{{</file>}}

peer dependenciesがインストールされていないためインストールします。  
バージョン指定しないと2系が入って依存関係を満たさないので注意。

```
npm i tslib@1
npm i @ng-select/ng-select@4
npm i angular2-toaster@8
```

`@angular/http`は非推奨になったようです。

{{<refer "https://www.npmjs.com/package/@angular/http">}}

```
npm uninstall @angular/http
```

`angular2-markdown`は更新が止まっていますね..これは無視してもいいかな..。

{{<summary "https://www.npmjs.com/package/angular2-markdown">}}

`ng update --force`を使って強行突破します。

{{<file "ng update @angular/core@9 @angular/cli@9 --force">}}
```
$ ng update @angular/core@9 @angular/cli@9 --force
Your global Angular CLI version (10.1.0) is greater than your local
version (8.3.29). The local Angular CLI version is used.

To disable this warning use "ng config -g cli.warnings.versionMismatch false".
The installed Angular CLI version is older than the latest stable version.
Installing a temporary version to perform the update.
Installing packages for tooling via npm.
Installed packages for tooling via npm.
Using package manager: 'npm'
Collecting installed dependencies...
Found 68 dependencies.
Fetching dependency metadata from registry...
                  Package "angular2-markdown" has an incompatible peer dependency to "@angular/core" (requires "^2.4.0 || ^4.0.3 || ^5.0.0" (extended), would install "9.1.12").
    Updating package.json with dependency @angular-devkit/build-angular @ "0.901.12" (was "0.803.29")...
    Updating package.json with dependency @angular/cli @ "9.1.12" (was "8.3.29")...
    Updating package.json with dependency @angular/compiler-cli @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/language-service @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency typescript @ "3.8.3" (was "3.5.3")...
    Updating package.json with dependency @angular/animations @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/common @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/compiler @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/core @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/forms @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/platform-browser @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/platform-browser-dynamic @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency @angular/router @ "9.1.12" (was "8.2.14")...
    Updating package.json with dependency zone.js @ "0.10.3" (was "0.9.1")...
UPDATE package.json (2667 bytes)
√ Packages installed successfully.
** Executing migrations of package '@angular/cli' **

> Angular Workspace migration.
  Update an Angular CLI workspace to version 9.
UPDATE package.json (2669 bytes)
√ Packages installed successfully.
  Migration completed.

> Lazy loading syntax migration.
  Update lazy loading syntax to use dynamic imports.
  Migration completed.

> Replace deprecated 'styleext' and 'spec' Angular schematic options.
UPDATE angular.json (3540 bytes)
  Migration completed.

** Executing migrations of package '@angular/core' **

> Static flag migration.
  Removes the `static` flag from dynamic queries.
  As of Angular 9, the "static" flag defaults to false and is no longer required for your view and content queries.
  Read more about this here: https://v9.angular.io/guide/migration-dynamic-flag
UPDATE src/app/components/detail-dialog/detail-dialog.component.ts (21092 bytes)
UPDATE src/app/components/summary/summary.component.ts (26444 bytes)
UPDATE src/app/components/markdown-inline-editor/markdown-inline-editor.component.ts (4034 bytes)
  Migration completed.

> Missing @Injectable and incomplete provider definition migration.
  In Angular 9, enforcement of @Injectable decorators for DI is a bit stricter and incomplete provider definitions behave differently.
  Read more about this here: https://v9.angular.io/guide/migration-injectable
UPDATE src/app/services/monaco-editor-loader.ts (1487 bytes)
  Migration completed.

> ModuleWithProviders migration.
  In Angular 9, the ModuleWithProviders type without a generic has been deprecated.
  This migration adds the generic where it is missing.
  Read more about this here: https://v9.angular.io/guide/migration-module-with-providers
  Migration completed.

> Renderer to Renderer2 migration.
  As of Angular 9, the Renderer class is no longer available.
  Renderer2 should be used instead.
  Read more about this here: https://v9.angular.io/guide/migration-renderer
  Migration completed.

> Undecorated classes with decorated fields migration.
  As of Angular 9, it is no longer supported to have Angular field decorators on a class that does not have an Angular decorator.
  Read more about this here: https://v9.angular.io/guide/migration-undecorated-classes
  Migration completed.

> Undecorated classes with DI migration.
  As of Angular 9, it is no longer supported to use Angular DI on a class that does not have an Angular decorator.
  Read more about this here: https://v9.angular.io/guide/migration-undecorated-classes

    This migration uses the Angular compiler internally and therefore projects that no longer build successfully after the update cannot run the migration. Please ensure there are no AOT compilation errors and rerun the migration. The following project failed: src/tsconfig.json

    Error: The Angular Compiler requires TypeScript >=3.6.4 and <3.9.0 but 3.9.7 was found instead.

    Could not migrate all undecorated classes that use dependency
    injection. Some project targets could not be analyzed due to
    TypeScript program failures.

    Migration can be rerun with: "ng update @angular/core --migrate-only migration-v9-undecorated-classes-with-di"

  Migration completed.


Your project has been updated to Angular version 9!
For more info, please see: https://v9.angular.io/guide/updating-to-version-9
```
{{</file>}}

TypeScriptを3.8にして、失敗の続きからmigrationを再開します。

```
npm uninstall typescript
npm i typescript@3.8
ng update @angular/core --migrate-only migration-v9-undecorated-classes-with-di
```

今度は`@angular/http`を消したツケが..

```
    Error: error TS100: src\app\app.module.ts(115,9): Error during template compile of 'AppModule'
      Could not resolve @angular/http relative to [object Object]..
```

インポート元とインポートするModuleが変わります。

```diff
- import { HttpModule } from '@angular/http';
+ import { HttpClientModule } from '@angular/common/http';
```

これでようやくOK！

> Your project has now been updated to TypeScript 3.8, read more about new compiler checks and errors that might require you to fix issues in your code in the TypeScript 3.7 or TypeScript 3.8 announcements.

TypeScript3.8になったことで発生するかもしれないエラーを直します。  
今回は問題ありませんでした。

> Run ng update @angular/material@9.

`angular/material`をv9にバージョンアップします。

{{<file "ng update @angular/material@9">}}
```
$ ng update @angular/material@9
Your global Angular CLI version (10.1.0) is greater than your local
version (9.1.12). The local Angular CLI version is used.

To disable this warning use "ng config -g cli.warnings.versionMismatch false".
The installed local Angular CLI version is older than the latest stable version.
Installing a temporary version to perform the update.
Installing packages for tooling via npm.
Installed packages for tooling via npm.
Using package manager: 'npm'
Collecting installed dependencies...
Found 68 dependencies.
Fetching dependency metadata from registry...
    Updating package.json with dependency @angular/cdk @ "9.2.4" (was "8.2.3")...
    Updating package.json with dependency @angular/material @ "9.2.4" (was "8.2.3")...
UPDATE package.json (2668 bytes)
√ Packages installed successfully.
** Executing migrations of package '@angular/cdk' **

> Updates the Angular CDK to v9
    Could not find TypeScript project for project: hoge-e2e

      ✓  Updated Angular CDK to version 9

  Migration completed.

** Executing migrations of package '@angular/material' **

> Updates Angular Material to v9
    Could not find TypeScript project for project: hoge-e2e

    ⚠  General notice: The HammerJS v9 migration for Angular Components is not able to migrate tests. Please manually clean up tests in your project if they rely on HammerJS.
    Read more about migrating tests: https://git.io/ng-material-v9-hammer-migrate-tests

      ✓  Updated Angular Material to version 9

UPDATE src/app/components/detail-dialog/detail-dialog.component.ts (21145 bytes)
UPDATE src/app/components/summary/summary.component.ts (26541 bytes)
UPDATE src/app/components/dialogs/confirm-dialog/confirm-dialog.component.ts (800 bytes)
UPDATE src/app/components/markdown-inline-editor/markdown-inline-editor.component.ts (4043 bytes)
UPDATE src/app/app.module.ts (7400 bytes)
UPDATE package.json (2642 bytes)
√ Packages installed successfully.
  Migration completed.
```
{{</file>}}

その他、依存ライブラリの細かいIF変更などに対応してビルドが通りました。


調べたこと
----------

### 【Golang】go getでバージョン指定できない

以下のようなエラーが表示されます。

```
~\work\sandbox\golang ❯ go get -u github.com/spf13/cobra/cobra@v1.0.0                                                                                                              13:18:11
go: cannot use path@version syntax in GOPATH mode
```

GOPATHモードでは`path@version`のシンタックスは利用できません。  
MODULEモードに移行する必要があるため、環境変数`GO111Module`に`on`を設定します。

PowerShellの場合は以下の設定が必要です。

```
$env:GO111MODULE = "on"
```

### 【Golang】viperで環境変数が適応されない

`viper.AutomaticEnv()`と`viper.Unmarshal(...)`を使う場合の制約でした。  
configファイルで指定された項目以外の環境変数は無視されます。

たとえば以下のコードを考えます。

```golang
type Params struct {
	User string
	Password string
}

var params Params

// ...
// 中略
// ...

func initConfig() {
	viper.AddConfigPath(".")
	viper.SetConfigName(".cobra-use")

	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}

	if err := viper.Unmarshal(&params); err != nil {
		log.Fatal(err)
	}
}
```

そして`.cobra-use.yaml`は`user`だけが指定されているとします。

```yaml
user: hoge
```

このとき環境変数`PASSWORD`に値を指定した状態で実行しても、`params.Password`は設定されません。

{{<summary "https://github.com/spf13/viper/issues/584">}}

色々ハマリポイントが多かったので、手動で`viper.BindEnv`するようにしました。  
環境変数で指定したくない設定があるかもしれませんし。


整備したこと
------------

### 【IDEA】Go言語の開発環境

IntelliJ IDEAでGo言語を開発する環境を整えました。  
以前はVS Codeを使っていましたが、最近はIDEAを愛用しているため統一しようと思ったからです。

#### プラグインインストール

Goプラグインをインストールします。

{{<summary "https://plugins.jetbrains.com/plugin/9568-go/">}}

#### 動作確認

ターミナルからGoのプロジェクトを作ります。

```
$ cd ~\tmp\gotest
$ go mod init tmp/tadashi-aikawa/gotest
go: creating new go.mod: module tmp/tadashi-aikawa/gotest
```

IntelliJ IDEAで開いて`main.go`を作成します。

{{<himg "resources/cb05c683.png">}}

main関数の横にある実行ボタンから実行します。

{{<himg "resources/804091c7.png">}}

結果が表示されればOK👍

#### ファイル保存時に自動フォーマット

File Watchersプラグインを使って、gofmtを自動実行します。

{{<summary "https://plugins.jetbrains.com/plugin/7177-file-watchers/">}}

以前はGoのプラグインに`On Save`という設定があり、そこで実現できたようです。  
あるバージョンで削除され、以降はFile Watchersプラグインを使う流れのようです。

File Watchersプラグインにはgofmtのテンプレがあります。素晴らしい！

{{<himg "resources/0336cda9.png">}}

テンプレ通りに設定を作成すればOK。


今週のリリース
--------------

今週はありません。

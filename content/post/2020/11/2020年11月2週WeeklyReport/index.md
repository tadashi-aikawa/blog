---
title: 2020年11月2週 Weekly Report
slug: 2020-11-2w-weekly-report
date: 2020-11-16T22:42:47+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
---

📰 **Topics**

先週までとうってかわり、ネタが少なめの一週間です。  
仕事でAtlassian製品やAPIの仕様に詳しくはなりましたが、業務なのでレポートの対象外です。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【TypeScript】リリースノート v3.4

TypeScript v3.4のリリースノートをまとめ終わりました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/releases/3.4/">}}

`--incremental`フラグによるビルド時間の短縮は重要ですね。


### 【Docker】Ubuntu on WSL2にDockerをインストールする方法

以前のWeekly Reportに書いた内容を少しだけ修正してMimizou Roomに載せました。

{{<summary "https://mimizou.mamansoft.net/it-note/tools/docker/#ubuntu-on-wsl2">}}


学んだこと
----------

なし。


読んだこと/聴いたこと
---------------------

### 「フロントエンド領域」を再定義する

最近10年間のトレンドをふりかえり、未来を見据える発表スライドです。

{{<summary "https://speakerdeck.com/mizchi/hurontoendoling-yu-wozai-ding-yi-suru">}}

#### これまでについて

私は2015年にフロントエンドを真面目にやり始めましたが、当時はまさに戦国時代でした。

* Reactが登場するも表記がキモいと受け入れられない風習
* Browserifyが流行っていたもののWebpackが登場したところ
* TypeScriptはv1系で型定義の管理方法も分散されて地獄絵図

そのときに色々試した結果、2016年はじめの時点で以下のスタックを選択しました。

* TypeScript
* React with Redux
* Webpack

日本語の情報が当時は少なく、学習コストは高めでしたが将来性を感じたためです。  
その後、VueやNuxt/Nextのようなフレームワークが登場し2019年で以下に落ち着きました。

* TypeScript
* Vue with Nuxt
* SPA / SSG (not SSR)

スライドの内容と上記に大きなズレはなさそうでしたので少し安心しています。

#### これからについて

2～3年で新たなパラダイムシフトが発生し、以下になるのではと予想しています。

* TypeScript
* Svelte Kit (on serverless)
* エッジケースでWASM (Rust)

Svelte Kitを推す根拠は下記のレポートにて簡潔に書きました。

{{<summary "https://blog.mamansoft.net/2020/11/09/2020-11-1w-weekly-report/#whats-the-deal-with-sveltekit">}}

もしかするとVueやReactが発展してその役割を担うかもしれません。  
いずれにしても、Bundlerからの脱却+Serverlessベースの波がくるのかなと。  
根拠はありません。日々個人プロダクトを開発してる身の勘です..。

やはりnpmエコシステムは強いため、RustがJavaScriptに取って代わることはないと思います。  
ただ、本当にパフォーマンスが求められるエッジケースで可能性はあるかなと。  
v8が十分速いので使う機会は滅多にないと思いますが、引き続きRustの勉強はするつもりです。

スライドではTypeScript + 一部Rustは一緒なもののNext(Nuxt)になってますね。  
Svelteはまだ不確定要素も強いので、現時点では公に推すのは難しいと思ってます。  
※ Bundler脱却できればなんでもOK


試したこと
----------

### 【Golang】envconfig

サポートする環境変数をstructで定義するとパースできるライブラリです。  

{{<summary "https://github.com/kelseyhightower/envconfig">}}

prefixやCamelCaseとの変換、必須/任意の設定ができて便利です。

こんなコードを書いて実行すると..

```go
package main

import (
	"fmt"
	"github.com/kelseyhightower/envconfig"
	"log"
)

type Env struct {
	UserName string `split_words:"true" required:"true"`
	Group string `default:"anonymous"`
	Age int
}

func getEnv() (Env, error) {
	var goenv Env
	err := envconfig.Process("MAMAN", &goenv)
	if err != nil {
		return Env{}, err
	}
	return goenv, nil
}

func main() {
	env, err := getEnv()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("UserName: %s\n", env.UserName)
	fmt.Printf("Group: %s\n", env.Group)
	fmt.Printf("Age: %d\n", env.Age)
}
```

環境変数の設定状態に応じて、以下の様にパースされます。

```bash
# 設定なし
$ go run main.go
2020/11/11 13:17:11 required key MAMAN_USER_NAME missing value
exit status 1

# MAMAN_USER_NAME="maman" MAMAN_GROUP="admin"
$ go run main.go
UserName: maman
Group: admin
Age: 0

# MAMAN_USER_NAME="maman" MAMAN_GROUP="admin" MAMAN_AGE=13
$ go run main.go
UserName: maman
Group: admin
Age: 13
```

### 【VSCode】Jira and Bitbucket (Official)

VSCode上でJira Cloud/Bitbucket Cloudが操作できる拡張です。

{{<summary "https://marketplace.visualstudio.com/items?itemName=Atlassian.atlascode">}}

こういうのは基本的に公式を使うポリシーなので、当初使う気はありませんでした。  
しかし、ツール間の切り替えやBitbucket Cloudの新UIがあまりに使いにくかったので試してみました。

使ってみると思ったより高機能でビックリしました。  
ソースコードを見ながらプルリクエストを確認できることは期待通りでしたが、それ以上にJiraの操作が凄い😆

UIや操作方法に拘りがないのであれば、VSCodeを使った方が速いと思えるレベルです。  
プライベートはGitHubなので不要ですが、仕事ではしばらく使ってみます。


調べたこと
----------

### 【HTTP】Illegal or missing hexadecimal sequence in chunked-encoding

ブラウザから直接CORS未対応APIにアクセスするとデータを取得できないため、間にAWS SAMを使ってProxy APIを入れたときに発生したエラーです。

これだけでは全然分からなかったのですが、Postmanでアクセスしたとき以下のエラーが表示されました。

```
Parse Error: The response headers can't include "Content-Length" with chunked encoding
```

chunked encodingで`Content-Length`を含むことはできない..というヒントです。  
調べてみたら仕様を見つけました。

{{<summary "https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Transfer-Encoding">}}

今回の通信で付与されたレスポンスヘッダは以下。

```
[CORS未対応API]
  ↓
  ↓ <- Content-Lengthなし、Transfer-Encoding: chunked
  ↓
[Proxy] <- レスポンスヘッダはそっくりそのまま渡す
  ↓
  ↓ <- Content-Lengthあり、Transfer-Encoding: chunked
  ↓
[ブラウザ]
```

CORS未対応APIから受け取った`Transfer-Encoding`をそのまま流していたのが原因でした。  
AWS SAMは`Content-Length`を自動で付与するため、両方ついてしまっていたのですね。

Proxyからレスポンスを返却するとき`Transfer-Encoding`を除去したら動きました。


整備したこと
------------

### Mimizou Roomのビルドスピードアップ

Mimizou Roomのビルドスピードを短縮しました。

{{<summary "https://mimizou.mamansoft.net/">}}

今までキャッシュの効いた状態で30秒かかっていたのが10秒になりました。  
やったことはURLに対するmacroの解析/パース処理に対するキャッシュ戦略です。

| 概要                  | Before         | After                |
| --------------------- | -------------- | -------------------- |
| URLに対するキャッシュ | レスポンスHTML | 本文に置換する文字列 |
| キャッシュストレージ  | sqlite         | json                 |
| キャッシュの有効期間  | 4週間          | 無制限               |
| キャッシュの管理      | ストレージ     | Git                  |

地味にHTMLの解析で時間がかかっていたのかなと思います。


今週のリリース
--------------

なし


その他
------

### Quizletの単語数

本日時点での単語数は93(+10)です。

---
title: 2020年11月3週 Weekly Report
slug: 2020-11-3w-weekly-report
date: 2020-11-23T15:47:55+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
---

📰 **Topics**

TypeScriptやGoの学びを深め、アウトプットもできた一週間でした。  
一方で情報整理についてはまだ迷いがあるため、日々改善していきたいと思っています。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【Vim】Vimの起動が遅い理由を調べたい

`vim --startuptime`を使って起動速度を調べる方法をメモしておきました。

{{<summary "https://mimizou.mamansoft.net/it-note/tools/vim/faq/#vim_1">}}

### 【CSS】backdrop-filter

背景の輝度などを変更する方法として`backdrop-filter`をはじめて知りました。  
ホバーしたときにカードをうっすらグレーアウトしたかったので。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/css/faq/#_9">}}

### 【Vue】ERR_ACTION_ACCESS_UNDEFINED

以下のようなエラーになるものの、Actionの中で直接値変更などはしていない場合について書きました。

```
index.js:363 Uncaught (in promise) Error: ERR_ACTION_ACCESS_UNDEFINED: Are you trying to access this.someMutation() or this.someGetter inside an @Action? 
That works only in dynamic modules. 
If not dynamic use this.context.commit("mutationName", payload) and this.context.getters["getterName"]
Error: Could not perform action updateSlackConfig
```

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/vue/vuex-module-decorators/faq/#err_action_access_undefined">}}



学んだこと
----------

### 【TypeScript】デコレータの書き方

はじめてTypeScriptでデコレータを書きました。  
当たり前ですが思想はPythonやScalaと一緒ですね。

{{<summary "https://www.typescriptlang.org/docs/handbook/decorators.html">}}


#### 作ったデコレータ

```typescript
function IgnoreIfDisabled(
  _target: any,
  _propertyKey: string,
  descriptor: PropertyDescriptor
) {
  const originMethod = descriptor.value;

  descriptor.value = function (this: SlackModule) {
    if (this.slackConfig?.disabled) {
      return;
    }
    return Reflect.apply(originMethod, this, arguments);
  };
}
```

`@IgnoreIfDisabled`をつけたメソッドは`this.slackConfig.disabled = true`の場合に処理を行わず終了します。

* `descriptor.value`はメソッド
    * `descriptor.value`を上書きすることによりメソッドの挙動を変える
    * 変更後のメソッドで元のメソッドを呼び出すため、あらかじめ`originMethod`に代入している
* `IgnoreIfDisabled`は`SlackModule`クラスのメソッドに付けられることを想定しているため、変更後のメソッドにおける`this`の型を`SlackModule`としている

#### デコレータを使う

実際に利用しているコードは以下です。

```typescript
@Module({ name: "Slack", namespaced: true, stateFactory: true })
class SlackModule extends VuexModule {
  _slack: FirestoreSlack | null = null;
  get slackConfig(): SlackConfig | null {
    return this._slack ? toSlackConfig(this._slack) : null;
  }

  // 中略

  @Action({ rawError: true })
  @IgnoreIfDisabled
  async notifyStartEvent(entry: Entry): Promise<TogowlError | undefined> {
    const err = await service!.start(entry);
    if (err) {
      console.error(err.messageForLog);
      return err;
    }
  }
}
```

詳細はGitHubをご覧ください。

{{<summary "https://github.com/tadashi-aikawa/togowl/blob/b4dea889c6fa63a9a880d0468e76e8abedace1d7/store/Slack.ts#L21">}}


### 【Golang】goroutineで並行処理

今まで後回しにしていたgoroutineの基本を学びました。  
目的は**HTTPリクエストを含む処理の並行化**です。

`A Tour of Go`の1～4を学びました。  
5以降は現時点で必要ないと判断しました。

{{<summary "https://go-tour-jp.appspot.com/concurrency/1">}}

#### 書いたコード

goroutineを使って通常の関数をラップしたコードを想定しました。

```go
package main

import (
	"errors"
	"fmt"
	"math/rand"
	"time"
)

type Response struct {
	Title string
	Body  string
}

type concurrentResponse struct {
	response Response
	error    error
}

// この関数は直列/並行に関わらず同じ実装にしたい
func dummyFetch(url string) (Response, error) {
	// 実装はダミーなので引数/戻り値はなんでもよい. ただしgoroutineを意識するインタフェースは避ける
	rnd := rand.Intn(5000)
	time.Sleep(time.Duration(rnd) * time.Millisecond)
	if rnd > 2500 {
		return Response{}, errors.New(url)
	} else {
		return Response{
			Title: "hoge",
			Body:  url,
		}, nil
	}
}

// 並行処理のためにdummyFetchをwrapした関数
func asyncDummyFetch(url string, reqCh chan bool, resCh chan concurrentResponse) {
	// 非同期処理前にreqChチャンネルへ値を送信することで並行数を制御(reqChのbuffer数)
	reqCh <- true
	res, err := dummyFetch(url)
	<-reqCh

	// channelに (res, err)タプルを送信できないためconcurrentResponse型を返す
	resCh <- concurrentResponse{
		response: res,
		error:    err,
	}
}

func dummyFetchAll(urls []string, concurrentNum int) (responses []Response, errors []error) {
	reqCh := make(chan bool, concurrentNum)
	resCh := make(chan concurrentResponse, len(urls))

	for _, url := range urls {
		go asyncDummyFetch(url, reqCh, resCh)
	}

	for i := 0; i < len(urls); i++ {
		res := <-resCh
		if res.error != nil {
			errors = append(errors, res.error)
		} else {
			responses = append(responses, res.response)
		}
	}

	return
}

func main() {
	rand.Seed(time.Now().UnixNano())

	responses, errors := dummyFetchAll(
		[]string{"1つ目のURL", "2つ目のURL", "3つ目のURL", "4つ目のURL"},
		4,
	)

	fmt.Println("[successes]")
	for _, r := range responses {
		fmt.Printf("%+v\n", r)
	}
	fmt.Println("[errors]")
	for _, err := range errors {
		fmt.Printf("%+v\n", err)
	}
}
```

名前は結構適当ですが、各関数の役割は以下です。

* `dummyFetch`は並行処理したい関数
* `asyncDummyFetch`は`dummyFetch`を並行処理するためwrapした関数
* `dummyFetchAll`は`asyncDummyFetch`を使って並行処理する関数

`dummyFetch`のインタフェースと実装はどうでもいいです。  
それをwrapした`asyncXXX`を作り、`xxxAll`でそれを使うのがポイントですね。

#### ハマったところ

はじめ、channelの理解が不十分で以下のエラーにハマりました。

```
fatal error: all goroutines are asleep - deadlock!
```

閉じられることのないchannelをrangeで回し続けていたが原因です。  
先ほどのコードに当てはめると、`dummyFetchAll`を以下のように実装した場合ですね。

```go
func dummyFetchAll(urls []string, concurrentNum int) (responses []Response, errors []error) {
	reqCh := make(chan bool, concurrentNum)
	resCh := make(chan concurrentResponse, len(urls))

	for _, url := range urls {
		go asyncDummyFetch(url, reqCh, resCh)
	}

	// rangeでchannelの結果を受け取る
	// ... がresChがcloseされることはないのでdeadlockになる
	for res := range resCh {
		if res.error != nil {
			errors = append(errors, res.error)
		} else {
			responses = append(responses, res.response)
		}
	}

	return
}
```

なぜか`resCh`のbufferが満タンになったタイミングでchannelが閉じられると勘違いしていました。  
実際はbufferが満タンになっても送信待機になるだけです。  
Closeは送り手が知らせなければいけません。

ところが今回の実装では、channelを閉じるタイミングが難しいと感じました。  
実装の仕方が洗練されていないからかもしれません..😓  
それでも、rangeを使わずにforループを回せばやりたいことができるため、今回はこれ以上踏み込まないことにしました。

#### 気になるところ

はじめに実行処理数だけgoroutineが生成されてしまうことが気になりました。  
先のコードで言うと`urls`の要素数です。

`urls`をchunkに分割し、chunkごとに並行実行すればgoroutineの生成数は抑えられます。  
一方、各chunkの最も遅い処理を待つ必要があるため完了までの時間は長引きそうです。

私が並行処理を学ぶ動機は冒頭に述べました。

> 目的は**HTTPリクエストを含む処理の並行化**です。

具体的には以下のようなケースです。

* 都度実行するCLIツール (APIなど常駐しないもの)
* 最大の並行処理数は数万程度

goroutineのポテンシャルを調べていたら以下の記事を見つけました。

{{<summary "https://mahata.gitlab.io/post/2018-10-15-goroutines-vs-java-threads/">}}

この記事によると、goroutineのコストは以下のように説明されています。

* goroutineのスタックサイズは4KB程度[^1]
* 百万オーダーでの利用にも耐えられるよう設計されている

[^1]: Go1.4からは2KBスタートであり、別途必要なメモリは確保するため4KBと言っているのかもしれない

仮に並行処理数が10000だとすれば、メモリ使用量は40MBです。  
実際に10000でのメモリサイズを確かめてみました。

```diff
  	responses, errors := dummyFetchAll(
- 		[]string{"1つ目のURL", "2つ目のURL", "3つ目のURL", "4つ目のURL"},
+ 		make([]string, 10000, 10000),
  		4,
  	)
```

`string`がどれだけメモリを使用するか分かっていませんが、結果は100MB弱です。  
想定の2倍以上でした。

{{<himg "resources/ea610b5a.jpeg">}}

数百MBで収まるのなら一旦この実装で試してみようと思います。  
とはいえ、数十万オーダーになったらchunkで分けた方が良さそうですね。


読んだこと/聴いたこと
---------------------

### 【Golang】Goを学ぶときにつまずきやすいポイントFAQ

凄いボリュームとクオリティの記事。チョイスがいい。

{{<summary "https://future-architect.github.io/articles/20190713/">}}

もうちょっとGoに詳しくなったら見直したいと思います。

### 【SlimBladeレビュー】トラックボールがPC作業を快適にしてくれる

私が7年近く愛用しているトラックボールのレビューです。

{{<summary "https://bamka.info/slimblade-review">}}

トラックボールのレビューに留まらず、効率化の大事なエッセンスも紹介されています。  
特に私が共感したのが以下の部分。

> SlimBlade は、使い慣れるまでにすこし時間が掛かります。これは事実。慣れない道具ですので、これは仕方がありません。  
> 使い始めて1週間ぐらいは、おそらく「これ、マウスで良いんじゃないか……」と思うでしょう。「カッコつけてないで、大人しくマウス使お…」と、諦めるかもしれません。  
> しかしそれを抜けた先に、快適なパソコン環境が待っています。マウスでは得られない快感があります。  
> こればかりは時間をかけて使ってみないとわからない。だから信じてもらうしかありません。

新しいものを取り入れるのに、多くの方は試行時間が短すぎると思っています。  
たった数時間/数日程度で、今まで数千/数万時間使ってきたものの価値を上回るわけがありません。

私の場合、トラックボールに慣れるまで1ヶ月かかりました。  
それでもマウスの方が効率良いと感じ続け、それが逆転したのは1年後です。  

似た話だと、テキストエディタとしてVim(のキーバインド)を取り入れたときも同じです。  
Vimも数日..しかも無理のない範囲で試して諦める人が多く勿体ないなと思っています。

年齢を重ねるにつれ時間はなくなります。  
そのため、本当に価値があるか分からないものに時間を費やすリスクも大きくなっていきます。

しかし、そのチャレンジ精神こそが内なる若さをキープする秘訣だと思っています。  
新しいものを受け入れられなくなってしまわぬよう、精進していきたいですね。

### 【TypeScript】Prettier と ESLint の組み合わせの公式推奨が変わり plugin が不要になった

PrettierとESLintの共存は、常につきまとう難しい問題です。  
今まで使われてきた`eslint-plugin-prettier`が公式推奨ではなくなったようです。

{{<summary "https://blog.ojisan.io/prettier-eslint-cli">}}

以前の記事で個人的に`eslint-plugin-prettier`は使うべきでないと主張してきました。


{{<summary "https://blog.mamansoft.net/2020/03/29/use-typescript-and-eslint-with-intellij-idea/#prettier%E3%81%A8%E8%A8%AD%E5%AE%9A%E3%81%8C%E7%AB%B6%E5%90%88%E3%81%99%E3%82%8B">}}

公式もその方針になったようで嬉しい限りです☺️

一方、Prettierを使わない人、フォーマット忘れなどには対応できません。  
非推奨というわけではないので、必要に応じてpluginを使うのもアリかと。


試したこと
----------

### 【Google Chrome】Session Buddy

セッションごとに保存したり履歴管理できるChrome拡張です。  
UIが好みだったのと、履歴/タブ管理をスマートにやりたかったので試してみました。

{{<summary "https://chrome.google.com/webstore/detail/session-buddy/edacconmaakjimmfgnblocblbcdcpbko?hl=ja&a8=.VwlTVDbAumvIOs1PSjaJOq.hJ5TI4mQf1-a41-bY_sjiaw3iusQFuFQqPYamIw.YVLOAywUlyXZxs00000003166005">}}

1日使った感じだと、Chromeデフォルトの履歴を使いこなした方が良さそうです。  
ChromeアプリやPWAを閉じなければセッションが終了しない(記録されない)のが難点。

思考の速度で開きたいページを開く技術の習得にはまだまだ時間がかかりそうです。


調べたこと
----------

Togowlのv2.17.0で依存パッケージ最新化を行いました。  
そのときに調べたことです。

### 【TypeScript】swiperのバージョンアップに伴うエラー

[swiper]をv5からv6にバージョンアップしたところエラーになりました。  
今回は[vue-awesome-swiper]を使っています。

[swiper]: https://swiperjs.com/
[vue-awesome-swiper]: https://github.com/surmon-china/vue-awesome-swiper

```
* swiper/css/swiper.css in ./node_modules/babel-loader/lib??ref--12-0!./node_modules/ts-loader??ref--12-1!./node_modules/vue-loader/lib??vue-loader-options!./components/TaskSwiperEntry.vue?vue&type=script&lang=ts&
                                                                                                                                                                  friendly-errors 18:24:11
To install it, you can run: npm install --save swiper/css/swiper.css
```

エラーだけ見ると`swiper/css/swiper.css`をインストールしなければいけないかのように見えますが、v6からimport方式が変わったからです。  
`css/swiper.css`の代わりに`swiper-bundle.css`を指定したら動きました。

```diff
- import 'swiper/css/swiper.css'
+ import 'swiper/swiper-bundle.css'
```

[vue-awesome-swiper]のREADMEにも書いてあります。

```typescript
// import style (>= Swiper 6.x)
import 'swiper/swiper-bundle.css'
// import style (<= Swiper 5.x)
import 'swiper/css/swiper.css'
```

### 【TypeScript】firebaseのバージョンアップに伴うエラー

[firebase]をv7からv8にバージョンアップしたところエラーになりました。  
型が存在しないエラーが大量に出ます。以下は一例です。

[firebase]: https://github.com/firebase/firebase-js-sdk

```
TS2339: Property 'auth' does not exist on type 'typeof import("C:/Users/syoum/git/github.com/tadashi-aikawa/togowl/node_modules/firebase/index")'.
```

[Versin 8.0.0のBreaking change](https://firebase.google.com/support/release-notes/js#version_800_-_october_26_2020)を見ると、インポート方法が変わっていました。

```diff
- import * as firebase from 'firebase/app'
+ import firebase from 'firebase/app'
```

### 【TypeScript】eslint-plugin-nuxtのバージョンアップに伴う警告

[eslint-plugin-nuxt]をv1からv2にバージョンアップしたところ警告になりました。  
2つあるうちの1つは解決しました。

[eslint-plugin-nuxt]: https://github.com/nuxt/eslint-plugin-nuxt

#### vue/v-slot-styleの警告

`v-slot:`ではなく`#`を使おうという警告が出ます。  
その方がシンプルなので修正しました。

```
C:\Users\syoum\git\github.com\tadashi-aikawa\togowl\components\CalendarSelector.vue
  8:15  warning  Expected '#activator' instead of 'v-slot:activator'  vue/v-slot-style
```

#### inline styleの末尾からセミコロンが消える

Vue templateの中でstyleを直接書いたとき、末尾のセミコロンを消すようになりました。

```
  10:39  error  Delete `;`  prettier/prettier
```

### 【TypeScript】sass-loaderのバージョンアップに伴うエラー

[sass-loader]をv8からv10にバージョンアップしたところエラーになりました。

[sass-loader]: https://github.com/webpack-contrib/sass-loader

```
Module build failed (from ./node_modules/sass-loader/dist/cjs.js):                                                                                                friendly-errors 19:09:41
ValidationError: Invalid options object. Sass Loader has been initialized using an options object that does not match the API schema.
 - options has an unknown property 'prependData'. These properties are valid:
   object { implementation?, sassOptions?, additionalData?, sourceMap?, webpackImporter? }
    at validate (C:\Users\syoum\git\github.com\tadashi-aikawa\togowl\node_modules\sass-loader\node_modules\schema-utils\dist\validate.js:104:11)
    at Object.loader (C:\Users\syoum\git\github.com\tadashi-aikawa\togowl\node_modules\sass-loader\dist\index.js:30:29)
```

結論から言うと、v8にバージョンを戻しました。  
プルリクエストで対応されているものの、まだマージされていないからです。

1. [sass-loader]がv9にて`prependData`を`additionalData`に破壊的変更した
2. [vuetify-module]が上記[sass-loader]の変更に対応していない
3. [プルリクエスト](https://github.com/nuxt-community/vuetify-module/pull/393)は作成されているがマージされてない

[vuetify-module]: https://github.com/nuxt-community/vuetify-module


整備したこと
------------

なし



今週のリリース
--------------

### Togowl v2.16.0～v2.17.0

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### Slack通知のON/OFFトグルボタン

ナビゲーションバーにSlackボタンを追加しました。  
クリックすると通知のON/OFFを切り替えられます。

設定はすべての端末で同期します。

##### ON

{{<himg "resources/e5df338e.jpeg">}}

##### OFF

{{<himg "resources/1025d7da.jpeg">}}

#### タスク削除機能

Togowlから直接タスクを削除できるようになりました。  
削除前には確認ダイアログが表示されます。

{{<himg "resources/623d3b05.jpeg">}}


その他
------

### Weekly Reportが与えた影響

なんだかんだ習慣となったWeekly Reportですが、友人もチャレンジし始めてくれた模様。

{{<twitter "1330438686933090306">}}

日々精進しているSuperエンジニアに影響与えられるのは嬉しいことですね😊

### 薬屋のひとりごと

2年前くらいに1巻を試し読みして結構心に残っていた作品。  
どうやら最近人気作品としてピックアップされていたらしく、ちゃんと読んでみようと思ったら全巻買ってしまいました..😊

{{<summary "https://www.amazon.co.jp/%E8%96%AC%E5%B1%8B%E3%81%AE%E3%81%B2%E3%81%A8%E3%82%8A%E3%81%94%E3%81%A8-1%E5%B7%BB-%E3%83%87%E3%82%B8%E3%82%BF%E3%83%AB%E7%89%88%E3%83%93%E3%83%83%E3%82%B0%E3%82%AC%E3%83%B3%E3%82%AC%E3%83%B3%E3%82%B3%E3%83%9F%E3%83%83%E3%82%AF%E3%82%B9-%E6%97%A5%E5%90%91%E5%A4%8F%EF%BC%88%E3%83%92%E3%83%BC%E3%83%AD%E3%83%BC%E6%96%87%E5%BA%AB%EF%BC%8F%E4%B8%BB%E5%A9%A6%E3%81%AE%E5%8F%8B%E7%A4%BE%EF%BC%89-ebook/dp/B0757MTWDV">}}

何に惹かれるのか正直言語化はできないのですが、以下2点かなと思ってます。

* 主人公と周りのキャラ設定がイイ
* 第三者ではない人物視点の語り (人も固定ではない)

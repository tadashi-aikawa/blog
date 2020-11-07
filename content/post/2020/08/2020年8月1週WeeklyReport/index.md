---
title: 2020年8月1週 Weekly Report
slug: 2020-08-1w-weekly-report
date: 2020-08-02T21:02:41+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

Inputの多い一週間でしたが、WriteやTryは少なめです。  
一方、初づくしの一週間でもありました。  
Markowlの初Issue対応、Kotlinテスト初導入、はてなの初3桁など。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

今週はありません。

読んだこと/聴いたこと
---------------------

### Conceptのプレゼン表示

仕事のMTGではじめてConceptを使ってみました。  
驚いたのは外部ディスプレイに接続したとき、他のアプリケーションのように不完全な画面サイズでミラーリングされなかったことです。

手元のiPadとは別に画面を拡張することができ、以下の特徴があります。

* 画面にはキャンバスのみが表示される (プレゼンのフルスクリーンモードのよう)
* 画面の解像度に表示範囲が最適化され、手元のiPadには表示範囲に枠線が表示される

この機能により、手元で小さな文字を書いてもスクリーンでは鮮明に表示されます。  
このユーザー体験は想像以上に最高でした😄

詳しくは公式ドキュメントをご覧ください。

{{<summary "https://concepts.app/ja/ios/manual/presenting">}}

### 土日の体感時間を“1週間”に延ばせる!? 目からウロコの「時間の長さコントロール法」

自分の時間をゆっくり進める方法が紹介されています。  
あっという間に1日/1週間が終わってしまう..と危機感を感じている方は是非！

{{<summary "https://r25.jp/article/561114081475273212?utm_source=twitter&utm_medium=social&utm_campaign=share_on_site&utm_content=sp">}}

印象に残ったこと。

* 冒頭の動画による体感時間
* 代謝をコントロールすることで時間の感じ方を変えられる
* 明るくて広くてやまかしい場所

### 社内勉強会で専門的技術力を高めるには

前半はTLSのコアな話が出てきて面食らいますが、後半に素晴らしい教えがあります。  
`専門的技術力を高めるために大事なこと`から下が心に響きました。

{{<summary "https://techblog.yahoo.co.jp/entry/2020072830014370/">}}

ざっくり言うと、『基礎を大事に1次情報を何回も学びアウトプットしよう』という感じです。  
熟練者になるためには基礎の積み重ねからは逃げられないと思っています。

### なぜDiscordはGoからRustへ移行するのか

[Why Discord is switching from Go to Rust - Discord Blog](https://blog.discordapp.com/why-discord-is-switching-from-go-to-rust-a190bbca2b1f)の内容を和訳された記事です。  
パフォーマンス改善を目的としてGoからRustに移行したストーリーが書かれています。

{{<summary "https://misonln41.hateblo.jp/entry/2020/02/12/232853">}}

元記事が秀逸な理由として、Goのソースコードまで見てチューニングを頑張ったけれど厳しかった..という過程でRustに移行した効果が書かれていることですね。  
Rustにしたらパフォーマンス上がったという話と違い、具体的な壁がどこに存在するのかをイメージできました。

あと、リアルタイムビッグデータの扱いに長けたScyllaDBを初めて知りました。

{{<summary "https://www.scylladb.com/">}}

### Rustのモジュールの使い方 2018 Edition版

クレートとモジュールの説明からはじまり、具体的な利用シーンごとにどのような挙動をするのか、どういう用途で使えるかが丁寧に書かれています。

{{<summary "https://keens.github.io/blog/2018/12/08/rustnomoju_runotsukaikata_2018_editionhan/">}}

特に`lib.rsとmain.rs`セクションの以下は大変参考になりました。なるほどです。

> さて、ここからはスタイルの話ですが、私がRustを書く時はmain.rsの中にmodを書くことはないです。必ずlib.rsを作って、そこでライブラリとしてまとめてからmain.rsで使います。「アプリケーションはアプリケーションを記述するための巨大なDSLとそれを使った小さな実装からなる」という思想ですね。明示的に境界を作ることで自然とAPIを設計出来るのでコードが整理しやすくなります。

### Webブラウザ上で純粋なHTTPだけで単方向リアルタイム通信を可能にするHTTPのストリーミングアップロードが遂にやってくる

ReadableStreamとHTTP POSTでストリーミングができるという話。  
ファイルのストリーミングと違い、終わりが曖昧なものにも使えるのが違いという理解です。

{{<summary "https://scrapbox.io/nwtgck/Web%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6%E4%B8%8A%E3%81%A7%E7%B4%94%E7%B2%8B%E3%81%AAHTTP%E3%81%A0%E3%81%91%E3%81%A7%E5%8D%98%E6%96%B9%E5%90%91%E3%83%AA%E3%82%A2%E3%83%AB%E3%82%BF%E3%82%A4%E3%83%A0%E9%80%9A%E4%BF%A1%E3%82%92%E5%8F%AF%E8%83%BD%E3%81%AB%E3%81%99%E3%82%8BHTTP%E3%81%AE%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%9F%E3%83%B3%E3%82%B0%E3%82%A2%E3%83%83%E3%83%97%E3%83%AD%E3%83%BC%E3%83%89%E3%81%8C%E9%81%82%E3%81%AB%E3%82%84%E3%81%A3%E3%81%A6%E3%81%8F%E3%82%8B">}}

piping-serverも気になります。何かに使えそう。

{{<summary "https://github.com/nwtgck/piping-server">}}

### 現場トランスフォーメーション～アジャイル導入5つの壁を越えろ～

アジャイルを導入したあとに立ち塞がる壁をどう越えればいいかについての資料です。  
難しい用語がなく、くだけた言い回しが多いので専門書が苦手な方にもオススメ。

{{<summary "https://www.slideshare.net/NavitimeJapan/5-237313118">}}

個人的に好きなスライドは以下です。

{{<himg "https://image.slidesharecdn.com/2020-07-28-200728033423/95/5-54-638.jpg?cb=1595907337">}}

### 失敗したエンジニア組織施策としくじりの反省

『お恐らく貴方の会社もやってるのでは...』  
と思わせるような耳の痛い..リアルな話が丁寧に分析されています。

{{<summary "https://note.com/nottegra/n/nf2d782ff235e">}}

引用ではなく独自の解釈を含めた言い回しですが、印象に残ったのは以下です。

* 上の人自らが情報収集に動くべき (情報はもらうものじゃない)
* 普段かかわらない人をレビュアーにいれるなら初期がベスト
* 組織横断の取り組みは困ったときに相談受けるくらいで実はちょうどいいのかも

### Best 8 JavaScript Testing Frameworks In 2020

JavaScriptのテストフレームワークベスト8 in 2020。

{{<summary "https://www.lambdatest.com/blog/top-javascript-automation-testing-framework/">}}

私はJestが好きでそれしか使っていないので、初めにでてきたのは嬉しいですね😄  
e2eテストはChrome以外を対象にするかどうかがキモだな..と思いました。

そして、Cypressはないんですね。★は20000越えているのに..。

{{<summary "https://www.cypress.io/">}}

スターは2000弱ですが個人的にはQA WOLFが気になっています。

{{<summary "https://www.qawolf.com/">}}


試したこと
----------

### 【Vue】Teleport(portal-vue)

Vue3で実装されるTeleportのようなライブラリportal-vueを導入してみました。

{{<summary "https://github.com/LinusBorg/portal-vue">}}

Teleportの仕様はこちら。

{{<summary "https://v3.vuejs.org/guide/teleport.html#using-with-vue-components">}}

用途はNotificationの表示です。

Menuに仕込んだダイアログの処理完了時に表示すると、Menuを閉じたあとNotificationが隠れてしまうので、その対策として入れました。  
よくあるモーダルダイアログを使うケースに似ていると思います。

Nuxt moduleが用意されているので `npm i portal-vue` でインストールしたあとに`nuxt.config.js`をいじるだけで終了でした。プラグイン不要です。


調べたこと
----------

### 【IDEA】自作プラグインがincompatibleエラー

IntelliJ IDEAを2020.2にバージョンアップしたら、自作プラグインがエラーになりました。  
新しいバージョンが対応バージョンに含まれていないことが原因です。

{{<himg "resources/markowl-error.png">}}

制限した覚えはなかったので調べたところ、設定が不十分でした。  
以下の記事に追記しています。

{{<summary "https://blog.mamansoft.net/2020/04/22/create-intellij-idea-plugin/#%E4%BA%92%E6%8F%9B%E6%80%A7%E3%82%92%E5%AE%9A%E7%BE%A9%E3%81%99%E3%82%8B">}}

### 【TypeScript】Axiosでmultipart/form-dataのpostができない

`multipart/form-data`は複数データを送るので、その境目を示すため`boundary`の指定が必要です。

`axios.post(url, data, { headers })`の`data`にObjectを指定すると、リクエストヘッダに`boundary`が付与されないため失敗します。  
`data`にObjectではなく `FormData`クラスのインスタンスを渡すと上記問題が解消されます。

{{<summary "https://r17n.page/2020/02/04/nodejs-axios-file-upload-api/">}}

### 【Portal-Vue】1つのportal-targetを複数portalで指定すると上手く表示されない

以下のようなケースでhoge1とhoge2どちらかが表示されませんでした。

```html
<portal-target name="hoge" />

<portal to="hoge">hoge1</portal>
<portal to="hoge">hoge2</portal>
```

`<portal-target>`に`multiple`を指定しなければいけないようです。  

{{<summary "https://portal-vue.linusb.org/guide/getting-started.html#multiple-portals-one-target">}}

```
<portal-target name="hoge" multiple />

<portal to="hoge">hoge1</portal>
<portal to="hoge">hoge2</portal>
```

`<portal>`の`order`は指定しなくても平気でした。


整備したこと
------------

### JetBrains Toolbox Appの導入

IntelliJ IDEAしか使っていないため今まではScoopで運用していました。  
ところが `scoop update`した場合に設定がすべてリセットされてしまいました..。

ならば機会にJetBrains Toolbox Appを試してみようと思ったわけです。  
クリティカルな不具合があった場合の切り戻しも簡単そうですし😉

{{<summary "https://www.jetbrains.com/ja-jp/toolbox-app/">}}


### Intellij IDEAを2020.2にアップデート

主にWeb系の開発をしているためWebStormの記事が参考になりました。

{{<summary "https://blog.jetbrains.com/webstorm/2020/07/webstorm-2020-2/">}}

全体的に素晴らしいリリース内容ですが、特に興奮したものは2つあります。

#### Using Prettier as the default formatter

デフォルトのフォーマッターでPrettierが使えます！  
すぐに設定変更しました。

これで標準フォーマットかPrettierかで気を遣う日々ともオサラバです👋  
また、標準フォーマット特有の機能をPrettierで使えるのもありがたい..。

#### New tools for finding problems in your code

一番嬉しいのは`Problems tool window`の追加ですね。  
逆になぜ今まで無かったのか不思議なくらい便利です😆

#### その他

他にもワクワクするような変更が沢山あります。  
機会を見つけて試していきたいですね💪

* Vue/Nuxt周りの補完強化
* Vue/NuxtのCode Style追加
* Loopやoptional chaining / nullish coalescingのIntention強化
* WSL2内のプロジェクトではWSL2のGitを使えるようになった
* Gitの操作/UI改善
* 機械学習のコード補完(試験的機能)
* ターミナルからデバッグ開始
* Debugger ConsoleでObjectの詳細な情報が見られるようになった


### Kotlinの単体テストを導入

はじめてKotlinの単体テストを書いてみました。  
導入したプロダクトは[Markowl](https://plugins.jetbrains.com/plugin/14116-markowl)です。

以下を参考にさせていただきました。

{{<summary "https://qiita.com/suin/items/96799c9f50a31ae54969">}}

`build.gradle`を以下のように変更しました。

```diff
  dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk8"
-   testCompile group: 'junit', name: 'junit', version: '4.12'
+   testImplementation("org.jetbrains.kotlin:kotlin-test")
+   testImplementation("org.jetbrains.kotlin:kotlin-test-junit")
  }
```

あとはparameterizedテストを書くだけでOK。

```kotlin
package net.mamansoft.markowl.util
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import kotlin.test.Test
import kotlin.test.assertEquals

@RunWith(Parameterized::class)
class JapaneseTest(private val arg: String, private val expected: Int) {
    companion object {
        @JvmStatic
        @Parameterized.Parameters
        fun data() = listOf(
            arrayOf("ほげ", 4),
            arrayOf("ホゲﾎｹﾞ", 4),
            arrayOf("保毛★", 6)
        )
    }
    @Test
    fun test() {
        assertEquals(expected, width(arg))
    }
}
```

classのコンストラクタ引数とarrayOfの順番をあわせるのがミソです。


今週のリリース
--------------

### Markowl v0.5.2 ～ v0.6.0

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

#### プラットフォームバージョン2020.1以外でインストールできない不備を修正

互換性の設定が甘かったです..。

#### キリル文字の幅に対応

キリル文字の幅を2ではなく1にしました。

{{<himg "resources/markowl_cyrillic.gif">}}

他言語の幅についてもIssueが作成されたら対応していきたいと思っています💪

{{<summary "https://github.com/tadashi-aikawa/markowl/issues/1">}}


### Togowl v2.7.0 ～ v2.8.0

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### 新規タスク作成で任意の期日を指定可能に

タスク作成ダイアログの一番右のボタンで任意の期日を指定できます。

{{<mp4 "resources/togowl_v2.7.0.mp4">}}

もともとそこにあった『期日なしで作成』ボタンは消しました。  
Togowl使用中に期日無しタスクを作るケースがなかったので。

#### タスクの編集機能

タスクエントリのメニューからタスクの編集ができるようになりました。  
名前、プロジェクト、ラベルの変更ができます。

{{<mp4 "resources/togowl_v2.8.0.mp4">}}

期日や並び順の変更はスワイプメニューからとなります。

### Owlelia v0.13.0 ～ v0.14.0

{{<summary "https://github.com/tadashi-aikawa/owlelia">}}

#### DateTimeクラスのメソッド追加

以下のメソッド/getterを追加しました。

* DateTime.today()
* plusHours()
* plusMinutes()
* minusHours()
* minusSeconds()
* overwriteDate()
* isStartOfDay
* rfc3339WithoutTimezone

#### テスト整備

Lineカバレッジが62%から90%まで上昇しました😄  

{{<summary "https://codecov.io/gh/tadashi-aikawa/owlelia/commit/5c0724502bc55ec6bac721da08bc8270bb621eff">}}


その他
------

2ヶ月前に書いた記事が初のはてな3桁に到達していました🎉

{{<summary "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}

当時、結構頑張って書いたのもあり結果が出るのは嬉しいですね☺️

{{<tweet "1267019993318690816">}}


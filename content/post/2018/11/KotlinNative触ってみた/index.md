---
title: Kotlin/Native触ってみた
slug: try-kotlin-native
date: 2018-11-05T23:41:01+09:00
thumbnailImage: https://cdn.svgporn.com/logos/kotlin.svg
categories:
  - engineering
tags:
  - kotlin
---

Kotlin/NativeでHello Worldのようなプログラムを書いてみました。

<!--more-->

<!--toc-->


はじめに
--------

今回Kotlinを題材に挙げたのはKotlinを始めたからです。  
始めた理由は前からとても文法が好きだったからです。

例えば以下のようなものです。

* 関数型の書き方
* 暗黙の`it`が使える
* エルヴィス演算子


このタイミングでKotlinを始める理由
----------------------------------

### Go言語とCLIツール開発

私は公私共にCLIツールをよく開発します。  
その際、ポータビリティーを非常に重要視しています。

例えば以下のような特徴です。

* OS問わず動く (Windows/Mac/Linux)
* シングルバイナリにビルドできる
* 動的依存関係が一切ない

Go言語はこれら全ての特徴を満たしています。  
ポータビリティの高さと開発スピードの速さは素晴らしいです。

一方、関数型の書き方はほぼできないので毎回書くfor文やif文には不満を持っています。  
そう..Go言語は現実的かつ実用的ですが、決して面白かったり気持ちの良い言語ではないと思っています。


### Rustの学習コスト

実はGoを始める前に少しだけRustを使っていました。  
最近GitHubで公開し始めたGowlというCLIツール.. はじめはRustで開発しており途中からGoにリプレイスしています。

{{<summary "https://github.com/tadashi-aikawa/gowl">}}

{{<info "GoでGowlを開発した記事">}}
{{<summary "https://blog.mamansoft.net/2018/09/24/go-git-structual-cli-create/">}}
{{</info>}}

Rustは関数型の記述にも優れており魅力的な言語ですが、開発を続けるにあたりいくつか気になる点がありました。

* 所有権などが厳しい
* シングルバイナリをビルドするのにコツがいる ([過去の記事](http://localhost:1313/2018/08/20/rust-linux-single-binary/))
* 世間的にGoの方が流行っておりAWSなども公式対応している

Rustは悪い奴ではないのですが、このままRustで保守し続けるモチベーションが保てなかったのです。  
関数型の記述もRustの厳しさ故にかなりくどい書き方になります..。


### Kotlin/Nativeとポータビリティ

今まで基本的にJVM言語であるKotlinを敬遠していましたが、Kotlin 1.3にKotlin/Nativeのβ版が同梱されました。

{{<summary "https://kotlinlang.org/docs/reference/native-overview.html">}}

公式ドキュメントを見る限り以下を満たしていそうです。

* OS問わず動く (Windows/Mac/Linux)
* シングルバイナリにビルドできる
* 動的依存関係が一切ない (これは自信ないですが多分...)

『Kotlinでポータビリティの高いシングルバイナリを作る事ができる...!!』

この言葉が偽りでなければ.. 今Kotlin/Nativeを始めない理由は無いでしょう。


前提条件
--------

筆者の環境は以下の通りです。

* Windows10 Home 10.0.17134
* Kotlin/Native: 0.9.3 (kotlinc-native 1.3.0-rc-116 (JRE 1.8.0_191-b12))
* IntelliJ IDEA 2018.2.5 (Ultimate Edition) (Build #IU-182.4892.20, built on October 16, 2018)
  * Kotlin plugin (v1.3.0-release-IJ2018.2-1)


インストール
------------

以下のページからプラットフォームに適した圧縮ファイルをダウンロードします。

{{<summary "https://github.com/JetBrains/kotlin-native/releases">}}

解凍したら好きな場所に配置して、binディレクトリをPathに追加しましょう。  
私の場合はC直下に解凍し、`C:\kotlin-native-windows-0.9.3\bin`をPathに追加しました。


はじめての実行
--------------

`main.kt`を作成します。  
Hello Worldではつまらないので関数型っぽいコードを書いてみます。

```kotlin
fun main() {
    var list = listOf(1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21)
      .filter {it > 5}
      .map {it * 2}
      .groupBy {it % 5}
    println(list)
}
```

`kotlinc-native`コマンドでコンパイルします。  
初回だけ[LLVM], sysrootなどをダウンロードするため時間がかかります。

```
$ kotlinc-native main.kt
```

私のマシンでは20秒くらいかかりましたが、成功すると実行ファイルが生成されます。  
Windowsの場合は`program.exe`です。これを実行してみましょう。

```
$ ./program.exe
{4=[14, 34], 3=[18, 38], 2=[22, 42], 1=[26], 0=[30]}
```

ちゃんと結果が出力されました。


IntelliJ IDEAで動かす
---------------------

ちゃんと開発するにはIDEが必要です。  
Kotlinの開発元でもあるJetBrainsのIDE、IntelliJ IDEAを使います。

{{<summary "https://www.jetbrains.com/idea/">}}

Kotlinプラグインがインストールされていない場合はインストールが必要です。

{{<himg "resources/20181105_1.png">}}


### プロジェクト作成

Kotlinの`Kotlin/Native`を選びましょう。

{{<himg "resources/20181105_2.png">}}

`Gradle JVM`の指定を要求されます。  
Kotlin/NativeはGradle経由で実行するため、Gradleを動かすためにJVMが必要なようです... そんな馬鹿な..。

私の場合は`C:\Program Files\Java\jdk1.8.0_191`を指定しました。  
これは[Chocolatey]でインストールしたものです。

プロジェクト作成後は`kotlin-gradle-plugin`が準備を行うため少し待ちます。


### 実行

既にサンプルプログラムが`src`配下に用意されています。  
`src/mingwMain/kotlin/sample/SampleMingw.kt`がそれにあたります。

```
src
+---mingwMain
|   +---kotlin
|   |   \---sample
|   |           SampleMingw.kt
|   |
|   \---resources
\---mingwTest
    +---kotlin
    |   \---sample
    |           SampleTests.kt
    |
    \---resources
```

`build.gradle`を開き、`task runProgram`の横に表示される実行ボタンをクリックしてみましょう。  
プログラムが実行されます。

{{<himg "resources/20181105_3.png">}}



総括
----

Kotlin/NativeをターミナルとIntelliJ IDEAからそれぞれ実行してみました。

本当はhttp通信するCLIツールを作りたかったのですが、Kotlin/Native対応しているhttp clientライブラリが無かった(※1)ので断念しました。  
しばらくはJVMで動くKotlinコードを書いている方がいいのかもしれません..。

{{<warn "※1について...">}}
もしご存知の方いらっしゃいましたら教えて下さい <(_ _)>
{{</warn>}}


[LLVM]: https://llvm.org/
[Chocolatey]: https://chocolatey.org/

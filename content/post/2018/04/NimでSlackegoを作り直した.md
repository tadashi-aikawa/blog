---
title: "NimでSlackegoを作り直した"
slug: nim-recreate-slackego
date: 2018-04-30T3:30:00+09:00
thumbnailImage: https://images.pexels.com/photos/267447/pexels-photo-267447.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260
categories:
  - engineering
tags:
  - nim
  - slack
  - 情報収集
---

以前にPythonでSlackをエゴサーチするツールSlackegoを作りましたが、Nimでそれを作り直しました。

<!--more-->

![](https://images.pexels.com/photos/267447/pexels-photo-267447.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260)

リポジトリはこちらです。Windowsには対応していません。

{{<summary "https://github.com/tadashi-aikawa/slackego">}}

<!--toc-->


経緯
----

先週NimでGitHubのリポジトリ検索ツールを作りました。

{{<summary "https://blog.mamansoft.net/2018/04/22/nim-github-search-tool/">}}

ただ、これは実用的なものではなく勉強のために作成したモノに過ぎません。  
私が新しい言語を学ぶときにほぼ例外なく作成するモノです。

Nimを学んだ大きな理由の1つがPythonで作成モノの置き換えです。  
[Jumeaux]は私が本気で作成中のPython製ツールですが、置き換えには少々ヘビーです。  
そこで、先日作成したSlackegoを置き換えることにしました。

[Jumeaux]: https://github.com/tadashi-aikawa/jumeaux


本記事の内容
------------

本記事ではSlackegoをNimで実装することで得た知見を紹介します。  
いずれもNimを使い始めた方向けの内容になっていると思います。

Slackegoの経緯については下記記事を参照して下さい。

{{<summary "https://blog.mamansoft.net/2018/04/15/create-slackego/">}}

また、使い方はGitHubのREADMEをご覧下さい。

{{<summary "https://github.com/tadashi-aikawa/slackego">}}


利用パッケージ
--------------

Slackegoで利用したパッケージの紹介を簡単にします。  
前回説明したものは説明しません。


### [json](https://nim-lang.org/docs/json.html)

jsonをobjectと相互変換する為に使っています。
間に`JsonNode`という型が含まれます。

以下の変換を使用しています。

| Before       | 変換に使ったもの | After    | 主な用途                                             |
|--------------|------------------|----------|------------------------------------------------------|
| ファイルパス | parseFile        | JsonNode | jsonファイルの読みこみ                               |
| string       | parseJson        | JsonNode | 文字列をjsonに変換したいとき(http get)               |
| object       | %*               | JsonNode | objectをjsonとしてパースしたいとき                   |
| JsonNode     | getBool          | bool     | jsonのbool要素を取り出したいとき                     |
| JsonNode     | getStr           | string   | jsonのstring要素を取り出したいとき                   |
| JsonNode     | $                | string   | jsonをワンラインの文字列に変換したいとき (http post) |
| JsonNode     | pretty           | string   | jsonを人間が読める文字列に変換したいとき             |

{{<alert "info">}}
本当は[NimYAML](https://nimyaml.org/index.html)を使いたかったのですがビルドが通らなくて諦めました...
{{</alert>}}


### [dotenv](https://github.com/euantorano/dotenv.nim)

環境変数を定義したファイル、`.env`を読みこんで環境変数にセットする為に使います。

```nim
import os
import dotenv

if fileExists(".env"):
  initDotEnv().load()
```

`.env`が存在しない場合は無視したいので、osモジュールの`fileExists`を使用しています。


### [uri](https://nim-lang.org/docs/uri.html)

RFC3936に従いURIのクエリをパースするため、`encodeUrl`を使用します。

```nim
import uri

# ..中略..

proc search*(word: string, after: DateTime): SearchResult =
  assertToken()

  let
    token = getEnv("SLACK_TOKEN")
    afterDate = after.format("yyyy-MM-dd")
    query = encodeUrl(fmt"{word} after:{afterDate}")
```


### [times](https://nim-lang.org/docs/times.html)

日時を扱うために`DateTime`型を利用します。

`yyyy-MM-dd`表記に変換するため`format("yyyy-MM-dd")`を使用しています。  
`$`は`yyyy-MM-ddThh:mmzzz`にフォーマットされてしまうので使用できませんでした。

現在時刻から1日+minutes分前のDateTime型を生成するには以下のようにします。

```nim
let t: DateTime = now() - 1.days - minutes.minutes
```


### [options](https://nim-lang.org/docs/options.html)

みんな(多分)大好き`Option`型です。

| プロシージャ | 意味                                 |
|--------------|--------------------------------------|
| some(val)    | valを値としてOptionで包む            |
| none(T)      | `T`型の値ナシとしてOptionで包む      |
| isSome       | 値が存在する場合に`true`を返す       |
| get          | 値を取得する. 存在しない場合はエラー |

`Option(val)`みたいにしたら`val`を判定して`some(val)`か`none(T)`のどちらかを返却してくれるともっと楽なのですが..。

今回は使用しませんでしたが、`unsafeGet`, `map`, `filter`, `flatten`, `flatMap`も便利ですね。


### [terminal](https://nim-lang.org/docs/terminal.html↲)

ターミナル/コンソールでエラー表示をするために使用しています。  
エラーを表示してプログラムを終了させる関数`error`を`util.nim`に作りました。

```nim
import os
import terminal

proc error*(msg: string, code: int = 1) =
  styledWriteLine(stderr, fgRed, "Error: ", msg, resetStyle)
  quit(code)
```

`styledWriteLine`は標準出力に赤色でメッセージを出力します。


### [strutils](https://nim-lang.org/docs/strutils.html)

文字列を数値型に変換するために使用しています。  
実際に使用したのは`parseFloat`ですがよく使うプロシージャもあわせて紹介します。

| プロシージャ | 変換後の型 | 備考                                            |
|--------------|------------|-------------------------------------------------|
| parseInt     | int        | -                                               |
| parseFloat   | float      | -                                               |
| parseBool    | bool       | y,yes,true,1,onがtrue. n,no,false,0,offがfalse  |
| parseEnum    | enum       | デフォルト値を指定するとinvalidの時に採用される |

他にも文字列を置換する`replace`が使われています。


その他
------

Slackegoの実装とは関係ありませんがハマったことです。

### 1..n表記でsequenceを作成する

[sequtils](https://nim-lang.org/docs/sequtils.html)の`toSeq`を使用します。

```nim
toSeq(1..100).filterIt(it > 90)
```

### Get propert

Pythonにおけるget propertyのようなものをNimで使う方法です。  
[Properties](https://nim-lang.org/docs/tut2.html#object-oriented-programming-properties)を使います。

```nim
import strutils
import times

type Message* = object
  username*: string
  text*: string
  permalink*: string
  channel*: Channel
  ts: string

proc unixTime*(m: Message): int {.inline.} = m.ts.parseFloat.int
proc dateTime*(m: Message): DateTime {.inline.} = m.unixTime.fromUnix.inZone(local())
```

上記の`Message.ts`は外部モジュールに公開されていません。  
代わりに`unixTime`と`dateTime`が公開されており、それぞれ`int`型、`DateTime`型を返却します。

[Method call syntax](https://nim-lang.org/docs/tut2.html#object-oriented-programming-method-call-syntax)の記法を使うことでプロシージャ呼び出しではなくプロパティのように表記が可能です。  
Method call syntaxはNimが持つ非常に興味深い機能の1つであり、ルーチン呼び出しの糖衣構文です。  
これまでにも何度か登場していますが説明するのはこれが初めてになります。

| 通常の呼び出し方                     | Method call syntax                 |
|--------------------------------------|------------------------------------|
| days(1)                              | 1.days                             |
| parseFloat("1.23")                   | "1.23".parseFloat                  |
| int(parseFloat("1.23"))              | "1.23".parseFloat.int              |
| isZone(fromUnix(123456789), local()) | 123456789.fromUnix.isZone(local()) |

Nimにはclassが無いのでobjectにMethod call syntaxでプロシージャを定義していく流儀なのでしょうか..。


総括
----

Pythonで作成したSlackegoをNimに移植しました。  
yamlからjsonへの変更など移植しきれない部分もありましたが、ほとんどの機能はキレイに移植することができたと思います。

Python版のSlackegoもリポジトリは残してありますので興味がありましたらご覧下さい。

{{<summary "https://github.com/tadashi-aikawa/slackego-python">}}

構成や書き方が多少変わっていますが大筋に変更は無いはずです。


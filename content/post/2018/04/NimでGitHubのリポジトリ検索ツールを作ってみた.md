---
title: "NimでGitHubのリポジトリ検索ツールを作ってみた"
slug: nim-github-search-tool
date: 2018-04-22T17:01:00+09:00
thumbnailImage: https://raw.githubusercontent.com/nim-lang/assets/master/Art/logo-crown.png
categories:
  - engineering
tags:
  - nim
  - github
---

最近気になっている言語Nimを使ってGitHubのリポジトリ検索ツールを作ってみました。

<!--more-->

Nimは非常に美しい言語です!!  
どれくらい美しいかというと、レイの飛燕流舞くらいですね :grin:

{{<summary "http://www.geocities.jp/hokuaniken/ougi/nanto/suityou/hienryuubu.html">}}

<!--toc-->


対象とする読書
--------------

本記事は以下の読者を前提にしています。

* Nimを使ったことがない
* 1つ以上のプログラミング言語を習得している
* Ubuntuの開発環境がある(VMでもOK)
* REST APIを使った開発経験がある
* VS CodeまたはVimを使用した開発経験がある
* Package managerを使用した開発経験がある

以下は必須ではありませんが、該当すると望ましいです。

* Python3を用いた開発経験がある
* 関数型言語を用いた開発経験がある
* 英語のドキュメントに強い抵抗がない


Nimとは
-------

{{<summary "https://nim-lang.org/">}}

公式から流用しますと以下のような特徴を持つ言語です。

* システムおよびアプリケーションプログラミング言語
* 静的型付け
* コンパイル言語
* エレガントなパッケージ
* ハイパフォーマンスなガベージコレクタ言語
* C, C++, JavaScriptへのコンパイル
* シングルバイナリ
* Windows, mac, Linuxなどで動く


なぜNimか
---------

私が求める言語仕様の理想に最も近いからです。


### Pythonを使う理由

CLIツール作成には以下の理由からPythonを利用しています。

* シンプルに書ける
* エコシステムが充実している
* 型注釈が使える
* ラムダ式が使える


### Pythonの不満点

一方で以下の不満点がありました。

* 関数型言語の書き方をするには表現が乏しい
* 静的型付けに対応していない (対応する予定も無さそう)
* パフォーマンスが良くない (普通に使った場合)
* 非Python利用者には実行環境構築のハードルが高い

Nimはこれらの不満を全て解消します。


### Nimを使うとどうなるか

#### 関数型言語の書き方

関数型言語の書き方については、以下のようにメソッドチェーンで記述することができます。

```nim
echo @[1, 2, 3, 4, 5]
  .map(proc(x: int): int = x * 2)
  .filter(proc(x: int): bool = x < 5)
  .foldl(a + b)
# -> 6
```

`xxxIt`プロシージャを使うと、ラムダ式部分を更に簡略化できます。

```nim
echo @[1, 2, 3, 4, 5]
  .mapIt(it*2)
  .filterIt(it < 5)
  .foldl(a + b)
```

#### 静的型付け

Nimは静的型付けに対応しています。  
ジェネリクスを使用したり、不要な場合は型推論に頼ることも可能です。

#### パフォーマンス

Nimは非常に高いパフォーマンスを誇ります。  
以下のサイトにあるプログラムの比較結果を見てもPython3より遥かに速いことが分かります。

{{<summary "http://blog.johnnovak.net/2017/04/22/nim-performance-tuning-for-the-uninitiated/#round-2-----nim-vs-java-javascript--python">}}

#### 実行環境

Nimはシングルバイナリで実行可能です。  
また、作成されるバイナリのサイズも非常にコンパクトになることが公式サイトから分かります。

{{<summary "https://nim-lang.org/features.html">}}


Nimのインストール
-----------------

開発環境はUbuntu 16.04を使用します。  
公式サイトを参考にしてインストールします。

{{<summary "https://nim-lang.org/install_unix.html">}}

nimのインストール/管理を簡易可するツール、choosenimをインストールします。

{{<summary "https://github.com/dom96/choosenim#choosenim">}}

```
$ curl https://nim-lang.org/choosenim/init.sh -sSf | sh

Downloading Nim 0.18.0 from nim-lang.org
[##################################################] 100.0% 0kb/s
 Extracting nim-0.18.0.tar.xz
   Building Nim 0.18.0
   Building tools (nimble, nimgrep, nimsuggest)
  Installed component 'nim'
      Hint: Binary 'nim' isn't in your PATH. Add '/home/vagrant/.nimble/bin' to your PATH.
  Installed component 'nimble'
      Hint: Binary 'nimble' isn't in your PATH. Add '/home/vagrant/.nimble/bin' to your PATH.
  Installed component 'nimgrep'
      Hint: Binary 'nimgrep' isn't in your PATH. Add '/home/vagrant/.nimble/bin' to your PATH.
  Installed component 'nimsuggest'
      Hint: Binary 'nimsuggest' isn't in your PATH. Add '/home/vagrant/.nimble/bin' to your PATH.
   Switched to Nim 0.18.0
choosenim-init: ChooseNim installed in /home/vagrant/.nimble/bin
choosenim-init: You must now ensure that the Nimble bin dir is in your PATH.
choosenim-init: Place the following line in the ~/.profile or ~/.bashrc file.
choosenim-init:     export PATH=/home/vagrant/.nimble/bin:$PATH
```

これでnim, nimble, nimgrep, nimsuggest がインストールされました。
nimbleはパッケージ管理ツール、nimsuggestはIDEのサジェスト機能で使用するツールです。

バージョンを確認します。

```
$ nim -v
Nim Compiler Version 0.18.0 [Linux: amd64]
Copyright (c) 2006-2018 by Andreas Rumpf

git hash: 855956bf617f68ac0be3717329e9e1181e5dc0c6
active boot switches: -d:release
```

環境変数PATHに`/home/vagrant/.nimble/bin`を追加しましょう。


IDEを選ぶ
---------

IDEはVisual Stucio Codeを使用することにしました。

{{<summary "https://marketplace.visualstudio.com/items?itemName=kosz78.nim">}}

選んだ理由は以下の通りです。

* 一通り必要な機能が揃っている
* 今もメンテナンスされている
* [Nim専用IDEのAporiaがVS Codeを推奨している](https://github.com/nim-lang/Aporia)

IntelliJ IDEAを使いたかったのですがプラグインがメンテナンスされていなかったので諦めました。

Vimはvim-lspを使用しており、Nimが対応されていなかったので見送りました。  
nim専用のプラグインの使用を検討するのもアリかなと思っています。

{{<alert "success">}}
Vimのプラグインを使う場合は[zah/nim.vim](https://github.com/zah/nim.vim)が良さそうです。  
deinで管理している場合は`call dein#add('zah/nim.vim')`だけで上手くいきました。

* シンタックスハイライト
* ファイルタイプの認識
* ALEを通したnim check
{{</alert>}}


Hello World
-----------

### Nimプロジェクトの作成

nimbleを使ってプロジェクトを作成します。

{{<summary "https://github.com/nim-lang/nimble">}}

`ghsearch`ディレクトリを作成し、その配下で`nimble init`を実行してください。

いくつかの質問に答えるとプロジェクトが作成され、以下のエントリが存在します。  
成果物は実行ファイルにするため、`Package type`はbinを選択して下さい。

```
.
├── ghsearch.nimble   # PackageやDependenciesが記載されたファイル
├── src
│  └── ghsearch.nim   # Hello Worldプログラム
└── tests
   ├── test1.nim      # テストのサンプルファイル
   └── test1.nims     # ???
```


### 実行

以下のコマンドで開発用のコンパイル+実行することができます。

```
$ nim c -r 
Hint: used config file '/home/vagrant/.choosenim/toolchains/nim-0.18.0/config/nim.cfg' [Conf]
Hint: system [Processing]
Hint: ghsearch [Processing]
CC: ghsearch_ghsearch
CC: stdlib_system
Hint:  [Link]
Hint: operation successful (11718 lines compiled; 0.750 sec total; 22.215MiB peakmem; Debug Build) [SuccessX]
Hint: /home/vagrant/works/ghsearch/src/ghsearch  [Exec]
Hello, World!
```

VS Codeからは`Run selected file`で実行します。デフォルトだと`F6`に割り当てられています。


GitHubからデータを取得する
--------------------------

### httpsでデータを取得

[httpclient](https://nim-lang.org/docs/httpclient.html)モジュールを使用します。

```nim
import httpclient

const URL = "https://api.github.com/search/repositories?q=jumeaux&sort=stars&order=desc"

var client = newHttpClient()
echo client.getContent(URL)
```

これを実行するとエラーになりました。

```
Error: unhandled exception: SSL support is not available. Cannot connect over SSL. Compile with -d:ssl to enable. [HttpRequestError]
```

httpsのため、`-d:ssl`オプションを付けてコンパイルする必要があるみたいです。

```
nim c -d:ssl -r src/ghsearch.nim
```

これで実行できます。

{{<alert "info">}}
VS Codeで実行する場合はタスクから実行します。`task.json`に以下のような設定をしましょう。

```json
{
    "version": "2.0.0",
    "taskName": "Run",
    "command": "nim",
    "args": [
        "c",
        "-d:ssl",
        "-r",
        "src/ghsearch.nim"
    ],
    "options": {
        "cwd": "${workspaceRoot}"
    },
    "type": "shell",
    "group": {
        "kind": "build",
        "isDefault": true
    }
}
```
{{</alert>}}


### JSONからデータを抽出

レスポンスJSONを解析して必要なデータを抽出しましょう。  
[json](https://nim-lang.org/docs/json.html)モジュールを使用します。

```nim
import httpclient
import json

type
  GitHubRepository = object
    total_count: int

const URL = "https://api.github.com/search/repositories?q=jumeaux&sort=stars&order=desc"

let client = newHttpClient()
let res: string = client.getContent(URL)
let resJson: JsonNode = parseJson(res)

let data = to(resJson, GitHubRepository) 
echo data.total_count
```

上記コードはレスポンスjsonの`.total_count`を表示します。  
jsonモジュールのtoマクロがJsonNodeとGitHubRepositoryの変換を行っています。

{{<alert "warning">}}
変換後のtypeにOption型のフィールドが含まれる場合はエラーになります。

これは下記のプルリクエストが対応されれば解消すると思います。  
https://github.com/nim-lang/Nim/pull/7450
{{</alert>}}


### リポジトリ名と作者を表示

まずは完成コードをお見せします。

```nim
import httpclient
import json
import sequtils
import strformat
import strutils
import algorithm

type
  Owner = object
    id: int
    login: string
  Repository = object
    id: int
    name: string
    owner: Owner
  GitHubRepository = object
    total_count: int
    items: seq[Repository]

const URL = "https://api.github.com/search/repositories?q=jumeaux&sort=stars&order=desc"

let
  content: string = newHttpClient().getContent(URL)
  retStr: string = to(parseJson(content), GitHubRepository)
    .items
    .sortedByIt(it.id)
    .map(proc(r: Repository): string = fmt"{r.id}: {r.name} ({r.owner.login})")
    .join("\n")

echo retStr
```

なんと美しいコードでしょうか。  
retStrに代入する値の作成に使っているメソッドについて確認していきましょう。

#### リポジトリをidで並び替える

[algorithm](https://nim-lang.org/docs/algorithm.html)モジュールの`sortedByIt`を使用します。

`sotedByIt`は`seq[Repository]`の要素1つ1つを`it`という変数にInjectします。  
`it.id`は`Repository.id`のことであり、`seq[Repository]`はid昇順に並び替えられます。

#### リポジトリを1行の文字列に変換する

変換には[sequtils](https://nim-lang.org/docs/sequtils.html)モジュールの`map`を使います。  

`map`の引数に記載された`proc(r: Repository): string = ...`はラムダ式です。  
上記ラムダ式は`Repository`型のrを引数にとり、`string`型の値を返却します。

また文字列の生成には[strformat](https://nim-lang.org/docs/strformat.html)の`fmt`を使用します。

`fmt"..."`は[Formatted string literals](https://nim-lang.org/docs/strformat.html)です。  
`{変数名}`のようにすると、文字列の中に変数の値を埋め込むことができます。

#### 文字列を改行区切りで結合する

[strutils](https://nim-lang.org/docs/strutils.html)モジュールの`join`を使用します。


### 引数からリポジトリ名を指定

最後に引数からリポジトリ名を指定できるようにしましょう。  
[os](https://nim-lang.org/docs/os.html)モジュールの`commandLineParams`を使います。

```nim
let
  word = commandLineParams()[0]
  url = fmt"https://api.github.com/search/repositories?q={word}&sort=stars&order=desc"
  content: string = newHttpClient().getContent(url)
  retStr: string = to(parseJson(content), GitHubRepository)
    .items
    .sortedByIt(it.id)
    .map(proc(r: Repository): string = fmt"{r.id}: {r.name} ({r.owner.login})")
    .join("\n")
```

コード量が増えてきたので、letの中身だけ記載しています。  
`commandLineParams`にはコマンドラインで指定した引数がSequenceで渡ってきます。

`tasks.json`の`args`に引数を指定して実行してみましょう。

```json
{
    "version": "2.0.0",
    "taskName": "Run",
    "command": "nim",
    "args": [
        "c",
        "-d:ssl",
        "-r",
        "src/ghsearch.nim",
        "git"
    ],
    "options": {
        "cwd": "${workspaceRoot}"
    },
    "type": "shell",
    "group": {
        "kind": "build",
        "isDefault": true
    }
}
```

gitの検索結果が表示されました。

```
36502: git (git)
140656: tig (jonas)
286061: gitolite (sitaramc)
291137: oh-my-zsh (robbyrussell)
331603: vim-fugitive (tpope)
401025: hub (github)
481366: gitflow (nvie)
585285: gollum (gollum)
817345: git-extras (tj)
901662: libgit2 (libgit2)
1062897: gitignore (github)
1280180: phabricator (phacility)
1334369: resume.github.com (resume)
1614410: FFmpeg (FFmpeg)
2500088: gitlabhq (gitlabhq)
2889328: WordPress (WordPress)
5405654: learnGitBranching (pcottle)
9350746: gitbucket (gitbucket)
10154151: ungit (FredrikNoren)
16752620: gogs (gogits)
18280236: gitbook (GitbookIO)
18708860: github-cheat-sheet (tiimgreen)
21125024: husky (typicode)
22119721: git-flight-rules (k88hudson)
24420506: v8 (v8)
39122628: tips (git-tips)
40638363: GitUp (git-up)
43998576: git-recipes (geeeeeeeeek)
51071818: diff-so-fancy (so-fancy)
113752225: profile-summary-for-github (tipsy)
```


docoptを使用してCLIインターフェースを改良する
---------------------------------------------

既にリポジトリを指定して検索することはできますが、更に1つ改良を加えましょう。  
[docopt](https://github.com/docopt/docopt.nim)を使って以下の機能を追加します。

* `sort`でソート対象を指定できる
* `-r`または`--reverse`を指定すると順番を逆転させることができる(昇順になる)


### 外部パッケージのインストール

`nimble install`にパッケージ名を指定するとパッケージをインストールすることができます。

```
$ nimble install docopt
```

これだけでは依存関係が記録されませんので`ghsearch.nimble`のDependenciesに追記します。

```
# Package

version       = "0.1.0"
author        = "tadashi-aikawa"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["ghsearch"]

# Dependencies

requires "nim >= 0.18.0"
requires "docopt >= 0.6.5"
```

{{<alert "success">}}
`nimble install docopt`にオプションを指定すれば`.nimble`ファイルのDependenciesに自動で記載されるのが一番楽ですが、やり方を見つけられませんでした...
{{</alert>}}


`.nimble`ファイルのDependenciesをインストールする場合は以下の様に実行します。

```
$ nimble install -d
```

installコマンドを実行せず、`nimble build`でビルド実行でもOKです。

インストール済みのパッケージを確認する場合は以下のコマンドを実行します。

```
$ nimble list -i
```


### docoptを使った実装

docoptはCLI説明言語です。仕様は以下の公式を参考にして下さい。

{{<summary "http://docopt.org/">}}

{{<alert "success">}}
[docopt.nim](https://github.com/docopt/docopt.nim)はdocoptの数ある実装の1つです。
{{</alert>}}

READMEを参考にして以下の`ghsearch.nim`を実装しました。

```nim
const doc = """
Usage:
  ghsearch <repository> [--sort=<sort>] [-r | --reverse]

Options:
  <repository>      Search repository
  --sort=<sort>     Sort by stars/forks/updated [default: stars]
  -r --reverse      Sort by asc
"""
import sequtils
import strformat
import strutils
import algorithm
import docopt

import ghsearchpkg.clients.github

proc main = 
  # コマンドライン引数を解釈し、必要な形で変数に代入する
  let
    args = docopt(doc, version = "0.1.0")
    repository: string = $args["<repository>"]
    sort: Sort = parseEnum[Sort]($args["--sort"])
    order: SortOrder = if args["--reverse"]: SortOrder.Ascending else: SortOrder.Descending

  # GitHubに検索して結果を表示
  echo searchRepositories(repository, sort, order)
    .items
    .map(proc(r: Repository): string = fmt"[✪ {r.stargazers_count:<5}] {r.owner.login}/{r.name}")
    .join("\n")

main()
```

実装がガラっと変わっていますが、処理はコメントに書かれている通りです。

docにdocoptの仕様に従った記載をしています。  
`docopt(doc, version = "0.1.0")`の戻り値である`Table[string, Value]`型のargsにCLI引数が格納されています。

新しく登場した仕様を箇条書きで簡単に補足します。

* `if ???: A else: B`は三項演算子のような動きをします
* `$args["..."]`の`$`は`string`型に変換する演算子です
  * `Value`型の`args["..."]`を`string`型に変換します
* `parseEnum[T](A)`は`string`型のAをenumである`T`型に変換します


### Githubクライアントモジュールの外出し

`ghsearch.nim`の中で呼び出されている`searchRepositories`プロシージャは`ghsearchpkg/clients/github.nim`を作成して移動しました。  
GitHubに関するクライアント処理を記載しています。

{{<alert "warning">}}
`ghsearch.nim`以外のファイルは`ghsearchpkg`という`pkg`を付け加えたディレクトリ配下で管理する必要があります。  
このルールに違反した場合は以下の警告が表示されます。

```
Package 'ghsearch' has an incorrect structure. It should contain a single directory hierarchy for source files, named 'ghsearchpkg', but file 'github.nim' is in a directory named 'clients' instead. This will be an error in the future.
```
{{</alert>}}

```nim
import httpclient
import json
import algorithm
import strformat

type Sort* = enum
  stars,
  forks,
  updated,

type
  Owner* = object
    id*: int
    login*: string
  Repository* = object
    id*: int
    name*: string
    owner*: Owner
    stargazers_count*: int
  GitHubRepository* = object
    total_count*: int
    items*: seq[Repository]

proc searchRepositories*(word: string, sort: Sort, order: SortOrder): GitHubRepository =
  let
    qQuery: string = word
    qSort: string = $sort
    qOrder: string = if order == SortOrder.Ascending: "asc" else: "desc"
  let
    url = fmt"https://api.github.com/search/repositories?q={qQuery}&sort={qSort}&order={qOrder}"
    content: string = newHttpClient().getContent(url)
  result = to(parseJson(content), GitHubRepository)
```

外部からimportさせる(exportする)対象には`*`を付ける必要があります。  
これを付け忘れると`undeclared xxx`エラーでコンパイルエラーになります。

{{<alert "warning">}}
typeそのものに`*`を付けても、そのフィールドはexportされません。  
exportが必要なフィールドにも忘れずに`*`を付けましょう。
{{</alert>}}


### 動作確認

実行してみます。まずは`--help`を付けて。

```
$ nim c -d:ssl -r src/ghsearch.nim --help
.
.
Usage:
  ghsearch <repository> [--sort=<sort>] [-r | --reverse]

Options:
  <repository>      Search repository
  --sort=<sort>     Sort by stars/forks/updated [default: stars]
  -r --reverse      Sort by asc
```

スターの数が多い順に5件検索してみます。  
`--sort`のデフォルトが`stars`なので指定しなくても結果は同じです。

```
$ nim c -d:ssl -r src/ghsearch.nim nim --sort stars | head -5
.
.
[✪ 6405 ] jverkoey/nimbus
[✪ 4789 ] nim-lang/Nim
[✪ 2755 ] Quick/Nimble
[✪ 728  ] netease-im/NIM_iOS_UIKit
[✪ 561  ] dom96/jester
```

最後に最近更新されていないものを5件取得してみます。

```
$ nim c -d:ssl -r src/ghsearch.nim nim --sort updated -r | head -5
.
.
[✪ 2    ] jonuts/nimrod
[✪ 2    ] johnbintz/comicpress-nimble
[✪ 3    ] ahbishop/NimbusNagiosMonitoring
[✪ 1    ] scottdavis/nimblize-examples
[✪ 1    ] raviprakash/Nimko
```


リリース物を作成する
--------------------

最後にリリース用の実行バイナリを作成しましょう。  
シングルバイナリはNimが持つ大きな魅力の1つです。

せっかくnimbleを使っているので、nimbleコマンド経由で実行してみます。


### nimコマンドの実行オプションを指定する

`-d:ssl`オプションを指定しないとhttpsのリクエストでエラーになるため、`src/ghsearch.nim.cfg`ファイルを作成します。  
内容は以下1行です。

```
-d:ssl
```

これでnimbleがnimコマンドを実行する時、上記オプションが指定されるようになります。

{{<alert "warning">}}
[公式](https://github.com/nim-lang/nimble#troubleshooting)に記載されている方法に従ったつもりですが、英語の解釈にあまり自信がありません...  
間違っている場合はご指摘いただけると助かります..
{{</alert>}}


### リリースビルド

installコマンドを実行するだけです。

```
$ nimble install
```

以下2つの場所にバイナリが作成されました。

* `./ghsearch`
* `/home/vagrant/.nimble/bin/ghsearch` -> `/home/vagrant/.nimble/pkgs/ghsearch-0.1.0/ghsearch`

バイナリサイズは420kです。シングルバイナリにしてはコンパクトですね。

{{<alert "success">}}
`--opt:size`オプションを付けてビルドすると305kまでサイズを削減できました。

```
$ nim -d:ssl -d:release --opt:size c src/ghsearch.nim
```
{{</alert>}}


### 動作確認

最後なのでGIFで!!

{{<himg "https://dl.dropboxusercontent.com/s/w8pkles5hbo52h3/20180422_1.gif">}}


総括
----

Nimを使ってGitHubのリポジトリを検索するツールを作ってみました。

本ソースをメンテするつもりはありませんので、ソースコードや成果物をGitHubに展開する予定はありません。  
その代わり、今Pythonで作成中のSlackegoをNimで作ってみようと思います。

{{<summary "https://github.com/tadashi-aikawa/slackego">}}

仕事でもNimを使用する許可が下りましたので、PythonからNimに主戦場を移していくつもりです :smile:


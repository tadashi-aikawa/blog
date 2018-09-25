---
title: "Go言語でGitの構成管理CLIを作成してみた"
slug: go-git-structual-cli-create
date: 2018-09-24T01:52:45+09:00
thumbnailImage: https://images.pexels.com/photos/634613/pexels-photo-634613.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260
categories:
  - engineering
tags:
  - golang
  - git
  - github
  - bitbucket
---

Go言語でGitの構成管理を手助けするCLIを作ってみました。

<!--more-->

<img src="https://images.pexels.com/photos/634613/pexels-photo-634613.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"/>

<!--toc-->


経緯
----

作成の動機は**Go言語スキルをアップしたかった**からです。


### Go言語を業務で

最近、業務でGo言語を導入するチャンスがあったので導入を進めています。  
Go言語が持つ以下の特徴がプロジェクトにマッチしそうなためです。

* 仕様が少なく泥臭い (良くも悪くも)
* 教育コストが低い
* パフォーマンスが良い
* シングルバイナリで環境にほとんど依存しない
* Googleが開発しており実績も十分


### 習得の近道

本やWebで真面目に勉強するのが王道です.. が私にとってそれはあまり効率良くありません。  
まず動くモノ、使えるモノを作る方が身になると考えています。

一通り作った後に勉強することにより吸収の度合いは数倍以上になると思っています。  
ああ..勿論その後にリファクタリングしてくださいね。


作ったモノ
----------

gowlというツールを作りました。

{{<summary "https://github.com/tadashi-aikawa/gowl">}}


### どういうツール?

GitHubやBitbucketと軽く連携しつつ、ローカルのリポジトリ構成を管理するツールです。  
具体的には以下の様な機能があります。

* リポジトリの取得
* リポジトリの編集
* リポジトリのWebサイト表示
* 取得したリポジトリ一覧の表示

対話型のシェルを使い、リポジトリの管理場所を意識せずに上記を実現させます。

![](https://raw.githubusercontent.com/tadashi-aikawa/gowl/master/demo.gif)

LinuxだけではなくWindowsでも動きます。さすがGo言語!!  
今の業務環境はほぼWindowsであるため欠かせないポイントです :relaxed:

お試しいただける場合は[Install](https://tadashi-aikawa@github.com/tadashi-aikawa/gowl#install)の項をご覧下さい。


### 影響を受けたツール

以下ツールの影響を受けています。  
車輪の再発明かもしれませんが目的がスキルアップなので問題ありません。

* [ghq](https://github.com/motemen/ghq)
* [fzf](https://github.com/junegunn/fzf)
* [hub](https://hub.github.com/)


開発環境
--------

ここからは開発側の話に入ります。


### IDE

まずIDEですが、VSCodeを使っています。

VSCodeを選んだ理由は以下の記事をご覧下さい。

{{<summary "https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/">}}


### 構成管理

構成管理にはdepという依存関係管理ツールを使っています。  
Pythonでいう[Pipenv]のようなものです。

[Pipenv]: https://pipenv.readthedocs.io/en/latest/

{{<summary "https://golang.github.io/dep/">}}

Go言語1.11から導入されたmodulesを使わない理由は、まだ不安定だからです。  
安定してきたら乗り換えると思います。公式ですからね。

depを使えば`dep ensure`と実行するだけでプロジェクト特有の環境を構築できます。  
依存関係の追加は`dep ensure --add ...`です。


レシピとメモ
------------

レシピのような形で学んだ事を簡潔にまとめてみました。  
丁寧な説明ではなくメモに近いです。


### GitHub APIを利用する

go-githubというライブラリを使いました。

{{<summary "https://github.com/google/go-github">}}

{{<file "depコマンド">}}
```
$ dep ensure --add github.com/google/go-github/github
```
{{</file>}}


{{<warn "go-githubを追加できない...">}}
指定が`go-github/github`ではなく`go-github`になっていないかを確認してください。

* OK: `dep ensure --add github.com/google/go-github/github`
* NG: `dep ensure --add github.com/google/go-github`
{{</warn>}}


### OAUth2認証を利用する

GitHub APIを使用する際にOAuth2認証をするため、以下のライブラリを使用しています。

{{<summary "https://github.com/golang/oauth2">}}

{{<file "depコマンド">}}
```
$ dep ensure --add golang.org/x/oauth2
```
{{</file>}}


### tomlファイルから設定を読み込む

tokenをはじめとした各種設定をtomlで読み込むため、以下のライブラリを使用しています。

{{<summary "https://github.com/BurntSushi/toml">}}

{{<file "depコマンド">}}
```
$ dep ensure --add github.com/BurntSushi/toml
```
{{</file>}}

ファイルから読み込むために`toml.DecodeFile`を使いました。

{{<file "config.go">}}
```go
package main

import (
    "path/filepath"

    "github.com/BurntSushi/toml"
    homedir "github.com/mitchellh/go-homedir"
    "github.com/pkg/errors"
)

// Service is information of Github, Bitbucket, and so on.
type Service struct {
    Token    *string
    UserName *string
    Password *string
    BaseURL  *string
    Prefix   *string
}

// Config configuration
type Config struct {
    Editors         map[string]string
    Browser         string
    Root            string
    GitHub          Service
    BitbucketServer Service
}

// CreateConfig creates configurations from .gowlconfig(toml)
func CreateConfig() (Config, error) {
    home, err := homedir.Dir()
    if err != nil {
        return Config{}, errors.Wrap(err, "Home directory is not found.")
    }

    configPath := filepath.Join(home, ".gowlconfig")

    var conf Config
    if _, err := toml.DecodeFile(configPath, &conf); err != nil {
        return Config{}, err
    }

    return conf, nil
}
```
{{</file>}}


### API結果のjsonを構造体に変換する

GitHub以外にもBitbucket Serverに対応させる必要がありました。  
しかし、GitHubのように著名なライブラリが無かったためClientを自作しました。  
その際、できるだけ楽にjsonを構造体として扱う方法を調べてみました。

{{<why "なぜBitbucket Serverに対応させる必要があったのか?">}}
職場でBitbucket Serverを使用しており、仕事でも使用したかったからです。
{{</why>}}

#### jsonから構造体定義を作成する

jsonと睨めっこして構造体定義をするほど暇ではありません。  
楽をする方法をいくつか紹介します。

##### JSON-to-Go

一番簡単な方法で、JSON-to-GOというサイトを使います。  
サイトを開いてjsonを左側に貼り付けてみて下さい。

{{<summary "https://mholt.github.io/json-to-go/">}}

右に定義が出現しましたね！ 素晴らしい！

##### Paste JSON as Code

VS Codeを使っているならオススメです。  
先日の記事で紹介しましたのでそちらをご覧下さい。

{{<refer "VSCodeをVimmerが満足できる設定にしてみた" "https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/#paste-json-as-code">}}


上記にある通り、quicktypeを直接利用してもOKですね。


#### jsonを構造体に変換する

変換は簡単です。  
httpクライアントから取得した結果(res)のBodyを取り出し、デコード関数に構造体インスタンスを渡すだけです。


```go
import (
    "encoding/json"
    "net/http"
)

// ....

res, err := client.Get(url)
if err != nil {
    panic(err)
}
defer res.Body.Close()

var r BitbucketRepositoryResponse
json.NewDecoder(res.Body).Decode(&r)
```

BitbucketRepositoryResponseは先ほどjsonから作成した構造体です。  
その定義は例えば以下のようになります。

```go
// BitbucketRepositoryResponse is struct of a API response
type BitbucketRepositoryResponse struct {
    Size       int64                 `json:"size"`
    Limit      int64                 `json:"limit"`
    IsLastPage bool                  `json:"isLastPage"`
    Values     []BitbucketRepository `json:"values"`
    Start      int64                 `json:"start"`
}
```

タグにjsonのプロパティを指定すると、構造体のフィールドに紐付けることができます。


### Basic認証を利用する

Bitbucket Serverとの認証にはBasic認証を使う必要があります。

`http.Get`を直接呼び出さず、作成したリクエストに対してBasic認証情報をセットしてやるだけです。

```go
req, err := http.NewRequest("GET", url, nil)
if err != nil {
    panic(err)
}

req.SetBasicAuth(username, password)

client := &http.Client{}
res, err := client.Do(req)
```


### コマンドライン引数を渡す

CLIツールなので当然引数が必要です。  
[以前紹介したflagモジュール]ではなくdocoptを使います。

[以前紹介したflagモジュール]: https://blog.mamansoft.net/2018/08/27/golang-third-challenge/#%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%83%A9%E3%82%A4%E3%83%B3%E5%BC%95%E6%95%B0

{{<summary "https://github.com/docopt/docopt.go">}}

docoptを使うと`gowl`の引数取り扱い部分を以下のように分離できます。

{{<file "args.go">}}
```go
package main

import (
    "github.com/docopt/docopt-go"
    "github.com/pkg/errors"
)

const version = "0.2.0-alpha"
const usage = `Gowl.

Usage:
  gowl get [-f | --force] [-r | --recursive] [-s | --shallow] [-B | --bitbucket-server]
  gowl edit [-e=<editor> | --editor=<editor>]
  gowl web
  gowl list
  gowl -h | --help
  gowl --version

Options:
  -e --editor=<editor>        Use editor [default: default]
  -f --force                  Force remove and reclone if exists
  -r --recursive              Clone recursively
  -s --shallow                Use shallow clone
  -B --bitbucket-server       Use Bitbucket Server
  -h --help                   Show this screen.
  --version                   Show version.
  `

// Args created by CLI args
type Args struct {
    CmdGet  bool `docopt:"get"`
    CmdEdit bool `docopt:"edit"`
    CmdWeb  bool `docopt:"web"`
    CmdList bool `docopt:"list"`

    Editor          string `docopt:"--editor"`
    Force           bool   `docopt:"--force"`
    Recursive       bool   `docopt:"--recursive"`
    Shallow         bool   `docopt:"--shallow"`
    BitbucketServer bool   `docopt:"--bitbucket-server"`
}

// CreateArgs creates Args
func CreateArgs(usage string, argv []string, version string) (Args, error) {
    parser := &docopt.Parser{
        HelpHandler:  docopt.PrintHelpOnly,
        OptionsFirst: false,
    }

    opts, err := parser.ParseArgs(usage, argv, version)
    if err != nil {
        return Args{}, errors.Wrap(err, "Fail to parse arguments.")
    }

    var args Args
    opts.Bind(&args)

    return args, nil
}
```
{{</file>}}

Usageのように指定して実行すると、その内容がArgsに取り込まれます。  
これを別のファイル(`main.go`など)から以下のように呼び出すわけです。

```go
args, err := CreateArgs(usage, os.Args[1:], version)
if err != nil {
    log.Fatal(errors.Wrap(err, "Fail to create arguments."))
}
```

{{<file "depコマンド">}}
```
$ dep ensure --add github.com/docopt/docopt-go@master
```
{{</file>}}

{{<why "なぜflagではなくdocoptを使うのか?">}}
複雑な組み合わせを容易にバリデーションできるからです。

コマンドが複雑になればなるほど、if文による制御では考慮漏れが生じます。  
しかし、docoptはUsageに一致しないパターンをエラーと判定できるため処理をシンプルに保つことができます。
{{</why>}}


{{<error "&docopt.Parserが解決しない">}}
以下のように依存関係の追加コマンドから`@master`が抜けている可能性があります。

```
$ dep ensure --add github.com/docopt/docopt-go
```

上記でインストールされるのは執筆時点でv0.6.2です。  
しかし、GitHubのmasterは更に先を行っているため`&docopt.Parser`などのIFが存在しません。

masterブランチを指定して追加してみましょう。
{{</error>}}


### 対話型の実現

初めは非対話式にしていましたが、キーワード検索が予期した結果になるとは限りません。  
また、検索結果を表示した後に改めて指定するのも面倒です。

`survey.v1`というライブラリを使って対話型を実現します。

{{<summary "https://gopkg.in/AlecAivazis/survey.v1">}}

他の対話型CLIを実現するライブラリも検討しましたが以下の理由で断念しました。

* Windowsだと表示がおかしくなる
* 上手く動かない
* 多機能すぎて実装のコスパが悪い

{{<file "depコマンド">}}
```
$ dep ensure --add gopkg.in/AlecAivazis/survey.v1
```
{{</file>}}


### 外部コマンドを実行する

CLIでは実際にgitなどのコマンドを実行します。  
`exec.Command`を使用しますが、以下の様な関数を定義して使っています。

```go
func execCommand(workdir *string, name string, arg ...string) error {
    cmd := exec.Command(name, arg...)
    if workdir != nil {
        cmd.Dir = *workdir
    }
    cmd.Stdin = os.Stdin
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    return cmd.Run()
}
```

以下は呼び出しの一例です。

```go
if err := execCommand(nil, "git", "commit", "-m", "hogehoge"); err != nil {
    return errors.Wrap(err, "Fail to clone "+url)
}
```

{{<warn "execCommandの引数にスペースが含まれると正しく動作しない...">}}
トークンの切れ目を表す場合は別の引数を指定して下さい。  
引数`arg ...string`は1つ1つの要素がコマンドと見なされます。

| ソース                                   | 解釈されるコマンド |
|------------------------------------------|--------------------|
| execCommand(ni., "git", "clone hoge")    | `git "clone hoge"` |
| execCommand(ni., "git", "clone", "hoge") | `git clone hoge`   |

{{</warn>}}

{{<warn "cdコマンドを実行してもgowl終了後にカレントディレクトリが移動していない...">}}
Go言語で呼び出し元ターミナルのカレントディレクトリを変更することはできません。  
なぜならgowlはターミナルから呼び出されたプロセスであり、ターミナルは親プロセスにあたるからです。

{{<summary "https://stackoverflow.com/questions/46028707/how-to-change-the-current-dir-in-go">}}
{{</warn>}}

{{<warn "コマンドの出力結果や入力待ちが表示されない場合は...">}}
コマンドの標準入出力にOSの入出力が割り当てられていることを確認してください。  
たとえば以下のような記述があるかどうかです。

```go
cmd.Stdin = os.Stdin
cmd.Stdout = os.Stdout
cmd.Stderr = os.Stderr
```
{{</warn>}}


### スピナーを表示する

最後に..GitHubと通信中は少し待ち時間が発生するので退屈しない演出を入れてみました。  
スピナーを表示するライブラリを使用します。

{{<summary "https://github.com/briandowns/spinner">}}

{{<file "depコマンド">}}
```
$ dep ensure --add github.com/briandowns/spinner
```
{{</file>}}

43種類も選べるのでテンション上がりますが、Windowsでもちゃんと表示されるモノを選ぶ必要があります。  
gowlでは35番を使用しています。

```go
s := spinner.New(spinner.CharSets[35], 100*time.Millisecond)
s.Color("fgHiGreen")
s.Start()
repos, err := handler.SearchRepositories(word)
s.Stop()
```


ハマッたところ
--------------

その他ハマッたところを2つほどご紹介します。

### WindowsとLinuxのセパレータが混ざる

`filepath.Join`を使用しましょう。  
`path.Join`を使用していたため発生した問題でした。


### Interfaceの実装を認識してくれない

pointer receiverを使用している場合はInterfaceに値ではなく参照を返す必要があります。  
ちょっと古いですが以下の記事が分かりやすいです。

{{<summary "http://otiai10.hatenablog.com/entry/2014/05/27/223556">}}

gowlでの実装例を一部抜き出してみました。

{{<file "pointer receiverとInterfaceを使う例">}}
```go
type IHandler interface {
    SearchRepositories(word string) ([]Repository, error)
    GetPrefix() string
}

type BitbucketServerHandler struct {
    client *BitbucketClient
    prefix string
}

// pointer receiverを使用している
func (h *BitbucketServerHandler) GetPrefix() string {
    return h.prefix
}

// pointer receiverを使用している
func (h *BitbucketServerHandler) SearchRepositories(word string) ([]Repository, error) {
    res, err := h.client.searchRepositories(word)
    if err != nil {
        return nil, errors.Wrap(err, "Fail to search repositories.")
    }

    var repos []Repository
    for _, bsrepo := range res.Values {
        var r Repository
        repos = append(repos, *r.fromBitbucketServer(&bsrepo))
    }

    return repos, nil
}


func NewBitbucketServerHandler(config Config) IHandler {
    // BitbucketServerHandlerはpointer reciverを使用しているので参照を返す
    return &BitbucketServerHandler{
        client: createBitbucketClient(*config.BitbucketServer.UserName, *config.BitbucketServer.Password, *config.BitbucketServer.BaseURL),
        prefix: *config.BitbucketServer.Prefix,
    }
}
```
{{</file>}}

{{<file "上記の呼び出し元">}}
```go
var handler IHandler
if args.BitbucketServer {
    handler = NewBitbucketServerHandler(config)
} else {
    handler = NewGithubHandler(config)
}
```
{{</file>}}



総括
----

Go言語でGitの構成管理を手助けするCLIを作り、学んだ事をまとめてみました。

呼び出し元シェルのワーキングディレクトリを変更出来ないのは残念ですが、改修しやすい設計にすることができたので今後も機能追加していこうと考えています :smile:


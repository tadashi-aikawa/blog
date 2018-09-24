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

{{<alert "info">}}
TODO
{{</alert>}}


### Basic認証を利用する

{{<alert "info">}}
TODO
{{</alert>}}


### コマンドライン引数を渡す

{{<alert "info">}}
TODO
{{</alert>}}


### 対話型の実現

{{<alert "info">}}
TODO
{{</alert>}}


### 外部コマンドを実行する

{{<alert "info">}}
TODO
{{</alert>}}


### スピナーを表示する

{{<alert "info">}}
TODO
{{</alert>}}


ハマッたところ
--------------

{{<alert "info">}}
TODO
{{</alert>}}


総括
----

{{<alert "info">}}
TODO
{{</alert>}}



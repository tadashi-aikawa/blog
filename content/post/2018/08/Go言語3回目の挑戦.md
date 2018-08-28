---
title: "Go言語3回目の挑戦"
slug: golang-third-challenge
date: 2018-08-27T06:18:23+09:00
thumbnailImage: https://cdn.svgporn.com/logos/gopher.svg
categories:
  - engineering
tags:
  - golang
  - vim
---

Go言語の開発環境を作成して簡単なスクリプトを書いてみました。  
過去2回ほどGo言語にチャレンジして挫折したので3回目のチャレンジになります。

<!--more-->

<img src="https://cdn.svgporn.com/logos/gopher.svg"/>

<!--toc-->


はじめに
--------

以前に以下の記事でGo言語をCLIツール作成言語の選択肢から外した経緯があります。

{{<summary "https://blog.mamansoft.net/2018/08/06/rust-clitool-create/#nim%E3%82%84golang%E3%81%AB%E3%81%AF%E4%B8%8D%E6%BA%80%E3%81%8C%E3%81%82%E3%82%8B">}}

そう..あまりにも言語に面白みがなく泥臭かったためRustを選んだのです。  
しかし、そんなGo言語を見る目が変わる出来事がありました。

[vim-go]との出会いです。  
Go言語を書くためにVimを使うのではなく、Vimで開発するためにGoを使うのです！

Vimの話は開発環境構築のセクションで後ほど紹介します。


インストール
------------

まずはGo言語をインストールします。  
公式サイトからバイナリがダウンロードできます。

{{<summary "https://golang.org/">}}

Ansibleを使っている場合は以下のようにplaybookを作成します。

```ruby
- name: Download golang
  get_url:
    url: https://storage.googleapis.com/golang/go{{ version }}.linux-amd64.tar.gz
    dest: /tmp/go.tar-{{ version }}.gz

- name: Extract go.tar.gz
  unarchive:
    src: /tmp/go.tar-{{ version }}.gz
    dest: /usr/local
```

versionは1.10.3にしました。

{{<alert "success">}}
執筆時点での最新はversion 1.11でした。  
ただ、リリース直後のせいか[vim-go]が上手く動作しなかったため1つ前のバージョンをインストールしました。
{{</alert>}}


### 環境変数の設定

上記に記載していませんが別途`$GOPATH`と`$PATH`を設定する必要があります。  
fishの場合は`config.fish`に記載しておきます。

```sh
set -x GOPATH "$HOME/.go"
export PATH= "$PATH:/usr/local/go/bin:$GOPATH/bin"
```


### 動作確認

バージョンが表示されれば問題ありません。

```
$ go version
go version go1.10.3 linux/amd64
```


開発環境構築
------------

Vimをベースとして開発環境の準備をします。  
以下のプラグインをそれぞれインストールします。

* [vim-go]
* [Deoplete]
* [UltiSnips]

### なぜVimを使うのか

いくつか理由がありますが、半分くらいは好みの問題になります。

* 起動が速い
* Vimmerであれば操作も速くテンションが上がる
* Go言語は使用がシンプルなのでIDEを使うメリットが多言語ほど大きくない


### vim-go

VimでGo言語を開発するためのプラグインです。  
読むだけなら[vim-go]だけで十分だと思います。

{{<summary "https://github.com/fatih/vim-go">}}

`dein.toml`の設定です。  
Go言語の場合はインデントがタブであるため、`setl nolist`でタブが目立たないようにしています。

```toml
[[plugins]]
# golang
repo = 'fatih/vim-go'
on_ft = ['go']
hook_add = '''
autocmd FileType go setl nolist
```

{{<alert "success">}}
`dein_lazy.toml`に記載した場合は`main.go`がテンプレートから作成されませんでした。
{{</alert>}}

#### ツールのインストール

[vim-go]インストール後にVimを開き、`:GoUpdateBinaries`を実行してツールをインストールします。  
ツールには例えば以下の様なものがあります。

* guru (静的解析)
* golint (構文解析)
* dlv (デバッガ)

これらがインストールされていないと[vim-go]の機能をフル活用することができません。

{{<alert "info">}}
1.11から追加されたGo modulesの機能に対するIssueが作成されていますが実現は厳しいかもしれません...  
[Support Go modules · Issue #1906 · fatih/vim-go](https://github.com/fatih/vim-go/issues/1906)
{{</alert>}}


### UltiSnips

開発速度を爆速にするためのスニペットを利用できるプラグインです。

{{<summary "https://github.com/SirVer/ultisnips">}}

以前は[Neosnippet]を使っていましたがスターの数が多かったので乗り換えてみました。  
[Deoplete]との連携を考えると[Neosnippet]の方が良かったかもしれません..

`dein.toml`の設定は以下です。

```toml
[[plugins]]
repo = 'SirVer/ultisnips'
hook_add = '''
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim-snippets/UltiSnips', 'UltiSnips']

" snippet 次へ
let g:UltiSnipsJumpForwardTrigger="<tab>"
" snippet 前へ
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
'''

[[plugins]]
repo = 'honza/vim-snippets'
```


### Deoplete

最後は補完候補を助けるプラグインです。  
Vimの標準補完に慣れていると戸惑うかもしれませんが、とても賢い補完をしてくれます。

{{<summary "https://github.com/Shougo/deoplete.nvim">}}

`dein.toml`の設定は以下です。  
Deopleteは2つのプラグインを依存関係に持つため計3つをインストールする必要があります。

```toml
[[plugins]]
repo = 'roxma/nvim-yarp'

[[plugins]]
repo = 'roxma/vim-hug-neovim-rpc'

[[plugins]]
repo = 'Shougo/deoplete.nvim'
depends = ['nvim-yarp', 'vim-hug-neovim-rpc']
hook_add = '''
let g:python3_host_prog = '/usr/bin/python3'
let g:deoplete#enable_at_startup = 0
let g:deoplete#auto_complete_delay = 0

nnoremap <Space>a :call deoplete#enable()<CR>
'''
```

`<Space>a`を押さないとDeopleteは有効にならないようにしています。  
これにはパフォーマンス上の理由があります。

はじめは起動時に有効になるよう`deoplete#enable_at_startup = 1`を設定していました。  
しかし、起動時に0.5～1秒ほどラグを感じるため設定を解除しました。

次に挿入モードに入った時、初めて文字を入力した時に有効になるよう設定してみました。  
これも引っかかりのような違和感を感じたため解除しています。


Hello World
-----------

構築した開発環境でHello Worldを出力するプログラムを書いてみました。

{{<himg "https://dl.dropboxusercontent.com/s/6bj192s7bqf6sno/20180827_1.gif">}}

記載から実行までわずか10秒程度です。  
`main.go`を作成すると[vim-go]が自動でテンプレをベースにしてくれます。  
こういうところにGoとVimの哲学を感じますね :smile:

ターミナルから実行する場合は`go run`を使います。

```
$ go run main.go
Hello World
```


コマンドライン引数
------------------

最後は標準モジュールでコマンド引数を処理する方法を紹介します。

{{<summary "https://golang.org/pkg/flag/">}}

`var value = flag.型(フラグ名, デフォルト値, 説明)`と書いてParseをするだけです。  

```go
package main

import (
	"flag"
	"fmt"
)

func main() {
	var id = flag.Int("id", 777, "Your ID")
	var name = flag.String("name", "hoge", "Your Name")

	flag.Parse()

	fmt.Printf("%d: %s\n", *id, *name)
}
```

使用するときに`*`を付けるのが気持ち悪い場合は以下のように書くこともできます。  
変数の宣言とflagの適応を別にしなければいけないので一長一短だとは思います。

```go
package main

import (
	"flag"
	"fmt"
)

func main() {
	var (
		id   int
		name string
	)

	flag.IntVar(&id, "id", 777, "Your ID")
	flag.StringVar(&name, "name", "hoge", "Your Name")

	flag.Parse()

	fmt.Printf("%d: %s\n", id, name)
}
```

Vimからは以下の様に実行することができます。

```
:GoRun % --id 7 --name yuta
```

コマンドプロンプトだと以下の様になります。どれでもOK。

```
$ go run main.go --id 7 --name yuta
7: yuta
$ go run main.go -id 7 -name yuta
7: yuta
$ go run main.go -id=7 -name=yuta
7: yuta
```

`--help`でUsageを表示することができます。

```
$ go run main.go --help                                                                                                 194ms  Tue 28 Aug 201
Usage of /tmp/go-build669378413/b001/exe/main:
  -id int
        Your ID (default 777)
  -name string
        Your Name (default "hoge")
exit status 2
```


総括
----

Go言語の開発環境を作成して簡単なスクリプトを書いてみました。

次はもう少し本格的なもの..GitHubにアクセスして情報を取得するCLIを作ってみようと思います。



[vim-go]: http://https://github.com/fatih/vim-go
[Deoplete]: https://github.com/Shougo/deoplete.nvim
[UltiSnips]: https://github.com/SirVer/ultisnips
[Neosnippet]: https://github.com/Shougo/neosnippet.vim

---
title: "Vimプラグインの見直し"
slug: vim-plugin-refactoring
date: 2018-08-13T02:44:14+09:00
thumbnailImage: https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940
categories:
  - engineering
tags:
  - vim
---

Vimを本格的に使い始めて半年強が経過しました。  
プラグインや`.vimrc`が散らかってきたので良い機会だと思って掃除をしてみました。

よく使うプラグインはGIFを交えて紹介したいと思います。

<!--more-->

<img src="https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"/>

<!--toc-->


今後も使用するプラグイン
------------------------

まずは以前から利用しており引き続き継続して使用するプラグインを紹介します。


### easymotion/vim-easymotion

{{<summary "https://github.com/easymotion/vim-easymotion">}}

先頭の数文字を入力すると候補が表示されてジャンプできるプラグイン。  
Migemoを有効にして日本語も候補にしたり、Windowを越えて移動できるので便利です。

{{<himg "https://dl.dropboxusercontent.com/s/hro6lz9ur70gjpm/20180813_1.gif">}}

`s` => `om` => `a`


### editorconfig/editorconfig-vim

{{<summary "https://github.com/editorconfig/editorconfig-vim">}}

`.editorconfig`を読み込んで反映するプラグインです。  
EditorConfigについては下記をご覧下さい。

{{<summary "https://editorconfig.org/">}}


### tpope/vim-surround

{{<summary "https://github.com/tpope/vim-surround">}}

カッコやクォート、タグなどの追加/削除/置換を行うプラグインです。  
IDEAやVS CodeのVimプラグインにも搭載されているほどの人気です。

{{<himg "https://dl.dropboxusercontent.com/s/kd5alsxpxaka616/20180813_2.gif">}}

`ds]` => `cs(]`


### tpope/vim-repeat

{{<summary "https://github.com/tpope/vim-repeat">}}

`.`コマンドで繰り返すことができない一部プラグインの挙動を繰り返し可能にするプラグインです。  
`tpope/vim-surround`を繰り返すために使用しています。

{{<himg "https://dl.dropboxusercontent.com/s/e5h3w0o1vu7wn0u/20180813_3.gif">}}

`ysw)` => `j.` => `j.` => `j.`


### tpope/vim-fugitive

{{<summary "https://github.com/tpope/vim-fugitive">}}

Vimから様々なGitの操作を行うことができるプラグインです。  
以下2つの理由だけのために使用しています。

* GBlameコマンド
* ステータスラインにGitのステータスを表示するために必要

{{<himg "https://dl.dropboxusercontent.com/s/70iiq6khtz0dttx/20180813_6.png">}}


### yuttie/comfortable-motion.vim

{{<summary "https://github.com/yuttie/comfortable-motion.vim">}}

スムーズなスクロールを提供するプラグインです。  
動作イメージはGitHubのREADMEをご覧下さい。


### kshenoy/vim-signature

{{<summary "https://github.com/kshenoy/vim-signature">}}

マークを可視化したり色々な機能を提供するプラグインです。  
主にマークの可視化に使用しています。

{{<himg "https://dl.dropboxusercontent.com/s/sio7cjhda3kmi02/20180813_4.gif">}}


### w0rp/ale

{{<summary "https://github.com/w0rp/ale">}}

非同期にLinterを実行し結果を表示するプラグインです。  
Language Serverと連携することもできます。

{{<himg "https://dl.dropboxusercontent.com/s/kk9bm5vv2rrkbth/20180813_5.gif">}}

上記の例ではbash-language-serverと連携の結果を表示しています。  
ALEに関する`.vimrc`の記載は以下をご覧下さい。

<details>
  <summary>関連する`.vimrc`の設定</summary>
```vim
" エラー行に表示するマーク
let g:ale_sign_error = '☠'
let g:ale_sign_warning = '⚠'
" エラー行にカーソルをあわせた際に表示されるメッセージフォーマット
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" エラー表示の列を常時表示
let g:ale_sign_column_always = 1

" ファイルを開いたときにlint実行
let g:ale_lint_on_enter = 1
" ファイルを保存したときにlint実行
let g:ale_lint_on_save = 1
" 変更がある度に更新されるとチカチカするのでOFF
let g:ale_lint_on_text_changed = 'never'

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
" ウィンドウサイズ
let g:ale_list_window_size = 5

```
</details>


### crusoexia/vim-monokai

{{<summary "https://github.com/crusoexia/vim-monokai">}}

私が設定しているVimのテーマです。  
monokaiは本記事のスクリーンショットのような配色で非常にクールです。


### terryma/vim-multiple-cursors

{{<summary "https://github.com/terryma/vim-multiple-cursors">}}

最近のエディタのようにカーソルを分裂させるプラグインです。  
個々の機能はGitHubのREADMEをご覧下さい。

{{<himg "https://dl.dropboxusercontent.com/s/gw0apjv0ebdom5b/20180813_7.gif">}}

`ll` => `vip` => `<C-k>` => `daw` => `<ESC>` => `j` => `vw` => `<C-k><C-k><C-k>` => `ctadashi-aikawa`

以下を頭に入れておくと迷わずに操作できると思います。

* `v`を押さずに起動すると、配下の単語を検索対象としてカーソルを増殖する
* `v`を押した後に起動すると、現在選択中の文字(1文字以上)を対象としてカーソルを増殖する
* 複数行選択した後に起動すると、選択した全ての行にカーソルを増殖する


### mbbill/undotree

{{<summary "https://github.com/mbbill/undotree">}}

変更履歴をツリー表示するプラグインです。  
途中で枝分かれしたツリーを可視化したり、変更箇所がハイライトされるので便利です。

{{<himg "https://dl.dropboxusercontent.com/s/wq7hw1h9pauc5c2/20180813_8.gif">}}


### osyo-manga/vim-over

{{<summary "https://github.com/osyo-manga/vim-over">}}

プレビューしながら一括置換できるプラグインです。
慣れるまで難しい一括置換コマンド..自信を持って実行できます。

{{<himg "https://dl.dropboxusercontent.com/s/6z7orgps2tpdcye/20180813_9.gif">}}

`<Space>//` => `https/ftp<CR>`

基本的にファイル全体を対象とするため、`<Space>//`でそうなるよう以下設定をしています。

```vim
nnoremap <silent> <Space>// :OverCommandLine<CR>%s/
```

### kana/vim-operator-replace

{{<summary "https://github.com/kana/vim-operator-replace">}}

置換のオペレータです。  
素のVim以外を使ったときはこれが使えないのが辛いほど便利です。

ベースとして[kana/vim-operator-user](https://github.com/kana/vim-operator-user)のインストールが必要です。

{{<himg "https://dl.dropboxusercontent.com/s/rvtnyoufqmt4idd/20180813_10.gif">}}

`yi"` => `_i'`

初見だと魔法のように見えるかもしれません。  
ダブルクォーテーションで囲まれた文字列をyankした後、シングルクォーテーションの中にpasteしています。

設定で`_`をキーに割り当てています。

```vim
nmap _ <Plug>(operator-replace)
```

TODO: 続き...

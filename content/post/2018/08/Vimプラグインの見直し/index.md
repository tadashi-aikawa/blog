---
title: "Vimプラグインの見直し"
slug: vim-plugin-refactoring
date: 2018-08-13T02:44:14+09:00
thumbnailImage: images/cover/2018-08-13.jpg
categories:
  - engineering
tags:
  - vim
---

Vimを本格的に使い始めて半年強が経過しました。  
一度プラグインと`.vimrc`を整理したので、継続して使うものを紹介します。

よく使うプラグインはGIFを交えて紹介したいと思います。

<!--more-->

{{<cimg "2018-08-13.jpg">}}

<!--toc-->


easymotion/vim-easymotion
-------------------------

{{<summary "https://github.com/easymotion/vim-easymotion">}}

先頭の数文字を入力すると候補が表示されてジャンプできるプラグイン。  
Migemoを有効にして日本語も候補にしたり、Windowを越えて移動できるので便利です。

{{<himg "resources/20180813_1.gif">}}

`s` => `om` => `a`


editorconfig/editorconfig-vim
-----------------------------

{{<summary "https://github.com/editorconfig/editorconfig-vim">}}

`.editorconfig`を読み込んで反映するプラグインです。  
EditorConfigについては下記をご覧下さい。

{{<summary "https://editorconfig.org/">}}


tpope/vim-surround
------------------

{{<summary "https://github.com/tpope/vim-surround">}}

カッコやクォート、タグなどの追加/削除/置換を行うプラグインです。  
IDEAやVS CodeのVimプラグインにも搭載されているほどの人気です。

{{<himg "resources/20180813_2.gif">}}

`ds]` => `cs(]`


tpope/vim-repeat
----------------

{{<summary "https://github.com/tpope/vim-repeat">}}

`.`コマンドで繰り返すことができない一部プラグインの挙動を繰り返し可能にするプラグインです。  
`tpope/vim-surround`を繰り返すために使用しています。

{{<himg "resources/20180813_3.gif">}}

`ysw)` => `j.` => `j.` => `j.`


tpope/vim-fugitive
------------------

{{<summary "https://github.com/tpope/vim-fugitive">}}

Vimから様々なGitの操作を行うことができるプラグインです。  
以下2つの理由だけのために使用しています。

* GBlameコマンド
* ステータスラインにGitのステータスを表示するために必要

{{<himg "resources/20180813_6.png">}}


yuttie/comfortable-motion.vim
-----------------------------

{{<summary "https://github.com/yuttie/comfortable-motion.vim">}}

スムーズなスクロールを提供するプラグインです。  
動作イメージはGitHubのREADMEをご覧下さい。


kshenoy/vim-signature
---------------------

{{<summary "https://github.com/kshenoy/vim-signature">}}

マークを可視化したり色々な機能を提供するプラグインです。  
主にマークの可視化に使用しています。

{{<himg "resources/20180813_4.gif">}}


crusoexia/vim-monokai
---------------------

{{<summary "https://github.com/crusoexia/vim-monokai">}}

私が設定しているVimのテーマです。  
monokaiは本記事のスクリーンショットのような配色で非常にクールです。


terryma/vim-multiple-cursors
----------------------------

{{<summary "https://github.com/terryma/vim-multiple-cursors">}}

最近のエディタのようにカーソルを分裂させるプラグインです。  
個々の機能はGitHubのREADMEをご覧下さい。

{{<himg "resources/20180813_7.gif">}}

`ll` => `vip` => `<C-k>` => `daw` => `<ESC>` => `j` => `vw` => `<C-k><C-k><C-k>` => `ctadashi-aikawa`

以下を頭に入れておくと迷わずに操作できると思います。

* `v`を押さずに起動すると、配下の単語を検索対象としてカーソルを増殖する
* `v`を押した後に起動すると、現在選択中の文字(1文字以上)を対象としてカーソルを増殖する
* 複数行選択した後に起動すると、選択した全ての行にカーソルを増殖する


mbbill/undotree
---------------

{{<summary "https://github.com/mbbill/undotree">}}

変更履歴をツリー表示するプラグインです。  
途中で枝分かれしたツリーを可視化したり、変更箇所がハイライトされるので便利です。

{{<himg "resources/20180813_8.gif">}}


osyo-manga/vim-over
-------------------

{{<summary "https://github.com/osyo-manga/vim-over">}}

プレビューしながら一括置換できるプラグインです。
慣れるまで難しい一括置換コマンド..自信を持って実行できます。

{{<himg "resources/20180813_9.gif">}}

`<Space>//` => `https/ftp<CR>`

基本的にファイル全体を対象とするため、`<Space>//`でそうなるよう以下設定をしています。

```vim
nnoremap <silent> <Space>// :OverCommandLine<CR>%s/
```


kana/vim-operator-replace
-------------------------

{{<summary "https://github.com/kana/vim-operator-replace">}}

置換のオペレータです。  
素のVim以外を使ったときはこれが使えないのが辛いほど便利です。

ベースとして[kana/vim-operator-user](https://github.com/kana/vim-operator-user)のインストールが必要です。

{{<himg "resources/20180813_10.gif">}}

`yi"` => `_i'`

初見だと魔法のように見えるかもしれません。  
ダブルクォーテーションで囲まれた文字列をyankした後、シングルクォーテーションの中にpasteしています。

設定で`_`をキーに割り当てています。

```vim
nmap _ <Plug>(operator-replace)
```


scrooloose/nerdtree
-------------------

{{<summary "https://github.com/scrooloose/nerdtree">}}

サイドにディレクトリツリーを表示する定番プラグインです。  
ディレクトリ構造の可視化はVim標準に無い弱点の1つなので、それを補うことができます。


jistr/vim-nerdtree-tabs
-----------------------

{{<summary "https://github.com/jistr/vim-nerdtree-tabs">}}

異なるタブ間でNERDTreeの状態を同期するプラグインです。  
タブを使わない場合は必要ありません。

以下はNEDRTreeおよびNEDRTreeTabsに関する私の設定です。

{{<file ".vimrc">}}

```vim
" [NERDTree] ON/OFF切り替え
nnoremap <silent> <Space>n :<C-u>:NERDTreeTabsToggle<CR>
" [NERDTree] Treeに移動し、カレントファイルをフォーカス
nnoremap <silent> <Space>w :<C-u>:NERDTreeTabsFind<CR>

augroup NERD
    au!
    " タブを全て閉じたらVimを終了する
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
      exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
      exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
    endfunction
    call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
    call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
    call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')

    " ディレクトリを指定したときだけ起動時に表示
    let g:nerdtree_tabs_open_on_console_startup=2
augroup END
```

{{</file>}}


Xuyuanp/nerdtree-git-plugin
---------------------------

{{<summary "https://github.com/Xuyuanp/nerdtree-git-plugin">}}

NERDTreeにGitの変更情報を表示することができます。

{{<himg "resources/20180813_11.gif">}}

変更があったディレクトリやファイルには印がつきます。


airblade/vim-gitgutter
----------------------

{{<summary "https://github.com/airblade/vim-gitgutter">}}

Gitの変更情報をgutter部分に表示することができます。
その他にもハンク単位の移動、Undo、Preview表示など便利な機能が揃っています。

{{<himg "resources/20180813_12.gif">}}

編集: `A2:w` => `jyypp` => `jjdddd`  
移動: `gikgikgik` => `gijgik`  
Preview: `gip`  
Undo `giu`

{{<file ".vimrc">}}

```vim
" [gitgutter] 0.1秒おきに表示を更新する
set updatetime=100

" [vim-gitgutter] 次のハンクへ移動
nmap gij <Plug>GitGutterNextHunk
" [vim-gitgutter] 前のハンクへ移動
nmap gik <Plug>GitGutterPrevHunk
" [vim-gitgutter] ハンクを元に戻す
nmap giu <Plug>GitGutterUndoHunk
" [vim-gitgutter] ハンクをプレビューする
nmap gip <Plug>GitGutterPreviewHunk
```

{{</file>}}


Shougo/unite.vim
----------------

{{<summary "https://github.com/Shougo/unite.vim">}}

様々な検索を提供するプラグインです。  
私は後ほど紹介するShougo/unite-outlineを使用するためだけにインストールしています。


Shougo/unite-outline
--------------------

{{<summary "https://github.com/Shougo/unite-outline">}}

アウトラインを表示/検索することができるプラグインです。  
事前にShougo/unite.vimをインストールする必要があります。

主にMakrdownのアウトラインをサイドに表示するため使用しています。

{{<himg "resources/20180813_13.gif">}}

{{<file ".vimrc">}}

```vim
" [unite-outline] アウトライン
nnoremap <silent> <Space>o :Unite -vertical -winwidth=30 -no-quit outline<CR>
```

{{</file>}}

Markdownのアウトラインを表示するプラグインは他にもいくつか試しましたが、上手くいきませんでした。

* vim-scripts/VOoM
* vimoutliner/vimoutliner
* majutsushi/tagbar + jszakmeister/markdown2ctags


plasticboy/vim-markdown
-----------------------

{{<summary "https://github.com/plasticboy/vim-markdown">}}

MarkdownのSyntaxを初め編集に役立つ機能を提供するプラグインです。  
Syntax以外に、テーブルフォーマット機能を目的として使用しています。

{{<himg "resources/20180813_14.gif">}}

`<Space>@`

テーブルフォーマット機能を有効にするには以下のプラグインをインストールする必要があります。

{{<summary "https://github.com/godlygeek/tabular">}}


kien/ctrlp.vim
--------------

{{<summary "https://github.com/kien/ctrlp.vim">}}

様々な検索を提供するプラグインです。以下の検索をよく行います。

* バッファ一覧
* 最近開いたファイル(MRU)
* プロジェクトルートからのファイル

先に紹介したShougo/unite.vimと機能は似ていますが、ctrlp.vimの方がシンプルで使いやすいです。

{{<himg "resources/20180813_15.gif">}}

`<C-p>` => `Rust` => `↑<CR>` => `<Space>e` => `rust<CR>`

{{<file ".vimrc">}}

```vim
" [ctrlp] node_modules,build,distは無視
let g:ctrlp_custom_ignore = '\v[\/](node_modules|build|dist)$'

" [ctrlp] MRU files
nnoremap <silent> <Space>e :CtrlPMRUFiles<CR>
" [ctrlp] Line
nnoremap <silent> <Space>L :CtrlPLine<CR>
" [ctrlp] Buffer
nnoremap <silent> <Space>t :CtrlPBuffer<CR>
```

{{</file>}}


prabirshrestha/vim-lsp
----------------------

{{<summary "https://github.com/prabirshrestha/vim-lsp">}}

IDEのような各種機能をLanguage Server Protocolを使って実現するプラグインです。  
機能をフルに使うには以下のプラグインもインストールする必要があります。

* [prabirshrestha/async](https://github.com/prabirshrestha/async)
* [prabirshrestha/asyncomplete](https://github.com/prabirshrestha/asyncomplete)
* [prabirshrestha/asyncomplete-lsp](https://github.com/prabirshrestha/asyncomplete-lsp)

IDEや専用プラグインに比べて機能が非実装であることも多いため、言語によって使いわけています。  
私の場合は主にbashで利用し、PythonやRustで参考程度に使っています。

{{<file ".vimrc">}}

```vim
" [lsp] 定義
nmap <silent> <Space>d :LspDefinition<CR>
" [lsp] Hover
nmap <silent> <Space>p :LspHover<CR>
" [lsp] 参照箇所
nmap <silent> <Space>r :LspReferences<CR>

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Pipfile'))},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('bash-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->['bash-language-server', 'start']},
        \ 'whitelist': ['sh'],
        \ })
endif

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif
```

{{</file>}}


w0rp/ale
--------

{{<summary "https://github.com/w0rp/ale">}}

非同期にLinterを実行し結果を表示するプラグインです。  
Language Serverと連携することもできます。

{{<himg "resources/20180813_5.gif">}}

上記の例ではbash-language-serverと連携の結果を表示しています。  

{{<file ".vimrc">}}

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

{{</file>}}


fatih/vim-go
------------

{{<summary "https://github.com/fatih/vim-go">}}

Go言語で開発するためのプラグインです。  
言語仕様がシンプルでどこでも実行できるGoはVimとの相性もバッチリです。

## leafgarland/typescript-vim

{{<summary "https://github.com/leafgarland/typescript-vim">}}

TypeScript用のSyntax Highlighterです。  
TypeScriptの開発はJetBrainsのIDE(WebStormなど)がオススメなので、あくまでサクっとコードを見たい時だけ使用しています。

## posva/vim-vue

{{<summary "https://github.com/posva/vim-vue">}}

Vue用のSyntax Highlighterです。  
TypeScriptと同じく開発はJetBrainsのIDEがオススメです。



---
title: Vimmerを強化するIDEAプラグイン
slug: more-vimmer-intellij-idea-plugin
date: 2020-05-03T15:03:06+09:00
thumbnailImage: images/cover/2020-05-03.jpg
categories:
  - engineering
tags:
  - idea
  - vim
---

Vimmerを強化するためのIntelliJ IDEAプラグインを紹介します。

<!--more-->

{{<cimg "2020-05-03.jpg">}}

<!--toc-->


IdeaVim
-------

Vimの操作をエミュレーションするプラグインです。  

{{<summary "https://plugins.jetbrains.com/plugin/164-ideavim">}}

JetBrains製のIDEならほとんど対応しています。

{{<warn "ここからの内容を過信しないでください">}}
本情報は2020/05/03時点のものです。  
最新の情報は公式ドキュメントで確認してください。
{{<summary "https://github.com/JetBrains/ideavim">}}
{{</warn>}}


### インストール

`Setup`に従って他プラグイン同様にインストールします。

### 設定

`~/.ideavimrc`を作成します。  
`source ~/.vimrc`で`~/.vimrc`を読み込むこともできます。

{{<file "~/.ideavimrc">}}

```vim
" [ 🖥️ Display ]
"-------------------
" 無駄な描画をしない
set lazyredraw
" 再描画の速度が速くなるらしいけど最近の端末では無意味との噂も..
set ttyfast
" 検索語をハイライト
set hlsearch
" コマンドのタイムラグをなくす
set ttimeoutlen=1
" スクロールした時 常に下に表示するバッファ行の数
set scrolloff=5


" [ 🔊 Sound ]
"---------------
" ベル音を鳴らさない
set visualbell


" [ 🔍 Search ]
"----------------
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索時に大文字を含んでいたら大/小を区別
set smartcase
" (設定するとincsearchが無効になるためコメントアウト) 検索時に最後まで行っても最初に戻らない
" set nowrapscan

" [ 📁 File system ]
"---------------------
" swapfileなし
set noswapfile
" クリップボードの共有化
set clipboard=unnamedplus

" [ ⌨️ Key ]
"-------------
" メソッド移動
nnoremap [m :<C-u>action MethodUp<CR>
nnoremap ]m :<C-u>action MethodDown<CR>
```

{{</file>}}


Vimプラグインのエミュレート対応
-------------------------------

IdeaVimは著名なプラグインのエミュレートに対応しています。

{{<summary "https://github.com/JetBrains/ideavim/blob/master/doc/emulated-plugins.md">}}

いくつか紹介します。


### easymotion

数回のキー入力で画面の好きなところに瞬間移動できるプラグインです。  
個人的に、コレなしでVimを使うことは考えられません😆

{{<summary "https://github.com/easymotion/vim-easymotion">}}

{{<mp4 "resources/easymotion.mp4">}}

easymotionだけはIdeaVim以外のプラグインが必要です。

{{<summary "https://plugins.jetbrains.com/plugin/13360-ideavim-easymotion">}}

インストールすると、依存している`AceJump`プラグインもインストールされます。  
`~/.ideavimrc`の設定は以下のようにしています。

{{<file "~/.ideavimrc">}}

```vim
set easymotion
" sで開始
nmap s <Plug>(easymotion-s2)
```

{{</file>}}

{{<why "分割されたウィンドウも移動対象に含められないのか?">}}
2020-05-03現在では未対応のようです。

>   Over Window Motion                | Note
>   ----------------------------------|---------------------------------
>   <Plug>(easymotion-overwin-f)      | UNSUPPORTED
>   <Plug>(easymotion-overwin-f2)     | UNSUPPORTED
>   <Plug>(easymotion-overwin-line)   | UNSUPPORTED
>   <Plug>(easymotion-overwin-w)      | UNSUPPORTED
{{</why>}}

### surround

特定の文字で囲まれた範囲を編集するプラグインです。  
カッコやクォーテーション、タグの追加/削除/変更ができます。

{{<summary "https://github.com/tpope/vim-surround">}}

{{<mp4 "resources/surround.mp4">}}

{{<file "~/.ideavimrc">}}

```vim
set surround
```

{{</file>}}

### multiple-cursors

IDEAにもあるマルチカーソルを実現するプラグインです。  
Insertモード以外の操作にも対応しているので心強いです。

{{<summary "https://github.com/terryma/vim-multiple-cursors">}}

{{<mp4 "resources/multiple-cursors.mp4">}}

{{<file "~/.ideavimrc">}}

```vim
set multiple-cursors
" Ctrl+kで発動
map <C-k> <A-n>
```

{{</file>}}

### commentary

コメント化/コメント解除するプラグインです。  
text-objectやmotionと一緒に使えるのが強みです。

{{<summary "https://github.com/tpope/vim-commentary">}}

{{<mp4 "resources/commentary.mp4">}}

{{<file "~/.ideavimrc">}}

```vim
set commentary
```

{{</file>}}

### ReplaceWithRegister

対象範囲をyank(クリップボード)に保存されたデータで置き換えます。

このとき、対象範囲のデータとyankの内容が置き換わることはありません。  
複数の対象をyankのデータで置き換えたいときに便利です。

{{<summary "https://github.com/vim-scripts/ReplaceWithRegister">}}

{{<mp4 "resources/replace-with-register.mp4">}}

{{<file "~/.ideavimrc">}}

```vim
set ReplaceWithRegister
" _で発動. ダブルクォーテーションの中を置換したいなら _i"
map _ gr
```

{{</file>}}

### argtextobj

引数を対象とするtext-objectです。  
型も一緒に含まれるため、型定義がある場合に便利です。

{{<summary "https://www.vim.org/scripts/script.php?script_id=2699">}}

デモには他プラグインの機能も混ざっています。  
`aa`や`ia`でtext-objectを指定している箇所が、本プラグインの機能です。

{{<mp4 "resources/argtextobj.mp4">}}

{{<file "~/.ideavimrc">}}

```vim
set argtextobj
```

{{</file>}}


### textobj-entire

ファイル全体を対象とするtext-objectです。

{{<summary "https://github.com/kana/vim-textobj-entire">}}

{{<mp4 "resources/textobj-entire.mp4">}}

{{<file "~/.ideavimrc">}}

```vim
set textobj-entire
```

{{</file>}}


総括
----

IntelliJ IDEAや他のJetBrains製 IDEで、Vimmer向けのプラグインを紹介しました。  

作業効率という意味でVimの哲学は素晴らしいと思っています。  
しかし、進化したツールがある現代に素のVimだけで開発するのは非効率です。

JetBrains製 IDEは開発効率や品質を圧倒的に向上させてくれます。  
そこにVimの哲学をあわせることが今の時代にあった最適化ではないでしょうか。

`P.S.`

最近公開したMarkdownプラグインもよろしくお願いします😉

{{<summary "https://blog.mamansoft.net/2020/04/22/create-intellij-idea-plugin/">}}

過去に書いたIDEA関連の記事もよろしければ🙏

{{<summary "https://blog.mamansoft.net/tags/#idea-list">}}

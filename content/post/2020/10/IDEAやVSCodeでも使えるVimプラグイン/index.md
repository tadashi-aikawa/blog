---
title: JetBrains IDEやVS Codeでも使える10のVimプラグイン
slug: jetbrains-ide-vs-code-vim-plugin-10
date: 2020-11-03T22:20:11+09:00
thumbnailImage: images/cover/2020-11-03.jpg
categories:
  - engineering
tags:
  - idea
  - vscode
  - vim
  - jetbrains
---

IntelliJ IDEAをはじめとしたJetBrainsのIDE、VS Codeなどでも同じ体験ができる..  
そのような**10のVimプラグイン**を紹介します。

<!--more-->

{{<cimg "2020-11-03.jpg">}}

<!--toc-->


はじめに
--------

※ `はじめに`はポエムとなっています. プラグインを知りたいだけの方は次章までお進みください😇

### Vimをとりまく世界

皆さんはVimをお使いでしょうか?  
一度でもVimの良さを知った方ならこう思うことでしょう..  
『すべての入力をVim流でやりたい!!』と。

そんな想いに応えるよう、多くのエディタやIDEは拡張でVimの機能を提供しています。  
たとえばIntelliJ IDEAやVSCodeではそれぞれ以下のような拡張を提供しています。

{{<summary "https://plugins.jetbrains.com/plugin/164-ideavim">}}

{{<summary "https://marketplace.visualstudio.com/items?itemName=vscodevim.vim">}}

当ブログでも、上記拡張に関する記事を執筆してきました。  
ありがたいことにどの記事もそれなりの閲覧数を記録しています。

**IntelliJ IDEA**

{{<summary "https://blog.mamansoft.net/2020/05/03/more-vimmer-intellij-idea-plugin/">}}

**VS Code** 

{{<summary "https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/">}}
{{<summary "https://blog.mamansoft.net/2019/02/01/review-vscode-vim-setting/">}}


### Vimの世界が広がると同時に体現化する悩み

このようにVimの世界を広げると1つの悩みが発生します。  
**どこまで素のVimをエミュレートできるか**..と。

Vim拡張は所詮拡張に過ぎず、素のVimに比べて機能は劣ります。  
そのため、**VimではできるけどIDEAやVSCodeではできない**操作が生まれます。  
これを`Vimの差分`という言葉で表現し、この先は`Vimの差分`と呼びます。

`Vimの差分`がもたらすもの..それは**コンテキストスイッチの切り替えコスト**です。

* 『IDEAだとこの機能は使えないから、Vimで使うこの操作は回避しよう』
* 『VSCodeでは使えない機能がVimだと使えるから、この気を使おう』

無意識かもしれませんがこのような考えるコストが発生します。  
このコストは静かに私達の生産性を蝕んでいきます。そう..静かに..。


### Vim原理主義 VS プラグイン王

Vim原理主義の方は言います。  
**『プラグインを使うなど邪道である.. Vimの機能に精通していればプラグインなど必要ない!!』**

一方、別のVimmerはこう言います。  
**『.vimrcとプラグインを自分流にしてこそ真のVimmerだ!!』**

{{<alert info "プラグインと拡張の違いについて">}}
本記事では混乱を避けるため、プラグインと拡張を以下のように使い分けています。
* `プラグイン`: 素のVimに対するプラグイン
* `拡張`: IDEやエディタの拡張(アドオン/Extension/プラグイン)
{{</alert>}}

Vimのプラグイン機能を使うとVimでできることは格段に増えます。  
一方でIDEやエディタのVim拡張では、Vimプラグインの機能が使えるとは限りません。  
また、すべてのVim環境に同じプラグインがインストールできる保証もありません。

同様のことは素のVimを極限まで使いこなす場合でも言えます。  
Vimのインストール環境化においてコンテキストスイッチの切り替えコストは発生しません。  
しかし、細かなVimの機能はIDEやエディタのVim拡張だと再現できないでしょう。  

結局どのような戦略をとっても、Vim/IDE/エディタをそれぞれ使い続ける限りコンテキストスイッチの切り替えコストから逃れることはできないのです。


### コンテキストスイッチの最小化戦略

ここで少し話を戻し、冷静に考えてみます。  
そもそも私達は何をしたかったのでしょうか?

プラグインを使う/使わない、Vimのコアな機能を使う/使わない..これらは手段に過ぎません。  
目的はコンテキストスイッチの最小化でした。

それなら以下の観点でコンテキストスイッチを最小化する戦略を検討すればいいのでは..。

* 頻度の高い環境
* 頻度の高い操作

それでは`頻度の高い環境`と`頻度の高い操作`とは何にあたるのでしょうか..。  
それは皆さんの中にそれぞれ違う答えが存在すると思います。

ここから先は私の中の答えを前提として話を進めていきます。


### 頻度の高い環境

タイトルにもあるよう、私がVimの操作を行う主な環境は3つです。

* 自分のPC内のVim
* 自分のPC内のVS Code (エディタ)
* 自分のPC内のIntelliJ IDEA (IDE)

操作の機会はほとんど自分のPCです。  
他人のPCを操作する機会はあまりありません。

それなら、Vim/VS Code/IntelliJ IDEAの3環境においてコンテキストスイッチを最小化できれば.. 機能やショートカットキーを極力統一できればいいのではないか.. そう考えました。  
その範囲内なら..Vimのプラグインが提供する機能も取り入れるられる..と。

**過去にVimプラグインについて紹介した記事**

{{<summary "https://blog.mamansoft.net/2018/08/13/vim-plugin-refactoring/">}}

幸い、**IdeaVimやVSCodeVimには著名なVimプラグイン同様の機能がバンドルされています。**  
そのようなプラグインであればインストールできるのではないでしょうか。

次の章ではそのようなプラグインを紹介します。


選ばれし10のプラグイン
----------------------

各節のタイトルはVimのプラグイン名です。  
それぞれの節内には以下の項目があります。

| 項目名        | 説明                                        |
| ------------- | ------------------------------------------- |
| 設定          | 全ツールで概念として共通する設定            |
| Vim           | Vimのプラグインリポジトリと`.vimrc`の設定   |
| IntelliJ IDEA | `.ideavimrc` または IDEのkeymap設定         |
| VS Code       | `settings.json` または エディタのkeymap設定 |

各設定の知識はある前提で進めます。

これから紹介するプラグインは以下のVim環境で動作を確認しています。

* `Vim 8.2` + `Vundle` + `PowerShella 7.0.3` + `Windows Terminal 1.2` + `Windows10`
* `Vim 8.1` + `Vundle` + `Bash 5.0.17` + `Windows Terminal 1.2` + `Ubuntu 20.04.1 (WSL2)`

個人的に重要なものから紹介していきます。


### ❶ vim-easymotion

文字列をキーとして画面内の好きな場所に瞬間移動するプラグインです。

#### 設定

* `s`キーでスタート
* 最低2key絞り込みにする

Vimのプラグインのみ、分割された別ウィンドウにも移動できます。強い..!!

#### Vim

{{<summary "https://github.com/easymotion/vim-easymotion">}}

```vim
" デフォルトのマッピング無効化
let g:EasyMotion_do_mapping = 0
" 小文字は小文字/大文字にヒット、大文字は大文字だけにヒットさせる
let g:EasyMotion_smartcase = 1
" sキーでスタート -> 2key絞り込み
nmap s <Plug>(easymotion-overwin-f2)
```

#### IntelliJ IDEA

IdeaVimとは別に拡張が必要です。

{{<summary "https://plugins.jetbrains.com/plugin/13360-ideavim-easymotion">}}

IDEAの場合のみ2key**以上**の絞り込みに対応しています。  
つまり、3key以上入力して候補を更に絞り込めます。

```vim
set easymotion
" sキーでスタート -> 2key以上で絞り込み
nmap s <Plug>(easymotion-s2)
```

#### VS Code

```json
{
  "vim.easymotion": true,
  "vim.easymotionMarkerBackgroundColor": "rgba(0, 0, 0, 0.5)",
  "vim.easymotionMarkerForegroundColorOneChar": "lime",
}
```

```json
{
  "vim.normalModeKeyBindings": [
    {
      "before": ["s"],
      "after": ["<leader>", "<leader>", "2", "s", "<char>", "<char>"]
    }
  ]
}
```

### ❷ ctrlp.vim

カレントディレクトリ配下をインクリメンタルサーチしてファイルを開くプラグインです。

#### 設定

* `<C-j>f`でファイル検索
* `<C-j>e`で最近のファイル検索

#### Vim

{{<summary "https://github.com/ctrlpvim/ctrlp.vim">}}

```vim
let g:ctrlp_map = '<C-j>f'      " ファイル検索
nnoremap <C-j>e :CtrlPMRU<CR>   " 最近のファイル検索
set wildignore+=*/node_modules/*,*.so,*.swp,*.zip 
```

#### IntelliJ IDEA

`Main menu` > `Navigate` > `Go to File...` にキー設定する。

#### VS Code

`keybindings.json`
```json
[
  {
    "key": "ctrl+j f",
    "command": "workbench.action.quickOpen"
  }
]
```


### ❸ nerdtree

サイドにプロジェクトのディレクトリ階層構造を表示/操作するプラグインです。

#### 設定

* `<C-j>w`で現在ファイルをツリー表示

#### Vim

{{<summary "https://github.com/preservim/nerdtree">}}

```vim
" 起動時には表示しない
let NERDTreeShowHidden=1 
" 現在ファイルをツリー表示
nnoremap <C-j>w :NERDTreeFind<cr>
```

#### IntelliJ IDEA

`Other` > `Select in Project View` にキー設定する。

#### VS Code

`keybindings.json`
```json
[
  {
    "key": "ctrl+j w",
    "command": "workbench.view.explorer"
  }
]
```


### ❹ vim-visual-multi

カーソルを分裂させて複数箇所で同時に操作するプラグインです。  
マルチカーソルとVim操作の合わせ技はまさに圧巻..!!


#### 設定

* `<C-k>`を押す度に、カーソルの単語や選択範囲と同じ部分にカーソルが増殖する

ツールによって、どこまでVim操作できるかに違いがあります。  
高度な操作をする場合は注意してください。

#### Vim

{{<summary "https://github.com/mg979/vim-visual-multi">}}

```vim
" デフォルトのマッピング無効化
let g:VM_maps = {}
" <C-k>にバインド
let g:VM_maps['Find Under'] = '<C-k>'
let g:VM_maps['Find Subword Under'] = '<C-k>'
```

#### IntelliJ IDEA

```vim
set multiple-cursors
" <C-k>にバインド
map <C-k> <A-n>
```

#### VS Code

```json
{
  "vim.normalModeKeyBindings": [
    {
      "before": ["<C-k>"],
      "after": ["g", "b"]
    }
  ],
  "vim.visualModeKeyBindings": [
    {
      "before": ["<C-k>"],
      "after": ["g", "b"]
    }
  ]
}
```


### ❺ vim-commentary

対象をコメントインするプラグインです。

#### 設定

* `gc`でスタート

VimとVS Codeはコメントインとコメントアウトをトグルできます。

#### Vim

{{<summary "https://github.com/tpope/vim-commentary">}}

#### IntelliJ IDEA

```vim
set commentary
```

#### VS Code

設定不要(デフォルトで有効)。


### ❻ vim-highlightedyank

yankした範囲を一瞬ハイライトするプラグインです。  
視覚的フィードバックが心地よく操作ミスも減ります。

#### 設定

なし。

#### Vim

{{<summary "https://github.com/machakann/vim-highlightedyank">}}

```vim
" 点滅時間の設定
let g:highlightedyank_highlight_duration = 300
```

#### IntelliJ IDEA

```vim
set highlightedyank
```

#### VS Code

```json
{
  "vim.highlightedyank.enable": true,
}
```


### ❼ vim-gitgutter

側面にGitの状態を表示するプラグインです。

#### 設定

統一するのは表示部分だけです。操作は統一していません。

#### Vim

{{<summary "https://github.com/airblade/vim-gitgutter">}}

```vim
" 100msごとに表示更新
set updatetime=100
" プレビューにfloatingウィンドウを使う
let g:gitgutter_preview_win_floating = 1
" ハンクのdiffをプレビュー表示
nmap ghp <Plug>(GitGutterPreviewHunk)
" ハンクを元に戻す
nmap ghu <Plug>(GitGutterUndoHunk)
" ハンクをstagingする (編集画面からは差分がなくなる)
nmap ghs <Plug>(GitGutterStageHunk)
```

#### IntelliJ IDEA

IDEデフォルトの機能を使うため設定不要。

#### VS Code

IDEデフォルトの機能を使うため設定不要。


### ❽ vim-sandwich

クォーテーションやカッコなど挟むモノを操作するプラグインです。

#### 設定

[surround.vim]と同じキーマップを使います。

[surround.vim]: https://github.com/tpope/vim-surround

Vimのプラグインのみ視覚的フィードバックがあります。

#### Vim

{{<summary "https://github.com/machakann/vim-sandwich">}}

```vim
" vundle#end() より後ろの行に記載すると surround.vimのキーマップが使える
runtime macros/sandwich/keymap/surround.vim
```

#### IntelliJ IDEA

```vim
set surround
```

#### VS Code

設定不要(デフォルトで有効)。


### ❾ ReplaceWithRegister

対象をレジスタの値で置換するプラグインです。  
置換後もレジスタの値は変更されません。

#### 設定

* `_`キーでスタート

#### Vim

{{<summary "https://github.com/vim-scripts/ReplaceWithRegister">}}

```vim
" `_`キーでスタート
nmap _ <Plug>ReplaceWithRegisterOperator
```

#### IntelliJ IDEA

```vim
set ReplaceWithRegister
" `_`キーでスタート
map _ gr
```

#### VS Code

```json
{
  "vim.replaceWithRegister": true,
}
```

```json
{
  "vim.normalModeKeyBindings": [
    {
      "before": ["_"],
      "after": ["g", "r"]
    }
  ]
}
```


### ❿ vim-textobj-entire

ファイル全体をテキストオブジェクトとして扱えます。

#### 設定

* `ie` `ae`

#### Vim

{{<summary "https://github.com/kana/vim-textobj-entire">}}

#### IntelliJ IDEA

```vim
set textobj-entire
```

#### VS Code

設定不要(デフォルトで有効)。


総括
----

Vim/IDE/エディタのいずれでもコンテキストスイッチの切り替えナシで利用可能..  
そのような10のVimプラグインを紹介しました。

プラグインを使わない方、プラグインで自分に最適な環境をカスタマイズする方..  
各々事情はあると思いますが、最適な落とし所としてよろしければお試し下さい😁


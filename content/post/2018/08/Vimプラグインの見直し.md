---
title: "Vimプラグインの見直し"
slug: vim-plugin-refactoring
date: 2018-08-13T01:00:14+09:00
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


### [easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion)

先頭の数文字を入力すると候補が表示されてジャンプできるプラグイン。  
Migemoを有効にして日本語も候補にしたり、Windowを越えて移動できるので便利です。

{{<himg "https://dl.dropboxusercontent.com/s/hro6lz9ur70gjpm/20180813_1.gif">}}

入力は`s` => `om` => `a`


### [editorconfig/editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)

`.editorconfig`を読み込んで反映するプラグインです。  
EditorConfigについては下記をご覧下さい。

{{<summary "https://editorconfig.org/">}}


### [tpope/vim-surround](https://github.com/tpope/vim-surround)

カッコやクォート、タグなどの追加/削除/置換を行うプラグインです。  
IDEAやVS CodeのVimプラグインにも搭載されているほどの人気です。

{{<himg "https://dl.dropboxusercontent.com/s/kd5alsxpxaka616/20180813_2.gif">}}

入力は`ds]` => `cs(]`


### [tpope/vim-repeat](https://github.com/tpope/vim-repeat)

`.`コマンドで繰り返すことができない一部プラグインの挙動を繰り返し可能にするプラグインです。  
`tpope/vim-surround`を繰り返すために使用しています。

{{<himg "https://dl.dropboxusercontent.com/s/e5h3w0o1vu7wn0u/20180813_3.gif">}}

入力は`ysw)` => `j.` => `j.` => `j.`


### [yuttie/comfortable-motion.vim](https://github.com/yuttie/comfortable-motion.vim)

スムーズなスクロールを提供するプラグインです。  
動作イメージはGitHubのREADMEをご覧下さい。


### [kshenoy/vim-signature](https://github.com/kshenoy/vim-signature)

マークを可視化したり色々な機能を提供するプラグインです。  
主にマークの可視化に使用しています。

{{<himg "https://dl.dropboxusercontent.com/s/sio7cjhda3kmi02/20180813_4.gif">}}


{{<alert "success">}}
TODO: 他のプラグインを追加
{{</alert>}}


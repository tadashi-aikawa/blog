---
title: VSCodeVimの設定を見直す
slug: review-vscode-vim-setting
date: 2019-02-01T23:52:00+09:00
thumbnailImage: images/cover/2019-02-01.jpg
categories:
  - engineering
tags:
  - vscode
  - vim
---

久しぶりにVSCodeVimの設定を見直してみました。  
そこから得た知見の一部をVimの設定にも反映させました。

<!--more-->

{{<cimg "2019-02-01.jpg">}}

<!--toc-->


経緯
----

**ツールによらないキーバインド統一化**を目指す過程で、VSCodeのキーバインドを見直し始めたのがきっかけです。  
以前からモヤモヤしていたVSCodeVimに関する設定も整理しようと思って始めました。

{{<info "ツールによらないキーバインド統一化">}}
普通、キーバインドはツールごとに異なります。  
ある程度統一されている部分もありますが、細かな違いが脳のコンテキストスイッチの切り替えコストを増大させます。

全てのツールで同じキーバインドを実現することにより、それらの問題を解決するプロジェクトです。  
まだ実行には至りませんが、2019年中に完成させたいと思っています。
{{</info>}}


VSCodeVimとは
-------------

VSCodeでVimのような各種操作を実現するための拡張機能です。

{{<summary "https://marketplace.visualstudio.com/items?itemName=vscodevim.vim">}}

以下のようにとても人気があり、私にとってもVSCodeを使う上で欠かせない拡張機能です。

* ダウンロード500万超
* インストール100万弱
* ★4.3

なんとVersion1.0を越えていました！ 😄  

**Plenty of thanks to every one of developers!!**


基本設定
--------

基本はREADMEに従っていきます。まずは基本設定です。

### OSクリップボードとの同期

OSのクリップボードとの同期はコラボレーションに必須です。

```
"vim.useSystemClipboard": true
```

### 検索結果のハイライト

無効にする理由がありませんので有効にします。

```
"vim.hlsearch": true
```

### `*`で配下の単語を検索

無効にする理由がありませんので有効にします。

```
"vim.visualstar": true
```

### 折りたたまれた場所を乗り越える

折りたたまれた箇所について、表示された通りに移動するかどうかのフラグです。  
せっかく折りたたんだ箇所が展開されるのはストレスなのでtrueにします。

```
"vim.foldfix": true
```

#### フラグがfalseの場合

{{<himg "resources/20190201_2.gif">}}

#### フラグがtrueの場合

{{<himg "resources/20190201_1.gif">}}


NeoVim
------

[NeoVim]の説明は割愛しますが、以下の様に設定することでいくつかの機能を使えます。

```
"vim.enableNeovim": true
```

[Chocolatey]でインストールして環境変数PATHが通っていない場合は`vim.neovimPath`の指定が必要です。

```
"vim.neovimPath": "C:\\tools\\neovim\\Neovim\\bin\\nvim.exe",
```

[NeoVim]: https://neovim.io/ 
[Chocolatey]: https://chocolatey.org/packages/neovim


### できること

以下の2つができるようになります。

* `:normal`コマンド(`:norm`コマンド)
* `:g`コマンド

詳細はここでは触れません。


マルチカーソルモード
--------------------

個人的に最もエレガントな項目がこれです! 素晴らしい!!! 😂

私がVimmerになったのは2018年1月ですが、最後まで悩んだことが『マルチカーソルを捨てられるか』でした。  
当初、VSCodeVimはマルチカーソルに対応していなかった(動作が不安定あった)のですが遂に...という感じでしょうか。

利用イメージ。  
<small>※ 押したキー: `steh <C-k><C-k><C-k> cvscode<ESC> ^ $a,<BS> <Space>--vim <ESC><ESC>`</small>

{{<himg "resources/20190201_3.gif">}}

カーソルを増やすデフォルトのキーバインドは`gb`ですが、`<C-k>`に変更しています。  

{{<file "settings.jsonに追加した設定">}}
```
"vim.normalModeKeyBindings": [
  {
    "before": [
      "<C-k>"
    ],
    "after": [
      "g",
      "b"
    ]
  }
],
"vim.visualModeKeyBindings": [
  {
    "before": [
      "<C-k>",
    ],
    "after": [
      "g",
      "b"
    ]
  }
],
```
{{</file>}}

{{<warn "キーバインド設定が上手くいかない...">}}
キーバインド設定はハマリポイントが多いです。  
以下を確認しましょう。

####  beforeとafterが逆転していないか

`before`と`after`の正しい役割は以下の通りです。

* `before`: 割り当てたいキー
* `after`: `before`を押した時、代わりにどのキーを押したことにするか

`before`は現在割りあたっているキーではありません😢

#### `vim.visualModeKeyBindings`の設定がされているか

たとえNORMALモードでも、一度目は単語選択をするため**必ずVISUALモードに移行します**。  
そのため、`vim.visualModeKeyBindings`の設定をしなければ、カーソルを増やすことはできません。

#### `extension.vim_ctrl+?`にキーが割りあたっているか

今回の場合、VSCodeのキーバインド設定にて、`extension.vim_ctrl+k`に`Ctrl+k`が割りあたっていなければいけません。  
`Ctrl+k`をVSCodeVimのキーバインドと判別できるようにするためです。
{{</warn>}}


プラグイン
----------

VSCodeVimにプラグイン機能はありません。  
その代わりに著名なプラグインをエミュレートするオプションが用意されています。


### vim-airline

見た目が格好良くなると思いますが、パフォーマンスが劣化すると書かれていたため無効にしています。

> :warning: There are performance implications to using this plugin. In order to change the status bar, we override the configurations in your workspace settings.json which results in increased latency and a constant changing diff in your working directory (see issue#2124).


### vim-easymotion

表示された領域内に少ないタイプ数で移動できます。

```
"vim.easymotion": true,
```

利用イメージ。  
<small>※ 押したキー: `svsk cw<ESC> smau cw<ESC> smai cw<ESC>`</small>

{{<himg "resources/20190201_4.gif">}}

`s`を押した後にキーを入力すると、該当箇所にMarkerが表示されます。  
Markerに表示された文字を押すと移動します。

デフォルトのMarkerは好みに合わなかったので設定でカスタマイズしました。

```
"vim.easymotionMarkerBackgroundColor": "rgba(0, 0, 0, 0.7)",
"vim.easymotionMarkerForegroundColorOneChar": "pink",
"vim.easymotionMarkerWidthPerChar": 12,
"vim.easymotionMarkerHeight": 24,
"vim.easymotionMarkerFontSize": "24",
"vim.easymotionMarkerYOffset": 5,
```

また、デフォルトでは`s`を押した後のキーが1つなので、2つにするため以下の設定をしました。

```
"vim.normalModeKeyBindings": [
  {
    "before": [ "s" ],
    "after": [ "<leader>", "<leader>", "2", "s", "<char>", "<char>" ]
  }
],
```

1つだと候補が多数存在するため、かえって非効率だからです。

{{<warn "jump-motionsで移動前のカーソル位置に戻れない..">}}
vim-easymotionと後述するvim-sneakも...`<C-o>`で直前の位置に戻ることができませんでした。  
シンボルへの移動など`jump-list`で対応しきれないVSCodeのアクションがいくつかあるようです。

{{<refer "Feature/improved jump list #3028" "https://github.com/VSCodeVim/Vim/pull/3028">}}

VSCodeの機能として存在する`Go Forward`と`Go Back`の挙動にしたければ、`settings.json`でそのように設定しましょう。

{{<file "settings.jsonの設定例">}}
```
{
  "before": [
    "<C-o>"
  ],
  "commands": [
    {
      "command": "workbench.action.navigateBack"
    }
  ]
},
{
  "before": [
    "<C-i>"
  ],
  "commands": [
    {
      "command": "workbench.action.navigateForward"
    }
  ]
},
```
{{</file>}}

{{</warn>}}


### vim-surround

指定範囲を記号で囲むことができます。  
`S`でVISUALモードのときも使えることは知りませんでした...。

利用イメージ。  
<small>※ 押したキー: `ysiw) W cs]} B lds)`</small>

{{<himg "resources/20190201_5.gif">}}


### vim-commentary

指定範囲をコメントイン/コメントアウトできます。  
`gc`オペレータの後にモーションを指定するだけなのでイメージは割愛します。


### vim-indent-object

インデント単位で指定できるtext-objectです。  
このプラグインは初めて知りましたが、 便利だったのでVimの方にも逆輸入しました。

利用イメージ。  
<small>※ 押したキー: `vai d`</small>

{{<himg "resources/20190201_6.gif">}}

Pythonなどインデントが重要な位置づけを持つ言語では役立ちそうですね。


### vim-sneak

`f`/`t`をシンプルなまま高機能にできます。

Markerが表示ず、押した瞬間に移動するので候補が少ない場合は強みを発揮します。  
一方、候補が多い場合は移動するまで`;`を押し続けなければいけないのでパフォーマンスが落ちます。

私の場合、VSCodeではvim-easymotionを使うことにしました。  
一方、Vim版のoriginalではMarkerを表示するオプションがあるため、vim-easymotionから乗り換えました。

どちらも基本操作は似ているので、コンテキストスイッチの切り替えコストは低そうです。

せっかくなのでVim版の利用イメージを載せておきます。  
<small>※ 押したキー: `sre;;; <C-o> sret`</small>

{{<himg "resources/20190201_7.gif">}}


その他
------

VSCodeVimならではのショートカットキーがいくつかあります。  
私が使っているのは以下の2つです。

* `af`: 選択範囲拡張
* `gh`: マウスカーソルでホバーしたときの情報を表示

選択範囲拡張は以下の様にラフな使い方ができます。  
<small>※ 押したキー: `vafafafafaf`</small>

{{<himg "resources/20190201_8.gif">}}


総括
----

VSCodeVimの設定見直しをして、VSCode環境が大きく改善しました。

Vimmerとして...VSCodeのファンとして... これからもVSCodeVimの進化を陰ながら応援させて頂きます🙇

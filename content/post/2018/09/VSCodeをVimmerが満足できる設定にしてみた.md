---
title: "VSCodeをVimmerが満足できる設定にしてみた"
slug: vscode-satisfies-vimmer
date: 2018-09-17T01:26:15+09:00
thumbnailImage: https://images.pexels.com/photos/35188/child-childrens-baby-children-s.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260
categories:
  - engineering
tags:
  - vscode
  - vim
---

VSCodeの設定をいじったりプラグインを導入して、Vimmerが満足できる設定にしてみました。

VSCodeを使いこなしたい方にも役立つ内容となっておりますので、Vimmer以外の方もご一読いただければと思います。

{{<update "2019/02/01: VSCodeVimの設定を見直す記事を追加しました">}}
VSCodeVimがversion1.0を迎えたことによる設定見直し記事です。

{{<summary "https://blog.mamansoft.net/2019/02/01/review-vscode-vim-setting/">}}
{{</update>}}

<!--more-->

<img src="https://images.pexels.com/photos/35188/child-childrens-baby-children-s.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"/>

<!--toc-->


はじめに
--------

私はVimが好きです。可能であればずっと触っていたいくらい。

しかしVimは万人に優しいエディタではありません。  
集団で開発環境を整える場合、Vimを勧めることは現実的と言えないでしょう。


そのような場合、候補に挙がることが多いのはVSCodeです。

{{<summary "https://code.visualstudio.com/">}}


### なぜVSCodeか?

VSCodeが選ばれる理由は大抵以下のようなものでしょう。

* 無料 (導入障壁の低さ)
* 近代的なUI/UX (楽しさ)
* 起動が速い (他のIDEと比べて)
* Windows/Mac/Linux全てで動く
* ほとんどの開発環境を構築できる (カバー領域の広さ)
* MicroSoftがOSSとして開発している (信頼)

私も上記には全て同意します。  
唯一不満な点を描画が遅い(*1)くらいのものです。

{{<info "*1について">}}
Vimプラグインをインストールした場合の話
{{</info>}}


### 経緯

これまでは同じような機会でも以下の選択肢でくぐり抜けてきました。

* Jet Brains製IDE (IntelliJ IDEA, Pycharmなど)
* Vim + プラグイン

しかし、今度ばかりはVSCodeが最善の選択肢になりそうです。  
WindowがメインのチームでGo言語の開発をしなければいけないのです。

Windows上で動かすVimはVimにあらず。  
そうなるとVSCodeがベストな選択肢であることは明白でしょう。


### エディタの楽しさは開発効率に直結する

VSCodeを使うことにしました。  
ただ、Vimに陶酔していた私からすれば素のVSCodeを使い続けることは苦痛でしかありません。

**『それならば... VSCodeをVimに近づけてしまえばいいではないか』**

私は悪魔の囁きに耳を貸すことにしました。


Vimプラグイン
-------------

Vimmer向けの章です。  
Vimmerでない方は本章はスルーしていただければと思います :grin:


### インストール

これをインストールしないと何も始まりません。

{{<summary "https://marketplace.visualstudio.com/items?itemName=vscodevim.vim">}}

{{<warn "Vimプラグインが有効にならないときは...">}}
VSCodeを開いてもNORMALモードに移行せず、Vimプラグイン自体が無効になっている場合があります。  
以下のいずれかを疑って下さい。

* Toggle Vim Modeでプラグインを無効にしている
* ユーザ設定に間違いがありプラグインの読みこみに失敗している

よく遭遇してハマるのが2つ目のケースでした。  
Dropboxで設定を同期しておりますが、知らない間に変な入力が入って設定を壊していたのだと思います...
{{</warn>}}


### 設定

いくつか設定をします。

#### 無名レジスタとクリップボードを同期する

yankとコピー&ペーストの内容を同期するために設定します。

```
"vim.useSystemClipboard": true,
```

#### 検索結果をハイライトする

この設定が無いと検索結果がハイライトされないので不便です。

```
"vim.hlsearch": true,
```

#### カーソル配下の文字列を検索する

`*`や`#`キーでカーソル配下の文字列を検索するようにします。

```
"vim.visualstar": true,
```

#### EasyMotionの有効

EasyMotionは数回のキータッチでどこにでも移動できるVimのプラグインです。

{{<summary "https://github.com/easymotion/vim-easymotion">}}

VSCodeではほんの一部ですがEasyMotionのような機能を使うことができます。

```
"vim.easymotion": true,
```

#### Leaderの設定

Vim同様、Vimプラグインでは`<Leader>`を使用したキーバインディングが可能です。  
個人的な好みでSpaceキーに割り当てました。

```
"vim.leader": "<space>",
```

#### Neovimの有効化

normコマンドを実行するためにNeovimをインストールして有効にしました。  
残念ながら`norm .`には対応していませんでした...。

```
"vim.enableNeovim": true,
```

{{<info "Neovimのインストール方法">}}
Chocolateyまたは公式サイトからインストールしましょう。

##### 公式サイト

{{<summary "https://neovim.io/">}}

##### Chocolatey

```
$ choco install neovim
```
{{</info>}}


ユーザ設定
----------

プラグインではなくVSCode本体の設定をいくつか変更します。


### スニペット

デフォルトの設定だと以下の点でスニペットが使いにくいです。

* スニペットの候補が一覧の上に表示されない
* プレフックスが完全一致してもワンキーで展開できない

これらを解消するため以下の設定を追加します。

```
# スニペットを候補の上部に表示する
"editor.snippetSuggestions": "top",
# プレフィックスが一致する場合はスニペットを挿入する
"editor.tabCompletion": true,
```

デフォルトでこの設定にしてくれてもいいと思うのですが...。


### テーマ

Vimと同じテーマ、Monokaiを使用します。

```
"workbench.colorTheme": "Monokai",
```


### ターミナル

デフォルトはPower Shellになっていますがコマンドプロンプトを使用します。

```
"terminal.integrated.shell.windows": "C:\\WINDOWS\\Sysnative\\cmd.exe",
```

Power Shellでも大抵の場合は問題ないのですが、コマンドプロンプトの方が安定するんですよね。  
どうせbashが使えないならコマンドプロンプトでいいかなと。


### 改行コード

規定の改行コードをLF改行にします。  
CRLF改行なんてbatファイルの編集以外で使いたくないです... 使いますけど :cry:

```
"files.eol": "\n",
```


### 文字コード

ファイルを開くときの推測変換をONにします。  
ええ..そうなんです。CP932とかSJISとかよく開かなくてはいけないんです :cry:

```
"files.autoGuessEncoding": true,
```


### ミニマップ

以下の設定にします。

* ミニマップスライダーは常に表示する
* ミニマップ内の文字を真面目に表示しない (パフォーマンスアップ)

```
"editor.minimap.showSlider": "always",
"editor.minimap.renderCharacters": false,
```


プラグイン
----------

Vim以外で必要不可欠なプラグインをいくつかインストールします。

その前にプラグインのインストールはCUIでもできることを知っておきましょう。  
PCの再セットアップをする際に環境構築を完全に自動化できます。

インストールには`code --install-extension`コマンドを実行します。  
`code --help`で関連するコマンドにも目を通しておきましょう。

例えば、Vimプラグインをインストールするコマンドは以下になります。

```
$ code --install-extension vscodevim.vim
```

{{<why "既にインストール済みの場合はどうなるの?">}}
既にインストール済みの場合、`code --install-extension`コマンドはインストールを実行しません。
{{</why>}}

{{<warn "インストールが実行されずにVSCodeが開かれてしまう...">}}
コマンド名があっているかを確認しましょう。  
コマンドが間違っている場合、VSCodeは間違ったコマンド名でファイルを作成し編集を試みます。

特に以下の間違いには気をつけましょう。

* `code install-extension` (`--`がついていない)
* `code --install-extention` (`s`が`t`になっている)
* `code --install-extensions` (最後に`s`がついている)
{{</warn>}}

{{<warn "batファイルで `code --install-extensions` を実行しても1つ目しかインストールされない">}}
callを付けて1つ１つ呼び出す必要があります。

##### 駄目な例

* `code --install-extension vscodevim.vim`
* `call code --install-extension vscodevim.vim donjayamanne.github`

##### 正しい例

```
call code --install-extension vscodevim.vim
call code --install-extension donjayamanne.github
```
{{</warn>}}


### Git History

VSCodeでGitの履歴を参照するプラグインです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory">}}

特にコミットグラフは必見！ 公式READMEのgifを見てみましょう :smile:

{{<file "Install command">}}
```
$ code --install-extension donjayamanne.githistory
```
{{</file>}}


### GitLens

かなり多機能なGitプラグイン。

{{<summary "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens">}}

以下2機能のために使っています。

* エディタ上に最終更新内容をリアルタイムで表示する
* ファイルの履歴確認(サイドバー)

{{<file "Install command">}}
```
$ code --install-extension eamodio.gitlens
```
{{</file>}}


### Code Runner

コードスニペットに対して実行することができるプラグインです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner">}}

ちょっと文法やライブラリの挙動を確認したいとき非常に便利です :relaxed:  
無題の新規ファイルを作成して実行したりします。

{{<why "言語ごとの実行コマンドはどこで設定されているのか?">}}
設定`code-runner.executorMap`にて言語ごとの実行コマンドがマッピングされています。  
以下の場合は設定を確認してみましょう。

* 規定の設定だと都合悪い場合
* 実行エラーになってしまう場合

なお、言語ではなく拡張子ごとの設定は`code-runner.executorMapByFileExtension`で可能です。  
また、シバンが指定されている場合はそれが優先されます。  
※ `"code-runner.respectShebang": false` となっていなければ
{{</why>}}

{{<file "Install command">}}
```
$ code --install-extension formulahendry.code-runner
```
{{</file>}}


### Japanse Language Pack for Visual Studio Code

VSCodeを日本語化するプラグインです。  
OSが日本語であれば自動でインストールを促されると思います。

{{<summary "https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-ja">}}

{{<file "Install command">}}
```
$ code --install-extension MS-CEINTL.vscode-language-pack-ja
```
{{</file>}}


### Paste JSON as Code

JSONから各言語のスキーマ定義を作成するプラグインです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=quicktype.quicktype">}}

主要な型または型注釈のある言語は全て抑えていそうです。  
あれ..Haskellはありませんね :smirk:

返却値の統計からEnumやOptionalとして扱うか、同一スキーマとするかまで判断してくれます。
quicktypeというサイトがあり、そこの処理を使っているようですね。

{{<summary "https://quicktype.io/">}}

上記サイトで直接実行した方がいいかもしれません。

{{<file "Install command">}}
```
$ code --install-extension quicktype.quicktype
```
{{</file>}}


### Edit with Shell Command

指定範囲にシェルコマンドを実行できるプラグインです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=ryu1kn.edit-with-shell">}}

Windowsだとデフォルトでは`cmd.exe`を実行しますがそれでは嬉しくありません。  
Bash on Windowsのbashを実行するように設定変更します。

```
"editWithShell.shell.windows": "bash",
"editWithShell.shellArgs.windows": [
    "-c"
],
```

ついでにテキストを選択していない場合は現ファイルを実行対象にします。

```
"editWithShell.processEntireTextIfNoneSelected": true
```

{{<file "Install command">}}
```
$ code --install-extension ryu1kn.edit-with-shell
```
{{</file>}}


### Japanese Word Handler

日本語に最適なカーソル移動を提供するプラグインです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=sgryjp.japanese-word-handler">}}

このプラグインは実に燻し銀です。日本人の救世主としか思えない!!  
`Ctrl+→`や`Ctrl+←`で単語移動できるのはこのプラグインのおかげです。

{{<file "Install command">}}
```
$ code --install-extension sgryjp.japanese-word-handler
```
{{</file>}}


### Table Formatter

ラストのプラグインはテーブルをフォーマットするプラグインです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=shuworks.vscode-table-formatter">}}

Markdownを書く場合は必要不可欠ですね。

{{<file "Install command">}}
```
$ code --install-extension shuworks.vscode-table-formatter
```
{{</file>}}


キーバインド
-----------

Vimプラグインを使用していると`"vim.useCtrlKeys": false`としていなければ、ほぼVimと同じキーバインドになります。  
なので、あまり多くのキーバインド設定をする必要はありませんでした。

敢えて言うなら、`Ctrl+j`は必ず次のキーとセットのバインディングにしています。  
`Ctrl+j`にした理由は最も押しやすいキーの1つだからです。

以下は一例です。

| キーバインド | コマンド                               |
|--------------|----------------------------------------|
| Ctrl+j => d  | workbench.view.debug                   |
| Ctrl+j => f  | workbench.view.search                  |
| Ctrl+j => h  | workbench.action.focusSideBar          |
| Ctrl+j => j  | workbench.action.editor.nextChange     |
| Ctrl+j => k  | workbench.action.editor.previousChange |
| Ctrl+j => o  | workbench.action.gotoSymbol            |
| Ctrl+j => s  | workbench.view.scm                     |
| Ctrl+j => w  | workbench.view.explorer                |

連続して入力しないコマンドはShiftを使うパターンにしています。

| キーバインド      | コマンド                               |
|-------------------|----------------------------------------|
| Ctrl+j => Shift+K | workbench.action.openGlobalKeybindings |
| Ctrl+j => Shift+S | workbench.action.openGlobalSettings    |


総括
----

VSCodeをVimmerが満足できるようカスタマイズしてみました。

今はとりあえず設定してみたというレベルであり、突き詰めるようなことは行っておりません。  
今後もVSCodeを使い続けていくと確信が深まるにつれ、更に設定を突き詰めていきたいと思います。



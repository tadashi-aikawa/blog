---
title: "git bashを格好良くしてみた"
slug: make-git-bash-look-good
date: 2018-06-04T03:05:00+09:00
thumbnailImage: https://gitforwindows.org/img/gwindows_logo.png
categories:
  - engineering
tags:
  - git
  - bash
---

普段はLinuxを使っていますが、仕事でWindowsを使う機会が増えています。  
今回はWindowsのターミナルとしてバランス感のあるgit bashを格好良く使うため色々頑張ってみました。

<!--more-->

![](https://images.pexels.com/photos/826380/pexels-photo-826380.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260)

<!--toc-->


git bashとは
------------

Windows用のGitをインストールすると漏れなくついてくるbashのようなものです。  
仮想的にLinuxの上でbashを動かしているわけではなく、Windows用に用意されたbashコマンド相応のexeファイルを使っています。

git bashを選んだ理由は詳しく延べませんが、大きな理由だけ挙げると以下3点になります。

* 基本的なbashコマンドが一通り使える
* WindowsのexeファイルをCLIから実行できる
* Vimが使える


デフォルトのgit bash
--------------------

起動するとこんな感じです。

{{<himg "https://dl.dropboxusercontent.com/s/96a8ueq7iyy4aom/20180604_1.png">}}

ブランチ名を表示してくれたりはしますがテンションが下がる画面ですよね..。

これを改造していきます。


ターミナルの設定を変更
----------------------

### フォント

フォントは`Source Code Pro for Powerline`がオススメです。  
文字の形がカッコよく、記号も使えるフォントです。

{{<summary "https://github.com/powerline/fonts/tree/master/SourceCodePro">}}

インストールしていない場合は上記からotfファイルをインストールしましょう。  
通常版とBold版をインストールしておいてください.

後はターミナルのOptionから`Text -> Font`に`Source Code Pro for Powerline`を設定します。  
個人的には太字のサイズ12がオススメです。


### テーマ

デフォルトのテーマが格好良くないので、Optionからテーマを変更します。

* `Look -> Theme`を`rosipov`に変更
  * 他テーマでも良いが文字が見にくい色になることが無かったため採用
* `Terminal -> Type`を`xterm-256color`に変更
  * VimでテーマMonokaiを使った時に格好良くなるため


### ターミナルを再起動する

少しは格好良くなりました。

{{<himg "https://dl.dropboxusercontent.com/s/vjwayt9cqfxh2zk/20180604_2.png">}}


プロンプトの設定を変更する
--------------------------

更にfishなどで使われているPowerlineのようなプロンプトにしてしまいます。  
git bashはPythonのInterfaceに難があるため、purelineを使うことにしました。

{{<summary "https://github.com/chris-marsh/pureline">}}

試してみましたが、Gitコマンドの反応が遅かったため少し改変したリポジトリを自分で作成してみました。

{{<summary "https://github.com/tadashi-aikawa/pureline-inspired">}}

ほとんどがpurelineのコードそのままなので、Documentationなどは作成していません。  
インストール方法だけ自分が使用している設定とあわせて記載しています。

READMEにある通り`.bashrc`に以下を記載します。

```
source /c/Users/syoum/git/pureline/pureline /c/Users/syoum/git/pureline/.pureline.conf
```

そして再起動すると... ようやくテンションが上がってきましたね！

{{<himg "https://dl.dropboxusercontent.com/s/h6hd0i78srnok0g/20180604_3.png">}}


`.bashrc`
---------

そのままでは使えないよく使うコマンドを`.bashrc`に定義しています。

```bash
alias acmd='powershell -command "Start-Process -Verb runas cmd"'

function to_win_path() {
  path=${*}
  echo "$(readlink -f ${path} | sed -e 's@/@\\@g' -e 's@\\c\\@c:\\@g' | tr '\n' ' ')"
}

function tree() {
  dst="$(to_win_path ${1:-$(pwd)})"
  cmd //c "chcp 437 & tree ${dst}" //a //f
}

function te() {
  dst="$(to_win_path ${1:-$(pwd)})"
  /c/tablacus/TE64 ${dst}
}
```

### acmd

管理者権限でコマンドプロンプトを立ち上げるエイリアスです。  
powershell経由で実行しています。


### tree

git bashにはtreeコマンドが同梱されていないためコマンドプロンプトのtreeを呼び出します。  
パスをWindowsが判別できる絶対パスに変換する必要があるため`to_win_path`を通しています。

現状では複数引数には対応していません。


### te

Tablacus Explorerを立ち上げます。  
引数で指定したディレクトリを開きますが、指定なしの場合はカレントディレクトリを開きます。

現状では複数引数には対応していません。


Vim
---

### 画面が点滅するのを制御する

Beep音が出るタイミングで画面が点滅してしまうのを防ぐため`.vimrc`に以下を追加します。

```
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
```

### deinのインストール

git bashでも問題なく動作しました。  
ただし、Pythonのインタフェースは使えませんでした。

```
$ curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
$ sh ./installer.sh ~/.cache/dein
```

1. `./installer.sh`で表示されたテンプレを`.vimrc`の先頭に貼る
2. vimを起動して`:call dein#install()`

環境整備した状態だとLinuxのVimと区別がつきませんね。

{{<himg "https://dl.dropboxusercontent.com/s/6sgqdzxw61zuhpm/20180604_4.png">}}


総括
----

git bashを格好良く使う方法を紹介しました。  
Windowsでターミナルをいじらなければならなくて辛い方は是非試してみて下さい。


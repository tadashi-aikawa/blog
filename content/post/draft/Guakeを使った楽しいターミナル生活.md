---
draft: true
title: "Guakeを使った楽しいターミナル生活"
date: 2017-MM-dd
#thumbnailImage: 
categories:
  - 
tags:
  - 
---

Ubuntuで使用しているターミナルをgnome-terminalから、Guakeに変更しました。

<!--more-->

<!--toc-->


はじめに
--------

### 経緯

背景画像を変えたかったというのがターミナルを変更した動機です。  
実際にGuakeを使い始めてみると、それ以上のメリットがありました。

### 求めないこと

タブや画面分割の機能は必要ありません。  
tmuxを使っているため使用しないからです。

### 環境

TODO: Ubuntuの環境とか


Guakeとは
---------

TODO: 説明


設定
----

ホームディレクトリに`.gconf`というディレクトリが作成されます。  
その下を同期できるようにしておけば、環境が変わっても同じ設定を使用できます。

TODO: もうちょっと解析


総括
----


----

デフォルトシェルを /usr/bin/fish
  => tmuxだとなぜか.tmux.confの読みこみエラーに
常に全面に表示

Start fullScreen
  => tmux起動時に再描画されてしまう

タブバーを表示する
  => いらない



フォント => Source Code Pro
スキーム => Xterm
効果


Toggle Guake visibility => Ctrl + ,
全画面
外観.Toggle transparency => Alt + Toggle
Clipboard

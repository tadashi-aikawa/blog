---
title: "最近導入した3つのVSCode拡張"
slug: 3vscode-extensions-recently
date: 2019-08-19T21:10:54+09:00
thumbnailImage: images/cover/2019-08-19.jpg
categories:
  - engineering
tags:
  - vscode
---

2019年度の夏になって導入した3つのオススメExtensionについて紹介します。

<!--more-->

{{<cimg "2019-08-19.jpg">}}

<!--toc-->


はじめに
--------

ご紹介するのは最近取り入れたものであり、最近作られたものとは限りません。  
なお、その他のExtentionでオススメなものは以前に以下記事で紹介しています。

{{<summary "https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/">}}

{{<summary "https://blog.mamansoft.net/2019/05/04/vscode-over-wsl-ssh-docker/">}}

今回紹介するExtensionにはそれらを置き換えるものも存在します。


Git Graph
---------

Gitのコミットグラフを綺麗に見たり、操作ができるExtensionです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph">}}

**『IDEやエディタに付属しているから』** ではなく **『Gitクライアント単体として見ても』** 使いたいと初めて感じました😄

* デザインが格好良くて見やすい
* ブランチ/タグと同じ色でノード/リンクが表示されるため追跡しやすい
* コミットグラフから実行したい操作がほとんどできる
* [Remote Development]を使えば **リモート環境でも使用できる**

詳しくは以下の動画をご覧下さい。

{{<mp4 "resources/20190819_1.mp4">}}


REST Client
-----------

REST APIの操作ができるExtensionです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=humao.rest-client">}}

GUIツールとしては[Postman]を使っており、非常に使いやすいツールです。  
それでも、以下の点が本Extensionは優れていると思います。

* VSCodeから切り替えをせずに使用できる
* httpファイルを管理できる
* CLIならではのフットワークの軽さ
* [Remote Development]を使えば **リモート環境でも使用できる**

エディタと一体化 + テキストエディタの操作を活かした心地よい拡張ですね🌝

{{<mp4 "resources/20190819_2.mp4">}}

上記動画はほんの1機能に過ぎません。  
結果として表示する内容を精査したり、プレビューではなくてテキストエディタとして開くこともできます。


Material Icon Theme
-------------------

最後はアイコンテーマを変更するExtensionです。

{{<summary "https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme">}}

導入前は『正直アイコンくらいで..』と正直舐めていました。  
しかし、一度導入してみたらその素晴らしさを実感しました。すみませんでした🙇

{{<vimg "resources/20190819_3.jpg">}}

特にVSCodeはディレクトリアイコン?が非常に見にくいため、それが解消されるだけでも素晴らしいです。  
他にも**ファイル検索時の絞り込み結果が見やすい**というメリットありました。

{{<himg "resources/20190819_4.gif">}}


総括
----

2019年度の夏になって導入した3つのオススメExtensionについて紹介しました。

表向きの情報だけ調べて使わなかったけど、イザ使ってみると素晴らしいものにも出会えました。  
今に満足せず、定期的に自身の環境を見直す時間をつくることはやはり大事ですね😄

最近は[Remote Development]が使えるようになったため、Extensionの価値が以前より上がった気がします。  
特にGUIを持たないLinux環境では、今回紹介したExtensionが重宝するのではないでしょうか。

### オマケ

自分でExtensionを作りたい方へ。  
以前に記事を書きましたのでよろしければどうぞ🤓

{{<summary "https://blog.mamansoft.net/2018/11/12/create-vscode-extension/">}}


[Remote Development]: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack
[Postman]: https://www.getpostman.com/

---
title: "ファイルが変更されたらブラウザリロードさせる方法"
slug: reload-browser-change-file
date: 2018-05-14T00:40:00+09:00
thumbnailImage: http://livereload.com/images/LiveReload_350.png
categories:
  - engineering
tags:
  - python
  - livereload
---

python-livereloadを使ってファイルが変更されたらブラウザがリロードされる仕組みを作ってみました。

<!--more-->

{{<cimg "http://livereload.com/images/LiveReload_350.png">}}

<!--toc-->


LiveReload
----------

LiveReloadはファイルシステムの変更を監視し、ファイルが保存されるとブラウザを更新するプロダクトです。  
ブラウザを更新する前に指定した前処理を行う事も可能です。

{{<summary "http://livereload.com/">}}


python-livereload
-----------------

LiveReloadを利用するためのPython packageです。  
内部ではlivereload.jsを利用しています。

{{<summary "https://github.com/lepture/python-livereload">}}

コマンドラインによる実行と、ソースコードでの実装に対応しています。  
今回はソースコードでの実装を紹介します。


なぜpython-livereload
---------------------

PythonだけでLiveReloadの機能を使用したかったからです。

Node環境であれば最近では[Browsersync](https://browsersync.io/)というサービスが流行っています。  
しかし実装したいツールである[Jumeaux](https://github.com/tadashi-aikawa/jumeaux/)がPython製であるため、Pythonだけで動かせることを重視しました。

また、ブラウザにアドオンをインストールしたり、OSにLiveReloadをインストールする必要がないのも大きなポイントでした。


最小限の実装例
--------------

以下の要件を満たす最小限のコードです。

* 起動すると`index.html`のコンテンツが表示される
* `watch-target.json`が変更されたらブラウザが自動リロードされる
* ブラウザが自動リロードされる前に標準出力に`Reload...`が出力される


```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from livereload import Server


def reload():
    print('Reload...')


server = Server()
server.watch('./watch-target.json', reload)
server.serve(root='./index.html', open_url=True)
```

とても簡単ですね！


ハマリポイント
--------------

初回起動後にファイルを変更してもブラウザが自動リロードされないという問題にしばらくハマリました。  
結論から言うと、HTMLファイルの構造が不正だった(`<HEAD></HEAD>`が存在しなかった)ことが原因でした。

上記原因のエラーが出力されなかったため、しばらくの間は環境に問題があると思い込んでいました。  
ブラウザやOSに必要なモジュールがインストールされていないと思いましたが、ソースコードを読んで解決しました。

### python-livereloadが動く仕組み

せっかく調べたのでpython-livereloadが動作する仕組みを簡単に紹介します。

変更検知によるリロードは、ブラウザとサーバのWebSocket通信で実現されています。  
また、WebSocketの接続はブラウザが表示したHTML内で読み込まれた`livereload.js`により行われます。

シーケンスは以下の通りです。  
(細かいところが間違っているかもしれません..)

1. python-livereloadのサーバが起動し、`/index.html`と`/livereload.js`の静的ファイル配信受付を開始する
2. python-livereloadがブラウザを起動する (`opne_url=True`でない場合は手動で起動する)
3. ブラウザがサーバへ`/index.html`をリクエストする
4. python-livereloadが`livereload.js`を読み込む`<script>`タグを埋め込んだ`index.html`を返却する
5. ブラウザが`livereload.js`を読みこんでサーバにWebSocket接続を行う
6. 以後、python-livereloadがファイル変更を検知するとWebSocket通信でブラウザをリロードさせる

起動時の配信コンテンツにサーバ自身へのWebSocket接続スクリプトを埋め込むというのが個人的に新鮮でした。  
世の中のWebSocketを利用したサイトは全て同じような実装になっているのでしょうか..。

関連するソースコードはこの辺です。

* https://github.com/lepture/python-livereload/blob/master/livereload/server.py#L221
* https://github.com/lepture/python-livereload/blob/master/livereload/handlers.py#L136


総括
----

python-livereloadを使ってファイルが変更されたらブラウザがリロードされる仕組みを作ってみました。

凄い簡単な上に一瞬で作る事ができるのでオススメです！！..... HTMLさえちゃんと書けていれば...


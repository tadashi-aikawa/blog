---
title: "2018年はVimmerになる"
slug: 2018-vimmer
date: 2018-01-09T22:27:00+09:00
thumbnailImage: http://thehacker.jp/wp-content/uploads/2015/12/vimlogo-564x564.png
categories:
  - other
tags:
  - vim
  - idea
---

2018年が始まりましたね。

年始に目標を決めることは非常に大事ですが、設定しすぎると実現に現実味が無くなります。  
なので目標を1つに絞ることにしました。

『Vimmerになる』でいきたいと思います。

<!--more-->

<!--toc-->


経緯
----

私はAutoHotKeyを駆使して思考の速度で入力する環境を整えています。

{{<summary "https://autohotkey.com/">}}

影響を受けたのは以下の記事です。5年経った今でも非常にリスペクトしております。

> [思考の速度でパソコンを使う技術 \- 分裂勘違い君劇場 by ふろむだ](https://www.furomuda.com/entry/20070212/1171244226)

自分なりには満足するレベルまでカスタマイズを極めたと思っています。  
GitHubに設定を公開しておりますが、そこらのVimmerの方よりは高速操作ができていると思っていました。

{{<summary "https://github.com/tadashi-aikawa/spinal-reflex-bindings-template">}}


しかし、私はVimをちゃんと習得したことがありません。  
基本的な操作方法は知っていましたが、Vimの哲学や高度な使い方は全く知りませんでした。

何かを判断する上で食わず嫌いをするのは一番危険な考え方です。  
貴重なスキルアップのチャンスを逃してしまうことになるからです。

そこで今年は本気でVimを学び、その結果使えそうな文化や技術は吸収することにしました。


やること
--------

中途半端にVimを使っても習得できないと思いますので徹底的に環境をVim化します。  
具体的には以下5つにチャレンジします。


### 特別な理由がなければVimを使う

今までメインで使っていたエディタはVS Codeです。

VS CodeのVimプラグインを使うという方法もありますが、完全にはVimをエミュレートできずどっちつかずになってしまうため、特別な理由がなければVimを使うようにしてみます。


### Vim実践入門を読破する

Vimの思想が込められた素晴らしい本がありました。  
Vimmerと思われるレビュアーの皆さんからもほとんど★5という評価の高さ！

冒頭の20ページを試し読みしてすぐにKindleで購入しました。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="background-color:#FFFFFF;width:410px;margin:0px;padding-top:6px;text-align:center;overflow:auto;"><a href="https://hb.afl.rakuten.co.jp/hgc/14a76b37.c0914a83.14a76b38.d3a9cd94/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Frakutenkobo-ebooks%2F6e08bf5776463bf5a3cbc33848706e1f%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Frakutenkobo-ebooks%2Fi%2F13115341%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MCwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjowLCJjb2wiOjB9" target="_blank" rel="nofollow" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/14a76b37.c0914a83.14a76b38.d3a9cd94/?me_id=1278256&item_id=13115341&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Frakutenkobo-ebooks%2Fcabinet%2F4574%2F2000001734574.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Frakutenkobo-ebooks%2Fcabinet%2F4574%2F2000001734574.jpg%3F_ex%3D400x400&s=400x400&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/14a76b37.c0914a83.14a76b38.d3a9cd94/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Frakutenkobo-ebooks%2F6e08bf5776463bf5a3cbc33848706e1f%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Frakutenkobo-ebooks%2Fi%2F13115341%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MCwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjowLCJjb2wiOjB9" target="_blank" rel="nofollow" style="word-wrap:break-word;"  >実践Vim 思考のスピードで編集しよう！【電子書籍】[ Drew　Neil ]</a><br><span >価格：2419円</span> <span style="color:#BBB">(2018/1/9時点)</span></p></div></td></tr></table>

この本をリスペクトしてまずはVim中級者を目指したいと思います。


### 目先のスピードより打鍵効率を重視する

慣れた操作はスピーディーで気持ちいいものですが、それではいつまで経ってもVimmerになることはできません。  
もっと打鍵効率の良いやり方はないか? を常に考えていきます。

ここで言う『打鍵効率』とは以下をバランスよく満たすものです。

* 打鍵数が少ない
* 次の打鍵への移動距離が少ない
* 次の打鍵への移動時間が少ない


### .vimrcを育てる

最も効率よく編集ができる `.vimrc` を常に追い求めます。 

`.vimrc` を育てることには賛否両論あると思いますが、思考の速度を目指す身としてデフォルトにこだわらない方針をとります。  
もちろんAutoHotKeyのキーバインディングとも連携しますよ。


### IDEにVimプラグインを使う

開発をしているとIDEを使わないことはありません。  
Vimで頑張るのも一興ですが個人開発ではないためちゃんとしたIDEを使うべきだと考えています。

私は普段IntelliJ IDEAを使用しているので、IDEAのVimプラグインを使用することにしました。

{{<summary "https://github.com/JetBrains/ideavim">}}

JetBrains公式であり、かなり高機能のためVS Codeのように中途半端にはならないと考えています。


総括
----

新年の抱負と、Vimmerになるための心がけ5箇条を掲げてみました。

目標の実現にあたり、印象に残った内容はVimシリーズの記事として書きたいと思います。


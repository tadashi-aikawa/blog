---
title: "日本語入力関連で困ること"
slug: trouble-japanese-ime
date: 2017-12-12T07:26:00+09:00
thumbnailImage: images/cover/2017-12-12.jpg
categories:
  - engineering
tags:
  - windows
  - ubuntu
---

日本語入力関連で毎回困ることの解決方法をまとめてみました。

<!--more-->

{{<cimg "2017-12-12.jpg">}}

<!--toc-->


Ubuntu
------

Ubuntu16.04で動作を確認しています。

### Mozcで常にスペースを半角にしたい

1. `コンピュータを検索`で`Mozcの設定`を検索しクリック
2. `一般`タブの`スペースの入力`を`半角`にする


Windows
-------

Windows10で動作を確認しています。

### `Ctrl+Shift`で日本語入力が切り替わるのをやめて欲しい

私はATOKを使っていますので、Microsoft IMEを無効にするやり方を紹介します。

まずはWindowsメニューから`言語とキーボードのオプション`を選択します。

{{<vimg "resources/20171212_1.png">}}

次に`地域と言語`から`日本語`をクリックし、表示された`オプション`を選択します。  
クリックしないとボタンが表示されないのが非常に分かりにくいですね...

{{<himg "resources/20171212_2.png">}}

更にその中で、`Microsoft IME`を削除します。

{{<himg "resources/20171212_3.png">}}

これで日本語入力の切り替えを防ぐ事ができます。


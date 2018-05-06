---
title: "HaskellでHello World"
date: 2018-05-07T03:30:00+09:00
thumbnailImage: http://t2.gstatic.com/images?q=tbn:ANd9GcQSqSxnXvtRfV1hALfAHqluQjSB3tegivfSAplaZMmW9ZqqF0dU
categories:
  - engineering
tags:
  - haskell
---

昨年の話になりますが、すごいHaskell本を読んでHaskellのファンになりました。  
今回はHaskellの始め方を簡単に紹介します。

<!--more-->

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #000000;background-color:#FFFFFF;width:410px;margin:0px;padding-top:6px;text-align:center;overflow:auto;"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F11709735%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fbook%2Fi%2F15889490%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" rel="nofollow" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=15889490&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F8850%2F9784274068850.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F8850%2F9784274068850.jpg%3F_ex%3D400x400&s=400x400&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F11709735%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fbook%2Fi%2F15889490%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" rel="nofollow" style="word-wrap:break-word;"  >すごいHaskellたのしく学ぼう！ [ ミラン・リポヴァチャ ]</a><br><span >価格：3024円（税込、送料無料)</span> <span style="color:#BBB">(2018/5/7時点)</span></p></div><br><p style="font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

<!--toc-->


はじめに
-------

Windows上のVirtualboxで稼働しているUbuntuという前提で環境構築します。  
また、本記事の内容は以下の公式ドキュメント(2018/05/07時点)とほぼ同じ内容になります。

{{<summary "https://docs.haskellstack.org/en/stable/README/#how-to-install">}}


Haskellのインストール
---------------------

いきなりIDEを使うと基本が疎かになるため、今回は素のHaskellを使います。  
Haskellの前にまずstackをインストールします。


```
$ curl -sSL https://get.haskellstack.org/ | sh
$ stack --version
Version 1.7.1, Git revision 681c800873816c022739ca7ed14755e85a579565 (5807 commits) x86_64 hpack-0.28.2
```


プロジェクトの作成
------------------

stackでプロジェクトを作成します。

```
$ stack new haskell-hello
```

`haskell-hello`ディレクトリ配下に以下のエントリが作成されます。

```
.
├── app
│   └── Main.hs
├── ChangeLog.md
├── haskell-hello.cabal
├── LICENSE
├── package.yaml
├── README.md
├── Setup.hs
├── src
│   └── Lib.hs
├── stack.yaml
└── test
    └── Spec.hs
```


プロジェクトに必要なモノの準備
------------------------------

必要なバージョンのコンパイラ(ghc)などを取得します。

```
$ stack setup
```

ghcのダウンロードは回線速度が遅いと時間がかかります。


ビルド
------

ビルドして実行ファイルを作成します。

```
$ stack build
```

ファイルは`./.stack-work/install/x86_64-linux/lts-11.7/8.2.2/bin/haskell-hello-exe`というような深い場所に作成されます。


使ってみる
----------

上記ファイルを指定する必要はありません。`stack exec`コマンドを使います。

```
$ stack exec haskell-hello-exe
someFunc
```


Hello World
-----------

出力をHello Worldに変えてみましょう。  
エントリポイントの`app/Main.hs`を開きます。

```haskell
module Main where

import Lib

main :: IO ()
main = someFunc
```

`Lib`の`someFunc`が呼び出されていますので、`src/Lib.hs`を開きます。

```haskell
module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"
```

putStrLnが第1引数を出力していますので、`someFunc`を`Hello World`に変えてみましょう。

```haskell
module Lib
    ( someFunc
    ) where
someFunc :: IO ()
someFunc = putStrLn "Hello World"
```

これで`stack exec haskell-hello-exe`を実行すると出力が変わっています。

※ なぜbuildナシで結果が変わるのかはまだ分かっていません..


総括
----

Haskellをインストールし、プロジェクトを作成してHello Worldするところまでやってみました。  
今後はHaskellの気になるところをピックアップして飛び飛びに紹介したいと思っています。


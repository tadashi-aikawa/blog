---
title: "Pythonライブラリの挙動をすぐ確かめる方法"
slug: python-library-light-check
date: 2018-05-21T02:55:00+09:00
thumbnailImage: images/cover/2018-05-21.jpg
categories:
  - engineering
tags:
  - python
  - pipenv
---

Pipenvを使ってPythonライブラリの挙動を気軽に確かめる方法を紹介します。  

<!--more-->

{{<cimg "2018-05-21.jpg">}}

<!--toc-->


経緯
----

開発中に依存ライブラリに不具合がある気がしたことはありませんでしょうか。  
OSSを使用して開発をしていれば誰もが1度は経験していると思います。

Python開発中にもライブラリの不具合を疑ったことがあります。
しかし、GoogleやGitHubのIssueを探してもそれらしき内容は見当たりません。

一番確実な手段として、インストールしたPythonライブラリを直接調べる方法があります。。  
エラーメッセージからの問題の箇所が特定できていれば、print文やコメントアウトで挙動の違いを確認するだけでも得られるものは多いです。

しかし、仮想環境内にある該当ライブラリのソースコードを開くのが面倒に感じたことがあるのではないでしょうか。  
本記事ではPipenvを使っている場合を想定して、上記の面倒を解決する方法を紹介します。


Pipenvとは
----------

Pipenvをご存知ない方のために簡単に紹介します。

{{<summary "https://github.com/pypa/pipenv">}}

PipenvはPythonのパッケージング管理ツールです。  
使い勝手はnpmに近く、Pipで感じる不満をほぼ全て解決してくれます。

Pipenvの紹介ページ冒頭に以下のように書かれているだけのことはあります。非常に使いやすい:smile:

> Pipenv is a tool that aims to bring the best of all packaging worlds (bundler, composer, npm, cargo, yarn, etc.) to the Python world. Windows is a first-class citizen, in our world.

本記事ではPipenvの使い方は説明しませんが、Pipenvの仮想環境が作成されている前提で進めます。


pipenv open
-----------

いきなり結論です。  
[`pipenv open <MODULE>`コマンド](https://docs.pipenv.org/#pipenv-open)を使うと指定したモジュールのソースコードを開くことができます。

モジュールなのでパスが通っていればインストールしたライブラリのモジュール、現在のプロジェクト配下にあるモジュール、Localにある別のモジュール、標準モジュールの全てを参照することができます。

例えば、`requests`モジュールのソースコードを見たい場合は`pipenv open requests`でOKです。  
`pipenv open os.path`で`os.path`モジュールのソースコードを閲覧できます。

後はprint文を仕込んだり、一部処理をコメントアウト/変更して問題の原因を確認しましょう。


総括
----

PythonモジュールのソースコードをPipenvを使って簡単に開く方法を紹介しました。

知らないけど便利な機能がまだPipenvにはありそうなのでまた調べてみます。


---
title: MkDocsでmarkdownなサイト作り
slug: create-site-markdown-by-mkdocs
date: 2019-07-14T13:37:26+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/c2qdld24ynb7boz/emiliano-vittoriosi-aTHqiz_sosU-unsplash.jpg
categories:
  - engineering
tags:
  - mkdocs
  - python
  - markdown
---

[MkDocs]を使って、Markdownがメインのポートフォリオ/ノウハウサイトを作成してみました。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/c2qdld24ynb7boz/emiliano-vittoriosi-aTHqiz_sosU-unsplash.jpg"/>

<!--toc-->


作成したもの
------------

作成したサイトとGitHubのリポジトリは以下です。

### サイト

{{<summary "https://mimizou.mamansoft.net/">}}

### リポジトリ

{{<summary "https://github.com/tadashi-aikawa/mimizou-room/">}}


経緯
----

### アウトプットの先

学びをアウトプットすることは大事です。  
私の場合はアウトプットとして、このブログに投稿していました。

しかし、ブログを書くまでも必要ないアウトプットもあります。

* 参考リンクを貼るだけで解決する場合 (公式の最新を見た方が信頼できる)
* インターネット上で既に似たような情報が多数見受けられる場合

このようなケースをどう扱うか悩んでいました。

### GitHubのリポジトリにノウハウを

GitHubはインターネットからアクセスでき、全文検索も可能です。  
ブログを書く必要のないものはGitHubのリポジトリにまとめていました。

しかし、しばらく使っていると以下の要望が出てきました。

* GitHub Markdown以上のリッチな機能を使いたい
* 自身の経歴などを記載したポートフォリオサイトにもしたい

そうなるとサイトジェネレータが必要になってきます。

### サイトジェネレータの要件

必要な要件は以下の7点でした。

1. 全文検索ができる
2. マクロ構文が使える
3. 追尾型の見出しに対応している
4. デザインが格好いい
5. 基本的にMarkdownで完結する
6. バージョン管理できる
7. レスポンシブ対応(スマホ対応)

本ブログで利用している[Hugo]も検討しましたが、条件1,3でハマッたため断念しました。

### MkDocsを使えば..

そんなとき、[Jumeaux]で利用している[MkDocs]を思い出しました。

[Jumeaux]はPython製であるため、同じPython製のサイトジェネレータとして、ツールのドキュメント作成に選定したものです。  
この[MkDocs]が先ほど挙げた7つの要件を全て満たしていました。

しかも、最近Version1.0になっていたのです😮


MkDocsとは
----------

プロジェクト文書の構築を目的としてサイトジェネレータです。  
ドキュメントソースはMarkdownを..設定は単一のYAMLファイルを使います。

{{<summary "https://www.mkdocs.org/">}}

[MkDocs]ではテーマやプラグインが利用できます。


Material for MkDocs
-------------------

見た目が好みで機能も抱負だったため、[Material for MkDocs]というテーマを使用しています。

{{<summary "https://squidfunk.github.io/mkdocs-material/">}}

[Material for MkDocs]は抱負なExtentionにも対応しています。  
以下のExtentionを利用しています。

|      Extention名      |                          説明                          |
| --------------------- | ------------------------------------------------------ |
| [Admonition]          | Info, Warning, Errorなど                               |
| [CodeHilite]          | ソースコードのハイライト表示                           |
| [Footnotes]           | 注釈                                                   |
| [Permalinks]          | パーマリンクを埋め込み                                 |
| [PyMdown.MagicLink]   | URLなどを自動でリンク化                                |
| [PyMdown.Details]     | [Admonition]を折りたたみ可能にする                     |
| [PyMdown.SuperFences] | [Admonition]の中でもcode fence blockが使えるようにする |

[Admonition]: https://squidfunk.github.io/mkdocs-material/extensions/admonition/
[CodeHilite]: https://squidfunk.github.io/mkdocs-material/extensions/codehilite/
[Footnotes]: https://squidfunk.github.io/mkdocs-material/extensions/footnotes/
[Permalinks]: https://squidfunk.github.io/mkdocs-material/extensions/permalinks/
[PyMdown.MagicLink]: https://squidfunk.github.io/mkdocs-material/extensions/pymdown/#magiclink
[PyMdown.Details]: https://squidfunk.github.io/mkdocs-material/extensions/pymdown/#details
[PyMdown.SuperFences]: https://squidfunk.github.io/mkdocs-material/extensions/pymdown/#superfences


要件について
------------

先ほど挙げた要件は以下のように満たせます。

### 1. 全文検索ができる

[Material for MkDocs]は検索も提供しています。  
他にpluginを使っていなければ特別な設定はいりません。

もし日本語を使う場合は`mkdocs.yml`の`extra.search.language`に設定が必要です。

```yaml
extra:
  search:
    language: 'en, ja'
```

### 2. マクロ構文が使える

プラグインを使うと、Pythonを利用したマクロが定義できます。

{{<summary "https://github.com/fralau/mkdocs_macros_plugin">}}

この話をすると長くなるため、別の機会に紹介させてください。

{{<info "Mimizou Roomで使っているマクロのイメージ">}}
以下のようなMarkdownを書くと

https://raw.githubusercontent.com/tadashi-aikawa/mimizou-room/master/docs/IT_Note/tools/mkdocs/index.md

以下のページのようになります。

https://mimizou.mamansoft.net/it_note/tools/mkdocs/
{{</info>}}

### 3. 追尾型の見出しに対応している

デフォルトで使用できます。

### 4. デザインが格好いい

[Material for MkDocs] カッコイイ( ´▽｀)

### 5. 基本的にMarkdownで完結する

一部、特殊表記もありますが基本はMarkdownです。

新しくファイルやディレクトリを追加しても、設定(`mkdocs.yml`)を変更する必要はありません😄

### 6. バージョン管理できる

GitHubで管理しています。

### 7. レスポンシブ対応(スマホ対応)

[Material for MkDocs]は対応しています👍


ビルド
------

### 開発中

```
$ mkdocs serve
```

localhostとポート番号をアクセスして確認できます。  
ファイルを変更すると自動でリロードします。

`--dirtyreload`オプションを指定すると、変更時に影響あるファイルだけリビルドします。  
見出しが一部バグりますが、それさえ許容出来れば確認速度が上がります。

### 本番用

```
$ mkdocs build
```

`site`ディレクトリに成果物ができます。


デプロイ
--------

`site`ディレクトリをpublishして終わりです。

私のサイトでは[Netlify]を使っています。

{{<file "netlify.toml">}}
```toml
[build]
command = "mkdocs build"
publish = "site"
```
{{</file>}}



総括
----

[MkDocs]を使って、Markdownがメインのサイトを作成するノウハウを紹介しました。

記事内にもあったように、マクロの部分は別の機会で紹介させていただければと思います。

Mimizou Roomには[MkDocs]に関する情報も記載しています。

{{<summary "https://mimizou.mamansoft.net/it_note/tools/mkdocs/">}}

よろしければ覗いてみてください😃


[MkDocs]: https://www.mkdocs.org/
[Qiita]: https://qiita.com/
[Hugo]: https://gohugo.io/
[Jumeaux]: https://tadashi-aikawa.github.io/jumeaux/
[Material for MkDocs]: https://squidfunk.github.io/mkdocs-material/
[Netlify]: https://www.netlify.com/
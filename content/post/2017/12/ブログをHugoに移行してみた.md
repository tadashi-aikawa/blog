---
title: "ブログをHugoに移行してみた"
date: 2017-12-01
thumbnailImage: https://dl.dropboxusercontent.com/s/enzavilsafwyk5b/20171201_1.png
categories:
  - engineering
tags:
  - wordpress
  - hugo
  - blog
---

ブログをWordpressからHugoに移行しました。

<!--more-->

<blockquote class="embedly-card"><h4><a href="https://gohugo.io/">A Fast and Flexible Website Generator</a></h4><p>The world's fastest framework for building websites</p></blockquote>

<!--toc-->


はじめに
--------

以下の内容を実施したときWordpressが再起不能になってしまいました。  

<blockquote class="embedly-card"><h4><a href="https://blog.mamansoft.net/docker%E3%82%92%E8%B7%A1%E5%BD%A2%E3%82%82%E7%84%A1%E3%81%8F%E6%B6%88%E3%81%97%E3%81%A6%E5%85%A5%E3%82%8C%E7%9B%B4%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F/">Dockerを跡形も無く消して入れ直してみた</a></h4><p>以下の理由からDockerを最新にしてみました。 サーバの容量が無くなってきた DockerのImageやContainerが管理しきれなくなってきて消した ブログ(Wordpress)のコンテナが再帰不能になった</p></blockquote>


頑張れば別の手段で復旧することはできると思います。  
ただ、2010年頃からずっとWordpressを使い続けており、世の中の流れも変わってきているのでWordpressをやめることにしました。


静的サイトジェネレータ
----------------------

CMSではWordpressの他にいくつか選択肢があります。  
しかし、今は優れた静的サイトジェネレータが多数存在しており、そちらに乗り換えた方が有意義に感じました。

### 静的サイトジェネレータのメリット

エンジニアにとっては嬉しいポイントが多いです。

* データベースが不要 (静的ファイルのみで構成されるため)
* 表示速度がCMSより早い (ことが多い)
* ブログまるごとGitで管理できる
* セキュリティに強い

プログラミングに馴染みが無い方にはキツイかもしれませんが...

### 静的サイトジェネレータのデメリット

エンジニアでない方にはこの辺がネックになるかもしれませんね。

* 複数人のサイト管理がしにくい
* 動的コンテンツを配置するには別サービスを使用する必要がある
* GUIによる設定などができない

エンジニアが個人ブログを書く分には、どうでもいいものばかりです。


Hugo以外の静的ジェネレータ
--------------------------

代表的な静的ジェネレータとして、Hugoと比較されるものがあります。

### Jekyll

Pythonで作られており、GitHubが開発しています。  
そのせいもあってGitやGitHub Pagesとの連携は抜群らしいです。

<blockquote class="embedly-card"><h4><a href="https://jekyllrb.com/">jekyll</a></h4><p>Transform your plain text into static websites and blogs</p></blockquote>

### Hexo

NodeJSで開発されています。

<blockquote class="embedly-card"><h4><a href="https://hexo.io/">Hexo</a></h4><p>Hexo is a fast, simple & powerful blog framework powered by Node.js.</p></blockquote>


Hugoに決めた理由
----------------

Hugoに決めた最大の理由は、静的ファイルの生成速度です。

正直言うと、JekyllとHexoは実際に試していません。  
ただ、ブログなどで紹介されたベンチマークを見る限り、差は一目瞭然でしたのでHugoにしました。

特に記事を書きながらプレビューを確認する時は速度が大事です。


実際に書いてみて
----------------

Wordpressから移行して良かったと感じることです。

* 標準環境でMarkdownが使える
* Localでプレビューを見ながら記事を作成/編集できる
* Wordpressサーバのことを気にする必要がない
* バックアップのことを気にする必要がない (GitHubなので)
* Shortcodesが便利

ShortcodesはHTMLのスニペットを作成することができる機能です。  
機会があれば別の記事で紹介します。

<blockquote class="embedly-card"><h4><a href="https://gohugo.io/content-management/shortcodes/">Shortcodes</a></h4><p>CONTENT MANAGEMENT Shortcodes are simple snippets inside your content files calling built-in or custom templates. Hugo loves Markdown because of its simple content format, but there are times when Markdown falls short. Often, content authors are forced to add raw HTML (e.g., video ) to Markdown content.</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

今のところ、Wordpressの方が良かったと感じることはありません。


総括
----

ブログをWordpressからHugoに移行した概要を記事にしてみました。  

今は存在しない以前の記事については、移行する価値があるものだけ移行しようと思います。

---
title: "とりあえずブログ内記事を検索するには"
slug: search-in-blog-quickly
date: 2018-05-28T04:25:00+09:00
thumbnailImage: images/cover/2018-05-28.jpg
categories:
  - other
tags:
  - blog
  - 情報収集
  - google
---

ブログの記事が増えてきたので、そろそろブログ内フリーワード検索を追加したいと思ってます。  
しかし、一筋縄ではいかないので特定のサイト内をGoogle検索する方法を紹介します。

<!--more-->

{{<cimg "2018-05-28.jpg">}}

<!--toc-->


経緯
----

本ブログはHugoで作っています。  
Hugoを選んだ理由は以下の記事で紹介しています。

{{<summary "https://blog.mamansoft.net/2017/12/01/migrate-blog-by-hugo">}}

Hugoのテーマとは tranquilpeakを使っています。

{{<summary "https://github.com/kakawait/hugo-tranquilpeak-theme">}}

しかしtranquilpeakには検索機能は付いていません。  
JavaScriptのライブラリを使い、indexを作成して自作する方法もありますがそこまでやりたくありませんでした。


サイト内Google検索
------------------

Google検索には特定のホスト配下を検索する機能があります。  
検索するフリーワードに`site:<ホスト名>`を指定するだけです。

例えば、本ブログでHaskellのフリーワード検索をする場合は`site:blog.mamansoft.net Haskell`で検索できます。

{{<summary "https://www.google.co.jp/search?num=50&ei=5AYLW_T6NYbQ0gT5vb3YAQ&q=site%3Ablog.mamansoft.net+Haskell&oq=site%3Ablog.mamansoft.net+Haskell&gs_l=psy-ab.3...90648.93141.0.93229.14.10.4.0.0.0.149.928.0j7.7.0....0...1c.1.64.psy-ab..3.0.0....0.N4KP6METZ5M">}}

検索結果には関係性の低いページ(categoriesやtags)もヒットしますが、関係性の高いページが先に表示されるので問題ありません。


カスタム検索エンジン
--------------------

Googleのカスタム検索エンジンを使用すれば、ブログのHTMLにパーツを配置するだけでサイト内にGoogle検索を設置することができます。  
以下の理由から現在は実装を見送っています。

* テーマに手を加える以外の方法を思いつかなかった (できればforkしたくない)
* サイトのデザインが損なわれる
* 検索結果の広告量が多い

ブログ内検索を利用される方はある程度常連の方であり、そうであればサイト内Google検索でも問題ないかなと判断しています。


総括
----

ブログ内検索をするため、ホスト指定でGoogle検索する方法を紹介しました。  
上記の問題が解決したら、ブログ内に検索バーを埋め込む日が来るかもしれません。


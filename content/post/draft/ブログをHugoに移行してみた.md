---
title: "ブログをHugoに移行してみた"
date: 2017-12-01
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

プログラミングに馴染みが無い方にはキツイかもしれませんが、エンジニアにとっては願ったり叶ったりです。

* データベースが不要 (静的ファイルのみで構成されるため)
* 表示速度がCMSより早い (ことが多い)
* ブログまるごとGitで管理できる


総括
----

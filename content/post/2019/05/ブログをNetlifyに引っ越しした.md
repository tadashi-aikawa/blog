---
title: ブログをNetlifyに引っ越しした
slug: migrate-blog-to-netlify
date: 2019-05-16T07:41:49+09:00
thumbnailImage: https://cdn.svgporn.com/logos/netlify.svg
categories:
  - engineering
tags:
  - netlify
---

さくらVPSのサーバー上にNginx in Dockerでデプロイしていた本ブログを[Netlify]に移行しました。

<!--more-->

<img src=""/>

<!--toc-->


経緯
----

さくらVPSのサーバが2019-05-15の夕方頃、マイニングマルウェアに感染しました。

ブログへアクセスできず、起動のためサーバのプロセスを確認したときに気付きました。  
`databog`というプロセスがCPUを300%使っていました。

ランサムウェアやトロイの木馬に比べると、情報漏洩などが行われた可能性は低いです。  
しかし、プロセスのkillをしても立ち上がり続け、cronを削除しても自動で追記されていました。

調べたところ、原因の特定と削除は困難なためサーバの初期化が推奨されていました。


なぜNetlifyか
-------------

[Netlify]はモダンなWebプロジェクトを、ビルドやデプロイのフローも含めて管理できるSaaSです。

{{<summary "https://www.netlify.com/">}}

他の代替案としてはAWS S3を考えていましたが、以下の理由で[Netlify]にしました。

* CDNやGitHubと連携したCIがサービスに含まれる (ADN)
* [以前の記事](https://blog.mamansoft.net/2019/02/09/github-viewer-change-pwa/)で[Netlify]を使ったときに使いやすかった
* 無料範囲内に収まる


なぜ初期化をしなかったか
------------------------

以下が理由です。

* 初期化後の再構築が面倒だった (Infrastructure as Codeになっていない)
* 再構築しても再びアタックされる恐れがあった
* 健全なサーバ管理に限界を感じ、サーバレスで全てを運用しようか迷っていた
  * jenkinsユーザが乗っ取られたので、Jenkinsのプラグイン経由である可能性がある
* CIサーバを自前で用意しなくても何とかなりそう (個人開発でしか使っていないため)

問題意識を感じていたところにちょうど事件が発生した... というところです。


移行作業でやったこと
--------------------

以前の記事にも記載のとおり[Netlify]の作業は簡単です。  
スクリーンショットを交える必要もないので、主な対応を箇条書きにしてみました。

### デプロイするまで

1. Netlifyにプロジェクトを追加
  * 今回: https://github.com/tadashi-aikawa/blog
2. GitHubの`Application`で上記リポジトリをNetlify連携できるようにする

この状態でリポジトリにpushすると自動でビルド/デプロイされます。  
この作業にかかる時間は数分です。

### ドメインの向き先を変える

1. Netlifyの`Domain management`にブログのドメインを追加
  * 今回: blog.mamansoft.net
2. ドメインプロバイダの管理画面からドメインのCNAMEレコードにNetlifyのホストを追加
  * 今回: ムームードメインに
    * サブドメイン: `blog`
    * 種別: `CNAME`
    * 内容: `...netlify.com`

この作業にかかる時間は数分です。

### HTTPS対応

１. Netlifyの`Domain management`で`SSL/TLS certificate`がOKになるのを待つ

[Netlify]がLet' Encryptを使って証明書を取得してくれます。  
指定ドメインで名前解決できるようになるまで待機する必要があり、今回の場合1～2時間ほど待ちました。

以前は自分で管理していたため、全てやってくれるのは楽ちんですね😄


総括
----

さくらVPSを解約して、[Netlify]にブログを引っ越ししました。

問題に気付いてから1時間程度で引っ越しできたのは[Hugo]のおかげです。
Wordpressから引っ越ししておいて良かったです。

Hugoから引っ越しした記事は下記になりますので、宜しければそちらもご覧下さい。

{{<summary "https://blog.mamansoft.net/2017/12/01/migrate-blog-by-hugo/">}}

[Netlify]: https://www.netlify.com/
[Hugo]: https://gohugo.io/

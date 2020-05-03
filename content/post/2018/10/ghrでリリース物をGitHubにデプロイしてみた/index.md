---
title: ghrでリリース物をGitHubにデプロイしてみた
slug: ghr-deploy-to-github
date: 2018-10-22T03:05:02+09:00
thumbnailImage: https://cdn.svgporn.com/logos/github-icon.svg
categories:
  - engineering
tags:
  - github
---

GitHubのreleasesページにワンコマンドでリリース物をデプロイする方法を紹介します。

<!--more-->

{{<cimg "https://cdn.svgporn.com/logos/github-icon.svg">}}

<!--toc-->


経緯
----

最近Go言語で開発を始めた影響で、GitHubのreleasesページにリリース物をデプロイする機会が出てきました。  
例えば以下のようなページです。

{{<summary "https://github.com/tadashi-aikawa/miroir-cli/releases">}}

これを手動で行うのは少々面倒です。以下の手順を行わなければいけません。

1. releasesページを開く
2. リリース物をデプロイするバージョン(タグ)のページを開く
3. 2の編集画面を開く
4. 添付ファイルにリリース物を添付する
5. バージョンページを保存する

これらを自動化する方法を探してみたところghrというツールを見つけました。


ghr
---

### ghrとは

GitHubリリースページの作成とリリース物のアップロードを平行で実行するツールです。

{{<summary "https://github.com/tcnksm/ghr">}}

### 使い方

READMEに記載の通りですが、`v0.12.0`時点では以下を実施しました。  
グローバル環境にインストールします。

```
$ go get -u github.com/tcnksm/ghr
```

[miroir-cli]の場合、例えば以下のように実行します。

```
$ ghr v0.4.1 dist
```

v0.4.1のタグと関連するReleasesコンテンツが作成されます。添付された成果物と一緒に。

このときカレントディレクトリの構成は以下の様になっています。

```
dist
└── miroir-0.4.1-x86_64-linux.tar.gz
```

総括
----

ghrを使ってGitHubにリリース物をデプロイする方法を紹介しました。  
GitHub APIを意識しなくても1コマンドで実行できるので非常に便利だと思います。


[miroir-cli]: https://github.com/tadashi-aikawa/miroir-cli

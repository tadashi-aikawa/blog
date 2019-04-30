---
title: GitHub上でコードリーディングの効率を上げるExtension
slug: extensions-to-code-reading-efficient-on-github
date: 2019-02-22T20:26:06+09:00
thumbnailImage: https://lh3.googleusercontent.com/nYhPnY2I-e9rpqnid9u9aAODz4C04OycEGxqHG5vxFnA35OGmLMrrUmhM9eaHKJ7liB-=w300
categories:
  - engineering
tags:
  - google-chrome
  - github
  - sourcegraph
---

GitHubをより快適に使うため、Google Chrome Extensionをいくつか追加してみました。

<!--more-->

<img src="https://lh3.googleusercontent.com/nYhPnY2I-e9rpqnid9u9aAODz4C04OycEGxqHG5vxFnA35OGmLMrrUmhM9eaHKJ7liB-=w300"/>

<!--toc-->


背景
----

エンジニアリングをしているとGitHubでREADMEやソースコードを見る機会は少なくないと思います。  
しかし、WebページのGitHubだけでは不便に感じることがありました。

* READMEのTOCが無い / 見にくい
* ファイルツリーの構成が分かりにくい
* 定義や宣言に移動したり、参照箇所の確認ができない

これらの課題を解決するため、いくつかのExtensionを取り入れてみました。


Smart TOC
---------

ページの見出しを解析して、TOCを生成するExtensionです。

{{<summary "https://chrome.google.com/webstore/detail/smart-toc/lifgeihcfpkmmlfjbailfpfhbahhibba">}}

GitHubに限らず見出しが整理されたサイトであればどこでも使えるという特徴があります。


### VSCodeリポジトリのREADMEを使った例

GitHubのREADMEをこんな感じに閲覧できます。  
私の環境では`Ctrl+E`をTOC表示/非表示に割り当てています。

{{<mp4 "https://dl.dropboxusercontent.com/s/4i7eapt5s9n3v4b/20190222_1.mp4">}} 

このExtensionの素晴らしい点は以下2点に尽きます。

* 参照側でTOCを作成できる (ドキュメント作成者は見出しさえちゃんと定義できていればよい)
* 自動追尾型のTOC

{{<error "No article/headings are detected.">}}
このエラーが出てTOCを生成出来ない場合があります。  
原因は不明ですが、以下を観測しています。

* h2ヘッダ以降が存在しないとき (h1ヘッダのみの場合も含む)
* iframeを利用したページが含まれているとき
{{</error>}}


Octotree
--------

GitHubのファイルツリーを表示してくれるExtensionです。

{{<summary "https://chrome.google.com/webstore/detail/octotree/bkhaagjahfmjljalopjnoealnfndnagc?hl=en-US">}}


### VSCodeリポジトリでの表示例

ファイルツリーは現在表示中のファイル位置と同期します。  
私の環境では`Ctrl+Shift+S`をツリーの表示/非表示に割り当てています。

{{<himg "https://dl.dropboxusercontent.com/s/v6sva33un11lqc0/20190222_2.png">}}


Sourcegraph
-----------

Sourcegraphというサービスと連携するプラグインです。  
GitHub上のコードに対して『定義や宣言に移動』『参照箇所へ移動』といったIDEのような機能を提供します。

{{<summary "https://chrome.google.com/webstore/detail/sourcegraph/dgjhfomjieaadpoljlnidmbgkdffpack">}}

今のところ対応言語は以下のみとなっているようです。

* Go
* Java
* TypeScript
* Python

私の三大言語は『Go』『TypeScript』『Python』なのでノープロブレムです😙


### Gowlリポジトリでの利用例

私がGoで開発しているGowlリポジトリでの利用例です。

{{<mp4 "https://dl.dropboxusercontent.com/s/j7mftjq2fh3anoe/20190222_3.mp4">}} 

GitHub上のソースコードから定義や宣言に移動できます。  
少しindex作成などの時間が取られますが、ローカルへCloneしたりpackageのインストールナシでジャンプできるのは素晴らしいですね😄

参照箇所への移動をする際は呼び出し元が2つ以上の場合、Sourcegraph本体に移動します。

{{<summary "https://sourcegraph.com">}}

コードを参照したり検索する用途に限って言えば、本家GitHubより優れていると思いました。  
そもそもSourcegraphが無ければこのExtensionも存在しませんし。

ファイルツリーが現在のファイル以降しか見られなかったり、ショートカットキーでファイル検索できなかったりというところもありますが...

{{<info "Gowlについて">}}
せっかくなので宣伝です😄

GowlはGitリポジトリ管理便利ツールです。  
Windows/Linux問わず、ターミナルから効率性を重視した現実的な機能を使えますので是非試してみてください。

{{<summary "https://github.com/tadashi-aikawa/gowl">}}

作成時の記事は以下です。

{{<summary "https://blog.mamansoft.net/2018/09/24/go-git-structual-cli-create/">}}
{{</info>}}


総括
----

GitHubでのコードリーディング効率を上げるGoogle Chrome Extensionを紹介しました。

OSSプロダクトを利用して問題が起きたとき、手元で環境構築してから調査するのは大きな心理的ハードルです。  
そのハードルを少しでも低くすることで、OSSの世界が一層活発になれば嬉しい限りです。

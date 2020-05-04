---
title: StackBlitzを使ってみた
slug: use-stackblitz
date: 2018-12-02T00:19:49+09:00
thumbnailImage: images/cover/2018-12-02.jpg
categories:
  - engineering
tags:
  - editor
  - github
---

StackBlitzという便利なサービスを使ってみました。

<!--more-->

{{<cimg "2018-12-02.jpg">}}

<!--toc-->


StackBlitzとは
--------------

StackBlitzはWebアプリケーションの為のオンラインIDEです。  
VSCodeベースで作成されているようです。

{{<summary "https://stackblitz.com/">}}

1クリックでいきなり開発を始められるので、動作確認環境として非常にオススメです。

ドキュメントは以下です。

{{<summary "https://stackblitz.com/docs#upload-from-your-computer">}}


使い方
-----

### プロジェクトの作成

Topページに有名な言語やフレームワークの案内がされています。  
ボタンを押すとプロジェクトが作成されてIDEが開きます。

例えばReactを押すと次のような画面になります。

{{<himg "resources/20181203_1.png">}}

ファイルを変更すると、リアルタイムにビルド/実行されます。


### 依存packageの追加

Webエディタでは依存packageが制限されていることが多いですが、StackBlitzは心配いりません。  
動作に必要なpackageがインストールされていないと以下の画面が表示されます。

{{<himg "resources/20181203_2.png">}}

するとpackageがインストールされて使用できるようになります。  
インストールしたpackageは左側に表示されます。

{{<himg "resources/20181203_3.png">}}

packageはDEPENDENCIESのフォームからもインストールできます。


### プロジェクトの共有

URLを教えると別の人にプロジェクトを共有できます。  
共有前にSaveを忘れないで下さい。

{{<himg "resources/20181203_4.png">}}

共有したプロジェクトを勝手に変更されることはありません。  
逆に他人から共有されたプロジェクトに変更を加えて保存するにはForkが必要です。

先ほど作成したプロジェクトの共有URLは以下になります。

https://stackblitz.com/edit/react-upyqot

埋め込み用のURLをiframeに指定すると、本文に埋め込むこともできます。

<iframe src="https://stackblitz.com/edit/vue-file-load?embed=1&file=index.js" width="100%" height=480></iframe>

ブログでソースコードと動作を紹介したいときに便利ですね :smile:


### プロジェクトのインポート

GitHubのリポジトリをプロジェクトとしてインポートできます。

インポートするには`https://stackblitz.com/github/<ユーザ名>/<リポジトリ名>`にアクセスします。  
しかもGitHubのリポジトリが更新されれば、上記StackBlitzプロジェクトも追従します。

{{<warn "対応プロジェクトの制限">}}
2018/12/19現在では`angular/cli`と`create-react-app`によって作られたプロジェクトしか対応していません。

> We currently support projects using @angular/cli and create-react-app. Support for Ionic, Vue, and custom webpack configs is coming soon!
{{</warn>}}


### プロジェクトのエクスポート

`Download Project`ボタンを押すとプロジェクトをzipでダウンロードできます。

{{<himg "resources/20181203_5.png">}}

zipを解凍して依存パッケージをダウンロードすればローカルで開発を続けることが可能です。



GitHubアカウントとの連携
------------------------

GitHubアカウントを持っている場合は`Sign in`できます。

{{<himg "resources/20181203_6.png">}}

`Sign in`すると以下のようにアカウントに紐づく形で管理できます。

{{<himg "resources/20181203_7.png">}}

> These are your StackBlitz projects. You'll soon be able to sync them to Github repos! Learn more.

今後はStackBlitzで作成したプロジェクトから、ワンクリックでGitHubリポジトリに同期できるのでしょうか.. 楽しみですね :smile:


総括
----

Webアプリケーションの為のオンラインIDEであるStackBlitzを使ってみました。  
以下のようなシーンに向いていると思います。

* Web開発に慣れていない人とのモブプロ
* 初心者向け勉強会
* コンポーネントの開発
* ブログの記事作成
* ライブラリのドキュメント作成
* ノウハウ/スニペット集

最後に私がTypeScriptの動作確認をする為に使用しているプロジェクトを晒しておきます。

https://stackblitz.com/edit/typescriptsandbox

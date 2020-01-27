---
title: NuxtのElectron Packageができない
slug: cannot-package-election-with-nuxt
date: 2020-01-28T01:16:47+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/8r68v9viivvqhb3/gokil-I_p6V-AAqhU-unsplash.jpg
categories:
  - engineering
tags:
  - nuxt
  - typescript
  - electron
---

以前に執筆した記事の内容ではElectronのPackagingができませんでした。  
本記事ではその対応を紹介します。

<!--more-->

{{<alert danger>}}
本記事では問題の原因についてほとんど触れていません。  
これは私が原因を理解できていないためです。誤解を招くため推測も載せていません。

本来は原因を含めての対策としたいのですが、Packagingのときのみに発生する事象であるため解決策の周知を優先させていただきました🙇
{{</alert>}}

<img src="https://dl.dropboxusercontent.com/s/8r68v9viivvqhb3/gokil-I_p6V-AAqhU-unsplash.jpg"/>

<!--toc-->


ElectronのPackaging
-------------------

Packagingはelectron-builderを使います。

{{<summary "https://github.com/electron-userland/electron-builder">}}


### インストール

```console
$ npm i -D electron-builder
+ electron-builder@22.3.2
```

### package.jsonの設定

`package:test`は動作確認用です。  
実際にリリースするときは`package`を使います。

```
  "scripts": {
    "package": "nuxt build && electron-builder",
    "package:test": "nuxt build && electron-builder --dir",
  }
```

エントリポイントが指定されていないため、`main.js`を指定します。

```
  "main": "main.js",
```


問題について
------------

以前に執筆した記事は下記です。

{{<summary "https://blog.mamansoft.net/2019/12/29/nuxt-typescript-electron-sqlite-project2/">}}

この記事通りに実装してPackagingしたアプリケーションを実行すると404エラーが発生します。

{{<himg "https://dl.dropboxusercontent.com/s/jlfnbrpvd44ienv/20200127_1.png">}}

`npm run dev`や`npm run build`では動いていたのに..ショッキングです😱


対策
----

開発時以外はサーバを立ち上げず、fileプロトコルで静的ファイルを参照するようにしました。

下記3ファイルを修正するとPackagingしたアプリケーションが正常に起動するはずです👍

### main.jsの修正

以下のように修正します。

```diff
 // HTTP server
 const http = require('http')
-const server = http.createServer(nuxt.render)
-server.listen()
-const _NUXT_URL_ = `http://localhost:${server.address().port}`
+let _NUXT_URL_
+
+if (config.dev) {
+  const server = http.createServer(nuxt.render)
+  server.listen()
+  _NUXT_URL_ = `http://localhost:${server.address().port}`
+} else {
+  _NUXT_URL_ = `${__dirname}/dist/index.html`
+}
+
 console.log(`Nuxt working on ${_NUXT_URL_}`)

+
 // Electron
 const electron = require('electron')
 const app = electron.app
```

### nuxt.config.jsの修正

ルーターの設定を追記します。  
デフォルトの`{ mode: 'history' }`では動作しません。

```
  router: {
    mode: 'hash'
  }
```

また、`build.extend`配下に`publicPath`の指定を追加します。

```
  build: {
    .
    .
    extend(config, ctx) {
      config.externals = { sqlite3: 'commonjs sqlite3' }

      // Fileビルドした場合のアクセス用
      config.output.publicPath = './_nuxt/';
    }
  },
```

### package.jsonの修正

`build.directories.output`にパッケージの格納先を指定します。

```
  "build": {
    "directories": {
      "output": "build"
    }
  }
```

この指定をしないと`Not allowed to load local resource`が発生します。


リポジトリ
----------

今回もタグを切っています。  
実際のコードが見たい場合はご覧下さい。

{{<summary "https://github.com/tadashi-aikawa/nuxt-electron-typescript-sqlite3/tree/20200128">}}


総括
----

過去執筆した記事をベースに、うまくPackagingできるよう修正する方法を紹介しました。

様々な問題の原因、設定の理由がハッキリ理解できていないのは心残りです..😓  
それでも困っている方のお役に立てればと思います😄

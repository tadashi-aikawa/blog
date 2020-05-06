---
title: GitHub ViewerをPWAにしてみた
slug: github-viewer-change-pwa
date: 2019-02-09T0:29:50+09:00
thumbnailImage: images/cover/2019-02-09.jpg
categories:
  - engineering
tags:
  - vue
  - nuxt
  - pwa
---

GitHub ViewerをPWA対応してみました。

<!--more-->

{{<cimg "2019-02-09.jpg">}}

<!--toc-->


PWAとは
------

Progressive Web Appsの略です。  
大きな特徴は以下2点です。

* Webをアプリのように使える仕組み
* 複数の技術の総称のようなもの

詳しい説明はSEO HACKSに載っていますので、そちらをご覧下さい。

{{<summary "https://www.seohacks.net/basic/terms/pwa/">}}


なぜPWA対応したのか
-------------------

私は毎年2回麻雀合宿を主催しています。  
更にそこで使用するシステムも自作しています。

今まで以下の理由からWebの技術(React)を使っていました。

* Android/iOSに対応するのは時間的に厳しい (Webならとりあえずなんでも動く)

また、実際に運用すると課題がありました。

* たまになのでURLを毎回聞かれる
* モバイルからだとUXが悪い

PWAはこれらの問題を解決する可能性を秘めています。

* アプリのようにインストールしてもらうことでURLを忘れることがない
* クロスプラットフォーム対応 (Windows/Mac/Android/iOSなど..)
* 拘らなければNativeと遜色ないクオリティ

その仮説を証明するため、自身が作成した最もシンプルなプロダクトで試してみることにしました。


GitHub Viewerとは
-----------------

私がVue/Nuxtの勉強用に開発したGitHubのリポジトリViewerです。

{{<summary "https://github.com/tadashi-aikawa/github-viewer">}}

今回はこれをPWA対応してみました。


Nuxt PWA
--------

NuxtのアプリケーションをPWA対応できるpackageがあったので使ってみました。

{{<summary "https://pwa.nuxtjs.org/">}}

以下に対応しているようです。

| モジュール名 |                        説明                        |
| ------------ | -------------------------------------------------- |
| Workbox      | オフラインキャッシュのためService workerを登録する |
| Manifest     | `manifest.json`を作る                              |
| Meta         | SEOに優しいメタデータを埋める                      |
| Icon         | 様々なサイズのアプリアイコンを作成する             |
| OneSignal    | バックグラウンドでpush通知を制御する               |

Get Startedページの指示に従っていきます。

{{<summary "https://pwa.nuxtjs.org/setup.html">}}

### インストール

公式はyarnでしたが私はnpmです。

```
$ npm i @nuxtjs/pwa
```

### Nuxtモジュールに追加

`nuxt.config.js`に`nuxtjs/pwa`を追加します。

```
    modules: [
      ...
      "@nuxtjs/pwa",
      ...
    ],
```

### アイコンを作る

`static`配下に`icon.png`を作成します。  
`512*512`のサイズが推奨です。

### Service Workerファイルの無視

`.gitignore`に以下を追加して無視します。

```
sw.*
```

これらのファイルはNuxt PWAモジュールが作成する成果物なのでバージョン管理は不要です。

### ビルド

いつも通りビルドします。  
コマンドの変更は必要ありません。

```
$ npm run build
```

{{<error "TypeError: Cannot read property 'minify' of undefined">}}
依存packageである`terser`のバージョンによっては発生します。

{{<summary "https://github.com/webpack-contrib/terser-webpack-plugin/issues/66">}}

私が直面したときは`terser`のバージョンを`3.14.1`にすることで解消しました。  
上記のIssueが今はCloseされているため、このエラーに出会わないことを祈っています😄
{{</error>}}


デプロイ
--------

ビルドで作成された成果物をデプロイします。  
あとは`manifest.start_url`に記載されたpathへアクセスすればOKです。

今まではGitHub Pagesを使っていましたが、せっかくなのでNetlifyを使ってみました。

{{<summary "https://www.netlify.com/">}}

{{<warn "アイコンから起動すると404になる">}}
エントリポイントが`/`以外の場合は`start_url`の指定が必要です。  
`nuxt.config.js`のmanifestに`start_url`を記載してください。

{{<refer "参考のコミット" "https://github.com/tadashi-aikawa/github-viewer/commit/a057a7f71a2e57469492f68be1e406b90bc8f7e3">}}
{{</warn>}}


Netlifyについても記事書こうと思いましたが、簡単すぎてネタにならないので諦めました...。  
シンプルで高機能...Netlify凄い!!👍


### 成果物

https://github-viewer.netlify.com/repositories/

PCやスマホからアクセスして、是非アプリ登録してみてください😆

{{<warn "PCからアクセスするとデスクトップアプリとして登録を促されない...">}}
プッシュ通知はされませんが、ブラウザメニューの中からインストールできます。  
日本語は少しおかしいですが...。

{{<vimg "resources/20190209_1.png">}}

Macでは未確認です。
{{</warn>}}

{{<warn "Windowsのアンインストール画面からアンインストールできない">}}
PWAアプリ立ち上げ後に表示されるメニューからアンインストールできます。

{{<himg "resources/20190209_2.png">}}

Windowsメニューから右クリックでのアンインストールはダミーです。お気をつけ下さい😿
{{</warn>}}

ちなみにPWA関連の情報はChrome Developer ToolsのApplicationメニューから確認できます。

{{<himg "resources/20190209_3.png">}}


総括
----

PWAの使い勝手を確かめるため、GitHub ViewerをPWA対応してみました。

少しいじってみて私が感じたのは以下になります。

* Webの知識だけでアプリっぽいものを作る事ができるのは凄い!!
* Nuxt使っていればPWA化はとても簡単!!
* キャッシュはそこまで期待していなかったけれど、速くて快適!!
* 検索バーが無いだけでアプリとして洗練された感がする

コスパが良く好印象なので、合宿用のアプリ作成にもチャレンジしてみます👍

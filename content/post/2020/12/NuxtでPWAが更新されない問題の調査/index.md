---
title: NuxtでPWAが更新されない問題の調査
slug: nuxt-pwa-not-updating
date: 2020-12-02T21:23:17+09:00
thumbnailImage: images/cover/2020-12-02.jpg
categories:
  - engineering
tags:
  - nuxt
  - pwa
  - workbox
  - service-worker
  - togowl
---

NuxtのPWAが全く更新されない問題を調査しました。

<!--more-->

{{<cimg "2020-12-02.jpg">}}

<!--toc-->


環境
----

依存関係のバージョンです。

| package     | バージョン |
| ----------- | ---------- |
| Nuxt        | 2.14.7     |
| @nuxtjs/pwa | 3.2.2      |
| workbox-cdn | 5.1.4      |

Windows/AndroidのChromeと、iPad OSのSafariで再現を確認しています。


事象
----

以下のような状況です。

* 最新バージョンをデプロイしても、以前のHTMLが表示される
* スーパーリロードをすると、そのときだけHTMLは最新化される
    * もう一度通常読み込みすると以前のHTMLが表示される
* Service Workerに関するキャッシュをすべて削除すると解決する
    * 古いキャッシュが消えているので当たり前
    * 次のバージョンアップ時に問題は発生する

### 古い情報を読み込んでしまうとき

Service Workerのキャッシュが使われていることが分かります。

{{<himg "resources/29b1a4e4.jpeg">}}

またChromeのDevToolsに以下のメッセージが表示されます。

```
workbox-precaching.prod.js:1 Workbox is precaching URLs without revision info: /?standalone=true
This is generally NOT safe. Learn more at https://bit.ly/wb-precache
```

Cache Storageには`workbox-precache-v2`のprefixをもつキャッシュが保存されていました。

{{<himg "resources/9982c259.jpeg">}}

これが使われてしまっているわけですね。

### スーパーリロードしたとき

Service Workerのキャッシュは当然使われません。

{{<himg "resources/86943057.jpeg">}}

アプリケーションの中身が違うため、読み込まれるjsファイルも一部変わっています。


問題と期待値
------------

通常の読込時に新しいHTMLを取得せず、Service Workerにキャッシュされた古いHTMLを取得していることが問題です。  
より新しいHTMLがサーバにデプロイされているため、そちらが取得されるべきです。

ではなぜService Workerキャッシュを使ってしまうのでしょうか。  
`@nuxtjs/pwa`の仕様を確認し、それらを突き止める必要があります。

{{<alert info>}}
対処方法だけ知りたい方は[対応](#対応)だけ読んで下さい。
{{</alert>}}



nuxt/pwa
--------

公式ドキュメントを読んでみます。

{{<summary "https://pwa.nuxtjs.org/">}}

### コンセプト

> Zero config PWA solution for Nuxt.js

Nuxt.jsで作ったプロダクトをPWA化するソリューションです。  
設定なしでも動くZero configが強みのようです。

### 機能

> Registers a service worker for offline caching.

オフラインでキャッシュするためにService Workerを登録する..とあります。  
他にも機能は4つほどありますが、今回のメインはこれです。

### Workbox Module

`nuxt/pwa`ではWorkboxを使ってPWAをサポートしています。

{{<summary "https://pwa.nuxtjs.org/workbox">}}

WorkboxはWebアプリのオフライン化をサポートするライブラリです。

{{<summary "https://developers.google.com/web/tools/workbox">}}

設定項目も多く、メジャーバージョンアップの内容によっては影響を受けてそうですね。


WorkboxとPrecaching
-------------------

先ほども紹介しましたが、問題発生時には以下の警告が表示されていました。

```
workbox-precaching.prod.js:1 Workbox is precaching URLs without revision info: /?standalone=true
This is generally NOT safe. Learn more at https://bit.ly/wb-precache
```

提示されたURLに記載された内容を見てみましょう。

### Workbox Precaching

Workbox Moduleのドキュメントです。

{{<summary "https://developers.google.com/web/tools/workbox/modules/workbox-precaching">}}

Cache Storageにも`workbox-precache-v2`という名前が出てきたため関係ありそうです。

#### revision

この部分は重要なことが書いてありました。

> When a user later revisits your web app and you have a new service worker with different precached assets, workbox-precaching will look at the new list and determine which assets are completely new and which of the existing assets need updating, based on their revisioning

**各assertsをアップデートするかはrevisionによって判断する**ようです。  
言い換えると、revisionに何かのトラブルが発生している場合は必要な場合でも更新されなくなります。

#### precache manifest

urlとrevisionの関係はprecache manifestとして参照されるようです。

```js
import {precacheAndRoute} from 'workbox-precaching';

precacheAndRoute([
  {url: '/index.html', revision: '383676' },
  {url: '/styles/app.0c9a31.css', revision: null},
  {url: '/scripts/app.0d5770.js', revision: null},
  // ... other entries ...
]);
```

さらに`revision: null`のケースについて言及がありました。

> For the second and third object in the example above, the revision property is set to null. This is because the revisioning information is in the URL itself, which is generally a best practice for static assets.

これらはURLにrevisionが含まれているおり、それはベストプラクティスなので好ましいとのことです。  
`0c9a31`や`0d5770`の部分がそれにあたります。

> The first object (/index.html) explicitly sets a revision property, which is an auto-generated hash of the file's contents. Unlike JavaScript and CSS resources, HTML files generally cannot include revisioning information in their URLs, otherwise links to these files on the web would break any time the content of the page changed.

`/index.html`はエンドポイントなのでコロコロ変えられないというわけですね。  
また`revision`はコンテンツの内容で決まるため、`index.html`に変更があれば変わります。  
`<script>`タグで読みこむjsファイル名が変わるので、通常のバージョンアップデプロイでは変わりますね。

> By passing a revision property to precacheAndRoute(), Workbox can know when the file has changed and update it accordingly.

`precacheAndRoute(...)`によって更新されるようです。


調査
----

Workboxについて必要な情報を得たので、`nuxt/pwa`を調査します。

### 問題が発生したバージョン

`3.0.0-beta20`でビルド/デプロイしたときは問題ありませんでした。  
`3.2.2`にバージョンアップしてから問題が発生している気がします。

### Issueを探してみる

同じような事象が報告されていないか探してみました。  
ありました..怪しいのが😏

{{<summary "https://github.com/nuxt-community/pwa-module/issues/381">}}

重要な部分をピックアップしてみます。

> Recently this problem appeared in our pwa. I had all default settings in workbox pwa module and everything worked fine, but now it seems root page (/) is precached, it is exists in CacheStorage workbox-precache-v2-...

まさに同じです。

> I can solve issue by manually deleting this CacheStorage, but it's not the solution because our users won't do it manually.

CacheStorageを消せば直りますが..ユーザーにそれをさせるのはあり得ませんよね..。  
それにモバイルはPCと違って気軽に削除できないと思っています。

> Google docs say, that cache-first policy is used for precached resources, that's why page is not refreshed.
  Precached resources are updated once service worker is, only if revision changes. And because no revision is used, it's not updating.

revisionが更新されないと更新されない.. そしてrevisionが使われていないのでそうなるとのこと。

### プルリクエストを探してみる

先ほどのIssueに対するプルリクエストがありました。  
URLのリストではなく、revision含めたObjectが渡るように改修されています。

{{<summary "https://github.com/nuxt-community/pwa-module/pull/386">}}

この内容はv3.3.0に取り入れられたようなので、バージョンアップすれば直りそうですね。


対応
----

`@nuxtjs/pwa`をv3.3以上にバージョンアップします。

### v3.3.0の内容確認

バージョンアップ前に内容を確認します。

{{<summary "https://github.com/nuxt-community/pwa-module/releases/tag/v3.3.0">}}

revision周りを含めるようになったので解決しそうですね。

```
Features
  * manifest: add revision to start_url (ad26827)

Bug Fixes
  * manifest: invalidate start_url cache (240d4a1)
  * add revision to precache assets (#386) (872dce1)
```

### v3.3以上にバージョンアップ

この記事を執筆したときはv3.3.2でした。  
バージョンアップしたバージョンでCache Storageを確認すると..

{{<himg "resources/e81aac46.jpeg">}}

urlに`wCAfmo9uzc9a`のようなハッシュが追加されているので期待通りですね🥳  
アプリも最新バージョンに更新されました！


総括
----

NuxtのPWAが全く更新されない問題を調査しました。

`@nuxtjs/pwa`のv3.2.1から、エントリポイントのprecacheにrevisionが付けられなくなったことが原因でした。  
不具合はv3.3で修正されたため、`@nuxtjs/pwa`を最新にアップデートしたらなおりました。

発生を確認したときは少し青ざめましたが、PWAやService Worker、Workbox、nuxt/pwaについて学ぶ良い機会になったので結果的に良かったと思っています。

...これが緊急性の高いだと思うとゾっとしますが。。

#### オマケ

対応コミットです。

{{<summary "https://github.com/tadashi-aikawa/togowl/commit/2478ecaeb4fd84f3600ac284ac072794c4a1ea4a">}}

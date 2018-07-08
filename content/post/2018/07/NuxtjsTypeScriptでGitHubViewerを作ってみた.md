---
title: "Nuxt.js+TypeScriptでGitHub Viewerを作ってみた"
slug: nuxtjs-typescript-github-viewer
date: 2018-07-09T02:00:00+09:00
thumbnailImage: https://cdn.svgporn.com/logos/nuxt.svg
categories:
  - engineering
tags:
  - typescript
  - vue
  - nuxt
  - github
  - element
---

Nuxt.jsとTypeScriptを使ってGitHubの情報を閲覧できるツールを作ってみました。

<!--more-->

<img src="https://github.com/tadashi-aikawa/github-viewer/raw/master/pv.gif"/>

<!--toc-->


はじめに
-------

### 経緯

Vue.jsを使ってSPAを作成する予定があるため、その勉強とBoilerplate作成を兼ねてとなります。  
そのためツールを作り込むことは目的ではありません。


### 前提条件

以下の環境を想定して進めます。

* npm5
* Ubuntu16.04
    * Lubuntu
    * VMでありホストはWindows


### ソースコード

以下で公開しています。

{{<summary "https://github.com/tadashi-aikawa/github-viewer">}}


### ツールのデモ

以下からお試しできます。

{{<summary "https://tadashi-aikawa.github.io/github-viewer/repositories/">}}


利用技術
--------

以下の技術を利用しています。

* Vue.js
* Nuxt.js (1.3.x)
* TypeScript (2.7.x)
* Element (2.4.x)


### Vue.js

Vue.jsはJavaScriptのフレームワークです。

{{<summary "https://jp.vuejs.org/">}}


#### なぜvue.js?

ReactとAngularは開発しているプロダクトがありますが、Vue.jsだけ開発経験が無いからです。  
また2018/07/09現在において、ReactやAngularに比べ、以下の理由から職場でも導入しやすいと思っています。

* Vue.jsはコスパが良い(学習コストとできることのバランス)
* Vue.jsは日本語ドキュメントが充実している
* Elementで必要なことがほとんどできる

ReactとAngularの経験も手伝ってはいますが、Vue.jsの習得コストは他の半分以下だと思います。


### Nuxt.js

Nuxt.jsはVue.jsアプリケーションを作成するためのフレームワークです。  

{{<summary "https://ja.nuxtjs.org/">}}

サーバサイドレンダリング(SSR)するためのフレームワークNext.jsに影響されていますが、今回はSPAとして作成するためSSRは利用しません。


#### なぜNuxt.js?

アプリケーションを開発する仕組みが整理されており、開発が楽だからです。  
SSRを利用しなくても以下の機能を持っているため恩恵は十分です。

* [Vue-Router](https://router.vuejs.org/) (ルーター)
* [Vuex](https://github.com/vuejs/vuex) (状態管理)


### TypeScript

TypeScript はMicrosoftが開発しているJavaScriptのスーパーセットです。  
強力な型システムを備え、中・大規模システムの開発には欠かせません。

{{<summary "https://www.typescriptlang.org/">}}

#### なぜTypeScript?

安全で高速な開発を持続するためです。  
初めて動かすまでの速度以外の面でTypeScriptを選ばない理由はないでしょう。

フレームワークやライブラリのチュートリアルはJavaScriptを対象にしていることが多いため、その点でTypeScriptが足を引っ張ることはありますが以前に比べて随分マシになりました。  
少しの技術力とドキュメントを読む力があれば、そのデメリットより使用するメリットが遥かに上回るでしょう。


### Element

ElementはVueのコンポーネント用UIライブラリです。

{{<summary "http://element.eleme.io/#/en-US">}}

#### なぜElement?

見た目が格好良く、ツール作成に必要なUIがほぼ揃っているからです。  
また、新しいComponentを使う時もimportなどが不要で非常に使いやすいです。


開発環境
--------

IntelliJ IDEAでプラグインを使用して開発しています。

{{<summary "https://plugins.jetbrains.com/plugin/9442-vue-js">}}

VSCodeだと[Vetur](https://marketplace.visualstudio.com/items?itemName=octref.vetur)になりますが、Nuxt.jsの補完やジャンプが不十分でした。


アプリケーションを立ち上げる
----------------------------

まずはアプリケーションを立ち上げることを目指しました。


### インストール

`vue-cli`をインストールします。

```
$ npm install -g vue-cli
```


### templateからプロジェクトを作成

TypeScript用のNuxt.jsテンプレートを利用します。

```
$ vue init nuxt-community/typescript-template
```

依存モジュールをインストールします。

```
& npm i
```

package.jsonの`scripts.dev`コマンドに以下オプションを追加します。

```json
  "scripts": {
    "dev": "nuxt -H 0.0.0.0 --spa",
```

`--spa`はSPAとして起動するオプションです。(SSRを利用しない)

`-H 0.0.0.0`はlocalhost以外からのアクセスも許容するオプションです。  
これは私がVM上のLubuntuで開発をしており、そこにホストOSのブラウザからアクセスする必要があるためです。


### 起動

以下で開発サーバが立ち上がります。

```
$ npm run dev
```

`http://localhost:3000`にアクセスすると画面が表示されます。


Elementの導入
-------------

UIとしてElementを導入します。  
[公式](http://element.eleme.io/#/en-US/component/installation)と以下の記事を参考にさせていただきました。

{{<summary "https://qiita.com/teriyakisan/items/9c2f479c30b8a829eb7c">}}


### インストール

npmでインストールします。

```
$ npm i element-ui
```

### 使い方

Nuxt.jsにプラグインとして登録します。

pluginsディレクトリ配下に`element-ui.js`を作成します。

```javascript
import Vue from 'vue'
import ElementUI from 'element-ui'
import locale from 'element-ui/lib/locale/lang/ja'

Vue.use(ElementUI, { locale })
```

`nuxt.config.js`にいくつか設定を追加します。

* `plugins`配下に`{ src: '~plugins/element-ui' }`を追加
* `css`配下に`"element-ui/lib/theme-chalk/index.css"`を追加
* `build.vendor`配下に`"element-ui"`を追加

後は公式ドキュメントの通りにvueファイルのtemplateを記述していけばOKです。


class-transformerの導入
-----------------------

class-transformerはObjectとクラスを相互変換可能なTypeScriptのライブラリです。  
GitHub APIから取得した結果をクラスに変換するために利用しています。

{{<summary "https://github.com/typestack/class-transformer">}}


### 使い方

例えば以下の様なinterfaceとclassが定義されているとします。

```typescript
export interface Owner {
  id: number;
  login: string;
  avatar_url: string;
}

export class Repository {
  id: number;
  owner: Owner;
  license: {
    spdx_id: string;
  };

  get licenseName(): string {
    return this.license && this.license.spdx_id ? this.license.spdx_id : 'Unknown';
  }
}
```

以下のように書くと`res: Object`を`response: Response`に変換できます。

```typescript
const res: Object  = (await axios.get(URL)).data;
const response: Response = plainToClass(Response, res);
```

クラスに変換されたため、`response.licenseName`のように呼び出すことができます。

{{<alert "warning">}}
`Uncaught TypeError: Reflect.getMetadata is not a function`エラーが表示される場合..  
`import 'reflect-metadata'`が記載されていることを確認して下さい。
{{</alert>}}

#### ネストオブジェクトを変換したいとき

以下のようにRespositoryクラスの`owner`プロパティがクラスである場合を考えます。

```typescript
export class Owner {
  id: number;
  login: string;
  avatar_url: string;

  get loginName(): string {
    return this.login;
  }
}
```

このとき`plainToClass(Response, res)`では`owner`はクラスに変換されません。  
つまり`response.owner.loginName`はエラーとなります。

変換したいネストしているプロパティに`@Types`アノテーションを付けることでこれを解決します。

```typescript
export class Repository {
  id: number;
  @Type(() => Owner)
  owner: Owner;
  license: {
    spdx_id: string;
  };

  get licenseName(): string {
    return this.license && this.license.spdx_id ? this.license.spdx_id : 'Unknown';
  }
}
```


font-awesomeの導入
------------------

Elementのアイコンは種類が少ないのでfont-awesomeを導入します。

{{<summary "https://fontawesome.com/">}}


### インストール

いくつかインストールが必要です。

```
$ npm i @fortawesome/fontawesome-svg-core @fortawesome/free-solid-svg-icons @fortawesome/vue-fontawesome
```

* `fontawesome-svg`: SVGを使う
* `free-solid-svg-icons`: Solidの無料版を使う
* `vue-fontawesome`: Vueで使うために必要


### 使い方

Nuxt.jsにプラグインとして登録します。

pluginsディレクトリ配下に`font-awesome.js`を作成します。

```javascript
import Vue from 'vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faCoffee,
  faUser,
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(
  faCoffee,
  faUser,
);

Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.config.productionTip = false
```

上記の例では`coffee`と`user`というアイコンのみを使用します。  
他のアイコンを使う場合は`import`と`library.add`にそれぞれ追加する必要があります。

※ しばらくこれに気づかずハマりました...

`nuxt.config.js`の`plugins`配下に`{ src: '~plugins/font-awesome' }`を追加します。

vueファイルのtemplateには`<font-awesome-icon icon="calendar" size="sm"/>`のように書きます。

{{<alert "info">}}
[`@nuxtjs/font-awesome`](https://www.npmjs.com/package/@nuxtjs/font-awesome)という公式提供のmoduleがありますが使い方が分からずに断念しました...
{{</alert>}}


GitHub Pagesへデプロイするときの注意
------------------------------------

ドメイン直下ではないため`nuxt.config.js`の変更が必要です。  
リポジトリ名をルーターのベースおよびfaviconのベースとして追加します。

```javascript
module.exports = {
  mode: 'spa',
  router: {
    base: '/github-viewer/',
  },
  head: {
    link: [
      {
        rel: "icon",
        type: "image/x-icon",
        href: "/github-viewer/favicon.ico",
      }
    ]
  },
```

この変更によって`npm run dev`でアクセスする先も`http://localhost:3000/github-viewer/repositories`に変わります。  
GitHub Pagesに特化した設定となってしまいますが大きな支障は無いと思います。


総括
----

Nuxt.jsとTypeScript、Elementなどを使用してgithub-viewerを作成してみました。

思ったより良いモノができたので必要に応じてメンテしてみるかもしれません。


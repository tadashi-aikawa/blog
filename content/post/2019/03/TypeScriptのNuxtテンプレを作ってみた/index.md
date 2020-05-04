---
title: TypeScriptのNuxtテンプレを作ってみた
slug: create-typescript-nuxt-template
date: 2019-03-01T21:09:48+09:00
thumbnailImage: https://cdn.svgporn.com/logos/nuxt.svg
categories:
  - engineering
tags:
  - nuxt
  - typescript
  - pwa
  - vuetify
  - vue
---

create-nuxt-appを使ってTypeScriptのNuxtテンプレを作ってみました。

<!--more-->

ここで言うテンプレは開発するための準備です。  
create-nuxt-app用のテンプレートを作成したわけではありません。

{{<cimg "https://cdn.svgporn.com/logos/nuxt.svg">}}

<!--toc-->


はじめに
--------

なぜNuxt.jsやTypeScriptを使うかの経緯は以下の記事で説明済みのため省略します。

{{<summary "https://blog.mamansoft.net/2018/07/09/nuxtjs-typescript-github-viewer/">}}


利用技術
--------

今回使用する技術は上記記事とは少し異なります。

|      種類      |       今回利用する技術        |       上記記事で利用した技術       |
| -------------- | ----------------------------- | ---------------------------------- |
| Viewライブラリ | Vue.js                        | Vue.js                             |
| フレームワーク | Nuxt.js (**nuxt-ts**) (2.4.x) | Nuxt.js (nuxt) (1.3.x)             |
| 言語           | TypeScript (3.2.x)            | TypeScript (2.7.x)                 |
| CLI            | **create-nuxt-app**           | vue-cli (with typescript-template) |
| 形式           | SPA (**PWA**)                 | SPA                                |
| UIライブラリ   | Vuetify (1.5.x)               | Element (2.4.x)                    |

大きな変更点は以下3点です。

* Nuxt.js 2.4からTypeScriptに正規対応したので`nuxt-ts`コマンドを使う
* create-nuxt-appを使う
* PWA対応


JavaScriptで動く環境を作る
--------------------------

create-nuxt-appを使って環境構築します。

{{<summary "https://github.com/nuxt/create-nuxt-app">}}

create-nuxt-appは公式がメンテナンスしており、Nuxtの公式ドキュメントでも推奨されています。  
しかし、現在はまだTypeScriptへ対応していません。

そのため、まずはJavaScriptで動作する環境を作ってからTypeScript用の設定を入れていきます。

### 環境構築

プロジェクトディレクトリの中に移動して以下コマンドを実行します。  
もしディレクトリ未作成の場合は指定したプロジェクト名でディレクトリが作成されます。

```
$ npx create-nuxt-app .
```

途中いくつか質問されますので答えましょう。  
ポイントは以下です。

* ServerはNoneを選択
* UIライブラリはVuetifyを選択
* SPAを選択
* PWAを選択

{{<warn "ESLintについて">}}
本記事ではESLintのTypeScript対応をサポートしません。  
ESLintをインストールセットに含める場合は、TypeScriptのコードとしてエラーにならないよう自身で設定してください。

そのままの設定でビルドするとTypeScriptの文法を解釈できず、ビルドエラーになります。
{{</warn>}}


### 動作確認

開発確認実行をしてみましょう。

```
$ npm run dev
```

起動後、コンソール上で案内されたエンドポイントにアクセスできればOKです。


TypeScriptで動くようにする
--------------------------

TypeScriptで開発出来るように準備します。

{{<refer "公式のTypeScriptサンプルコード" "https://github.com/nuxt/nuxt.js/tree/dev/examples/typescript">}}

以下の内容は上記を参考にしています。


### nuxt-tsのインストール

create-nuxt-appでインストールされるNuxt.jsは2.4以上ですが、それとは別に`nuxt-ts`をインストールする必要があります。

{{<summary "https://www.npmjs.com/package/nuxt-ts">}}

```
$ npm install nuxt-ts
```

その後に`package.json`の`dev`コマンドを`nuxt-ts`にします。

```diff
-   "dev": "nuxt",
+   "dev": "nuxt-ts",
 
```

これを忘れるとTypeScriptとしてビルドされません。


### vue-property-decoratorのインストール

デコレータで可読性の高いコードを書けるようにするため、`vue-property-decorator`をインストールします。

{{<summary "https://github.com/kaorun343/vue-property-decorator">}}

今回のサンプルコードでは`@Component`を使用します。


### `nuxt.config.js`の修正

まずは名前を`nuxt.config.ts`に変更してください。  
これを忘れると、`nuxt-ts`が設定を読み込んでくれません。

次に以下の部分を削除します。

```diff
-  /*
-   ** You can extend webpack config here
-   */
-   extend(config, ctx) {
-
-   }
 
```

これを忘れると、`extend`の引数である`config`と`ctx`が暗黙的anyのためエラーになります。  
もし`extend`が必要な場合はルールを変更したり、anyを指定することで対処してください。


### 動作確認

JavaScriptのときと同じコマンドです。

```
$ npm run dev
```

初回実行時は`tsconfig.json`を作ってよいか聞かれますのでyesを選びます。

{{<error "nuxt.config.ts:1:17 - error TS2307: Cannot find module './package'.">}}
`import pkg from './package'`でエラーになる場合です。  
理由は、TypeScriptがjson(package.json)のimportにデフォルトで対応していないからです。

`tsconfig.json`でJsonをモジュールとして読み込む設定をtrueにしましょう。
```json
"resolveJsonModule": true,
```

また、`nuxt.config.js`のimportは拡張子まで指定してください。
```ts
import pkg from './package.json'
```

{{<refer "TypeScript 2\.9 · TypeScript --resolvejsonmodule" "https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-9.html#new---resolvejsonmodule">}}
{{</error>}}

{{<error "Cannot find module '~/components/Logo.vue'.">}}
`~`から始まるパスをTypeScriptが解決できていません。  
`tsconfig.json`の`compilerOptions`に以下の設定を追加して、パスを解決できるようにしてください。
```json
  "compilerOptions": {
    "paths": {
      "~/*": ["./*"]
    }
  }
```
{{</error>}}


TypeScriptのコードにする
------------------------

動きはしましたが、まだ`vue`ファイルはJavaScriptのままです。  
これをTypeScriptにしてみましょう。

### `default.vue`の修正

`default.vue`を開き、`<script>`を`<script lang=ts>`に変更します。  
これで`<script>`タグの内部はTypeScriptとして認識されるようになります。

更に`<script>`タグ内部を以下のように変更します。

{{<file "変更前">}}
```ts
export default {
  data() {
    return {
      clipped: false,
      drawer: false,
      fixed: false,
      items: [
        {
          icon: 'apps',
          title: 'Welcome',
          to: '/'
        },
        {
          icon: 'bubble_chart',
          title: 'Inspire',
          to: '/inspire'
        }
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: 'Vuetify.js'
    }
  }
}
```
{{</file>}}


{{<file "変更後">}}
```ts
import { Component, Vue } from 'vue-property-decorator'

interface Item {
  icon: string
  title: string
  to: string
}

@Component({})
export default class extends Vue {
  clipped = false
  drawer = false
  fixed = false
  miniVariant = false
  right = true
  rightDrawer = false
  title = 'Vuetify.js'
  items: Item[] = [
    {
      icon: 'apps',
      title: 'Welcome',
      to: '/'
    },
    {
      icon: 'bubble_chart',
      title: 'Inspire',
      to: '/inspire'
    }
  ]
}
```
{{</file>}}


### `tsconfig.json`の修正

デコレータを使うために必要な設定を`tsconfig.json`のcompilerOptionsに追加します。

```diff
  {
    "extends": "@nuxt/typescript",
    "compilerOptions": {
+     "experimentalDecorators": true,
 
```

この設定を忘れるとビルドエラーになります。


### 動作確認

```
$ npm run dev
```

先ほどと同じ画面が表示されればOKです😄


{{<error "Experimental support for decorators is a feature that is subject to change in a future release. Set the 'experimentalDecorators' option to remove this warning.">}}
`experimentalDecorators`を`true`にしても設定が消えない場合はVSCodeを再起動してみてください。
{{</error>}}

{{<error "ERROR  (node:8464) DeprecationWarning: Tapable.plugin is deprecated. Use new API on .hooks instead">}}
pwa-moduleのv3.0.0が出れば修正されるようです。  
動作には支障ないのでリリースされるのを待ちましょう。

{{<summary "https://github.com/nuxt-community/pwa-module/issues/120">}}
{{</error>}}


PWAとしてビルドする
-------------------

`npm run build`でビルドすればOKです。  
`nuxt`を`nuxt-ts`に変更することだけ忘れないで下さい。

```diff
-   "build": "nuxt build",
+   "build": "nuxt-ts build",
 
```


総括
----

create-nuxt-appを使って、nuxt-tsでビルドするTypeScriptのテンプレを作ってみました。

create-nuxt-appが公式でTypeScriptに対応したらこの手順は不要になると思います。  
ただ、JavaScriptからTypeScriptに移行するケースのコツを掴めると思うので、知識は無駄にならないと思っています😄


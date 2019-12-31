---
title: Nuxt × TypeScript × Electron × SQLiteを動かしてみた2
slug: nuxt-typescript-electron-sqlite-project2
date: 2019-12-29T22:26:09+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/40csiok4h69535w/mikayla-mallek-ZDBQ2dx_gbQ-unsplas
categories:
  - engineering
tags:
  - nuxt
  - typescript
  - electron
  - sqlite
  - element
---

10月に書いた以下の記事について、一部上手く動かなくなった部分があったため続編を書きました。

<!--more-->

{{<summary "https://blog.mamansoft.net/2019/10/08/nuxt-typescript-electron-sqlite-project/">}}

<img src="https://dl.dropboxusercontent.com/s/40csiok4h69535w/mikayla-mallek-ZDBQ2dx_gbQ-unsplash.jpg"/>

{{<alert danger>}}
本記事は執筆時点のやり方であり、この分野は非常に変化が激しいです。  
時間が経過している場合は、必ず公式ドキュメントを確認の上、自己責任で実施してください。
{{</alert>}}

<!--toc-->


はじめに
--------

### 方針

以前の記事と重複する内容は、基本的に記載しません。  
各対応の前提や経緯はそちらをご覧下さい。

### 利用技術のバージョン

|        利用技術         | 今回バージョン | 前回バージョン |
| ----------------------- | -------------- | -------------- |
| Nuxt                    | 2.11.0         | 2.10.0         |
| TypeScript              | 3.7.4          | 3.6.3          |
| Electron                | 7.1.7          | 6.0.11         |
| sqlite3                 | 4.1.1          | 4.1.0          |
| Element                 | 2.13.0         | 2.12.0         |
| create-nuxt-app         | 2.12.0         | 2.11.1         |
| nuxt-property-decorator | 2.5.0          | 2.4.0          |
| Python2                 | 2.7.14         | 2.7.14         |


プロジェクト作成
----------------

```console
$ npx create-nuxt-app nuxt-electron-typescript-sqlite3
? Project name nuxt-electron-typescript-sqlite3
? Project description Nuxt x Electron x TypeScript x sqlite3
? Author name tadashi-aikawa
? Choose the package manager Npm
? Choose UI framework Element
? Choose custom server framework None (Recommended)
? Choose Nuxt.js modules Axios
? Choose linting tools ESLint, Prettier
? Choose test framework Jest
? Choose rendering mode Single Page App
```

前回はインストールしなかった`ESLint`を追加してみました。


TypeScript対応
--------------

```console
cd nuxt-electron-typescript-sqlite3
npm i -D @nuxt/typescript-build nuxt-property-decorator
```

### 設定

#### nuxt.config.js:

* `export default {`を`module.exports = `に変更
* `buildModules`に`@nuxt/typescript-build`を追加

{{<file "tsconfig.json">}}

```json
{
  "compilerOptions": {
    "target": "es2018",
    "module": "esnext",
    "moduleResolution": "node",
    "lib": ["esnext", "esnext.asynciterable", "dom"],
    "esModuleInterop": true,
    "allowJs": true,
    "sourceMap": true,
    "strict": true,
    "strictPropertyInitialization": false,
    "skipLibCheck": true,
    "experimentalDecorators": true,
    "noEmit": true,
    "baseUrl": ".",
    "paths": {
      "~/*": ["./*"],
      "@/*": ["./*"]
    },
    "types": ["@types/node", "@nuxt/types"]
  },
  "exclude": ["node_modules"]
}
```

{{</file>}}

`Optional Chaining`や`Nullish Coalescing`を使いたいので`target`は`es2018`にしています。  
以下は公式の記載です。

{{<refer "Nuxt TypeScript" "https://typescript.nuxtjs.org/guide/setup.html#configuration">}}

> TIP
>
> Notice that es2018 target is needed to be able to use Optional Chaining and Nullish Coalescing, as esnext target doesn't seem to support these features for now.


### ソースコードのTypeScript化

{{<file "pages/index.vue">}}

```html
<template>
  <div style="padding: 30px;">
    <h2>{{ counter }}</h2>
    <button @click="increment(2)">increment</button>
    <button @click="decrement(1)">decrement</button>
  </div>
</template>

<script lang="ts">
import { Component, Vue, State, Mutation } from 'nuxt-property-decorator'

@Component({})
class Root extends Vue {
  @State counter: number
  @Mutation increment: (value: number) => void
  @Mutation decrement: (value: number) => void
}

export default Root
</script>

```

{{</file>}}

{{<file "store/index.ts">}}

```ts
export interface State {
  counter: number
}

export const state = (): State => ({
  counter: 0
})

export const mutations = {
  increment(state: State, value: number) {
    state.counter += value
  },
  decrement(state: State, value: number) {
    state.counter -= value
  }
}
```

{{</file>}}

{{<file "index.d.ts">}}

```ts
declare module '*.vue' {
  import Vue from 'vue';
  export default Vue;
}
```

{{</file>}}

`npm run dev`で動作することを確認します。  
問題なければElectron導入前まではOKです。


Electron対応
------------

### インストール

```console
npm i -D electron cross-env
```

### Electronのエントリファイル作成

{{<file "main.js">}}

```js
// Nuxt
const { Nuxt, Builder } = require('nuxt')
let config = require('./nuxt.config.js')
config.rootDir = __dirname // for electron-builder

const nuxt = new Nuxt(config)
async function build() {
  await nuxt.ready()
  const builder = new Builder(nuxt)
  try {
    await builder.build()
  } catch (err) {
    console.error(err) // eslint-disable-line no-console
    process.exit(1)
  }
}

if (config.dev) {
  build()
}

// HTTP server
const http = require('http')
const server = http.createServer(nuxt.render)
server.listen()
const _NUXT_URL_ = `http://localhost:${server.address().port}`
console.log(`Nuxt working on ${_NUXT_URL_}`)

// Electron
const electron = require('electron')
const app = electron.app
const BrowserWindow = electron.BrowserWindow
let win = null

const newWin = () => {
  win = new BrowserWindow({
    webPreferences: {
      nodeIntegration: true
    }
  })
  win.maximize()
  win.on('closed', () => (win = null))
  if (config.dev) {
    const pollServer = () => {
      http
        .get(_NUXT_URL_, (res) => {
          if (res.statusCode === 200) {
            win && win.loadURL(_NUXT_URL_)
          } else {
            setTimeout(pollServer, 300)
          }
        })
        .on('error', pollServer)
    }
    pollServer()
  } else {
    return win.loadURL(_NUXT_URL_)
  }
}

app.on('ready', newWin)
app.on('window-all-closed', () => app.quit())
app.on('activate', () => win === null && newWin())

```

{{</file>}}

設定ファイルもいじります。

#### nuxt.config.js

* `module.exports`に`dev: process.env.NODE_ENV === 'DEV'`を追加

#### package.json

* `scripts.dev`を`cross-env NODE_ENV=DEV electron main.js`に変更

`npm run dev`で動作することを確認します。

### Vuexが上手く初期化されない問題へのアプローチ

前回の記事にはVuexを使用したコードの記載がなく、Vuexが正しく動かない問題をスルーしていました。  
具体的には **`Vuex`が上手く初期化されず、`state`, `actions`, `mutations`などがカラッポになります。**

以下は前回記事に記載された`main.js`の一部です。

```js
const nuxt = new Nuxt(config);
const builder = new Builder(nuxt);

if (config.dev) {
  builder.build().catch(err => {
    console.error(err); // eslint-disable-line no-console
    process.exit(1);
  });
}
```

`config` -> `nuxt` -> `builder` という順で作ってから`builder.build()`を実行しています。

しかし、`nuxt`インスタンスは作成後に`nuxt.ready()`を呼び出して準備完了を待たなければいけないようです。  
そうしないと、`nuxt`インスタンスの準備が整う前にビルドが開始して上手くいきません。

<object type="image/svg+xml" data="electron-nuxt-build.svg"></object>

今回の記事では`nuxt`インスタンスの作成直後に`await nuxt.ready()`を入れています。  
公式にもWARNINGとして記載されています。

{{<refer "Nuxt TypeScript" "https://typescript.nuxtjs.org/guide/setup.html#configuration">}}

> WARNING
>
> If you are using Nuxt programmatically with a custom server framework, note that you will need to ensure that you wait for Nuxt to be ready before building:


SQLiteの追加
------------

### インストール

```console
$ npx electron -v
v7.1.7
$ npm install -S sqlite3 ^
  --build-from-source ^
  --runtime=electron ^
  --target=7.1.7 ^
  --dist-url=https://atom.io/download/electron ^
  --python=c:\Python27\python.exe
```

```console
npm i -D @types/sqlite3
```

### ソースコードの変更


{{<file "db.ts">}}

```ts
import * as sqlite3 from 'sqlite3';

export function run() {
  const db = new sqlite3.Database(':memory:');

  db.serialize(function() {
    db.run('CREATE TABLE lorem (info TEXT)');

    const stmt = db.prepare('INSERT INTO lorem VALUES (?)');
    for (let i = 0; i < 10; i++) {
      stmt.run('Ipsum ' + i);
    }
    stmt.finalize();

    db.each('SELECT rowid AS id, info FROM lorem', function(err, row) {
      console.log(row.id + ': ' + row.info);
    });
  });

  db.close();
}
```

{{</file>}}

#### pages/index.vue

* `mounted() { run() }`をクラスのメソッドに追加 (importも忘れずに)

#### nuxt.config.js

* `extend(config, ctx)`の実装に`config.externals = { sqlite3: 'commonjs sqlite3' };`を追加


`npm run dev`で動けばOK😄


リポジトリ
----------

今後に備えて、今回のソースコードはGitHubにリポジトリとして作成しました。

{{<summary "https://github.com/tadashi-aikawa/nuxt-electron-typescript-sqlite3/tree/20191229">}}

上記リンクは本記事執筆時のタグにしています。  
今後変更があったときも変わりませんので、最新状況が気になる場合はmasterをご覧下さい。


総括
----

以下で紹介した組み合わせを、最新バージョンで動作するように作り直し確認しました。

{{<summary "https://blog.mamansoft.net/2019/10/08/nuxt-typescript-electron-sqlite-project/">}}

バージョンアップへの追従はフロントエンド開発からすると使命のようなものです。  
同じところで困っている人のお役に少しでも立てればと思っています。

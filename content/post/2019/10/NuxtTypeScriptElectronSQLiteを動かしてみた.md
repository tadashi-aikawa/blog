---
title: Nuxt × TypeScript × Electron × SQLiteを動かしてみた
slug: nuxt-typescript-electron-sqlite-project
date: 2019-10-08T23:05:27+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/8rzhoqi9gj8bo8z/freestocks-org-GYrxt-pUg8g-unsplash.jpg
categories:
  - engineering
tags:
  - nuxt
  - typescript
  - electron
  - sqlite
  - element
---

以下の技術を使ったネイティブアプリケーション作成土台を作ってみました。

* [Nuxt]
* [TypeScript]
* [Electron]
* [SQLite]

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/8rzhoqi9gj8bo8z/freestocks-org-GYrxt-pUg8g-unsplas"/>

{{<alert danger>}}
本記事は執筆時点のやり方であり、この分野は非常に変化が激しいです。  
時間が経過している場合は、必ず公式ドキュメントを確認の上、自己責任で実施してください。
{{</alert>}}

<!--toc-->


はじめに
--------

### 経緯

上記4技術を組み合わせた動作実績がWebでほとんど見つからなかったため、まとめてみました。

成果物ではなく作業過程を記載した読み物になっています。  
最終成果物だけでなく、そこに至った理由についての共有にもなればと思っています。

どうせ1ヶ月もしたら、その通りの手順では動かなくなってしまうので本質を汲み取っていただければと😄

### 前提

環境はWindows10です。

また、利用する技術の紹介はしません。  
技術の使い方を知らない場合は適宜調べて下さい。

### 方針

[Electron]や[Nuxt]の設定は極力JavaScriptで書きます。

[TypeScript]にすることでより堅牢になりますが、ハマリポイントが増えがちです。  
正直、設定部分にそこまで堅牢性は求めませんのでJavaScriptベースにしました。

### 利用技術のバージョン

|         利用技術          | バージョン |
| ------------------------- | ---------- |
| [Nuxt]                    | 2.10.0     |
| [TypeScript]              | 3.6.3      |
| [Electron]                | 6.0.11     |
| [sqlite3]                 | 4.1.0      |
| [Element]                 | 2.12.0     |
| [create-nuxt-app]         | 2.11.1     |
| [nuxt-property-decorator] | 2.4.0      |
| Python2                   | 2.7.14     |

[sqlite3]: https://github.com/mapbox/node-sqlite3
[create-nuxt-app]: https://github.com/nuxt/create-nuxt-app 
[nuxt-property-decorator]: https://github.com/nuxt-community/nuxt-property-decorator


プロジェクト作成
----------------

create-nuxt-appを使います。

{{<summary "https://github.com/nuxt/create-nuxt-app">}}

```bash
$ npx create-nuxt-app nuxt-electron-typescript-sqlite3
✨  Generating Nuxt.js project in nuxt-electron-typescript-sqlite3
? Project name nuxt-electron-typescript-sqlite3
? Project description My kickass Nuxt.js project
? Author name tadashi-aikawa
? Choose the package manager Npm
? Choose UI framework Element
? Choose custom server framework None (Recommended)
? Choose Nuxt.js modules Axios
? Choose linting tools Prettier
? Choose test framework Jest
? Choose rendering mode Single Page App
```

せっかくなのでUIフレームワークとして[Element]を入れます。  
他にもAxiosやJest、Prettierを採用していますが本記事では触れません。

インストールが完了したらディレクトリを移動して起動しましょう。

```bash
cd nuxt-electron-typescript-sqlite3
npm run dev
```

`http://localhost:3000`にアクセスして画面が表示されればOKです。


TypeScript対応
--------------

[TypeScript]に対応するための手順は公式ドキュメントに書かれています。

{{<summary "https://typescript.nuxtjs.org/guide/setup.html#installation">}}

### インストール

`@nuxt/typescript-build`だけをインストールすればOKです。

```bash
npm install --save-dev @nuxt/typescript-build
```

### 設定

ドキュメントの通りに設定を作成/追加します。

#### nuxt.config.js変更

`buildModules`に`@nuxt/typescript-build`を追加します。

```js
module.exports = {
  // ...中略...
  buildModules: ['@nuxt/typescript-build'],
  // ...中略...
}
```

#### tsconfig.json作成

公式ドキュメントの記載通りの作成します。

{{<file "tsconfig.json">}}

```json
{
  "compilerOptions": {
    "target": "esnext",
    "module": "esnext",
    "moduleResolution": "node",
    "lib": ["esnext", "esnext.asynciterable", "dom"],
    "esModuleInterop": true,
    "allowJs": true,
    "sourceMap": true,
    "strict": true,
    "noEmit": true,
    "baseUrl": ".",
    "paths": {
      "~/*": ["./*"],
      "@/*": ["./*"]
    },
    "types": ["@types/node", "@nuxt/types"],
  },
  "exclude": ["node_modules"]
}
```

{{</file>}}

実行するとエラーが出ます。

```
$ npm run dev
90:18 Interface 'NuxtApp' incorrectly extends interface 'Vue'.
  Types of property '$loading' are incompatible.
    Type 'NuxtLoading' is not assignable to type '(options: LoadingServiceOptions) => ElLoadingComponent'.
      Type 'NuxtLoading' provides no match for the signature '(options: LoadingServiceOptions): ElLoadingComponent'.
    88 | }
    89 |
  > 90 | export interface NuxtApp extends Vue {
       |                  ^
    91 |   $options: NuxtAppOptions
    92 |   $loading: NuxtLoading
    93 |   context: Context
```

### 名前空間の競合を回避する

NuxtAppが継承するVueと[Element]に定義されたVue、それぞれに定義された`$loading`が競合してしまっているようです。

{{<summary "https://github.com/nuxt/typescript/issues/49">}}

不幸なことに2019-10-08現在ではUIフレームワークの中で[Element]だけがこの問題にぶち当たります。

{{<summary "https://github.com/ElemeFE/element/issues/17329">}}

`node_modules`を直接いじるのは避けたいので、`tsconfig.json`の設定を追加します。

```json
  "compilerOptions": {
    // ...中略...
    "skipLibCheck": true,
  }
```

{{<warn "skipLibCheckについて">}}
全ての`*.d.ts`ファイルに対して型のチェックを無視するオプションです。

このオプションを`true`にすると、packageの型に問題があった場合それを検知できません。  
使わなくて済むようになったら、`false`に戻す or 削除することを推奨します。
{{</warn>}}


### ソースコードをTypeScriptにする

せっかくなので`pages/index.vue`をTypeScriptのコードとして書きましょう。  
クラス形式が好きなので、`nuxt-property-decorator`をインストールします。

```bash
npm i -D nuxt-property-decorator
```

デフォルトでは、試験的機能であるデコレータは無効なので`tsconfig.json`を編集して有効にします。

```json
  "compilerOptions": {
    // ...中略...
    "experimentalDecorators": true,
  }
```

普通に書くと`index.vue`のScriptタグ部分が以下の様になると思います。

```html
<script lang="ts">
import Logo from '~/components/Logo';
import { Component, Vue } from 'nuxt-property-decorator';

@Component({
  components: {
    Logo,
  },
})
export default class extends Vue { }
</script>
```

このまま`npm run dev`を実行するとエラーが出ると思います。

```plain
Cannot find module '~/components/Logo'
```

### .vueファイルを解決させる

まずimport元に拡張子を付けます。

```ts
import Logo from '~/components/Logo.vue';
```

このままでは`.vue`ファイルをimportできません。
そこで、`index.d.ts`を作り`.vue`拡張子のファイルを[TypeScript]に認識させます。

{{<file "index.d.ts">}}

```ts
declare module '*.vue' {
  import Vue from 'vue';
  export default Vue;
}
```

{{</file>}}

再び`npm run dev`を実行して画面が表示されればOKです。


Electron対応
------------

### インストール

```bash
npm i -D electron
```

### Electronのエントリファイル作成

[TypeScript]は使いません。よくあるテンプレートを少しカスタマイズしています。

{{<file "main.js">}}

```js
// Nuxt
const { Nuxt, Builder } = require('nuxt');
let config = require('./nuxt.config.js');
config.rootDir = __dirname; // for electron-builder
const nuxt = new Nuxt(config);
const builder = new Builder(nuxt);

if (config.dev) {
  builder.build().catch(err => {
    console.error(err); // eslint-disable-line no-console
    process.exit(1);
  });
}

// HTTP server
const http = require('http');
const server = http.createServer(nuxt.render);
server.listen();
const _NUXT_URL_ = `http://localhost:${server.address().port}`;
console.log(`Nuxt working on ${_NUXT_URL_}`);

// Electron
const electron = require('electron');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;
let win = null;

const newWin = () => {
  win = new BrowserWindow({
    webPreferences: {
      nodeIntegration: true,
    },
  });
  win.maximize();
  win.on('closed', () => (win = null));
  if (config.dev) {
    const pollServer = () => {
      http
        .get(_NUXT_URL_, res => {
          if (res.statusCode === 200) {
            win && win.loadURL(_NUXT_URL_);
          } else {
            setTimeout(pollServer, 300);
          }
        })
        .on('error', pollServer);
    };
    pollServer();
  } else {
    return win.loadURL(_NUXT_URL_);
  }
};

app.on('ready', newWin);
app.on('window-all-closed', () => app.quit());
app.on('activate', () => win === null && newWin());
```

{{</file>}}

はじめの5行がポイントです。  
`nuxt.config.js`から設定を読みこみ、それに従ってビルドするbuilderを生成しています。

```js
const { Nuxt, Builder } = require('nuxt');
let config = require('./nuxt.config.js');
config.rootDir = __dirname; // for electron-builder
const nuxt = new Nuxt(config);
const builder = new Builder(nuxt);
```

また`config.dev`というプロパティが登場します。  
しかし、現時点では`nuxt.config.js`にこれは定義されていません。

```js
if (config.dev) {
  builder.build().catch(err => {
    console.error(err); // eslint-disable-line no-console
    process.exit(1);
  });
}
```

そのため、`nuxt.config.js`に少し設定を追加します。


### nuxt.config.jsの変更

環境変数の値を見て、開発モードの場合だけ`true`になる`dev`プロパティを定義します。

```js
module.exports = {
  // ...中略...
  dev: process.env.NODE_ENV === 'DEV',
  // ...中略...
}
```

### package.jsonの変更

`npm run dev`では開発モードになるよう環境変数を設定します。  
Windowsなので`cross-env`をインストールします。

```bash
npm i -D cross-env
```

`package.json`のコマンドを以下のようにします。  
表向きは`nuxt`コマンドが登場しません。

```json
  "scripts": {
      // ...中略
    "dev": "cross-env NODE_ENV=DEV electron main.js",
      // ...中略
  }
```

`npm run dev`を実行し、[Electron]が起動してTopページが表示されたらOKです。


SQLiteの追加
------------

最後は[SQLite]を追加します。  
node-sqlite3を使います。

{{<summary "https://github.com/mapbox/node-sqlite3">}}

### インストール

[SQLite]はC++で作成されているため、現在の[Electron](V8)バージョンやディストリビューションに依存します。  
そのため、通常のインストールではなくソースコードからビルドする必要があります。

{{<summary "https://github.com/mapbox/node-sqlite3#custom-builds-and-electron">}}

上記のコマンドをバージョン指定のうえ実行します。

```bat
$ npx electron -v
v6.0.11
$ npm install -S sqlite3 ^
  --build-from-source ^
  --runtime=electron ^
  --target=6.0.11 ^
  --dist-url=https://atom.io/download/electron ^
  --python=c:\Python27\python.exe
```

実行には以下が前提となっていますので要注意です。

* Python2がインストールされていること
* Visual Studio 2015 Windows Build Toolsがインストールされていること

`--python`では *Python2* のインタープリタを指定してください。  
C++アドオンをバイナリからインストールするための[node-pre-gyp]が2系を必要とするからです。

{{<warn "別のVisual StudioでWindows Build Toolsが入っている場合は..">}}
2015のそれをインストールしても参照できずにエラーとなる可能性があります。  
以下などを参考に2015のそれを参照するようにしてください。

{{<summary "https://github.com/mapbox/node-sqlite3/issues/548">}}
{{</warn>}}

ついでに型ファイルもインストールしてしまいます。

```bash
npm i -D @types/sqlite3
```

### ソースコードの変更

`db.ts`を作成し、sqlite3のサンプルコードを少し加工した内容を転記します。

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

`pages/index.vue`のscriptタグ内を編集します。  
コンポーネントがマウントされた直後に先ほどの`run()`を呼び出します。

```html
<script lang="ts">
import Logo from '~/components/Logo.vue';
import { Component, Vue } from 'nuxt-property-decorator';
import { run } from '~/db';

@Component({
  components: {
    Logo,
  },
})
export default class extends Vue {
  mounted() {
    run();
  }
}
</script>
```

期待値は以下のとおりです。

* 起動後にオンメモリのDBが作成される
* データがINSERTされる
* データがSELECTされる

うまくいけばコンソールにログが出力されるはずです。


### nuxt.config.jsの変更

sqlite3は[webpack]でバンドルされると都合が悪いため、バンドル対象から外します。

```js
module.exports = {
  // ...中略...
    extend(config, ctx) {
      config.externals = { sqlite3: 'commonjs sqlite3' };
    },
  // ...中略...
}
```

この状態で`npm run dev`を実行すると`require`が理解できないというエラーになります。

```plain
ReferenceError: require is not defined
```

{{<summary "https://github.com/mapbox/node-sqlite3/issues/1029">}}

上記は[Electron]のRenderプロセスであるため、Node.jsの機能である`require`は理解できないのです。


### Renderプロセスでrequireを理解させる

`BrowserWindow`作成時にオプションで`nodeIntegration`を有効にします。

{{<error "リモートにアクセスする場合はnodeIntegrationを有効にしないで">}}
公式サイトに色々注意書きがありますので、必ず確認しましょう。  
もし **リモートなど不明なリソースにアクセスする可能性がある場合** は **nodeIntegrationを有効にせず** 代わりに **preload scriptを作成して読み込むべき** です。

{{<summary "https://electronjs.org/docs/tutorial/security#2-do-not-enable-nodejs-integration-for-remote-content">}}

{{</error>}}

```js
const newWin = () => {
  win = new BrowserWindow({
    webPreferences: {
      nodeIntegration: true,
    },
  });
  // ...中略
};
```

これで`npm run dev`を実行すると全てが動くはずです😄


総括
----

[Nuxt] × [TypeScript] × [Electron] × [SQLite]な構成をもつプロジェクトの作り方を作業過程ベースでまとめてみました。

ネイティブアプリをWebの技術だけで開発できることは非常に魅力的です。  
脆弱性問題と向き合いながら、状況に応じた構成で良いプロダクトを開発したいですね。


[Nuxt]: https://ja.nuxtjs.org/
[TypeScript]: http://www.typescriptlang.org/
[Electron]: https://electronjs.org/
[SQLite]: https://www.sqlite.org/index.html
[Element]: https://element.eleme.io/#/en-US
[node-pre-gyp]: https://www.npmjs.com/package/node-pre-gyp
[webpack]: https://webpack.js.org/

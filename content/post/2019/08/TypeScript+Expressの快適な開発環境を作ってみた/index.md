---
title: TypeScript+Expressの快適な開発環境を作ってみた
slug: develop-express-with-typescript-cool-environment
date: 2019-08-12T09:17:44+09:00
thumbnailImage: images/cover/2019-08-12.jpg
categories:
  - engineering
tags:
  - typescript
  - express
  - jest
  - prettier
  - nodejs
---

[Express]のAPIプロダクトをTypeScriptで快適に開発する準備を整えてみました。

<!--more-->

{{<cimg "2019-08-12.jpg">}}

<!--toc-->


はじめに
--------

本記事では[express-generator]で作成されたサンプルプロジェクトを、TypeScriptで快適に開発できる環境へ整えていきます。

* TypeScriptで開発できるようにする
* JavaScriptとTypeScriptを共存させる
* ソースコードに変更があったら自動で再コンパイル+再起動させる
* ソースコードのdocに記載した内容を仕様書に同期させる
* ソースコードを保存したら自動フォーマットをかける
* テストが書ける
* 必要な時にブラウザを自動リロードできる


### 前提条件

* OSはWindows10
* node.jsのバージョンはv10.13.0

### 想定する読者

TypeScriptとExpressの開発経験があり、GitHubのREADMEを読めば開発できる方を対象としています。

利用する技術について、丁寧な説明はしませんのでご了承ください。


プロジェクト作成
----------------

[express-generator]をインストールして、プロジェクトを作成します。

```
$ npm i -g express-generator
+ express-generator@4.16.1

$ express -v pug express-typescript
```

JavaScriptプロジェクトとして動くことを確認します。

```
$ cd express-typescript
$ npm i
$ npm start
```

`http://localhost:3000`にアクセスしてシンプルな画面が表示されればOKです。


TypeScript化
------------

TypeScriptと[Express]の型定義をインストールします。

```
$ npm i -D typescript @types/express
```

`tsconfig.json`を作成します。

```
$ npx tsc --init -t es2015
```

### app.jsをapp.tsにする

`app.js`をTypeScriptファイルにします。  
そのため、importしているpackageの型定義をインストールします。

```
$ npm i -D @types/cookie-parser @types/morgan @types/http-errors
```

`app.js`の代わりに`app.ts`を作ります。

{{<file "app.ts">}}
```ts
import createHttpError from "http-errors";
import express from "express";
import { Request, Response, NextFunction } from "express";
import path from "path";
import cookieParser from "cookie-parser";
import logger from "morgan";

import { router as indexRouter } from "./routes/index";
// TODO: JavaScriptファイルとの共存は後でやる
// import usersRouter from "./routes/users";

const app = express();

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "pug");

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use("/", indexRouter);
// TODO: JavaScriptファイルとの共存は後でやる
// app.use("/users", usersRouter);

app.use((req: Request, res: Response, next: NextFunction) =>
  next(createHttpError(404))
);
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  res.status(err.status || 500);
  res.render("error");
});

module.exports = app;
```
{{</file>}}


### index.jsをindex.tsにする

`routes`配下には2つのファイルがあります。

* index.js
* users.js

今回は`index.js`だけをTypeScriptファイルにします。  
`users.js`は敢えてJavaScriptファイルのままにしておきますが、`app.ts`ではコメントアウトされているためコンパイルに影響はありません。

{{<file "index.ts">}}
```ts
import { Router } from "express";

export const router = Router();

router.get("/", (req, res, next) => res.render("index", { title: "Express" }));
```
{{</file>}}


コンパイルすると、TypeScriptファイルと同じ階層に各JavaScriptファイルができます。

```
$ tsc
```

`npm start`で動作確認しましょう。


JavaScriptと共存する
--------------------

実際の開発では全てを一度にTypeScriptファイル化するのは難しいケースが多々あります。  
そのため、JavaScriptファイルを共存できるようにします。

### 設定の変更

`tsconfig.json`で以下のオプションを追加します。

```json
{
  "compilerOptions": {
    "outDir": "./dist",
    "allowJs": true,
  }
}
```

{{<why "outDirを指定するのはなぜ?">}}
デフォルトではコンパイル後のjsファイルはtsファイルと同じ場所に生成されます。

しかし、`--allowJs: true`の場合は元々あったJavaScriptファイルをコンパイル結果のJavaScriptファイルで上書きしてしまうリスクがあります。
tscはこれを防ぐためTS5055エラーを出します。  

`outDir`を指定することにより上記のリスクを防げます。  
その結果、`tsc`はエラーを出さなくなります。
{{</why>}}

### コメンアウトを戻す

`routes/users`に関するコメントアウトを戻します。

```diff
  import { router as indexRouter } from "./routes/index";
- // TODO: JavaScriptファイルとの共存は後でやる
- // import usersRouter from "./routes/users";
+ import usersRouter from "./routes/users";
 
...

  app.use("/", indexRouter);
- // TODO: JavaScriptファイルとの共存は後でやる
- // app.use("/users", usersRouter);
+ app.use("/users", usersRouter);
 
```

### 相対パスの起点を変更

`app.ts`の`__dirname`を削除します。  
パスの指定を`dist`配下からではなく、プロジェクトルートからの相対パスにしたいからです。

```diff
  const app = express();
  
- app.set("views", path.join(__dirname, "views"));
+ app.set("views", "views");
  app.set("view engine", "pug");
  
  app.use(logger("dev"));
  app.use(express.json());
  app.use(express.urlencoded({ extended: false }));
  app.use(cookieParser());
- app.use(express.static(path.join(__dirname, "public")));
+ app.use(express.static("public"));
  
  app.use("/", indexRouter);
 
```

### 起動スクリプトの修正

`bin/www`のappもパスを変更します。

```diff
- var app = require('../app');
+ var app = require('../dist/app');
 
```

`npm start`を実行して`http://localhost:3000/users`にアクセスできればOKです。


変更があったときに自動再起動
----------------------------

[tsc-watch]を使います。  
はじめは[nodemon]を使っていましたが、以下の理由で変更しました。

* hot build可能な差分コンパイルをしたい
    * `--increment`を使ったcold buildの差分コンパイルより速い
* [nodemon]を使う場合より必要なpackageが少ない
    * 依存packageを減らすことは重要

[tsc-watch]は`tsc --watch`コマンドが終了した後の挙動を指定できるpackageです。  
スターの数は[nodemon]と比べると多くありませんが非常にCoolです👍

{{<summary "https://github.com/gilamran/tsc-watch">}}

{{<why "なぜ`tsc --watch`ではダメ?">}}
`tsc --watch`はソースコードの変更があった場合に自動で再コンパイルしてくれます。  
しかし、コンパイルが終わった後に処理を実行できません。

`tsc --watch && exec ...`は想定通り動きません。  
`tsc --watch`が監視している間、そのコマンドは終わることがないからです。
{{</why>}}

### tsc-watchのインストール

```
$ npm i -D tsc-watch
```

### scriptsコマンドの設定

`package.json`の`scripts`に`dev`コマンドを設定します。

```json
  "scripts": {
    "dev": "rm -rf dist && set DEBUG=express-typescript:* & tsc-watch --noClear --onSuccess \"node ./bin/www\"",
  },
```

{{<why "pug,html,css,jsonなどの変更検知は不要か?">}}
不要と考えています。  
それらは静的ファイルであり、大抵の場合はnode.jsの再起動が必要ないからです。
{{</why>}}

{{<info "nodemonを使った場合の設定">}}
[nodemon]を使った場合の設定は以下のようになりました。

```json
  "scripts": {
    "dev": "nodemon -e ts,js --ignore dist/ --exec npm start",
    "start": "tsc && set DEBUG=express-typescript:* & node ./bin/www"
  },
```

[tsc-watch]の方がシンプルですね😉

[nodemon]: https://nodemon.io/
[tsc-watch]: https://github.com/gilamran/tsc-watch
{{</info>}}



Docと仕様書を連携させる
----------------------

ソースコードのDocがそのまま仕様書になるのは何事にも代えがたい安心感があります。  
以前に以下の記事で紹介したswagger-uiと[Express]の連携を使います。

{{<summary "https://blog.mamansoft.net/2019/06/18/create-api-specification-with-express/">}}


### swagger-uiと関係packageのインストール

TypeScriptなので型定義もインストールします。

```
$ npm i -D swagger-ui-express swagger-jsdoc @types/swagger-ui-express @types/swagger-jsdoc
```

### app.tsの変更

基本的に上記記事の通りです。

```diff
import createHttpError from "http-errors";
import express from "express";
import { Request, Response, NextFunction } from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";

+ import swaggerUi from "swagger-ui-express";
+ import swaggerJSDoc from "swagger-jsdoc";

...

const app = express();

+ // Swagger
+ const options = {
+   swaggerDefinition: {
+     info: {
+       title: "Express TypeScript",
+       version: "1.0.0"
+     }
+   },
+   apis: ["routes/*"]
+ };
+ app.use("/spec", swaggerUi.serve, swaggerUi.setup(swaggerJSDoc(options)));

...
 
```

### index.ts

Docを追加しただけなので差分ではなく`index.ts`全てを記載します。

`index.ts`
```ts
import { Router } from "express";

export const router = Router();

/**
 * @swagger
 * /:
 *   get:
 *     description: タイトルを返却する
 *     produces:
 *       - application/json
 *     responses:
 *       200:
 *         description: タイトル
 */
router.get("/", (req, res, next) => res.render("index", { title: "Express" }));
```

`http://localhost:3000/spec`にアクセスして仕様書が表示されればOKです。  
勿論、Docを書き換えたら再起動します。(自動リロードはされません)


ファイルの自動フォーマット
--------------------------

[Prettier]を使ってファイル保存時に自動フォーマットをかけます。  
先日記事を書いたばかりなので詳細は下記をご覧下さい。

{{<summary "https://blog.mamansoft.net/2019/08/08/only-use-prettier-typescript-auto-format/">}}

### Prettierのインストール

```
$ npm i -D prettier
```

### .prettierrc.yamlの設定

```yaml
printWidth: 120
tabWidth: 2
useTabs: false
semi: true
singleQuote: true
quoteProps: as-needed
trailingComma: all
bracketSpacing: true
arrowParens: avoid
```


テストを書く
------------

[Jest]を使います。

{{<summary "https://jestjs.io/ja/">}}

### Jestのインストール

TypeScriptで使うため型定義が必要です。

```
$ npm i -D jest @types/jest
```

また、TypeScriptをトランスパイルするためにBabel関連のpackageが必要です。

```
$ npm i -D babel-jest @babel/core @babel/preset-env @babel/preset-typescript
```

### jest.config.jsの設定

[Jest]の設定を作成します。  
`node_modules`と`dist`はテスト対象から外します。

```js
module.exports = {
  verbose: true,
  collectCoverage: true,
  testPathIgnorePatterns: ["/node_modules/", "/dist/"]
};
```

### babel.config.jsの設定

TypeScriptのプロダクトコードをテストできるよう設定ファイルを作成します。

```js
module.exports = {
  presets: [
    ["@babel/preset-env", { targets: { node: "current" } }],
    "@babel/preset-typescript"
  ]
};
```

### tsconfig.jsonの設定

テストファイルをコンパイルや監視対象から外します。

```diff
      "esModuleInterop": true
-   }
+   },
+   "exclude": ["dist", "node_modules", "**/*.test.ts"]
  }
 
```

### テストコードを書く

テストの動作確認用に`utils`ディレクトリと以下ファイルを作成します。

```
utils
├── math.test.ts
└── math.ts
```

`math.ts`
```ts
export function crazySum(x: number, y: number): number {
  return x + y - 1;
}
```

`math.test.ts`
```ts
import { crazySum } from "./math";

test("crazySum is sum and minus 1", () => {
  expect(crazySum(1, 3)).toBe(3);
});
```

### scriptsコマンドの設定

`package.json`の`scripts`に`test`コマンドを設定します。

```json
  "scripts": {
    "test": "jest"
  },
```

`npm test`を実行してテストが成功すればOKです。


ブラウザの自動リロード
----------------------

これで最後です。  
以下のケースでブラウザが自動リロードされるようにします。

* `.pug`ファイルに変更があったとき
* `.css`ファイルに変更があったとき


### BrowserSyncのインストール

[BrowserSync]を使います。

{{<summary "https://browsersync.io/">}}

```
$ npm i -D browser-sync
```

### /bin/wwwの変更

前半のコードを以下のように変更します。

```ts
/**
 * User Browser Sync when development
 */
let defaultPort = 3000;
if (process.env.NODE_ENV !== 'production') {
  console.log('User browser sync..');
  var browserSync = require('browser-sync');
  defaultPort = 3333;
  browserSync({
    open: false,
    proxy: `localhost:${defaultPort}`,
    files: ['./**/*.pug', './**/*.css'],
  });
}

/**
 * Get port from environment and store in Express.
 */
var port = normalizePort(process.env.PORT || defaultPort);
app.set('port', port);
```

BrowserSyncをプロキシサーバ`localhost:3333`として使います。  
一方、本番稼働する場合はBrowserSyncを使わないようにします。

`port`の設定以降は処理を共通化できます。

{{<why "`open: false`を設定しているのはなぜ?">}}
[tsc-watch]で`/bin/www`を再起動したとき、新しくブラウザタブが開くのを防ぐためです。  
毎回トップページが開くためメリットもありません。

[tsc-watch]: https://github.com/gilamran/tsc-watch
{{</why>}}

### scriptsコマンドの設定

`package.json`の`scripts`に`start`を追加します。

```json
  "scripts": {
    "start": "rm -rf dist && tsc && set NODE_ENV=production& node ./bin/www",
  },
```

今までプロダクションビルドコマンドを用意していなかったので、この機会に追加しました。  
`npm run dev`と`npm start`のそれぞれで、[BrowserSync]が起動するかを確かめてみましょう。

{{<warn "`NODE_ENV=production`が効いていない場合は...">}}
`production`と`&`の間にスペースを入れてないか確認してください。  
Windowsでそれは空白文字と見なされます。

* 🆖 `set NODE_ENV=production & node ./bin/www`
* 🆗 `set NODE_ENV=production& node ./bin/www`
{{</warn>}}

pugファイルやCSSファイルを編集して、その場でブラウザが自動更新されればOKです😄


総括
----

[Express]のAPIプロダクトをTypeScriptで快適に開発できる環境を構築しました。

開発環境の快適さはプロダクティビティに直結します。  
目先の時間に目を奪われず、腰を添えて取り組みたいですね😉

[Express]: https://expressjs.com/
[express-generator]: https://www.npmjs.com/package/express-generator
[nodemon]: https://nodemon.io/
[tsc-watch]: https://github.com/gilamran/tsc-watch
[Jest]: https://jestjs.io/ja/
[Prettier]: https://prettier.io/
[BrowserSync]: https://browsersync.io/


---
title: Electronのe2eテストを書いてみた
slug: electron-e2etest-use-spectron
date: 2019-10-23T14:49:29+09:00
thumbnailImage: images/cover/2019-10-23.jpg
categories:
  - engineering
tags:
  - electron
  - spectron
  - jest
---

[Spectron]と[Jest]を使ってElectronのテストを書いてみました。

<!--more-->

{{<cimg "2019-10-23.jpg">}}

<!--toc-->


はじめに
--------

Electronのe2eテストをずっと実施したかったので試してみました。

{{<why "TypeScriptを使わないのはなぜ?">}}
`webdriverio`の型定義が参照できないためです。

[WebDriverIO]は5系から型定義に公式対応したため、4系までで使っていた`@types/webdriverio`は凍結されました。
しかし、[Spectron]が依存する[WebDriverIO]は4系のままであるため参照できません。

以下にIssueが作成されていますが、すぐに対応される様子ではなさそうでした。

{{<summary "https://github.com/electron-userland/spectron/issues/349">}}

上記を回避して[Jest]なども含めて[TypeScript]対応するより、このままJavaScriptを使った方が良いと考えました。

[Spectron]: https://electronjs.org/spectron
[Jest]: https://jestjs.io/
[TypeScript]: http://www.typescriptlang.org/
[WebDriverIO]: https://webdriver.io/
{{</why>}}


### 想定する読者

以下の技術を理解していること

* Node.js (npm)
* [Electron]
* [Jest]

### 環境

#### OS

Windows10

#### 利用するプロジェクト

以下記事で構築した環境をベースに、UI/処理のロジックを少し変更したものを使います。

{{<summary "https://blog.mamansoft.net/2019/10/08/nuxt-typescript-electron-sqlite-project/">}}

#### packageのバージョン

今回重要なpackageのみを記載します。  
その他については先ほど紹介した以前の記事をご覧下さい。

|  package名   | バージョン |
| ------------ | ---------- |
| Node.js      | 10.13.0    |
| [Electron]   | 6.0.11     |
| [Spectron]   | 8.0.0      |
| [Jest]       | 24.9.0     |


Spectronとは
------------

[Spectron]は[Electron]の統合つとを簡潔に行うフレームワークです。

{{<summary "https://electronjs.org/spectron">}}

Node.js環境で利用可能なテストフレームワーク[WebDriverIO]をラップしています。

### インストール

npmでインストールします。

```
npm i -D spectron
```


テストファイル作成
------------------

テストファイルを4つ作成します。

```
.
test
  ∟util.js           // 共通処理
  ∟pages
    ∟BasePage.js     // テストサポート用のベースクラス
    ∟TopPage.js      // テストサポート用のトップページのクラス
  ∟spec.js           // テストコード本体
```

公式をかなり参考にさせていただきました。

{{<summary "https://github.com/pumano/spectron-typescript-starter">}}

### util.js

Electronのエントリポイントは`main.js`を想定しています。

```js
const Application = require('spectron').Application;
const electronPath = require('electron');

export async function bootApp() {
  const app = new Application({
    path: electronPath,
    args: ['main.js'],
  });
  await app.start();
  return app;
}

export async function terminateApp(app) {
  await app.stop();
}
```

### pages/BasePage.js

今回はPageの機能として以下3つの共通処理を実装しました。

* 要素をクリックする
* 要素の数を数える
* 要素のテキストを取得する

それぞれメソッドとして実装しています。

```js
export class BasePage {
  static create(clz, app) {
    const ins = new clz();
    ins.app = app;
    return ins;
  }

  async waitFor(selector) {
    await this.app.client.waitForExist(selector);
  }

  async clickElement(elementSelector) {
    await this.waitFor(elementSelector);
    this.app.client.$(elementSelector).click();
  }

  async countElements(elementsSelector) {
    await this.waitFor(elementsSelector);
    return (await this.app.client.$$(elementsSelector)).length;
  }

  async getText(elementSelector) {
    await this.waitFor(elementSelector);
    return this.app.client.getText(elementSelector);
  }
}
```

`await`を忘れただけで正常に動作しなくなりますので、ご注意を..。

### pages/TopPage.js

BasePageを実装しています。  
基本的にSelectorの定義が中心になると思います。

```js
import { BasePage } from '~/test/pages/BasePage';

export const INIT_BUTTON = '#init-db-button';
export const INFORMATION_ALERT = '#information-alert';

export const CARDS = '#card-area > *';

export class TopPage extends BasePage {
  static create(app) {
    return BasePage.create(TopPage, app);
  }
}
```

### spec.js

本体です。

```js
import { bootApp, terminateApp } from '~/test/util';
import { TopPage, INIT_BUTTON, INFORMATION_ALERT, CARDS } from '~/test/pages/TopPage';

const TIMEOUT = 15 * 1000;

let app;
let topPage;

beforeAll(async () => {
  app = await bootApp();
  topPage = TopPage.create(app);
}, TIMEOUT);

afterAll(async () => {
  await terminateApp(app);
});

describe('Insert records in top page.', () => {
  test('shows an initial window', async () => {
    expect(await app.client.getWindowCount()).toBe(1);
  });

  test('Initialize DB when button is clicked', async () => {
    await topPage.clickElement(INIT_BUTTON);
    expect(await topPage.countElements(CARDS)).toBe(10);
    expect(await topPage.getText(INFORMATION_ALERT)).toBe('データが入りました');
  });
});
```

{{<warn "app.clientで何ができるか分からない..調べてもうまくいかない">}}
[Spectron]の`app.client`は[WebDriverIO]の`browser`に相当します。  
[Spectron]のREADMEに記載があります。

{{<summary "https://github.com/electron-userland/spectron/blob/master/README.md#properties">}}

注意として *上記READMEに記載された[WebDriverIO]のリンクは正しくありません*。

リンクをクリックすると最新の仕様書..つまり5系のページが表示されます。  
しかし、[Spectron]で現在対応している仕様書は4系です。

そのため4系のサイトでAPI仕様書を閲覧しなければいけません。

{{<summary "http://v4.webdriver.io/">}}

ハマリどころでもあるのでご注意下さい。

[Spectron]: https://electronjs.org/spectron
[WebDriverIO]: https://webdriver.io/
{{</warn>}}


実行
----

`package.json`の`scripts`が以下の場合を想定します。

```js
  "scripts": {
    "dev": "cross-env NODE_ENV=DEV electron main.js",
    "build": "rm -rf dist && nuxt build",
    "test": "jest",
    "e2etest": "jest test/spec.js"
  },
```


今回はNuxtを使っているため事前にビルドが必要です。  
`npm run dev`のあとに`npm run e2etest`を実行しても起動に失敗します。

```
npm run build && npm run e2etest
```

実際の動作は以下のようになります。

{{<mp4 "resources/20191023_1.mp4">}}

一瞬なので瞬きしないように注意して下さいね😉


トラブルシューティング
----------------------

### this.timeout is not a function

Jestだと存在しない`timeout`を呼び出しているためです。  
mochaのサンプルコードをコピペするとハマリます。

なお、デフォルトのタイムアウト5秒では以下のエラーになると思います。

```
Timeout - Async callback was not invoked within the 5000ms timeout specified by jest.setTimeout.Error: Timeout - Async callback was not invoked within the 5000ms timeout specified by jest.setTimeout.
```

Electronアプリケーションの実行に5秒以上かかっているからです。  
それを回避するため上記コードでは15秒に設定していました。

```js
const TIMEOUT = 15 * 1000;

let app;
let topPage;

beforeAll(async () => {
  app = await bootApp();
  topPage = TopPage.create(app);
}, TIMEOUT);
```

### Server error

`nuxt build`に失敗した状態で起動すると発生します。

```
Renderer is loaded but not all resources are available! Please check C:\Users\syoum\tmp\nuxt-electron-typescript-sqlite3\.nuxt\dist\server existence.
```

[Spectron]や[Jest]ではなくNuxtに関する問題ですね。


総括
----

[Spectron]と[Jest]を使ってElectronのテストを書いてみました。

[WebDriverIO]の対応バージョンが古いためハマリどころも多いですが、公式プロダクトなので[Electron]という意味では安心感があります。

新しめのテストフレームワーク[Cypress]でも[Electron]対応が進められていますので、将来的にこちらへ移行する可能性はあります。

{{<summary "https://github.com/cypress-io/cypress/issues/4964">}}

e2eテストはやりすぎるとメンテコストが割にあいません。  
結果が返らない、フリーズする、画面遷移しないなどクリティカルな不具合確認に留めた方が良さそうです。

[Electron]: https://electronjs.org/
[Spectron]: https://electronjs.org/spectron
[Jest]: https://jestjs.io/
[TypeScript]: http://www.typescriptlang.org/
[WebDriverIO]: https://webdriver.io/
[Cypress]: https://github.com/cypress-io/cypress/issues/4964

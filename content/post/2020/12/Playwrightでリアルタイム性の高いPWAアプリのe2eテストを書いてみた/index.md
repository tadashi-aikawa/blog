---
title: Playwrightでe2eテストを書いてみた
slug: playwright-realtime-e2e-web-test
date: 2020-12-20T23:27:43+09:00
thumbnailImage: images/cover/2020-12-20.jpg
categories:
  - engineering
tags:
  - test
  - togowl
  - playwright
  - puppeteer
  - cypress
  - jest
  - idea
  - javascript
  - typescript
  - nuxt
  - github
---

Playwrightを使って、Togowlのe2eテストを書いてみました。

<!--more-->

{{<cimg "2020-12-20.jpg">}}

<!--toc-->


Togowlとは
----------

私が開発している時間/タスク管理のWebアプリです。  
バックエンドではTodoist/TogglのAPIを使っています。

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

同期機能を使ったリアルタイム性の高いアプリケーションですが、本稿ではそこまで高度なテストの書き方は紹介しません。  
必要最低限の内容を紹介します。


Playwrightとは
--------------

Microsoftが開発しているブラウザ自動テスト用のライブラリです。

{{<summary "https://playwright.dev/">}}

大きな特徴として以下があります。

* Chrome/Firefox/Safari/Edge すべてに対応
* Linux/Mac/Windows すべてに対応
* モバイルに適したテスト機能搭載
* Sleepを使わない人間に直感的なテストコードが書ける
* 複数のブラウザやタブ、フレームをエミュレートしたテストが可能


なぜPlaywrightか
----------------

以下2つの記事を読んで、TogowlにはPlaywrightが向いていると思ったからです。

{{<summary "https://blog.logrocket.com/playwright-vs-puppeteer/">}}

{{<summary "https://medium.com/sparebank1-digital/playwright-vs-cypress-1e127d9157bd">}}

具体的な決め手は以下3つです。

* 複数のブラウザやタブ、フレームをエミュレートしたテストが可能
    * Togowlは複数端末で同期する機能がある
* Linux/Mac/Windows すべてに対応
    * Togowlはマルチプラットフォーム/クラスブラウザをサポートしている
* Jestを使っている
    * TogowlはJestを使っている

**Puppeteerの開発チーム(元Google)がMicrosoftで開発している**という点も大きかったです。  
特に私はWindowsを使っているため、Windows環境が保証されていることが大きな魅力でした。


インストールから起動まで
------------------------

公式ドキュメントを見ながら進めていきます。

{{<summary "https://playwright.dev/#version=v1.6.2&path=docs%2Fintro.md&q=">}}


### インストール

npmプロジェクト配下でインストールします。

```
npm i -D playwright
```

### サンプルコード作成

TOPページでキャプチャを保存するだけのコードを書いてみます。

```js
const chromium = require("playwright").chromium;

(async () => {
  const browser = await chromium.launch();

  const page = await browser.newPage();
  await page.goto("http://localhost:3000");
  await page.screenshot({ path: "./picture.png" });

  await browser.close();
})();
```

こんな構成です。

```
  ./e2e
└──   test.js
```

### 実行

実行してみます。

```
node e2e/test.js
```

カレントディレクトリ配下に`picture.png`が作成されていました。

{{<himg "resources/picture.png">}}

ログイン画面が映っているので問題なさそうですね😊


テストランナーの導入
--------------------

ブラウザを操作するだけではテストになりません。  
表示された内容と期待結果を確認する必要があります。

テストランナーとを導入しましょう。

### jest-playwrightのインストール

テストランナーは全てのプロダクトで使っているJestを導入します。  
ただ、通常のJestだけではないようです。

{{<summary "https://playwright.dev/#version=v1.6.2&path=docs%2Ftest-runners.md&q=">}}

公式でjest-playwrightが紹介されていたためインストールしてみます。

{{<summary "https://github.com/playwright-community/jest-playwright">}}

```
npm install -D jest-playwright-preset
```

{{<alert info>}}
Jestをインストールしていない場合は、jestも指定する必要があります
{{</alert>}}

`jest.e2e.config.js`を作成します。  
通常のテストで使う`jest.config.js`とは別に作成することを推奨されていました。

```js
module.exports = {
  preset: "jest-playwright-preset",
  verbose: true,
};
```

### テストの作成

タイトルを確認するだけの簡単なテストを作ってみます。  
先ほどの`e2e/test.js`を書き換えます。

```js
const chromium = require("playwright").chromium;

/** @type {import('playwright').Browser} */
let browser;
/** @type {import('playwright').Page} */
let page;

beforeAll(async () => {
  browser = await chromium.launch({ headless: false });
});

describe("LOGIN", () => {
  beforeAll(async () => {
    page = await browser.newPage();
    await page.goto("http://localhost:3000");
  });

  it("Title is valid", async () => {
    expect(await page.title()).toBe("togowl - togowl");
  });
});

afterAll(async () => {
  await browser.close();
});
```

実際にブラウザが動いているところを見たかったので、`chromium.launch`関数に`{ headless: false }`を指定してみました。  
また、`@type {...}`をつけることによってJavaScriptファイルのままでもTypeScriptの型定義を使うことができます。

実行結果は以下のようになります。

```
$ npx jest e2e/test.js -c jest.e2e.config.js
 PASS   browser: chromium  e2e/test.js (5.561 s)
  LOGIN
    √ Title is valid (173 ms)

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Snapshots:   0 total
Time:        6.318 s, estimated 7 s
```

### expect-playwrightを使ってMatcherを強化する

期待値の確認を簡単にするため、expect-playwrightを使います。

{{<summary "https://github.com/playwright-community/expect-playwright">}}

インストールします。

```
npm install -D expect-playwright
```

`jest.e2e.config.js`に`setupFilesAfterEnv`を追加します。

```js
module.exports = {
  preset: "jest-playwright-preset",
  setupFilesAfterEnv: ["expect-playwright"],
  verbose: true,
};
```

あとは先ほどのテストコードに項目を1つ追加します。

```js
describe("LOGIN", () => {
  beforeAll(async () => {
    page = await browser.newPage();
    await page.goto("http://localhost:3000");
  });

  it("Title is valid", async () => {
    expect(await page.title()).toBe("togowl - togowl");
  });

  it("Show Login button", async () => {
    // 追加
    await expect(page).toHaveText("button", "Login");
  });
});
```

ボタンに`Login`の文字が含まれていればテストは成功します。  
`toEqualText`は改行も認識してしまうため使えませんでした。


デバッグツールを有効活用する
----------------------------

Playwrightにはデバッグツールが用意されています。

{{<summary "https://playwright.dev/docs/debug">}}

テストを作成するときにこれらの機能が役に立つことがあります。


### デバッグモードで実行する

環境変数`PWDEBUG=1`を指定するとデバッグモードで実行します。  
すると以下のような状態で起動します。

* headfulモードが有効 (`{ headless: false }`と同じ)
* timeoutなし
* DevToolsの設定を保持

{{<refer "Debugging tools | Playwright" "https://playwright.dev/docs/debug/#run-in-debug-mode">}}

`launch`の引数を空にして試してみましょう。

```js
beforeAll(async () => {
  // さっきは launch({ headless: false }) だった
  browser = await chromium.launch();
});
```

環境変数を指定して実行します。  
以下はPowerShellの例なので、BashやCmdを使う場合は適宜変更してください。

```powershell
$env:PWDEBUG = 1
npx jest -c jest.e2e.config.js e2e
```

ブラウザがGUIとして表示されればOKです。


### IntelliJ IDEAでデバッグする

Intellij IDEAを使ってデバッグしてみましょう。

`Run/Debug Configurations`で`Jest`の設定を追加します。  
環境変数の設定を忘れないように注意して下さい。

{{<himg "resources/48e5fa18.jpeg">}}

停止したい場所にブレークポイントを貼ってデバッグ実行しましょう。

{{<himg "resources/55aa339a.jpeg">}}

もちろんChrome DevToolsを使えます。

{{<himg "resources/77281898.jpeg">}}

`playwright`のAPIが使えるので、target DOMの選定などに役立ちます。


必要な情報を入力してログインする
--------------------------------

表示したログインページに必要な情報を入力し、ログインできることを確認します。

### ポイント

ポイントは3つあります。

#### 情報の入力

`page.fill`を使って、Inputフォームに情報を入力できます。

```js
    await page.fill("#mail-address-input", TOGOWL_MAIL_ADDRESS);
    await page.fill("#password-input", TOGOWL_PASSWORD);
```

`TOGOWL_MAIL_ADDRESS`と`TOGOWL_PASSWORD`は公開したくない情報であるため、環境変数で読み込んでいます。

```js// Environment variables
const { TOGOWL_MAIL_ADDRESS, TOGOWL_PASSWORD } = process.env;
```

{{<refer "class: Page | Playwright" "https://playwright.dev/docs/api/class-page#pagefillselector-value-options">}}

#### ボタンのクリック

`page.click`を使ってボタンをクリックできます。

```js
    await page.click("#login-button");
```

{{<refer "class: Page | Playwright" "https://playwright.dev/docs/api/class-page?_highlight=click#pageclickselector-options">}}

#### セレクタが存在するかの確認

`toHaveSelector`を使ってセレクタの存在を確認できます。  
ログイン後に表示されるはずのコンテンツがあるかを確かめるわけです。

```js
    await expect(page).toHaveSelector("#main-contents");
```

{{<github "toHaveSelector | expect-playwright" "https://github.com/playwright-community/expect-playwright#toHaveSelector">}}

### 作成したテストコード

以下がテストコード全体です。

```js
const chromium = require("playwright").chromium;

/** @type {import('playwright').Browser} */
let browser;
/** @type {import('playwright').Page} */
let page;

// Environment variables
const { TOGOWL_MAIL_ADDRESS, TOGOWL_PASSWORD } = process.env;

beforeAll(async () => {
  browser = await chromium.launch({slowMo: 1000});
});

describe("LOGIN", () => {
  beforeAll(async () => {
    page = await browser.newPage({
      viewport: { width: 480, height: 720 },
      recordVideo: { dir: "videos/" },
    });
    await page.goto("http://localhost:3000");
  });

  it("Title is valid", async () => {
    expect(await page.title()).toBe("togowl - togowl");
  });

  it("Exists login button", async () => {
    await expect(page).toHaveText("#login-button", "Login");
  });

  it("Login", async () => {
    await page.fill("#mail-address-input", TOGOWL_MAIL_ADDRESS);
    await page.fill("#password-input", TOGOWL_PASSWORD);
    await page.click("#login-button");
    await expect(page).toHaveSelector("#main-contents");
  });
});

afterAll(async () => {
  await browser.close();
});
```

{{<why "セレクタのベストプラクティスを採用しないのはなぜか?">}}
ベストプラクティスのメリット、およびアンチパターンのデメリットが実感できないからです。  
良さ/悪さを実際に体験してから考えたいと思いました😜

Playwrightの公式ドキュメントにはセレクタのベストプラクティスが書かれています。

{{<summary "https://playwright.dev/docs/selectors?_highlight=best#best-practices">}}

そこには以下3つが紹介されています。

* ユーザー目線の属性を優先せよ
* 明示せよ
* 実装に縛られるセレクタを避けよ

これらの結論をまとめると、以下2つを推奨しています。

* ラベルやプレイスホルダーの文字列をベースにセレクタを決定すること
* `data-test-id="login-button"`のように`data-`から始まるテスト専用の属性をつけること

それに対して、先ほどのコードは属性`id`を使っています。  
要素やclassを指定するよりはマシですが、決してベストな方法とは言われていません。  
ただ私は..`id`を使うことが妥当ではないかと考えています。

理由です。かなりバイアスがかかっています。

* `id`は一意性を決めるものであり、ユーザ目線に等しく意味を持つべきものである
    * DDDと同じように、パーツの呼び名をidで呼んでも違和感ないことが目標
* `id`はスタイルや構造によって決められるべきものではない
    * jQueryでいじりたい.. スタイルを当てたいという理由ではないはず
* `id`にすることで実装の影響を受けるのであれば、設計が悪いのではないか
    * 単体テストが書きにくい場合は設計が悪いと同じ発想
* `data-test-id`なども結局はidである
  * 表現が変わっただけ.. ただフレームワークがidを使うことは多いためそれは懸念

**実装に縛られる** という点、**テスト範囲が一目で分かる**という点は非常に興味深い話だったので、しばらくこの方針を続けた上で再考できればと思っています😉
{{</why>}}

#### 自動テストの速度を遅くする

`chromium.launch`に`slowMo: 1000`を指定することで、すべてのアクションが1秒おきに実行されるようにしました。  
人間がブラウザの変化を確認するための設定ですが、スピード重視の場合は外しましょう。

{{<refer "class: Browser | Playwright" "https://playwright.dev/docs/api/class-browser?_highlight=newpage#browsernewpageoptions">}}

#### テストの実行画面を記録する

`browser.newPage`に`recordVideo: { dir: "videos/" }`を指定することで、そのPageのテスト実行画面を録画して`videos`ディレクトリ配下にwebmファイルとして保存するようにしました。  
特にテスト失敗したときの確認に便利ですね😊

{{<refer "Verification | Playwright" "https://playwright.dev/docs/verification#videos">}}

#### ウィンドウのサイズを指定する

`browser.newPage`に`viewport: { width: 480, height: 720 }`を指定することで、ウィンドウサイズ`480x720`でテストが実行されるようにしました。  
今回の記事を書くための画面サイズとしてちょうど良かったからです。

{{<refer "class: Browser | Playwright" "https://playwright.dev/docs/api/class-browser?_highlight=newpage#browsernewpageoptions">}}

### 実行結果

Playwrightが録画したテストの実行画面です。

{{<mp4 "resources/record.mp4">}}

{{<alert "info">}}
すべてのブラウザで参照できるようにwebmをmp4へ変換しています
{{</alert>}}

Jestの実行結果は通常のテストと同じように表示されます。

{{<himg "resources/d2d71a6d.jpeg">}}


アプリケーションの立ち上げと同時にテストする
--------------------------------------------

今まではlocalでアプリケーションが起動した状態からテストを実行してきました。  
しかし、CIなどテスト実行中だけアプリケーションを起動したいこともあります。

以下のような`jest-playwright.config.js`をつくることで実現できます。

```js
module.exports = {
  serverOptions: {
    command: "npm start",
    port: 3000,
  },
};
```

{{<github "Start a server | jest-playwright" "https://github.com/playwright-community/jest-playwright#start-a-server">}}

上記ファイルはNuxtにおいて以下のような`scripts`を定義した場合です。

```json
  "scripts": {
    "dev": "nuxt",
    "build": "nuxt build",
    "start": "nuxt start",
```

事前に必ず`npm build`を実行して下さい。その成果物をテストに使うからです。  
既に起動中のアプリケーションでテストしたいケースもある場合はconfigの指定を変更しましょう。

{{<refer "Start a server | jest-playwright" "https://github.com/playwright-community/jest-playwright#configuration">}}

{{<alert "warning">}}
`jest-playwright.config.js`は`jest-playwright`が認識するファイルです。  
Playwrightのテスト用に用意したJestのconfigファイルではありません。
{{</alert>}}


GitHub Actionsで実行する
------------------------

それではGitHub Actionに組みこんでみましょう。  
実行コマンドを環境変数と共に追加するだけです。

```yaml
jobs:
  test:
    stops:
      // ...
      // 中略
      // ...
      - run: npm run test:e2e
        env:
          TOGOWL_MAIL_ADDRESS: ${{ secrets.TOGOWL_MAIL_ADDRESS }}
          TOGOWL_PASSWORD: ${{ secrets.TOGOWL_PASSWORD }}
      // 動画を成果物としてほしい場合は追加
      - uses: actions/upload-artifact@v2
        if: ${{ always() }}
        with:
          name: '${{ matrix.node }}-e2e-videos'
          path: videos
```

はじめて成功した結果は以下になります。

{{<summary "https://github.com/tadashi-aikawa/togowl/actions/runs/433937081">}}

{{<why "microsoft/playwright-github-actionを使わないのはなぜか?">}}
Playwrightの公式ドキュメントでは`microsoft/playwright-github-action`が紹介されています。

{{<summary "https://playwright.dev/docs/ci#github-actions">}}

Playwrightに必要な依存関係を解決してくれるアクションですが、以下の理由で今回は見送りました。

* Actionの実行に40~50秒かかる (全体の1/3)
* Ubuntu + Chromiumの組み合わせではAction実行ナシで動く
{{</why>}}


総括
----

Playwrightを使って、e2eテストを書くための手順/ノウハウを紹介しました。  
最終的にGitHub Actionsで実行し、操作が録画された動画ファイルを成果物して取得できるようになりました。

本稿で実行したテストはTogowlにとって始まりに過ぎません。  
これから更にPlaywrightの理解を深めながら、価値のあるテストを増やせればと思っています。

思えばGUIテストについてガッツリした記事を書くのは2~3年ぶりです。  
当時、以下のような記事を書いていました。

{{<summary "https://blog.mamansoft.net/2017/11/16/visual-regression-testing-with-react-story-book/">}}

{{<summary "https://blog.mamansoft.net/2018/04/09/puppeteer-storybook-screenshot/">}}

この頃は選択肢が多く、Selenium時代からの変わり目だった気がします。  
そのため、GUIテストのメンテナンスコストは非常に高く、途中でやめてしまいました。

一方、今はCypressとPlaywrightの2強時代な気がしています。  
それぞれ特徴が異なるため、どちらか一方が残る..という感じではないのかなとも思っています。  
2つがデファクトスタンダードになれば、GUIテストのメンテナンスコストも落ちるでしょう。

そのときが来たら.. 今のUnitテストみたいに.. 誰もがe2eテストを書ける..  
そんな時代の到来を楽しみにしています😁

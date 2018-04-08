---
title: "PuppeteerでStorybookのスクリーンショットを撮る"
slug: puppeteer-storybook-screenshot
date: 2018-04-09T03:04:00+09:00
thumbnailImage: https://user-images.githubusercontent.com/10379601/29446482-04f7036a-841f-11e7-9872-91d1fc2ea683.png
categories:
  - engineering
tags:
  - react
  - test
---

ヘッドレスブラウザのPuppeteerを使い、Storybookのスクリーンショットを撮るコードを書いてみました。

<!--more-->

<!--toc-->


経緯
----

昨年、LOKIとreg-suitを使ってReact Storybookの[CSS/Style Testing]の仕組みを作りました。  
LOKIとreg-suitについては以下の記事をご覧下さい。

{{<summary "https://blog.mamansoft.net/2017/11/16/visual-regression-testing-with-react-story-book/">}}

[CSS/Style Testing]: https://storybook.js.org/testing/css-style-testing/

その後すぐにLOKIが上手く実行できなくなり、ある時期から[CSS/Style Testing]は実行せず放置していました。  
しかし[CSS/Style Testing]はデグレや不具合の防止に非常に役立つため、LOKIを使わずに動作する環境を構築することにしました。


### なぜLOKIの使用をやめるのか

LOKIはStorybookのスクリーンショットを作成するために使用していましたが、以下の理由から使わないことにしました。

* LOKIは本来Visual Regression Testingのツールであり、スクリーンショットを撮るだけの場合オーバースペックである
* いくつか要件が合わない箇所があり、調査や作者とのやりとりにコストがかかる


ツールの選択肢
--------------

簡単に調査したところ、2つの選択肢を見つけました。


### Puppeteer

{{<summary "https://github.com/GoogleChrome/puppeteer">}}

GoogleChromeチームが作成しているGoogleChromeのヘッドレスブラウザライブラリです。  
最近1.0がリリースされ、以前のような不安定さは無くなりつつあると思っています。


### storybook-chrome-screenshot

{{<summary "https://github.com/tsuyoshiwada/storybook-chrome-screenshot">}}

Storybookのスクリーンショットが撮れるStorybook Addonです。  
内部でPuppeteerを使っており、React/Angular/Vueに対応しているようです。

こちらも1.0はリリース済みですが、いくつか理由がありPuppeteerを直接使うことにしました。


Puppeteerを使う理由
-------------------

理由は3つあります。


### Google Chromeチームが作っている

公式が作っているため、解決困難な問題が非常に発生しにくいと思っています。  
一方、Puppeteerを利用しているライブラリは問題発生時の調査コストがかかったり、回避策の検討が難しいなどの懸念があります。


### Puppeteerが使いやすい

先の懸念があっても、それを補うだけのメリットがあれば話は変わります。  
しかしPuppeteerはInterfaceも分かりやすく、単独で十分使いやすいのです。


### storybook-chrome-storybookが思うように動かなかった

Issueが存在せずStorybook公式のサンプルでは問題なく動作します。  
私の環境の問題だと思いますが、以下のような事象が発生するのです。

#### 実行途中でフリーズする

100%発生するわけではありませんが、再現率は非常に高いです。(90%以上)  
`waitUntil`の指定が不適切かと思いましたが、タイムアウトにもならないので違う気がします。

#### 保存されている画像がURLの内容と一致しない

実行画面では取得/保存完了とされていますが、実際に画像を確認すると同じStoryの画像が大量に保存されています。  
並列実行数をいじってみましたが変化はなく、検討もつきませんでした。

#### リソースを全て取得する前にスクリーンショットが撮られる

対象のStoryが外部リソース(アイコン画像など)を読み込む前に画像が作成されます。  
これは`waitUntil`に`networkidle2`を指定することで解決しました。

{{<alert "info">}}
`waitUntil`については本記事後半で説明があります。
{{</alert>}}


実行結果
--------

実行中の状況です。

{{<mp4 "https://dl.dropboxusercontent.com/s/7ndkf1ax3iul4bu/20180409_1.mp4">}}

作成したスクリーンショットの一覧です。  
サイズはテストケースごとに最適化されています。

{{<mp4 "https://dl.dropboxusercontent.com/s/zhsx7h3ejw8qqud/20180409_2.mp4">}}


ソースコード
------------

今回作成したソースコードを紹介します。  
1つの実行ファイルと1つの設定ファイルから構成されています。


### `storybook-camera.js`

nodeで実行する50行程度のJSファイルです。

```javascript
const puppeteer = require('puppeteer');
const connect = require('connect');
const serveStatic = require('serve-static');
const fs = require('fs');
const del = require('del');
const config = JSON.parse(fs.readFileSync('./storybook-camera.json', 'utf8'));
const HOST = `http://localhost:${config.port}`;

console.log(`Remove ${config.outdir} if exists`)
del.sync([config.outdir]);
console.log(`Create ${config.outdir} directory`)
fs.mkdirSync(config.outdir)

console.log('Start storybook server');
const app = connect();
app.use(serveStatic(config.storydir));
server = app.listen(config.port);

(async () => {
  console.log('Open browser')
  const browser = await puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']});
  const page = await browser.newPage();

  try {
    for (const kind of Object.keys(config.storiesByKind)) {
      console.log(`--------- ${kind} ----------`)
      for (const story of config.storiesByKind[kind]) {
        page.setViewport({width: story.width || config.viewport.width || 1, height: story.height || config.viewport.height || 1})
        const res = await page.goto(`${HOST}/iframe.html?selectedKind=${kind}&selectedStory=${story.story}`, {waitUntil: 'networkidle0'})
        const status = res.status()
        if (status < 400) {
          await page.screenshot({
            path: `${config.outdir}/${kind}-${story.title || story.story}.png`, fullPage: true
          })
        }
        console.log(`  >>> ${status}: ${story.title || story.story}`)
      }
    }
  } catch(e) {
    console.log(e)
    process.exit(1)
  } finally {
    console.log('Close browser');
    await browser.close();

    console.log('Stop storybook server');
    server.close();
  }

})();
```

処理の流れは以下の様になっています。

1. 出力ディレクトリの中身を削除して作り直す
2. ビルド済みStorybookにアクセスするためのHTTP Serverを起動する
3. Puppeteerを使ってスクリーンショットを撮影し出力ディレクトリに保存する
4. 全てのスクリーンショットを撮影したら2で起動したHTTP Serverを終了

{{<alert "warning">}}
Storybookは事前にビルドしておく必要があります。
{{</alert>}}

実行はnodeコマンドを使います。

```
$ node storybook-camera.js
```


### `storybook-camera.json`

`storybook-camera.js`で読み込む設定ファイルです。

```json
{
  "outdir": ".captures",
  "storydir": "storybook-static",
  "port": 8000,
  "viewport": {
    "width": 1920
  },
  "storiesByKind": {
    "DailyCard": [
      {"story": "Summary", "width": 350},
      {"story": "Appearance", "width": 700},
      {"story": "Past", "width": 350}
    ],
    "DailyCards": [
      {"story": "Summary"},
      {"story": "Filter"}
    ],
    "Icebox": [
      {"story": "Summary", "width": 350}
    ]
  }
}
```

定義は以下のようになっています。

| プロパティ名                  | 意味                                                |
|-------------------------------|-----------------------------------------------------|
| outdir                        | 作成した画像を出力するディレクトリ                  |
| storydir                      | ビルド済みのStorybookが格納されているディレクトリ   |
| port                          | StorybookのWebサーバを起動するポート                |
| viewport                      | テストで使用するViewportの設定                      |
| viewport.width                | テストで使用するViewportの幅デフォルト値            |
| viewport.height               | テストで使用するViewportの高さデフォルト値          |
| storiesByKind                 | Kindをキーにテスト対象のStoryを設定する             |
| storiesByKind.\<kind\>.story  | Storyの名称                                         |
| storiesByKind.\<kind\>.title  | 指定されている場合、画像名に優先される名称          |
| storiesByKind.\<kind\>.width  | 指定されている場合、`viewport.width`より優先される  |
| storiesByKind.\<kind\>.height | 指定されている場合、`viewport.height`より優先される |


ハマッタこと
------------

### リソースのロードが完了しないまま画像が撮影されてしまう

`page.goto`の第2引数に`{waitUntil: networkidle0}`を指定することで解決しました。  
本件は以下のIssueで議論されていました。

{{<summary "https://github.com/GoogleChrome/puppeteer/issues/728">}}

Storybookを静的コンテンツとして参照せずserveした場合は`networkidle2`にする必要がありました。  
ソースの変更検知をするためにnetworkが残っているためだと思います。

`networkidle0`と`networkidle2`の定義は公式の仕様をご覧下さい。

{{<summary "https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagegotourl-options">}}


### スクリーンショットの高さがちょうど良くならない

高さがありすぎて対象が小さくなってしまったり、高さが不足していて見切れてしまうケースです。  
以下2つの条件を満たせば解決します。

* `page.screenshot`に`{fullPage: true}`を指定する
* Viewportに`{height: 1}`を指定する

先ほどのサンプルコードでは以下の行に該当します。  
各StoryやViewportで高さの指定がない場合、1を設定するようにしています。

```javascript
page.setViewport({width: story.width || config.viewport.width || 1, height: story.height || config.viewport.height || 1})
```

heightを未指定にしたり、`{height: 0}`を指定すると高さがよく分からない決め方になります。


### DockerでPuppeteerが動作しない

公式ドキュメントに従うと、なぜか2つ目のRUNがいつまで経っても完了しませんでした。

{{<summary "https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker">}}

以前Chromeを動かした実績を参考に、自前のDockerfileを作成したら上手くいきました。

```
FROM node:8-slim


RUN apt-get update && apt-get install -y wget git

# puppeteer dependencies
RUN apt-get -y install gconf-service \
                       libasound2 \
                       libatk1.0-0 \
                       libcups2 \
                       libdbus-1-3 \
                       libgconf-2-4 \
                       libgtk-3-0 \
                       libnspr4 \
                       libx11-xcb1 \
                       libxss1 \
                       fonts-liberation \
                       libappindicator1 \
                       libnss3 \
                       lsb-release \
                       xdg-utils

WORKDIR /usr/src/app

COPY package-lock.json /usr/src/app/
COPY package.json /usr/src/app/
RUN npm install

COPY . /usr/src/app
```


総括
----

ヘッドレスブラウザのPuppeteerを使い、Storybookのスクリーンショットを撮影しました。  
reg-suitを使ったリグレッションテストとの結合については次回まとめようと思います。



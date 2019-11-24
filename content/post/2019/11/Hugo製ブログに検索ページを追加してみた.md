---
title: Hugo製ブログに検索ページを追加してみた
slug: add-search-page-in-blog-made-by-hugo
date: 2019-11-11T22:29:58+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/ys4ml2r4i9ehj43/girl-3038974_1280.jpg
categories:
  - engineering
tags:
  - hugo
  - vue
  - fuse
  - javascript
---

[Hugo]で作られたブログに、ブラウザで完結する検索ページを作ってみました。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/ys4ml2r4i9ehj43/girl-3038974_128"/>

<!--toc-->


はじめに
--------

### 経緯

このブログは[Hugo]で作られています。  
[Hugo]を選んだ経緯は以下の記事をご覧下さい。

{{<summary "https://blog.mamansoft.net/2017/12/01/migrate-blog-by-hugo/">}}

当初から検索ページは作る予定でした。  
しかし、調べていると『何かしら検索indexを作成/管理する仕組み』がサーバーサイドに必要という情報が数多くヒットしました。

SaaSや自前サーバを用意してまで作りたくなかったので、以前に以下の記事で一旦ごまかしました。

{{<summary "https://blog.mamansoft.net/2018/05/28/search-in-blog-quickly/">}}

とはいえ、この方法は格好良くないし、何より面倒です。  
記事を書いた私でさえ、検索する方法を覚えていません。

今回作成したページは上記不満を解決するものになっています。


### 前提

私の環境はWindows10です。  
Windowsでなくても大丈夫だと思います。

また、[Hugo]のテーマとして[Tranquilpeak]を使っています。

### 方針

クライアント側(ブラウザ)で全て完結する構成を目指します。

### 利用技術のバージョン

主な技術/ライブラリとして以下を使用します。

|      名称      | バージョン  |              備考              |
| -------------- | ----------- | ------------------------------ |
| [Hugo]         | v0.58.3     | Go製静的サイトジェネレーター   |
| [Tranquilpeak] | 0.4.7-beta? | [Hugo]で使えるテーマの1つ      |
| [Vue.js]       | v2.6.10     | フロントエンドのViewライブラリ |
| [Fuse.js]      | v3.4.5      | 軽量な曖昧検索ライブラリ       |

本記事ではこれらの技術説明はしません。

その他にもAxiosやLodashを使っています。


完成ページ
----------

完成したページは https://blog.mamansoft.net/search/ です。  
サイドバーの『Search』からでもどうぞ👾

キーワードを入力すると1秒弱してから結果が表示されます。

UIには[Vue.js]を、検索には[Fuse.js]を使っています。

以降は作り方の説明になります。


ビルドでjsonを作成できるよう設定ファイルをいじる
------------------------------------------------

`config.toml`に`outputs.home`を追加しましょう。  
HTMLとRSSの他に、JSONを追加します。

```toml
[outputs]
  home = ["HTML", "RSS", "JSON"]
```

これで記事をビルドすると、jsonファイルも作成されるようになります。


検索用jsonのテンプレート作成
----------------------------

`layouts/default`配下に作成します。

{{<file "layouts/_default/index.json">}}

```
{{- $.Scratch.Add "index" slice -}}
{{- range .Site.RegularPages -}}
    {{- $.Scratch.Add "index" (dict "title" .Title "tags" .Params.tags "categories" .Params.categories "contents" .Plain "permalink" .Permalink "date" .Params.date "image" .Params.thumbnailImage) -}}
{{- end -}}
{{- $.Scratch.Get "index" | jsonify -}}
```

{{</file>}}

ここで定義された変数を記事から取得して、[Fuse.js]の検索indexを作成します。  
以下はアイテムの一例です。

```json
  {
    "categories": ["engineering"],
    "contents": "TypeScriptでサクっと動作確認したいときのTipsをまとめてみました。\n はじめに 最小限のコードを書いて、『それがどのように動くのか』確認したいケースがあると思います。\nしかし、TypeScriptはJavaScriptのようにChrome開発者ツールから気軽に確認できません。\nそんなときに使えるTipsを3つ紹介します。\n公式のPlayground TypeScriptの文法や挙動を確認したいなら最適です。\n メリット 事前準備が不要 ブラウザがあれば動きます。\n設定の切り替えが楽 GUIから利用バージョンやConfig設定を切り替えられます。\nトランスパイル結果がデフォルトで隣に表示される ァイルを実行するため   prettier 自動でフォーマットをかけるため    個人的な好みでeslintはインストールしていません。\nテストを書きたい場合はJestを追加します。\nnpm i -D jest ts-jest @types/jest npx ts-jest config:init  総括 TypeScriptでサクっと動作確認したいときのTipsをまとめてみました。\n   Tips 個人的なオススメ用途     公式のPlayground TypeScriptの動作確認   StackBlitz フロントエンド開発の動作確認 (特にUIフレームワーク)   Localに自分で作る バックエンド開発の動作確認 or いつものエディタ/IDE使いたい    状況と用途に応じて使い分けていきたいですね😄\n",
    "permalink": "https://blog.mamansoft.net/2019/11/02/run-typescript-quickly/",
    "tags": ["typescript"],
    "title": "TypeScriptでサクっと動作確認したいとき"
  },
```


検索ページマークダウンの作成
----------------------------

`/search`でアクセスできるようにするため、`content`配下の`search.md`を作ります。

{{<file "content/search.md">}}

```markdown
---
title: "Search"
sitemap:
  priority : 0.1
showSocial: false
showPagination: false
showDate: false
---

{{</*search*/>}}

----

タイトル、本文、タグなどから記事を検索できます。  
空白区切りはOR検索になります。(AND検索はできません)
```

{{</file>}}

`showSocial`、`showPagination`、`showDate`は[Tranquilpeak]で使えるオプションです。  
ソーシャルボタン、ページネーションボタン、日付を非表示にしています。

上記ページには検索用のshortcodesを埋め込んでいます。  
このあと作成します。


検索shortcodesの作成
--------------------

`{{</*search*/>}}`で展開されるshortcodesを作ります。

{{<file "layouts/shortcodes/search.html">}}

```html
<script src="https://cdn.jsdelivr.net/npm/vue" crossorigin></script>
<script
  src="https://cdnjs.cloudflare.com/ajax/libs/fuse.js/3.4.5/fuse.min.js"
  crossorigin
></script>
<script src="https://unpkg.com/axios/dist/axios.min.js" crossorigin></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.15/lodash.min.js" crossorigin></script>
<link rel="stylesheet" href="{{ "css/search.css" | absURL }}" />

<div id="app">
  <div style="display: flex; align-items: center;">
    <i class="fas fa-search fa-lg"></i>
    <input
        v-model="word"
        name="word"
        type="text"
        class="form-control input--xlarge"
        placeholder="Search by word"
        autofocus="autofocus"
        style="margin-left: 10px;"
    />
  </div>
  <search-result-item
      v-for="res in results"
      :title="res.item.title"
      :contents="res.item.contents"
      :url="res.item.permalink"
      :date="res.item.date"
      :image="res.item.image"
      :tags="res.item.tags"
      style="padding: 20px;"
  />
</div>

<script src="{{ "js/search.js" | absURL }}"></script>
```

{{</file>}}

scriptタグで今回利用する技術を読み込んでいます。  
あとで作成する`js/search.js`は最後に読みこみ必要があるため、記載も最後です。

{{<why "なぜshortcodesを使うのか?">}}
それ以外で上手くいくやり方が思いつかなかったからです..😅  
もしbetterな方法ご存知の方いらっしゃれば教えて下さい🙇
{{</why>}}


JavaScriptファイルの作成
------------------------

上記のhtmlで読み込まれるJavaScriptファイルを作成します。

{{<file "static/js/search.js">}}

```js
const fuseOptions = {
  shouldSort: true,
  includeMatches: true,
  tokenize: true,
  threshold: 0.0,
  location: 0,
  distance: 100,
  maxPatternLength: 32,
  minMatchCharLength: 1,
  keys: [
    { name: "title", weight: 0.8 },
    { name: "contents", weight: 0.5 },
    { name: "tags", weight: 0.3 },
    { name: "categories", weight: 0.3 }
  ]
};

Vue.component("search-result-item", {
  props: ["title", "url", "date", "image", "contents", "tags"],
  template: `
  <div style="display: flex;">
    <div>
      <a :href="url">
        <img alt="" itemprop="image" :src="image" class="image">
      </a>
    </div>
    <div class="description">
      <a :href="url" v-text="title" style="font-weight: bold;"></a>
      <div v-text="contents" class="contents"></div>
      <div class="date" v-text="date"></div>
      <div v-for="tag in tags" class="search-tag" v-text="tag"></div>
    </div>
  </div>`
});

const app = new Vue({
  el: "#app",
  mounted: async function() {
    this.fuse = new Fuse((await axios.get("/index.json")).data, fuseOptions);
  },
  data: {
    fuse: {},
    word: "",
    results: []
  },
  watch: {
    word: _.debounce(function(word) {
      this.results = word.length > 0 ? this.fuse.search(word) : [];
    }, 500)
  }
});
```

{{</file>}}

2つポイントがあります。

### VueはMustache構文を避けている

以下のようなMustache構文は使わず、`v-text`を使うようにしています。

```
<span>Message: {{ msg }}</span>
```

これはMustache構文が、[Hugo]のshortcodes表記と衝突するからです。

### debounceで検索処理を遅延させている

Lodashの`_.debounce`関数で、0.5秒以上入力が途切れるまで検索しないようにしています。  
[Fuse.js]のパフォーマンスや[Vue.js]の描画コストを考慮しています。


CSSファイルの追加
-----------------

最後はCSSファイルを追加します。  
スマホでも全体が表示されるように一部`@media`を使っています。

{{<file "static/css/search.css">}}

```css
.search-tag {
  font-size: 1.3rem;
  padding: 2px 10px;
  color: #349ef3 !important;
  border: 1px solid #349ef3;
  display: inline-block;
  background: #fff;
  width: auto;
  height: auto;
  border-radius: 3px;
  letter-spacing: 0.01em;
  margin: 0;
  margin-right: 4px;
  margin-bottom: 7px;
}

.contents {
  position: relative;
  font-size: 85%;
  width: 100%;
  height: 50px;
  overflow: hidden;
  text-align: justify;
}

.date {
  text-align: right;
  padding-top: 10px;
  color: darkgrey;
  font-size: 75%;
}

.post .post-content .image {
  min-width: 200px;
  max-width: 200px;
  border-radius: 10%;
}
.description {
  width: 480px;
  padding: 10px 0 10px 30px;
}

@media screen and (max-width: 480px) {
  .post .post-content .image {
    display: none;
  }
  .description {
    width: 300px;
    padding: 5px 0 5px 15px;
  }
}
```

{{</file>}}


サイドバーに検索ページへのリンクを追加する
------------------------------------------

`/search`と入力してもらうわけにいかないので、`config.toml`にリンクを追加します。

```toml
[[menu.main]]
  weight = 2
  identifier = "search"
  name = "Search"
  pre = "<i class=\"sidebar-button-icon fas fa-lg fa-search\"></i>"
  url = "/search"
```

せっかくなので、スマホで閲覧したときのヘッダ右側にも追加しました。

```toml
[params]

  [params.header.rightLink]
    url = "/search"
    icon = "search"
```

これでビルドすると検索できるようになっていると思います👍


総括
----

[Hugo]で作られた本ブログに、ブラウザで完結する検索ページを作ってみました。  
以下のような課題も残っていますが、フロントエンドだけで完結できたため満足しています😄

* 検索実行されないときがある
* ローディング中 or 検索結果なし が区別できない
* AND検索ができない

時間があるときに改善していければと🌻

{{<update "2019-11-24: AND検索に対応しました">}}
`search.js`の`app`を以下のようにします。

```js
const search = (words, fuse) =>
  _.intersectionBy(...words.map(x => fuse.search(x)), "item.permalink");

const app = new Vue({
  el: "#app",
  mounted: async function() {
    this.fuse = new Fuse((await axios.get("/index.json")).data, fuseOptions);
  },
  data: {
    fuse: {},
    word: "",
    results: []
  },
  watch: {
    word: _.debounce(function(word) {
      this.results = word.length > 0 ? search(word.split(" "), this.fuse) : [];
    }, 500)
  }
});
```

`item.permalink`で記事の一意性が保証できるため、Lodashの`intersectionBy`で共通部分だけを抽出しています。

{{</update>}}


[Hugo]: https://gohugo.io/
[Tranquilpeak]: https://github.com/kakawait/hugo-tranquilpeak-theme
[Vue.js]: https://jp.vuejs.org/
[Fuse.js]: https://fusejs.io/

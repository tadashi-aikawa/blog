---
title: Markdownでスライドを作ってみた
slug: create-slide-by-markdown
date: 2019-07-24T23:22:47+09:00
thumbnailImage: images/cover/2019-07-24.jpg
categories:
  - engineering
tags:
  - markdown
  - reveal.js
---

[vscode-reveal]を使って、Markdownでプレゼンテーション用のスライドを作ってみました。

<!--more-->

{{<cimg "2019-07-24.jpg">}}

<!--toc-->


はじめに
--------

皆さんはプレゼンテーションスライドを何で作りますか?

私はPowerPointを使うことが多いです。  
複雑なアニメーションや表現をGUIで実現できるところが気に入っています。

しかも、最近はAIで勝手にデザインを決めてくれたりもします。

### Markdownでスライドを作るということ

以前から何度かMarkdownを使ったスライド作りにチャレンジしたことがあります。

下記の通り、色々な理由があります。

* マウスなどを使わずにキーボードで簡潔する
* CSSに精通していればスライド作成ツールよりもデザインしやすい
* Gitでバージョン管理できる
* 既存のマークダウンファイルを流用できることがある
* HTML/CSSの勉強になる
* ソースコードを載せるのが楽

しかし、CSSの知識が足りないこともあり、度々挫折してきました。  
PowerPointを使う方が直感的で分かりやすく、速かったのです。

### またチャレンジしようと想ったきっかけ

FUSUMAというスライド作成ツールのv1.0.0が公開された記事を見て、試したくなったからです。

{{<summary "https://github.com/hiroppy/fusuma">}}

FUSUMAは素晴らしいツールですが、今回は[vscode-reveal]を使うことにしました。


reveal.js
---------

本記事のメインは[vscode-reveal]です。  
その前に[reveal.js]の紹介をさせてください。

{{<summary "https://revealjs.com/#/">}}

[reveal.js]はJavaScript製のプレゼンテーション作成フレームワークです。  
HTMLを利用していますが、Markdownを使うこともできます。

しかし、非開発者からするとMarkdownを使ってスライドを作る過程が少し面倒です。


vscode-reveal
-------------

VSCodeで[reveal.js]を使ってスライド作成できる拡張です。  

{{<summary "https://marketplace.visualstudio.com/items?itemName=evilz.vscode-reveal">}}

ポイントはお手軽さです。  
**VSCode**でMarkdownを作成し、`Open presentation in browser`を実行するだけでスライドが表示されます😄


スライドを作ってみた
--------------------

私のトレードマークでもある『みみぞう』を表示するスライドを作ってみました。

詳しい使い方は公式ドキュメントをご覧下さい。  
ここではファイルの中身だけ記載します。

{{<file "slide.md">}}
```markdown
---
theme : "white"
customTheme: "theme"
transition: "slide"
highlightTheme: "monokai"
slideNumber: true
---

# みみぞうとレイアウト  
~ Grid Layout ~

----

### tadashi-aikawa
2019-07-24 (Wed)

<!-- .slide: class="title"  data-background="https://blog.mamansoft.net/images/cover/2019-07-04.jpg" -->

---

## みみぞう

<img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />

---

## 増えるみみぞう

--

### 2×1 みみぞう

<div class="grid-2x1">
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
</div>

--

### 2×2 みみぞう

<div class="grid-2x2" style="width: 500px; height: 500px;">
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
</div>

--

### 3×3 みみぞう

<div class="grid-3x3" style="width: 500px; height: 500px;">
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
    <img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />
</div>

---

## おしまい

<img src="https://avatars0.githubusercontent.com/u/9500018?s=400&v=4" />

```
{{</file>}}

よく使うレイアウトはCSSにまとめてみました。

{{<file "theme.css">}}
```css
/* Base font options */
.reveal {
    font-size: 250%;
}

/* Images */
.reveal section img {
    border: none;
    box-shadow: none;
}

/* Title */
.reveal .title {
    font-size: 80%;
    color: white;
    text-shadow:  3px 3px 3px #37474F;
}

/* Title image */
.reveal .slide-background.present {
    filter: brightness(50%) grayscale(20%) sepia(40%) blur(5px);
}

/* Title headers */
.reveal .title h1 {
    color: white;
    text-shadow:  3px 3px 3px #37474F;
}

.reveal .title h3 {
    color: white;
    text-shadow:  3px 3px 3px #37474F;
}

/* Headers */
.reveal h1 {
    color: #37474F;
    text-transform: none;
}

.reveal h2 {
    color: #37474F;
    text-transform: none;
}

.reveal h3 {
    color: #37474F;
    text-transform: none;
}

.reveal h4 {
    color: #37474F;
    text-transform: none;
}

/* Emphasis */
.reveal strong {
    color: #F06292;
}

.reveal em {
    color: #42A5F5;
}

/* List */
.reveal ol li {
    font-weight: bolder;
    font-size: 75%;
}

.reveal ul li {
    font-weight: bolder;
    font-size: 75%;
}

/* Code */
.reveal pre {
    padding: 15px;
    background-color: #37474F;
}

/* Table */
.reveal .small-table {
    font-size: 75%;
}

/* Refer */
.reveal .refer {
    font-size: 12px;
}

.reveal .refer:before {
    content: "🔗";
}

/***********/
/* Layouts */
/***********/
.reveal .central-2 {
    display: flex;
    justify-content: space-around;
}

/* Need to specify width & height */
.reveal .grid-2x1 {
    display: grid;
    align-content: center;
    justify-content: center;
    align-items: center;
    justify-items: center;
    margin: auto;
    grid-column-gap: 5%;
    grid-template-columns: 40% 40%;
}

.reveal .grid-2x2 {
    display: grid;
    align-content: center;
    justify-content: center;
    align-items: center;
    justify-items: center;
    margin: auto;
    grid-row-gap: 5%;
    grid-column-gap: 5%;
    grid-template-rows: 40% 40%;
    grid-template-columns: 40% 40%;
}

.reveal .grid-3x3 {
    display: grid;
    align-content: center;
    justify-content: center;
    align-items: center;
    justify-items: center;
    margin: auto;
    grid-row-gap: 3%;
    grid-column-gap: 3%;
    grid-template-rows: 30% 30% 30%;
    grid-template-columns: 30% 30% 30%;
}
```
{{</file>}}

変更があった場合は以下を更新していく予定です。

{{<summary "https://mimizou.mamansoft.net/it_note/tools/revealjs/snippets/">}}


スライドを見る
--------------

上記2ファイルをプロジェクトに含め、[vscode-reveal]でスライドを出してみましょう。  
以下のようなタイトルが表示されればOKです👍

{{<himg "resources/20190724_1.png">}}

スライドの構成には階層があり、`ESC`を押すと以下のように表示されます。

{{<himg "resources/20190724_2.png">}}


総括
----

[vscode-reveal]を使って、VSCodeからMarkdownで簡単にスライドを作る方法を紹介しました。

`fragment`を使えば、簡単なアニメーションが使えるため実用上も問題ありません。  
また、以下のような配布形式にも対応しています。

* 静的サイトとしてデプロイ
* PDF

しばらくは、画像構成やアニメーションが複雑でないスライドは[vscode-reveal]で作ってみる予定です。


[vscode-reveal]: https://marketplace.visualstudio.com/items?itemName=evilz.vscode-reveal
[reveal.js]: https://revealjs.com/#/

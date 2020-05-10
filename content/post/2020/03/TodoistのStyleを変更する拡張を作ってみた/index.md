---
title: TodoistのStyleを変更する拡張を作ってみた
slug: create-change-todoist-style
date: 2020-03-02T19:18:42+09:00
thumbnailImage: images/cover/2020-03-02.jpg
categories:
  - engineering
tags:
  - todoist
  - css
  - chrome
  - javascript
---

Todoistのデザインを自分好みに変更する拡張を作ってみました。

<!--more-->

{{<cimg "2020-03-02.jpg">}}

<!--toc-->


Todoistとは
-----------

マルチプラットフォームで使えるシンプルなタスク管理ツールです。

{{<summary "https://todoist.com/ja/">}}

私がTodoistのプレミアム版を使い始めたのは、2015年11月14日です。  
もうすぐ5年、カルマも50000越えておりかなりお世話になっています😄

Todoistの素晴らしさは本記事では割愛します。  
素晴らしいサイト、ブログ、SNS投稿、動画、スライドが溢れていますので探してみてください😉


TodoistとMAMANSOFT
------------------

本題へと入る前に少し脱線させてください。

私はTodoistの大ファンです。  
そのため、TodoistのAPIを使用したツールを多数作ってきました。

身内以外のユーザは確認しておりませんが、以下のようなプロダクトです。  
せっかくの機会ですので、テーブルで一覧を紹介します。

| プロダクト名  |                     概要                     |        利用技術        | 開発状況 |
| ------------- | -------------------------------------------- | ---------------------- | -------- |
| [togowl-next] | Toggl/Todoist/Slackを連携して管理するPWA     | TypeScript + Nuxt + FireBase   | 開発中   |
| [Owlora]      | Todoistのタスクを中期管理するためのWebアプリ | TypeScript + React + FireBase  | 保守     |
| [todoistools] | TodoistのDaily Viewを最適にSortするCLI       | Python3.7              | 保守     |
| [OwlTodoist]  | Googleカレンダーの文体をTodoistタスクに変換  | Python3.7 + Keypirinha | 保守     |
| [Togowl]      | Todoistタスクと連携可能なToggl用Chrome拡張   | TypeScript                     | 半凍結   |
| [TINA]        | Todoist(メイン)とTogglを連携させたSlack bot  | Python2 + Chalice      | 凍結     |

[TINA]: https://github.com/tadashi-aikawa/tina
[Owlora]: https://github.com/tadashi-aikawa/owlora
[OwlTodoist]: https://github.com/tadashi-aikawa/keypirinha-OwlTodoist
[Togowl]: https://github.com/tadashi-aikawa/togowl
[todoistools]: https://github.com/tadashi-aikawa/todoistools
[togowl-next]: https://github.com/tadashi-aikawa/togowl-next

それなりの経験を積んできたため、TodoistのAPI仕様にある程度詳しい自信はあります。  
しかし、今回紹介するChrome拡張はそれらを使いません。とても簡単です👍


完成イメージ
------------

### 通常画面

これだけでもシンプルですが、1日の予定が長い場合は1行にしたい..。  
あと、時間の区切りを分かりやすくしたい。

{{<vimg "resources/20200302_3.png">}}

### cssだけ適用した画面

cssだけのChrome拡張でもシュっとなります。

{{<vimg "resources/20200302_4.png">}}

### cssとjsを適用した画面

JavaScriptを使えばこんなところまで❗️

{{<vimg "resources/20200302_5.png">}}

それでは実際に作り方を紹介します。


プロジェクト作成
----------------

Chrome拡張のプロジェクトを作っていきます。

{{<summary "https://developer.chrome.com/extensions/getstarted">}}

### リポジトリの作成

GitHubにリポジトリを作りCloneします。

本記事で作成したリポジトリは以下です。

{{<summary "https://github.com/tadashi-aikawa/todoist-owl-style">}}

### manifest.jsonの作成

Cloneしてきたリポジトリ内に`manifest.json`を作成します。

```json
{
  "name": "todoist-owl-style",
  "version": "1.0",
  "description": "Adapt Owl Style to Todoist",
  "manifest_version": 2
}
```

これで、最低限のChrome拡張プロジェクトができました🎉

### Google Chromeでプロジェクトを読み込む

実際に読み込んでみましょう。  
Chromeで`chrome://extensions`を開きます。

{{<himg "resources/20200302_1.png">}}

こうなればOKです。

{{<himg "resources/20200302_2.png">}}

{{<info "アイコンについて">}}
Chrome拡張用のアイコンを指定する場合は`manifest.json`に追記しましょう。
{{</info>}}


TodoistページのStyleを変更する
------------------------------

Chrome拡張として認識されても、今の状態では何も起こりません。  
独自のCSSファイルを作成して、それを読み込ませてみましょう。

{{<summary "https://developer.chrome.com/extensions/content_scripts">}}

### style.cssの作成

`style.css`を作成します。 

```css
/*******************************************/
/* Layout
/*******************************************/
.section_day .task_item_details {
  padding: 7px 0;
}
.section_day .text.sel_item_content {
  display: flex;
}
.section_day .task_item_details_bottom {
  order: 1;
}
/* タスク名 */
.section_day .task_item_content_text {
  order: 2;
}

/*******************************************/
/* Hidden
/*******************************************/

/* 期日の非表示 */
.section_day .date.date_today {
  display: none;
}
/* コメント 非表示 */
.section_day .task_item_details_bottom .note_icon {
  display: none !important;
}
/* 関係ないラベルの非表示 */
.section_day
  .task_item_details_bottom
  > a:not([onclick*="分"]):not([onclick*="時間"]):not([onclick*="不明"]) {
  display: none;
}

/*******************************************/
/* label
/*******************************************/
.section_day .task_item_details_bottom {
  margin-top: 0 !important;
  min-width: max-content;
}
/* ラベル 幅統一 */
.section_day .label {
  min-width: 25px;
  text-align: center;
}
/* ラベル 装飾 (工数) */
.section_day .task_item_details_bottom > a[onclick*="分"],
.section_day .task_item_details_bottom > a[onclick*="時間"],
.section_day .task_item_details_bottom > a[onclick*="不明"] {
  font-size: 75%;
  opacity: 0.75;
  border-radius: 5px;
  border-style: outset;
  border-width: 1px;
  padding: 1px 5px 1px 5px;
  margin-right: 5px !important;
}
```

今回のスクリプトでは以下の仕様を想定しています。

* `今日`と`次の7日間`画面のみ有効
* `分``時間``不明`が含まるラベル以外は消す
* `分``時間``不明`が含まるラベルはレイアウトを変更して左側に寄せる
* 期日、コメントは表示しない

特にラベルの文字列は私の都合です。  
必要に応じてCSSをいじってみてください。

### style.cssを適用させる

`manifest.js`に`content_scripts`を追加します。

```js
{
  "name": "todoist-owl-style",
  "version": "1.0",
  "description": "Adapt Owl Style to Todoist",
  "manifest_version": 2,
  "content_scripts": [
    {
      "matches": ["https://todoist.com/app*"],
      "css": ["style.css"]
    }
  ]
}
```

Chrome拡張画面(`chrome://extensions`)からリロードマークをクリックして再読みこみします。  
Todoistを確認してみましょう👀


JavaScriptを使ってカスタマイズする
----------------------------------

cssだけでは限界があります。  
たとえば、特定条件を満たす子要素のDOMを変更することはできません。

特定条件を満たす場合のみ特殊なスタイルを適用するためにJavaScriptを使います。

### contents.jsの作成

タスクが特定の絵文字を含むときに`time-divider`クラスを適用するスクリプトを書きます。  
特定な絵文字は⏲🌅🏢🍙🏠です。

`contents.js`を作成します。

```js
function inSelectorAny(task, selectors) {
  return selectors.some(s => !!task.querySelector(s));
}

function styleTimeDivider(mutationRecords) {
  console.debug("todoist-owl-style: fire");
  const tasks = document.querySelectorAll(".task_item_details");
  tasks.forEach(task => {
    if (inSelectorAny(task, [
      '* img[alt="⏲"]',
      '* img[alt="🌅"]',
      '* img[alt="🏢"]',
      '* img[alt="🍙"]',
      '* img[alt="🏠"]'
    ])) {
      task.classList.add("time-divider");
    }
  });
}

// クエリだけ変わったとき用
(new MutationObserver(styleTimeDivider)).observe(
  document.querySelector("#content"),
  { childList: true }
);

// その他の変更検知
function setObserver() {
  (new MutationObserver(styleTimeDivider)).observe(
    document.querySelector("#editor"),
    { childList: true }
  );
}
window.onhashchange = setObserver;
setObserver();
```

MutationObserverを使って、DOMの変更を検知した場合にclassを適用します。  
その理由は、TodoistがいつどこでDOMを再構築するか分からないからです。

DOMが再構築されてしまうと、それ以前に付与したclassは全て無効化されます。  
そのため、都度処理を行う必要があるのです。

### style.cssの拡張

`style.css`に`time-divider`クラスのstyleを追加してください。  
JavaScriptはclassの付与に責務を集中させ、スタイルはcssでやりましょう😉

```css
/*******************************************/
/* time-divider
/*******************************************/
.section_day .time-divider {
  font-weight: bold;
  margin: 18px 0 6px !important;
}

.section_day .time-divider.task_item_details {
  border-bottom: 2px dotted rgba(0, 0, 0, 0.3);
}

/* Checkboxの透明度アップ */
.section_day .time-divider .sel_checkbox_td {
  opacity: 0.2;
}

/* プロジェクト名とhoverアクションの非表示 */
.section_day .time-divider + .task_item_actions {
  display: none;
}

/* タスク名の中央寄せ */
.section_day .time-divider .content.task_content_item {
  padding-right: 72px;
}
.section_day .time-divider .text.sel_item_content {
  justify-content: center;
}
```

### contents.jsを適用させる

`manifest.js`の`content_scripts`に`js`を追加します。

```js
{
  "name": "todoist-owl-style",
  "version": "1.0",
  "description": "Adapt Owl Style to Todoist",
  "manifest_version": 2,
  "content_scripts": [
    {
      "matches": ["https://todoist.com/app*"],
      "js": ["contents.js"],
      "css": ["style.css"]
    }
  ]
}
```

Chrome拡張画面(`chrome://extensions`)からリロードマークをクリックして再読みこみします。  
Todoistを確認してみましょう👀



総括
----

Todoistのデザインを自分好みに変更するGoogle Chrome拡張の作り方を紹介しました。
シンプルな構成なら、npmすら不要なのは嬉しいですね😄

npmプロジェクトで作ると、TypeScriptやSaSS、外部packageを使うことができます。  
本格的なChrome拡張を開発する場合はそのようにするのが良いでしょう。

開発はほぼ休止しておりますが、[Togowl]はTypeScriptとObserverパターンを使っています。  
よろしければ参考にしてみてください😄

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

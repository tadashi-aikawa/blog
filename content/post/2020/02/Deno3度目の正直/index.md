---
title: Deno3度目の正直
slug: Third-time-lucky-about-deno
date: 2020-02-26T09:37:03+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/ea69yw9k6rbmfj7/raptor-4452140_1280.jpg
categories:
  - engineering
tags:
  - typescript
  - javascript
  - deno
---

過去に2度挫折したDenoについて、3度目の正直でチャレンジしました。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/ea69yw9k6rbmfj7/raptor-4452140_128"/>

<!--toc-->


はじめに
--------

### Denoとは

JavaScriptとTypeScriptのために作られた安全な実行環境です。

{{<summary "https://deno.land/">}}

作者はNode.jsを作ったRyan Dahlさんです。

### なぜ3度目のチャレンジをしようと思ったのか?

以下の記事を見て、またチャレンジしてみたくなったからです😄

{{<summary "https://deepu.tech/deno-runtime-for-typescript/">}}

本稿は↑の記事に沿って進めていきます。

### 環境

|     環境     | バージョン | 備考 |
| ------------ | ---------- | ---- |
| OS           | Windows10  |      |
| [Chocolatey] | 0.10.13    |      |
| Deno         | 0.34       |      |


インストール
------------

[Chocolatey]を使います。

```console
cinst deno
```

以前は[Chocolatey]で上手くいかず、バイナリを直接インストールしていました。  
しかし今回は最新バージョンをインストールできました👍

※ [Scoop]のバージョンは少し古かったです


TypeScriptのコードを実行する
----------------------------

標準でTypeScriptに対応しているのがDenoの強みです💪

`main.ts`に簡単なコードを書いてみます。

```ts
interface Human {
    id: number
    name: string
    gender: "man" | "woman"
}

const taro: Human = {
    id: 1,
    name: "taro",
    gender: "man",
}

console.log(`${taro.name}: ${taro.id}`)
```

実行します。

```console
$ deno main.ts
Compile file:///C:/Users/syoum/works/deno-sandbox/main.ts
taro: 1
```

LGTM😼


フォーマッター
--------------

Denoでは`deno fmt`でPrettierを使ったFormatができます。  
ただ、`.prettierrc`などによる設定はできないようです..。

{{<summary "https://github.com/denoland/deno/issues/968">}}

オプションを与えてパターンを増やすよりも、設定ファイル不要の統一されたフォーマットに価値を置いているようです。


外部のコードをimportする
------------------------

Lodashの`groupBy`を使ってみました。

```ts
import groupBy from "lodash/groupBy.js";

interface Human {
  id: number;
  name: string;
  gender: "man" | "woman";
}

const taro: Human = {
  id: 1,
  name: "taro",
  gender: "man"
};

const jiro: Human = {
  id: 2,
  name: "jiro",
  gender: "man"
};

const hanako: Human = {
  id: 3,
  name: "hanako",
  gender: "woman"
};

console.log(groupBy([taro, jiro, hanako], (x: Human) => x.gender));
```

importでURLを指定しなくてもいいように`import_map.json`を使っています。

```json
{
  "imports": {
    "lodash/": "https://unpkg.com/lodash-es@4.17.15/"
  }
}
```

実行結果です。

```console
$ deno --importmap import_map.json main.ts
...
{ man: [ { id: 1, name: "taro", gender: "man" }, { id: 2, name: "jiro", gender: "man" } ], woman: [ { id: 3, name: "hanako", gender: "woman" } ] }
```

今までLodashをimportして実行できたことは無かったので大きな進歩です😄


できなかったこと
----------------

私の環境で上手くできなかったことです。  
やり方や設定不足かもしれませんが..。


### VSCodeの利用

以下の拡張機能を試してみましたが、importがうまくできませんした..。

{{<summary "https://github.com/axetroy/vscode-deno">}}

### dayjsの利用

パッケージは用意されてそうですが、importができませんでした..。

{{<summary "https://unpkg.com/browse/dayjs@1.8.20/">}}

### TypeScriptの恩恵

VSCode拡張が使えなかったこともあり、TypeScriptの型による恩恵を得ることができませんでした。


総括
----

過去に2度挫折したDenoについて、3度目の正直でチャレンジしました。

Lodashをimportして使う..という進展はありました。  
しかし、今のままでは実戦投入はもちろん、Sandboxでの使用も厳しそうです。

WindowsではなくLinuxで使えば上手く動くのかもしれません..がそのためだけにVMを使いたくないのでもう少し様子見します😅

PS: 強い方いましたら教えて下さい🙇

[Chocolatey]: https://chocolatey.org/
[Scoop]: https://scoop.sh/

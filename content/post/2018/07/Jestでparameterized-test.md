---
title: "JestでParameterized test"
slug: jest-parameterized-test
date: 2018-07-30T06:58:14+09:00
thumbnailImage: https://cdn.svgporn.com/logos/jest.svg
categories:
  - engineering
tags:
  - typescript
  - test
  - jest
---

Jestを使ってParameterized testを書いてみました。

<!--more-->

<img src="https://cdn.svgporn.com/logos/jest.svg"/>

<!--toc-->


前提条件
--------

本記事はNode.js v8以上がインストールされている前提で話を進めます。  
また、Node.jsの説明はしません。


Parameterized test
------------------

Parameterized testはパラメータ化されたテストのことです。  
テストケースごとに変わるパラメータと期待値を列挙することで、無駄な記述を減らすことができます。

通常のテストとの違いはこの後のセッションで説明します。


Jest
----

Facebookが開発しているJavaScriptのテストライブラリです。  
TypeScriptにも対応しています。

{{<summary "https://jestjs.io/ja/">}}

実際に動かしてみましょう。


### Nodeプロジェクトの作成

適当なディレクトリでプロジェクトを作成します。

```
$ npm init -y
```


### Jestのインストール

Jestをインストールします。

```
$ npm i -D jest
$ npx jest --version
23.4.2
```


### 通常のテストを書く

公式サイトを参考のテストを書いてみましょう。

{{<summary "https://jestjs.io/docs/ja/getting-started">}}

`test.js`に以下のコードを記載します。

```javascript
const sum = (x, y) => x + y

describe('sum returns', () => {
  test('1 + 2 -> 3', () => expect(sum(1, 2)).toBe(3));
  test('2 + 1 -> 3', () => expect(sum(2, 1)).toBe(3));
  test('2 + 2 -> 3', () => expect(sum(2, 2)).toBe(3));
})
```

`npx jest`を実行すると最後のテストだけが失敗すると思います。

{{<alert "warning">}}
バージョンによっては`package.json`に以下を追加しないとエラーになる場合があります。

```json
  "jest": {
    "testEnvironment": "node"
  }
```

https://github.com/jsdom/jsdom/issues/2304
{{</alert>}}


### Parameterized testを書く

いくつかの方法からここではTableを使った書き方を紹介します。

{{<summary "https://jestjs.io/docs/en/api#2-describeeach-table-name-fn">}}

```javascript
const sum = (x, y) => x + y

describe.each`
first | second | expected
${1}  | ${2}   | ${3}
${2}  | ${1}   | ${3}
${2}  | ${2}   | ${3}
`("sum returns", ({first, second, expected}) => {
    test(`${first} + ${second} -> ${expected}`, () => expect(first + second).toBe(expected))
})
```

テストケースごとのパラメータと期待値をテーブルのように記述することができます。

テーブル内の値はテンプレートリテラル形式にする必要があるので注意してください。  
`${2}`はint型の2です。文字列hogehogeを設定する場合は`${"hogehoge"}`とする必要があります。

通常の書き方より記述が増えているように見えるのは今回の例がシンプルだからです。  
テストロジックが複雑になったりテストケースが増えれば、可読性・コード数の両面でメリットを感じるでしょう。


総括
----

Jestを使ってTable形式のParameterized testを書いてみました。  
Table形式以外にも配列を流し込む方法もありますので、用途に応じて使い分けすることをオススメします。


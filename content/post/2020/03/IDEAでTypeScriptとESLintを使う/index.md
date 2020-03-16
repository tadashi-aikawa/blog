---
title: IDEAでTypeScriptとESLintを使う
slug: use-typescript-and-eslint-with-intellij-idea
date: 2020-03-16T00:09:43+09:00
thumbnailImage: https://pixabay.com/get/52e1d6454e54a914f6da8c7dda79367c143edee352556c4870277fd69f48c55cb9_640.jpg
draft: true
categories:
  - engineering
tags:
  - idea
  - typescript
  - eslint
---

IntelliJ IDEAでTypeScriptプロダクトを開発するとき、ESLintを導入する方法をまとめてみました。

<!--more-->

<img src="https://pixabay.com/get/52e1d6454e54a914f6da8c7dda79367c143edee352556c4870277fd69f48c55cb9_640.jpg"/>

<!--toc-->


はじめに
--------

### 環境

|     項目      |        バージョン         |
| ------------- | ------------------------- |
| OS            | Windows10                 |
| TypeScript    | 3.8.3                     |
| IntelliJ IDEA | 2019.3.3 Ultimate Edition |
| ESLint        | 6.8.0                     |

### 前提知識

本記事で登場する以下を知っている読者を対象とします。

* TypeScript
* IntelliJ IDEA
* ESLint


プロジェクトの作成
------------------

TypeScriptのNode.jsプロジェクトを作成します。

```console
npm init -y
npm i -D typescript prettier
npx tsc --init
```

`main.ts`を作成します。

```ts
const hello: string = "ハロー"
console.log(hello)
```

実行して`ハロー`と表示されればOKです。

```console
npx tsc && node main.js
```


ESLintの適応
------------

typescript-eslintを使います。

{{<summary "https://github.com/typescript-eslint/typescript-eslint#readme">}}

{{<why "TSLintは使えないのか?">}}
2019年で非推奨になっています。

> Palantir, the backers behind TSLint announced in 2019 that they would be deprecating TSLint in favor of supporting typescript-eslint in order to benefit the community.

{{<refer "typescript-eslint/typescript-eslint README" "https://github.com/typescript-eslint/typescript-eslint#readme">}}
{{</why>}}

### インストール

Getting Startedを見ます。

{{<summary "https://github.com/typescript-eslint/typescript-eslint/blob/master/docs/getting-started/linting/README.md">}}

```console
npm i -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

### 設定ファイルの作成

`.eslintrc.js`を作成します。

```js
module.exports = {
  root: true,
  // ESLintにTypeScript syntaxを理解させる
  parser: '@typescript-eslint/parser',
  // 利用するプラグインを指定
  plugins: [
    // ESLintをTypeScriptで使うためのプラグイン
    '@typescript-eslint',
  ],
  // 利用するベース設定を指定
  extends: [
    // ESLintが提供する推奨設定
    'eslint:recommended',
    // ↑の中でTypeScriptに不要なものをOFFにする設定 (TypeScriptの型チェックで事足りているもの)
    // https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/src/configs/eslint-recommended.ts
    'plugin:@typescript-eslint/eslint-recommended',
    // TypeScriptで推奨されるものをONにする設定
    'plugin:@typescript-eslint/recommended',
  ],
};
```

{{<warn "バージョンについて">}}
`@typescript-eslint/parser`と`@typescript-eslint/eslint-plugin`は同じバージョンにしてください。

{{<summary "https://github.com/typescript-eslint/typescript-eslint/tree/master/packages/eslint-plugin">}}
{{</warn>}}


### 無視ファイルの作成

`.eslintignore`を作成します。

```
node_modules
dist
coverage
```

{{<info "distとcoverageについて">}}
今回のサンプルプロジェクトには存在しないディレクトリですが、大抵の場合は必要になります。
{{</info>}}


### 動作確認

拡張子`.ts`を指定して実行します。  
2つ以上を指定する場合は`.ts,.js`のようにカンマで区切ります。

```
$ npx eslint . --ext .ts
...
  1:7  error  Type string trivially inferred from a string literal, remove type annotation  @typescript-eslint/no-inferrable-types

✖ 1 problem (1 error, 0 warnings)
  1 error and 0 warnings potentially fixable with the `--fix` option.
```

エラーが出ればOKです。  
次のセクションでエラーとの向き合い方を説明します。


Lintエラーに対するアクション
----------------------------

Linterが出すLintエラーとの向き合い方を解説します。


3つのエラー
-----------

すべて以下を削除で直ります。

```
  parserOptions: {
    parser: 'babel-eslint'
  },
```

> As it will make ESlint use a TypeScript parser (@typescript-eslint/parser), please ensure parserOptions.parser option is not overriden either by you or by another configuration you're extending.
>If you were using babel-eslint as parser, just remove it from your .eslintrc.js and your dependencies.

### namespaceのエラー

```
  1 | import axios from '~/plugins/axios'
  2 |
> 3 | export namespace DiceCompany {
    |                  ^
```

### staticのエラー

```
  19:11  error  Parsing error: Unexpected token

  17 |
  18 | export class Status {
> 19 |   private static readonly _values: Status[] = []
     |           ^
```

### importエラー

```
  2:3  error  Parsing error: Imports within a `declare module` body must always be `import type` or `import typeof`

  1 | declare module '*.vue' {
> 2 |   import Vue from 'vue'
    |   ^
  3 |   export default Vue
  4 | }
```


scriptタグで読み込んだglobal変数がエラーに
------------------------------------------

`eslintrc.js`の`global`に追加する

```
  globals: {
    $: 'readonly',
    axios: 'readonly',
  },
```



他のエラー
----------

> 16:5  error  Identifier 'last_updated' is not in camel case      camelcase

camelCaseじゃないから。

外部APIのInterfaceであるため仕方ないので
ファイル先頭に `/* eslint-disable camelcase */` をつける

> 10:7  error  Expected property shorthand                object-shorthand

`{property: property}` を `{property}` って書こう

> 32:3  error  Expected blank line between class members  lines-between-class-members

クラスメンバ間には空白を入れよう.

IDEAの`Fix ESLint Problems`使うと楽


JavaScriptではダメだけどTypeScriptでは問題ないもの
--------------------------------------------------

以下の手順が必要

1. 公式をOFFにする
2. TypeScript専用の設定をON

たとえば

> 128:3  error  Useless constructor                        no-useless-constructor

の場合は
https://eslint.org/docs/rules/no-useless-constructor

```
  rules: {
    'no-useless-constructor': 'off',
    '@typescript-eslint/no-useless-constructor': 'error'
  }
```

IntelliJ IDEAのCode Analysisと競合する
--------------------------------------

試しにInspectionで`JavaScript`と`TypeScript`を全てOFFにしてみる
Code quality tools > ESLintだけは必要

Node.js系?
----------

https://github.com/prettier/eslint-plugin-prettier

### プラグイン

`prettier`

```
npm i -D eslint-plugin-prettier
```

### 推奨設定

`plugin:prettier/recommended`

```
npm i -D eslint-config-prettier
```


エラー一覧
----------



参考
----

TSLintからの移植
https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/ROADMAP.md

https://teppeis.hatenablog.com/entry/2019/02/typescript-eslint

総括
----


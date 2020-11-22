---
title: IDEAでTypeScriptとESLintを使う
slug: use-typescript-and-eslint-with-intellij-idea
date: 2020-03-29T00:26:05+09:00
thumbnailImage: images/cover/2020-03-29.jpg
categories:
  - engineering
tags:
  - idea
  - typescript
  - eslint
  - prettier
---

IntelliJ IDEAでTypeScriptプロダクトを開発するとき、ESLintを導入する方法をまとめてみました。

<!--more-->

{{<cimg "2020-03-29.jpg">}}

<!--toc-->


はじめに
--------

### 環境

|              項目               |        バージョン         |
| ------------------------------- | ------------------------- |
| OS                              | Windows10                 |
| TypeScript                      | 3.8.3                     |
| IntelliJ IDEA                   | 2019.3.3 Ultimate Edition |
| ESLint                          | 6.8.0                     |
| typescript-eslint/parser        | 2.25.0                    |
| typescript-eslint/eslint-plugin | 2.25.0                    |
| Prettier                        | 2.0.2                     |

### 前提知識

本記事で登場する以下の基本知識がある読者を対象とします。

* TypeScript
* IntelliJ IDEA
* ESLint
* Prettier


プロジェクトの作成
------------------

TypeScriptのNode.jsプロジェクトを作成します。

```console
npm init -y
npm i -D typescript prettier
npx tsc --init
```

`index.ts`を作成します。

```ts
const hello: string = "ハロー"
console.log(hello)
```

実行して`ハロー`と表示されればOKです。

```console
npx tsc && node .
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

### ルールを確認する

typescript-eslintのルールは以下にまとまっています。  
まずは、エラーや警告が表示された理由を確認しましょう。

{{<summary "https://github.com/typescript-eslint/typescript-eslint/tree/master/packages/eslint-plugin#supported-rules">}}

> Type string trivially inferred from a string literal, remove type annotation

文字リテラルで初期化していることから`string`型であることは自明なため、型注釈を削除してほしい というエラーです。  
上記ページ内を`@typescript-eslint/no-inferrable-types`で検索すると以下がヒットします。

> Disallows explicit type declarations for variables or parameters initialized to a number, string, or boolean

`number`型、`string`型、`boolean`型の初期化されている変数は明示的な型注釈を許さない..ということです。  

### ルールを変更する

ESLintのドキュメントでルールの設定方法を見てみましょう。

{{<summary "https://eslint.org/docs/user-guide/getting-started#configuration">}}

`.eslintrc.js`の`rules`に以下を設定できます。

* ルール名
* エラーレベル
    * `off` / `warn` / `error`
* 設定値

たとえば、今回のエラーレベルを警告に変更したい場合は以下のようにします。

```javascript
module.exports = {
  // ...中略
  rules: {
    "@typescript-eslint/no-inferrable-types": ["warn"]
  }
}
```

以下のようにエラーが警告に変わりました。

```console
$ npx eslint . --ext .ts
C:\Users\syoum\works\sandbox\typescript\intellij-eslint-prettier\index.ts
  1:7  warning  Type string trivially inferred from a string literal, remove type annotation  @typescript-eslint/no-infer
rable-types

✖ 1 problem (0 errors, 1 warning)
  0 errors and 1 warning potentially fixable with the `--fix` option.
```

{{<info "エラーレベルの変更だけを設定したい場合">}}
糖衣構文として、値を配列でなく文字列で指定できます。
```javascript
  rules: {
    "@typescript-eslint/no-inferrable-types": "warn"
  }
```
{{</info>}}

エラーレベル以外の引数を受けつける場合は、公式ページの説明や例を参考にしましょう。  
以下はインデントの設定に関するページです。

{{<summary "https://eslint.org/docs/rules/indent">}}

### ルール違反を修正する

ルールに問題がない場合はソースコードを修正する必要があります。
🔨マークが付いているルールは自動修正に対応しています。  

`@typescript-eslint/no-inferrable-types`も対応していますので試してみましょう。  
`--fix`オプションをつけて実行します。

```console
npx eslint . --ext .ts --fix
```

`index.ts`のコードが以下のように変更されました。

```diff
- const hello: string = "ハロー";
+ const hello = "ハロー";
```

### ルールを無効化する

理由があって、特定箇所だけルールを無効化したい場合があると思います。  
そのときはコメントで対応します。

{{<summary "https://eslint.org/docs/user-guide/configuring#disabling-rules-with-inline-comments">}}

`ルール名`は特定のルール名で置き換えて下さい。  
先ほどの例だと`@typescript-eslint/no-inferrable-types`です。

* `ルール名`を省略すると全てのルールが対象になります
* `ルール名`を複数指定する場合はカンマで列挙します

#### 次の行だけ無視したい

```javascript
// eslint-disable-next-line @typescript-eslint/no-inferrable-types
const hello: string = "ハロー"; // この行だけ無視される
```

#### 現在行だけ無視したい

```javascript
const hello: string = "ハロー"; // eslint-disable-line @typescript-eslint/no-inferrable-types
```

#### ファイル内の特定行以降をすべて無効化したい

```javascript
const goodMorning: string = "グッドモーニング"; // エラー
// これより上は無効化されない

/* eslint-disable ルール名 */

// これより下は無効化される
const hello: string = "ハロー"; // この行は無視される
```


IntelliJ IDEAとの連携
----------------------

### Lintエラーを表示する

IntelliJ IDEAで連携するための設定をしましょう。  
`ESLint`の設定から、`Automatic ESLint configuration`を選んで下さい。

{{<himg "resources/20200328_1.png">}}

こんな風にInspectionが表示されればOKです。

{{<himg "resources/20200328_2.png">}}

### Lintエラーを自動修正する

`--fix`で修正できるルール違反はIntelliJ IDEAの`Show Context Actions`から修正できます。

{{<himg "resources/20200328_3.gif">}}

`Fix ESLint Problems`を実行すると、ファイルやディレクトリ単位でまとめて修正できます。

{{<himg "resources/20200328_4.gif">}}

### IntelliJのInspectionと競合を防ぐ

`TypeScript`と`JavaScript`のInspectionをすべてオフにすると競合しません。  
ただし、`Code quality tools > ESLint`だけはオンのままにしておく必要があります。

{{<vimg "resources/20200328_5.png">}}
{{<vimg "resources/20200328_6.png">}}

足りないInspectionがある場合は、Lintルールを変更するかIntelliJのInspectionを部分的にオンにすれば対処できます。


トラブルシューティング
----------------------

### Prettierと設定が競合する

ESLintにはフォーマットに関するルールがいくつか存在します。  
それはPrettierの設定と競合することがあります。

たとえばPrettierのクォーテーションはダブルがデフォルトです。  
もしESLintのルールを`quotes: ["error", "single"]`のようにした場合、以下のような無限ループが発生します。

1. ダブルクォーテーションの箇所がESLintの怒られる
2. 1を修正したあと保存すると、Prettierによってダブルクォーテーションへ戻される(1へ)

スタイルはPrettierに任せるため、ESLintの関連設定を無効にしましょう。  
そのために`prettier/eslint-config-prettier`を使います。

{{<summary "https://github.com/prettier/eslint-config-prettier">}}

例に書かれている通り、様々なeslint-plugin設定に対応するラインナップがあります。  
使ったことあるのは`eslint-plugin-vue`のスタイル設定を無効化する`prettier/vue`ですね:smile:

{{<why "記事内でprettier/eslint-config-prettierを紹介しないのはなぜ..?">}}
紹介した以下3つの設定にPrettierと競合するようなスタイル設定が含まれていないからです。

* `eslint:recommended`
* `plugin:@typescript-eslint/eslint-recommended`
* `plugin:@typescript-eslint/recommended`

`eslint:recommended`では`no-mixed-spaces-and-tabs`以外のStylistic Issuesはオフになっています。

{{<refer "https://eslint.org/docs/rules/#stylistic-issues">}}

{{</why>}}

{{<warn "prettier/eslint-config-prettierを使ったらスタイルエラーが拾えなくなった..">}}
`prettier/eslint-plugin-prettier`を使うと、PrettierのエラーをESLintで拾うことができます。

{{<summary "https://github.com/prettier/eslint-plugin-prettier">}}

Webを検索すると、`prettier/eslint-config-prettier`と併用を勧める情報が多く見つかります。  
しかし、私は以下の理由で導入していません。

* 保存時にPrettierで自動修正させれば開発に一切支障がない
    * ESLintで表示すると、スタイル以外のエラーか目立たなくなってしまう
* 依存が増え、設定も複雑になり敷居が上がる

本当に導入するメリットがあるか..は一度考えてみる価値があると思います。
{{</warn>}}


### namespaceやstatic、import周辺でエラーになる

```console
  1 | import axios from '~/plugins/axios'
  2 |
> 3 | export namespace DiceCompany {
    |                  ^
```

```console
  19:11  error  Parsing error: Unexpected token

  17 |
  18 | export class Status {
> 19 |   private static readonly _values: Status[] = []
     |           ^
```

```console
  2:3  error  Parsing error: Imports within a `declare module` body must always be `import type` or `import typeof`

  1 | declare module '*.vue' {
> 2 |   import Vue from 'vue'
    |   ^
  3 |   export default Vue
  4 | }
```

`parserOptions`に`babel-eslint`がある場合は削除すると解決することがあります。

```diff
    parserOptions: {
-     parser: 'babel-eslint'
    },
```


### scriptタグで読み込んだglobal変数がエラーになる

global変数の存在を知らせるため、`.eslintrc.js`の`global`に追加しましょう。  
以下はjQueryとaxiosの例です。

```javascript
module.exports = {
  // ...中略
  globals: {
    $: 'readonly',
    axios: 'readonly',
  },
}
```


総括
----

ESLintをTypeScriptで使う方法、それをIntelliJ IDEAと連携させる方法を紹介しました。

ESLintは設定周りのオプションも多いため、はじめて学ぶにはハードルが高いと思っています。  
TypeScriptやPrettier、ReactやVueなどの設定が入ってくると余計そうでしょう。  
インストールpackageやプラグイン名、extendsする設定名もすべて同じ名前に見えます..:sob:

一方、ESLintは使いこなせば非常に強力な武器になります。  
特にJavaScriptプロダクトをTypeScriptに移行する際は大変お世話になりました。

1人でも多くの方がESLintを使いこなし、TypeScriptで楽しい開発されることを願っております:blush:

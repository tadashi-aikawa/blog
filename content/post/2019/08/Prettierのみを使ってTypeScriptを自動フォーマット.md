---
title: Prettierのみを使ってTypeScriptを自動フォーマット
slug: only-use-prettier-typescript-auto-format
date: 2019-08-08T00:36:26+09:00
thumbnailImage: https://prettier.io/icon.png
categories:
  - engineering
tags:
  - typescript
  - prettier
  - vue
  - idea
---

[Prettier]を使って、[IntelliJ IDEA]で開発中のTypeScriptコードを保存したら自動でフォーマットされるようにしました。  
その際、[ESLint]は使用しません。

<!--more-->

<img src="https://repository-images.githubusercontent.com/75104123/f6f27280-61e5-11e9-8759-33288e842a50"/>

<!--toc-->


背景
----

普段のTypeScript開発では[IntelliJ IDEA]を使っています。  
その場合、[IntelliJ IDEA]に付属のコードフォーマット機能を使っていました。

しかし、それにはいくつか気になる点がありました。

* [IntelliJ IDEA]以外のエディタ/IDEで開発をしたとき同じようにフォーマットされない
* [IntelliJ IDEA]のフォーマット設定が変わるとフォーマットが変わる
* ↑は通常バージョン管理対象外

Go言語は公式にコードフォーマッターが提供されており、保存するだけ同じフォーマットに整形できます。  
Pythonも[Black]を使うと同じことができ、これが非常に快適です。

TypeScriptでも同様のことができるようにしようと思ったわけです。


Prettier
--------

JavaScript/TypeScript界隈にもフォーマッターの選択肢はいくつかあります。  
その中でも最もスターの多い[Prettier]を使うことにしました。

{{<summary "https://prettier.io/">}}

{{<why "ESLintは使わないの?">}}
同様の記事を検索すると、[Prettier]が[ESLint]とセットになって導入されている記事ばかり見かけます。

それがデファクト構成だと言われればそうかもしれません。  
しかし、[ESLint]と共存することでメンテナンスコストが上がるというリスクもあります。

個人的には[ESLint]が無くてもそこまで困らないため、今回は[Prettier]のみを使った導入事例を紹介しています。

[Prettier]: https://prettier.io/
[ESLint]: https://eslint.org/
{{</why>}}


### インストール

npmでインストールします。

```
$ npm i -D prettier
```

### 動作確認

#### フォーマットされているかのチェック

`--check`オプションをして`npx`コマンドを実行します。

```
$ npx prettier --check main.ts
```

`main.ts`がフォーマット済みなら以下のメッセージが表示されます。

```
Checking formatting...
All matched files use Prettier code style!
```

フォーマットされていない場合は以下のメッセージが表示されます。

```
Checking formatting...
main.ts
Code style issues found in the above file(s). Forgot to run Prettier?
```

#### フォーマット

フォーマット後の内容が標準出力に出力されます。  

```
$ npx prettier main.ts
```

フォーマット後の内容でファイルを上書きする場合は`--write`オプションを指定します。

```
$ npx prettier --write main.ts
```

{{<why "Parseを指定する必要はないの?">}}
拡張子からファイル形式を推定してParseを選択します。  
そのため、Parserを明示的に指定する必要はありません。

対応するParserは以下です。  
明示的に指定することもできます。

{{<summary "https://prettier.io/docs/en/options.html#parser">}}

{{</why>}}

### 設定

設定ファイルの読み込ませ方は何通りかありますが、今回は`.prettierrc.yaml`を作成しました。

```yaml
printWidth: 120
tabWidth: 2
useTabs: false
semi: true
singleQuote: true
quoteProps: as-needed
trailingComma: all
bracketSpacing: true
arrowParens: avoid
```

以下のスタイルが好みなので、これに準拠させました。

{{<summary "https://typescript-jp.gitbook.io/deep-dive/styleguide">}}

### 参考

* [CLI · Prettier](https://prettier.io/docs/en/cli.html)
* [Prettierの導入方法 \- フロントエンド開発で必須のコード整形ツール \- ICS MEDIA](https://ics.media/entry/17030/)


IntelliJ IDEAの設定
-------------------

ファイルを保存したら自動でフォーマットされるように[IntelliJ IDEA]を設定します。

### File Watchersプラグインのインストール

ファイル保存時に決まった処理をさせるため、File Watchersプラグインをインストールします。

{{<summary "https://plugins.jetbrains.com/plugin/7177-file-watchers">}}

### File Watchersの設定

以下のように`Tools > File Watchers`から新しい設定を追加します。

{{<himg "https://dl.dropboxusercontent.com/s/vz8vk4h5lr6y3au/20190808_1.jpg">}}

`Level`を`Global`にしておけば、他のプロジェクトに反映させたい場合も`Enabled`をチェックするだけです。

#### Program

`$ProjectFileDir$\node_modules\.bin\prettier`は現在のプロジェクトで`npm install`した`node_modules`配下の`prettier`を示しています。

#### Arguments

直接ファイルを上書きするため、`--write`オプションを指定しています。

### 動作確認

ファイルを編集して保存しましょう。  
Prettierがバックグランドで動作し、ファイルが自動フォーマットされたらOKです😄


総括
----

[Prettier]を使って、[IntelliJ IDEA]で開発中のTypeScriptコードを保存したら自動でフォーマットされるようにしました。  
シンプルにただ[Prettier]だけを使いたい...という方にはオススメです👍

[ESLint]と共存したい場合は公式の以下が参考になると思います。

{{<summary "https://prettier.io/docs/en/integrating-with-linters.html">}}


[Prettier]: https://prettier.io/
[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[Black]: https://github.com/psf/black
[ESLint]: https://eslint.org/
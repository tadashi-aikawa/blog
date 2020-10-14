---
title: VSCodeでよく作るTypeScriptの学習環境
slug: vscode-typescript-learning
date: 2020-10-14T23:54:09+09:00
thumbnailImage: images/cover/2020-10-14.jpg
categories:
  - engineering
tags:
  - typescript
  - vscode
  - prettier
---

TypeScriptの動作確認をするにあたってVSCodeはオススメのツールです。  
本記事ではその理由と環境構築方法を紹介します。

<!--more-->

{{<cimg "2020-10-14.jpg">}}

<!--toc-->


対象とする読者
--------------

以下のような読者を対象にしています。

* Localにnode.js動作環境がある
* TypeScriptを学習したい/する機会が頻繁にある
* VSCodeの使い方を知っている
* 普段のTypeScript開発ではVSCodeを使っていない

また、一部の操作はターミナルを利用します。  
すべてをVSCodeだけでやるわけではありません。ご了承下さい。


なぜVSCodeか?
-------------

VSCodeの開発元が、TypeScriptの開発元でもあるMicroSoftだからです。  
そのため、他の開発環境に比べて以下のメリットがあるはずです。

* TypeScriptの新バージョンに対応するスピードが最も早い
* TypeScriptの言語仕様に最も忠実

私はTypeScriptで開発をするとき、普段はIntelliJ IDEAを使います。  
しかし、リリースノートで言語仕様を確認するときだけはVSCodeを選びます。

きっかけは上記メリットの通りで、リリースノートに記載された細かな言語仕様の一部がIntelliJ IDEAでは忠実に表現されていないケースに巡りあいハマったことがあるからです。  
例を挙げると、TypeScript3.1の`Mapped types on tuples and arrays`など。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/3.1/#mapped-types-on-tuples-and-arrays">}}


一方、普段の開発で多用する仕様に関してはIntelliJ IDEAで困ったことはありません。  
あくまで言語の正確な仕様が知りたいとき.. 学習用途に限ります。


TypeScriptのプロジェクト作成
----------------------------

プロジェクトの作成はターミナルを使います。  
決まったアクションであればスクリプトを書くとより高速化できるでしょう。

ここでは`typescript-blog`というプロジェクト名にします。

```
# プロジェクトディレクトリ作成 -> 移動
$ mkdir typescript-blog
$ cd typescript-blog

# プロジェクト初期化
$ npm init -y

# TypeScriptとフォーマッターのインストール
$ npm i -D typescript prettier

# TypeScript設定の初期化
$ npx tsc --init --locale ja-jp --sourceMap --outDir out
```

### tsc --initのオプションについて

`tsconfig.json`の設定をデフォルト少し変えたいため、いくつかオプションを指定しています。

| オプション       | 意味                     | 指定する理由                                |
| ---------------- | ------------------------ | ------------------------------------------- |
| `--locale ja-jp` | 言語を日本語にする       | コメントが日本語になるので読みやすい        |
| `--sourceMap`    | SourceMapを出力する      | デバッグするため (ts <--> jsの紐付けが必要) |
| `--outDir out`   | jsファイルの出力先を変更 | tsファイルと同階層だと管理が面倒なため      |

作成された`tsconfig.json`は以下のようになります。  
説明が日本語なので英語が苦手な方でも安心です😁

{{<file "tsconfig.json">}}
```js
{
  "compilerOptions": {
    /* このファイルの詳細については、https://aka.ms/tsconfig.json をご覧ください */

    /* 基本オプション */
    // "incremental": true,                    /* インクリメンタル コンパイルを有効にする */
    "target": "es5",                           /* ECMAScript のターゲット バージョンを指定します: 'ES3' (既定値)、'ES5'、'ES2015'、'ES2016'、'ES2017'、'ES2018'、'ES2019'、'ES2020'、'ESNEXT'。 */
    "module": "commonjs",                      /* モジュール コードの生成を指定します: 'none'、'commonjs'、'amd'、'system'、'umd'、'es2015'、'es2020、'ESNext'。 */
    // "lib": [],                              /* コンパイルに含めるライブラリ ファイルを指定します。 */
    // "allowJs": true,                        /* javascript ファイルのコンパイルを許可します。 */
    // "checkJs": true,                        /* .js ファイルのエラーを報告します。 */
    // "jsx": "preserve",                      /* JSX コード生成を指定します: 'preserve'、'react-native'、'react'。 */
    // "declaration": true,                    /* 対応する '.d.ts' ファイルを生成します。 */
    // "declarationMap": true,                 /* 対応する各 '.d.ts' ファイルにソースマップを生成します。 */
    "sourceMap": true,                         /* 対応する '.map' ファイルを生成します。 */
    // "outFile": "./",                        /* 出力を連結して 1 つのファイルを生成します。 */
    "outDir": "out",                           /* ディレクトリへ出力構造をリダイレクトします。 */
    // "rootDir": "./",                        /* 入力ファイルのルート ディレクトリを指定します。--outDir とともに、出力ディレクトリ構造の制御に使用します。 */
    // "composite": true,                      /* プロジェクトのコンパイルを有効にします */
    // "tsBuildInfoFile": "./",                /* 増分コンパイル情報を格納するファイルを指定する */
    // "removeComments": true,                 /* コメントを出力しないでください。 */
    // "noEmit": true,                         /* 出力しないでください。 */
    // "importHelpers": true,                  /* 生成ヘルパーを 'tslib' からインポートします。 */
    // "downlevelIteration": true,             /* 'for-of' の iterable、spread、'ES5' や 'ES3' をターゲットとする場合は destructuring に対してフル サポートを提供します。 */
    // "isolatedModules": true,                /* 個々のモジュールとして各ファイルをトランスパイルします ('ts.transpileModule' に類似)。 */

    /* 詳細オプション */
    "locale": "ja-jp",                         /* ユーザーにメッセージを表示するときに使用するロケール (例: 'en-us') */
    "skipLibCheck": true,                      /* 宣言ファイルの型チェックをスキップします。 */
    "forceConsistentCasingInFileNames": true,  /* 同じファイルへの大文字小文字の異なる参照を許可しない。 */

    /* Strict 型チェック オプション */
    "strict": true,                            /* 厳密な型チェックのオプションをすべて有効にします。 */
    // "noImplicitAny": true,                  /* 暗黙的な 'any' 型を含む式と宣言に関するエラーを発生させます。 */
    // "strictNullChecks": true,               /* 厳格な null チェックを有効にします。 */
    // "strictFunctionTypes": true,            /* 関数の型の厳密なチェックを有効にします。 */
    // "strictBindCallApply": true,            /* 厳格な 'bind'、'call'、'apply' メソッドを関数で有効にします。 */
    // "strictPropertyInitialization": true,   /* クラス内のプロパティの初期化の厳密なチェックを有効にします。 */
    // "noImplicitThis": true,                 /* 暗黙的な 'any' 型を持つ 'this' 式でエラーが発生します。 */
    // "alwaysStrict": true,                   /* 厳格モードで解析してソース ファイルごとに "use strict" を生成します。 */

    /* 追加のチェック */
    // "noUnusedLocals": true,                 /* 使用されていないローカルに関するエラーを報告します。 */
    // "noUnusedParameters": true,             /* 使用されていないパラメーターに関するエラーを報告します。 */
    // "noImplicitReturns": true,              /* 関数の一部のコード パスが値を返さない場合にエラーを報告します。 */
    // "noFallthroughCasesInSwitch": true,     /* switch ステートメントに case のフォールスルーがある場合にエラーを報告します。 */

    /* モジュール解決のオプション */
    // "moduleResolution": "node",             /* モジュールの解決方法を指定します: 'node' (Node.js) または 'classic' (TypeScript pre-1.6)。 */
    // "baseUrl": "./",                        /* 相対モジュール名を解決するためのベース ディレクトリ。 */
    // "paths": {},                            /* 'baseUrl' の相対的な場所を検索するためにインポートを再マップする一連のエントリ。 */
    // "rootDirs": [],                         /* 結合されたコンテンツがランタイムでのプロジェクトの構成を表すルート フォルダーの一覧。 */
    // "typeRoots": [],                        /* 含める型定義の元のフォルダーの一覧。 */
    // "types": [],                            /* コンパイルに含む型宣言ファイル。 */
    // "allowSyntheticDefaultImports": true,   /* 既定のエクスポートがないモジュールからの既定のインポートを許可します。これは、型チェックのみのため、コード生成には影響を与えません。 */
    "esModuleInterop": true                    /* すべてのインポートの名前空間オブジェクトを作成して、CommonJS と ES モジュール間の生成の相互運用性を有効にします。'allowSyntheticDefaultImports' を暗黙のうちに表します。 */
    // "preserveSymlinks": true,               /* symlink の実際のパスを解決しません。 */
    // "allowUmdGlobalAccess": true,           /* モジュールから UMD グローバルへのアクセスを許可します。 */

    /* ソース マップ オプション */
    // "sourceRoot": "",                       /* デバッガーがソースの場所の代わりに TypeScript ファイルを検索する必要のある場所を指定します。 */
    // "mapRoot": "",                          /* デバッガーが、生成された場所の代わりにマップ ファイルを検索する必要のある場所を指定します。 */
    // "inlineSourceMap": true,                /* 個々のファイルを持つ代わりに、複数のソース マップを含む単一ファイルを生成します。 */
    // "inlineSources": true,                  /* 単一ファイル内でソースマップと共にソースを生成します。'--inlineSourceMap' または '--sourceMap' を設定する必要があります。 */

    /* 試験的なオプション */
    // "experimentalDecorators": true,         /* ES7 デコレーター用の実験的なサポートを有効にします。 */
    // "emitDecoratorMetadata": true,          /* デコレーター用の型メタデータを発行するための実験的なサポートを有効にします。 */
  }
}
```
{{</file>}}


VSCodeでソースコードを書く
--------------------------

VSCodeを使って、TypeScriptコードを書いてみましょう。

### プロジェクトを開く

VSCodeでプロジェクトディレクトリを開いて下さい。  
ターミナルからだと `code .` で開けます。

ワークツリーはこんな構成になっていると思います。

```
  .
├──   node_modules
│  ├──   prettier
│  └──   typescript
├──   package-lock.json
├──   package.json
└──   tsconfig.json
```

### index.tsの作成

`index.ts`を作成してみましょう。

`index.ts`
```ts
function sum(x:number, y:number): number {
    return x+y
}

const a = 10
const b = 15
console.log(`${a} + ${b} -> ${sum(a, b)}`)
```

フォーマットやセミコロンの乱れは一旦無視します。

### フォーマッターの設定をする

先ほどインストールしたprettierをフォーマットとして使いましょう。  
まずは拡張機能をインストールします。

{{<summary "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode">}}

VSCodeのデフォルトフォーマッターとして使われるよう`settings.json`の設定を追加します。  
ここではTypeScriptファイル、JavaScriptファイル、そしてJSONファイルを対象にしました。

```json
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
```

{{<refer "Visual Studio Code - Default settings" "https://code.visualstudio.com/docs/getstarted/settings#_default-settings">}}



### ファイル保存時に自動でフォーマットされるようにする

`settings.json`に以下を追加します。

```json
  "editor.formatOnSave": true,
```

{{<refer "Visual Studio Code - Default settings" "https://code.visualstudio.com/docs/getstarted/settings#_default-settings">}}

ここまで設定して保存すればコードが自動成形されます👍

```ts
function sum(x: number, y: number): number {
  return x + y;
}

const a = 10;
const b = 15;
console.log(`${a} + ${b} -> ${sum(a, b)}`);
```


TypeScriptファイルをコンパイルする
----------------------------------

`タスク: 既定のビルドタスクを構成する`からコンパイル用のビルドタスクを作成します。

{{<himg "resources/1b1f3eb2.png">}}

`tsc: build - tsconfig.json`を選びます。  
ソースコード変更時に自動ビルドしたい場合は`tsc: watch - tsconfig.json`を選んでください。

{{<himg "resources/5fa60b1d.png">}}

`.vscode/tasks.json`が作成されます。

```json
{
	"version": "2.0.0",
	"tasks": [
		{
			"type": "typescript",
			"tsconfig": "tsconfig.json",
			"problemMatcher": [
				"$tsc"
			],
			"group": {
				"kind": "build",
				"isDefault": true
			},
			"label": "tsc: build - tsconfig.json"
		}
	]
}
```

ビルドタスクを実行してみましょう。

{{<himg "resources/3d2c63ed.png">}}

`out`ディレクトリ配下にjsファイルとjs.mapファイルができればOKです👍

```
  .
├──   index.ts
├──   node_modules
│  ├──   prettier
│  └──   typescript
├──   out
│  ├──   index.js
│  └──   index.js.map
├──   package-lock.json
├──   package.json
└──   tsconfig.json
```


JavaScriptファイルを実行する
----------------------------

最後にビルドしたjsファイルを実行してみましょう。

`index.ts`を開いた状態で、サイドバーの実行メニューを開き`launch.jsonファイルを作成します`をクリックします。

{{<himg "resources/57955010.png">}}

`node.js`を選択します。

{{<himg "resources/b929e8d8.png">}}

`.vscode/launch.json`が作成されます。  
`program`と`outFiles`のパスに`--outDir`で指定した`out`の挿入を忘れずに..。

```js
{
  // IntelliSense を使用して利用可能な属性を学べます。
  // 既存の属性の説明をホバーして表示します。
  // 詳細情報は次を確認してください: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "プログラムの起動",
      "skipFiles": ["<node_internals>/**"],
      // ${workspaceFolder}\\index.js にoutを入れる
      "program": "${workspaceFolder}\\out\\index.js",
      // ${workspaceFolder}/**/*.js にoutを入れる
      "outFiles": ["${workspaceFolder}/out/**/*.js"]
    }
  ]
}
```

最後に実行します。デバッグあり/なし どちらかを選んでください。

{{<himg "resources/2be357ef.png">}}

デバッグコンソールに結果が出力されればOKです👍

{{<himg "resources/0d71dc8f.png">}}


デバッグする
------------

クリックでブレイクポイントを張って、デバッグ実行するだけです。

{{<himg "resources/ae431d9e.png">}}

こんな風に止まればOKです👍

{{<himg "resources/c7d0b298.png">}}


必ずコンパイルしてから実行する
------------------------------

ソースコードを修正した場合、必ずコンパイルしてからビルドすることになるでしょう。  
手間を省くため、実行前に必ずコンパイル(ビルド)されるよう設定変更しましょう。

`launch.json`の`configurations`配下に`preLaunchTask`以下を追加します。

```
    "preLaunchTask": "tsc: build - tsconfig.json"
```

`index.ts`を変更して実行すると、変更が反映されていることが確認できますね😄

{{<why "preLaunchTask実行後にデバッグコンソールタブがアクティブにならない">}}
`preLaunchTask`の設定を追加すると`ターミナル`タブがアクティブになります。  
そのあとの実行が始まっても`デバッグコンソール`タブに移動しません。

{{<himg "resources/be120fc9.png">}}

`launch.json`の`configurations`に以下オプションを追加することで、実行後自動でデバッグコンソールをアクティブにできます。

```json
    "internalConsoleOptions": "openOnSessionStart",
```

{{<refer "Visual Studio Code - Default settings" "https://code.visualstudio.com/docs/getstarted/settings#_default-settings">}}
{{</why>}}


総括
----

VSCodeでよく作るTypeScriptの学習環境構築方法を紹介しました。

最終的には以下のようなディレクトリ構成になります。

```
  .
├──   .vscode
│  ├──   launch.json     // 実行用の設定
│  └──   tasks.json      // ビルド(コンパイル)用の設定
├──   index.ts           // ビルド(コンパイル)のエントリポイント(target)
├──   node_modules
│  ├──   .bin
│  ├──   prettier
│  └──   typescript
├──   out
│  ├──   index.js        // コンパイル後の実行ファイル
│  └──   index.js.map    // TypeScriptとの紐付けに必要(デバッグ etc)
├──   package-lock.json
├──   package.json
└──   tsconfig.json      // TypeScriptの設定
```

新しいTypeScriptバージョンがリリースされたとき..、開発中のリポジトリとは別に動作確認がしたいときなど是非利用してみてください🦉

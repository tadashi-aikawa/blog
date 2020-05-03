---
title: VSCodeのExtensionを作ってみた
slug: create-vscode-extension
date: 2018-11-12T23:11:03+09:00
thumbnailImage: https://images.unsplash.com/photo-1507065282747-afce6cd90e84?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=442a16fcb9f1f67352b942be3af33f0d&auto=format&fit=crop
categories:
  - engineering
tags:
  - vscode
  - typescript
---

VSCodeでオレオレExtensionを作ってみました。  
参考にした情報や手順をまとめます。

<!--more-->

<img src="https://images.unsplash.com/photo-1507065282747-afce6cd90e84?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=442a16fcb9f1f67352b942be3af33f0d&auto=format&fit=crop" />

<!--toc-->


はじめに
--------

### 想定する読者

**VSCodeでこれからExtensionを作ろうと思っている方** を対象にしています。

また、以下の知識があることを前提にしています。

* TypeScript
* npm
* VSCode
* Promise
* async/await


### 実装する機能

Markdownの見出し(`#`を使わない方)を自動で挿入する機能を作ります。

{{<himg "resources/20181112_1.gif">}}

全角文字は2つ、半角文字は1つでカウントします。


### 成果物について

GitHubに公開しています。

{{<summary "https://github.com/tadashi-aikawa/owlcode">}}

Marketplaceには公開していません。内容があまりに特化しすぎているからです。  
利用する場合はGitHubのREADMEをご覧下さい。


### 参考文献

基本的に公式ドキュメントの内容をかみ砕いているだけです。  
英語に抵抗無い方は公式ドキュメントを読んだ方がいいと思います。

{{<summary "https://code.visualstudio.com/docs/extensions/overview">}}


準備
----

[npm]と[VSCode]が必要です。


Extensionプロジェクトの作成
---------------------------

公式ドキュメントでは以下のページに対応しています。

{{<summary "https://code.visualstudio.com/docs/extensions/yocode">}}

### Yeomanのインストール

[Yeoman]を使うのでgeneratorと共にインストールします。

```
$ npm install -g yo generator-code
```

{{<error "npm ERR! write after end">}}
npmをupgradeしたらなおりました。

```
$ npm install -g npm@latest
$ npm --version
6.4.1
```
{{</error>}}


### 雛形の生成

```
$ yo code
```

上記コマンドを実行するといくつか質問されます。  
今回のプロジェクトは以下の様に回答しています。

```
? What type of extension do you want to create? New Extension (TypeScript)
? What's the name of your extension? hello
? What's the identifier of your extension? hello
? What's the description of your extension?
? What's your publisher name (more info: https://code.visualstudio.com/docs/tools/vscecli#_publishing-extensions)? hello
? Enable stricter TypeScript checking in 'tsconfig.json'? Yes
? Setup linting using 'tslint'? Yes
? Initialize a git repository? Yes
```

プロジェクトタイプをTypeScriptにしているのが重要なポイントです。

`hello`ディレクトリが作成されていれば成功です。


VSCodeで動作確認する
--------------------

VSCodeで先ほど作成した`hello`ディレクトリを開きましょう。  
そのままデバッグ実行すると、新しいVSCodeが別のウィンドウで立ち上がるはずです。

コマンドパレットで`Hello World`と検索し、見つかったコマンドを実行しましょう。  
VSCode下部にメッセージが表示されれば成功です。


プロジェクト構成
----------------

ここからはサンプルをベースに作成したowlcodeのコードを例として紹介していきます。  
まずはプロジェクトを構成するファイルの中から重要なものだけ紹介します。


### package.json

以下のセクションが大事です。

#### contributes

コマンドの定義などを記載します。

```json
    "contributes": {
        "commands": [
            {
                "command": "extension.headerLV1",
                "title": "Add header LV1"
            },
            {
                "command": "extension.headerLV2",
                "title": "Add header LV2"
            }
        ],
        "keybindings": [
            {
                "command": "extension.headerLV1",
                "key": "alt+shift+-"
            },
            {
                "command": "extension.headerLV2",
                "key": "alt+-"
            }
        ]
    },
```

上記`commands`配下のプロパティの意味です。

* command
  * Extensionのソースコード内で使用する識別子
* title
  * VSCode利用時にコマンドパレットで表示されるコマンド名

`keybindings`配下のプロパティの意味です。

* command
  * Extensionのソースコード内で使用する識別子
* key
  * デフォルトのkey binding

GitLensの設定が大変参考になりました。

{{<summary "https://github.com/eamodio/vscode-gitlens/blob/master/package.json">}}


#### activationEvents

Extensionが読み込まれるタイミングのイベントを指定できます。

```json
    "activationEvents": [
        "onCommand:extension.headerLV1",
        "onCommand:extension.headerLV2"
    ],
```

`onCommand:`は特定のコマンドが実行される直前です。  
必ず読み込むために`*`を指定しても良さそうです。

```json
    "activationEvents": [
        "*"
    ],
```

### src/extension.ts

`activate`の中にcommandを登録します。

```typescript
export function activate(context: vscode.ExtensionContext) {
    const register = vscode.commands.registerCommand;

    context.subscriptions.push(
        register('extension.headerLV1', async () => await setHeader("=")),
        register('extension.headerLV2', async () => await setHeader("-")),
    );
}
```

上の例では`extension.headerLV1`と`extension.headerLV2`のコマンドを登録しています。  
それぞれ`setHeader`が異なる引数で呼び出されます。


実装
----

### エディタ操作のIFをラップする

vscodeが提供するデフォルトのIFでは記述量が増えてしまうため、`editor.ts`というラッパ層を作りました。

{{<file "editor.ts">}}
```typescript
'use strict'
import * as vscode from 'vscode'

const edit = (editor: vscode.TextEditor, editFunc: (editBuilder: vscode.TextEditorEdit) => void): Promise<{}> =>
    new Promise((resolve, reject) => {
        editor.edit(editBuilder => {
            editFunc(editBuilder)
            resolve()
        })
    })

export const getActiveLineText = (editor: vscode.TextEditor): string =>
    editor.document.lineAt(editor.selection.active.line).text

export const getSelectionText = (editor: vscode.TextEditor): string =>
    editor.document.getText(editor.selection)


export const replaceActiveLine = async (editor: vscode.TextEditor, str: string): Promise<{}> =>
    await edit(editor, editBuilder => {
        const activeLine = editor.document.lineAt(editor.selection.active.line).range
        editBuilder.replace(activeLine, str)
    })

export const replaceSelection = async (editor: vscode.TextEditor, str: string): Promise<{}> =>
    await edit(editor, editBuilder => editBuilder.replace(editor.selection, str))


export const insertNextLine = async (editor: vscode.TextEditor, str: string): Promise<{}> =>
    await edit(editor, editBuilder => editBuilder.insert(
        new vscode.Position(editor.selection.active.line, 999), str)
    )
```
{{</file>}}

今回は使っていないIFもありますが、利用機会が多そうなものは実装しています。

### 実現する機能を作る

今回実現する機能を`extension.ts`に実装します。

{{<file "extension.ts">}}
```typescript
'use strict'
import * as vscode from 'vscode'
import { insertNextLine, getActiveLineText, getSelectionText, replaceSelection } from './editor'

// Shift_JIS: 0x0 ～ 0x80, 0xa0 , 0xa1 ～ 0xdf , 0xfd ～ 0xff
// Unicode : 0x0 ～ 0x80, 0xf8f0, 0xff61 ～ 0xff9f, 0xf8f1 ～ 0xf8f3
const getBytes = (c: number | undefined): number =>
    c === undefined ? 0 :
        (c >= 0x0 && c < 0x81) || (c === 0xf8f0) || (c >= 0xff61 && c < 0xffa0) || (c >= 0xf8f1 && c < 0xf8f4) ?
            1 : 2

const countLength = (str: string): number => str.split('')
        .map(x => getBytes(x.codePointAt(0)))
        .reduce((x, y) => x + y)


function setHeader(symbol: string) {
    const editor = vscode.window.activeTextEditor
    if (!editor) {
        return
    }

    const titleLength = countLength(getActiveLineText(editor))
    insertNextLine(editor, `\n${symbol.repeat(titleLength)}`)
}

export function activate(context: vscode.ExtensionContext) {
    const register = vscode.commands.registerCommand

    context.subscriptions.push(
        register('extension.headerLV1', async () => await setHeader("=")),
        register('extension.headerLV2', async () => await setHeader("-")),
    )
}

export function deactivate() {
}
```
{{</file>}}

`setHeader`で指定された文字の繰り返しを次の行に挿入します。  
ただし、現在行の文字カウント(全角は2)と一致するように。

動作確認して上手く動けばOKです。


Extensionのローカルインストール
-------------------------------

Marketplaceには公開しないので直接ローカルにインストールします。  
Windowsの場合は`%USERPROFILE%\.vscode\extensions`配下にプロジェクトディレクトリをぶっ込むだけでOKです。

今回はインストール用のbatを作成しました。

```bat
git clone https://github.com/tadashi-aikawa/owlcode.git %HOMEPATH%\.vscode\extensions\owlcode ^
  && cd %HOMEPATH%\.vscode\extensions\owlcode ^
  && npm i ^
  && npm run compile
```

アップデート用は以下です。

```bat
cd %HOMEPATH%\.vscode\extensions\owlcode ^
  && git pull ^
  && npm i ^
  && npm run compile
```

{{<info "実行に必要な最小限のファイルは...">}}
今回はdependenciesが無いため、以下2ファイルがあれば動くはずです。

* `package.json`
* `./out/extension` (`package.json`の`main`で指定されているファイル)

とはいえ高々数十MBなので、更新時のことも考えてプロジェクトを丸丸取得するようにしています。
{{</info>}}


総括
----

VSCodeでExtensionを作成して、Marketplaceに公開せずインストールする方法を紹介しました。

公式ドキュメントには他のサンプルやAPIドキュメントがまだまだ沢山あります。  
VSCode利用時に欲しい機能ができたら、都度owlcodeに実装していきたいと思います。

{{<summary "https://github.com/tadashi-aikawa/owlcode">}}


[Yeoman]: http://yeoman.io/
[npm]: https://www.npmjs.com/
[VSCode]: https://code.visualstudio.com/
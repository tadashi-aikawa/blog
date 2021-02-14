---
title: Obsidianでオートコンプリートプラグインを作ってみた
slug: create-auto-complete-plugin-for-obsidian
date: 2021-02-14T18:21:24+09:00
thumbnailImage: images/cover/2021-02-14.jpg
categories:
  - engineering
tags:
  - obsidian
  - typescript
  - codemirror
  - show-hint
  - tiny-segmenter
---

日本語でオートコンプリートができる[Obsidian]のプラグインを作ってみました。英語をはじめとした他言語でもトークン解析ロジックがマッチすれば使えます。

<!--more-->

{{<cimg "2021-02-14.jpg">}}

<!--toc-->


はじめに
--------

[Obsidian]とはローカルで知識ベースを管理するアプリケーションです。詳しくは先月の記事をご覧ください。

{{<summary "https://blog.mamansoft.net/2021/01/16/use-obsidian-so-that-manage-knowledge/">}}

### 前提

`成果物`の章よりあとの部分は以下のスキルがある読者を想定しています。

- [TypeScript] (JavaScriptでもOK)
- npmやyarnでフロントエンド開発するための基礎知識
- Makefile
- GitHub Actions


プラグインを開発した経緯
------------------------

[Obsidian]には現在編集中のファイルからトークンを補完する機能がありません。既存のプラグインを探したところ、それらしい名前のプラグインはありました。

{{<summary "https://github.com/yeboster/autocomplete-obsidian">}}

しかし、こちらのプラグインは現時点でLatexに特化した補完のみを提供されているようであり用途が違いました。[Obsidian]のプラグイン作成には前々から興味があり、[TypeScript]は私の得意分野でもあるためチャレンジしてみました。


成果物
------

先に完成したものをお見せします。

{{<summary "https://github.com/tadashi-aikawa/obsidian-various-complements-plugin">}}

{{<himg "https://raw.githubusercontent.com/tadashi-aikawa/obsidian-various-complements-plugin/main/demo/demo.gif">}}

Windowsなら`Ctrl + Space`を押すと、日本語/英語のトークンを解析し候補をサジェストします。候補が1つしかない場合は即時決定します。


参考にした情報
--------------

まずはプラグインサンプルプロジェクトをCloneして挙動を確認しました。

{{<summary "https://github.com/obsidianmd/obsidian-sample-plugin">}}

プラグインSDKで利用できるAPIは以下の公式ドキュメントを参考にしました。

{{<summary "https://github.com/obsidianmd/obsidian-api">}}

自作プラグインをLocalで動かすには`<VaultFolder>/.obsidian/plugins/<your-plugin-id>/`に以下3ファイルをコピーするだけです。

| ファイル名      | 必須 | 用途                                       |
| --------------- | ---- | ------------------------------------------ |
| `main.js`       | o    | メイン処理                                 |
| `manifest.json` | o    | 名前やバージョンなどプラグインのメタデータ |
| `styles.css`    |      | スタイルを指定する場合に必要               |


実装の詳細
----------

ここからは実装の詳しい話をします。

### アクティブドキュメントの内容を取得する

まずは補完候補のトークンを作成する必要があります。英語なら[CodeMirror]のトークン取得APIを利用できますが日本語は無理です。メモアプリでは母国語サポートが重要なため対応は必要です。

`CodeMirror.Editor`の`getValue()`を使うとアクティブドキュメントのコンテンツを文字列で取得できます。

```ts
const currentView = this.app.workspace.getActiveViewOfType(MarkdownView);
if (!currentView) {
  // Do nothing if the command is triggered outside a MarkdownView
  return;
}

const cmEditor: Editor = currentView.sourceMode.cmEditor;
console.log(cmEditor.getValue());
```

### トークンへの分割

アクティブドキュメントのコンテンツを取得できたら、それをトークンへ分割する必要があります。

フロントエンドで完結し、日本語対応しており、軽量なライブラリを探したところ、[TinySegmenter]というライブラリを見つけました。

{{<summary "http://chasen.org/~taku/software/TinySegmenter/">}}

そのままでは[TypeScript]でimportできなかったため[若干手を加えて]使用させていただきました。

[若干手を加えて]: https://github.com/tadashi-aikawa/obsidian-various-complements-plugin/blob/bd74eddf1069740a0136036425fd5c6e3e677b54/tiny-segmenter.ts

#### トークン抽出ロジック

基本は[TinySegmenter]の素晴らしい解析に従っています。

```ts
function pickTokens(cmEditor: Editor): string[] {
  return cmEditor
    .getValue()
    .split(`\n`)
    .flatMap<string>((x) => segmenter.segment(x))
    // [, ], (, ), <, >, ", ', ` はノイズになるので除去
    .map((x) => x.replace(/[\[\]()<>"'`]/, ""));
}
```

コメントで補足した部分が追加で行っている調整です。


### CodeMirrorのトークンとTinySegmenterのトークン

[Obsidian]ではカーソル配下のトークンを[CodeMirror]経由で取得できます。

```ts
// 現在のカーソル位置
const cursor = cmEditor.getCursor();
// カーソル配下のトークン
const token = cmEditor.getTokenAt(cursor);
```

この情報は補完候補を決める際に利用します。しかし、[CodeMirror]のトークンと[TinySegmenter]のトークンは単位が異なるため問題が発生します。

たとえば『Today いい天気です』の場合、以下のように差分が生じます。

```
// TinySegmenter
[Today, いい, 天気, です]
// CodeMirror
[Today, いい天気です]
```

この差分によって、補完候補に出るべき情報が表示されなかったり、補完候補を決定したときに変更される位置がずれてしまうという問題が発生しました。事象と対策を掘り下げてみます。

#### 補完候補に出るべき情報が表示されない例

```
Today いい天気ですob
```

ここで補完したら『Obsidian』が候補に出てほしいのですが、**[CodeMirror]は『いい天気ですob』を1トークンとして捉える**ため『Obsidian』は補完候補に表示されません(部分一致していない)。

#### 対策

[CodeMirror]のトークンを[TinySegmenter]で更に解析し、最後の1トークンを **現在のトークン** として扱うようにしました。

```
// CodeMirror
[Today, いい天気ですob]

↓ // いい天気ですob を TinySegmenter で更に解析

[いい, 天気, です, ob]
```

これで、最後の『ob』が現在のトークンとして扱われるため、『Obsidian』は補完候補に表示されます。ソースコードでは以下のような実装になります。

```ts
const cursor = cmEditor.getCursor();
// カーソル配下のトークン取得
const token = cmEditor.getTokenAt(cursor);
if (!token.string) {
  return;
}

// カーソル配下のトークンをTinySegmenterで解析
const words = segmenter.segment(token.string);
// 最後の1つを現在のトークンとしてword, 残りをwordsとする
const word = words.pop();

// アクティブドキュメントのコンテンツに対してTinySegmenterで解析されたトークンを取得
const tokens = pickTokens(cmEditor);
// 現在のトークンと比較して最適な候補を選出
const suggestedTokens = selectSuggestedTokens(tokens, word);
```


#### 補完候補を決定したときに変更される位置がずれる例

先ほどの対策には副作用があります。補完候補を決定したとき挿入位置がずれてしまうのです。

```
Today いい天気ですob

↓ 『Obsidian』で決定すると..

Today Obsidian
```

これは[CodeMirror]から見た現在のトークンは『いい天気ですob』であるため、ここを置き換えようとするからです。

#### 対策

[CodeMirror]に『いい天気ですob』ではなく『ob』が置き換え対象であると伝える必要があります。そのために[CodeMirror]が置き換えるトークンの先頭をずらしてあげました。

```
// いい天気ですob を TinySegmenter で更に解析
[いい, 天気, です, ob]
```

ずれは『いい』『天気』『です』の6文字分です。つまり、`CodeMirrorから見た現在のトークン長 - TinySegmenterから見た現在のトークン長`になります。ソースコードでは以下の実装になります。

```ts
const cursor = cmEditor.getCursor();
const token = cmEditor.getTokenAt(cursor);
if (!token.string) {
  return;
}

const words = segmenter.segment(token.string);
const word = words.pop();
// 追加: `CodeMirrorから見た現在のトークン長 - TinySegmenterから見た現在のトークン長`
const restWordsLength = words.reduce(
  (t: number, x: string) => t + x.length,
  0
);

const tokens = pickTokens(cmEditor);
const suggestedTokens = selectSuggestedTokens(tokens, word);

return {
  list: suggestedTokens,
  // トークンの開始位置をrestWordsLengthだけずらす
  from: CodeMirror.Pos(cursor.line, token.start + restWordsLength),
  to: CodeMirror.Pos(cursor.line, cursor.ch),
};
```

### ソート順

ソートロジックは`selectSuggestedTokens`で決めています。

```ts
function selectSuggestedTokens(tokens: string[], word: string) {
  return Array.from(new Set(tokens))
    // 現在のトークンと同じワードは除外 (常に表示されるのでノイズ)
    .filter((x) => x !== word)
    // 小文字に統一して部分一致するもののみ対象に残す
    .filter((x) => lowerIncludes(x, word))
    // 文字列が短いものをより優先する
    .sort((a, b) => a.length - b.length)
    // 前方一致のものをより優先する
    .sort(
      (a, b) =>
        Number(lowerStartsWith(b, word)) - Number(lowerStartsWith(a, word))
    )
    // 候補の表示は5つまでとする
    .slice(0, 5);
}
```

各設定はユーザーの好みによってGOOD/BADは分かれると思います。そこは必要に応じて今後設定できるようにすればいいかなと。少なくとも私はある程度直感的な補完になっていると思っています。敢えて言うなら、アルファベットが大文字の場合はCase Sensitiveな優先度にしてもいいかもしれません。

### 補完ウィンドウの表示

候補の選出はできるようになりましたがUIへの反映はまだです。これには[CodeMirror]の[show-hint]プラグインを使います。

[TinySegmenter]と同様、[TypeScript]でインポートできるように[オリジナルのコード]を一部変更して[TypeScript用のshow-hint.ts]を作りました。

[オリジナルのコード]: https://codemirror.net/addon/hint/show-hint.js
[TypeScript用のshow-hint.ts]: https://github.com/tadashi-aikawa/obsidian-various-complements-plugin/blob/bd74eddf1069740a0136036425fd5c6e3e677b54/show-hint.ts

[show-hint]は[CodeMirror]インスタンスに対してprototypeを拡張する方式のため冒頭に以下のコードを追加します。

```ts
var CodeMirror: any = window.CodeMirror;
import "./show-hint";
```

`showHint`を呼び出せばUIとの結合は完了です。

```ts
CodeMirror.showHint(
  cmEditor,
  () => {
    const cursor = cmEditor.getCursor();
    const token = cmEditor.getTokenAt(cursor);
    if (!token.string) {
      return;
    }

    const words = segmenter.segment(token.string);
    const word = words.pop();
    const restWordsLength = words.reduce(
      (t: number, x: string) => t + x.length,
      0
    );

    const tokens = pickTokens(cmEditor);
    const suggestedTokens = selectSuggestedTokens(tokens, word);
    if (suggestedTokens.length === 0) {
      return;
    }

    return {
      list: suggestedTokens,
      from: CodeMirror.Pos(cursor.line, token.start + restWordsLength),
      to: CodeMirror.Pos(cursor.line, cursor.ch),
    };
  },
  {
    completeSingle: true,
  }
);
```

しかし、これだけではUIに表示されません。これはCSSの問題であるため`styles.css`に設定を追加します。

```css
.CodeMirror-hints {
  position: absolute;
  background-color: var(--background-primary);
  border: 2px solid var(--background-primary-alt);
  list-style: none;
  padding-left: 0;
}

.CodeMirror-hint {
  padding: 5px;
}
.CodeMirror-hint-active {
  background-color: var(--tooltip-bg);
}
```


プラグインのリリース
--------------------

[Obsidian]のCommunity pluginsとして公開するためにはGitHubへリリースが必要です。

### ローカルでバージョンアップとタグ付け

以下の作業が必要です。

- `manifest.json`のバージョン更新
- `package.json`のバージョン更新
- バージョンでタグ付け
- ビルドの確認
- push

私の場合はMakefileを作り、`make release version=x.y.z`のような形で自動化できるようしています。

```makefile
MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
ARGS :=
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9_-]+: $(MAKEFILE_LIST) | sed 's/://')

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9][a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "[ERROR] Required: $* !!"; \
		echo "[ERROR] Please set --> $*"; \
		exit 1; \
	fi

#------

release: guard-version ## [Required: $version. ex. 0.5.1]
	@echo '1. Update versions'
	@sed -i -r 's/\"version\": \".+\"/\"version\": \"$(version)\"/g' manifest.json
	@git add manifest.json
	@git commit -m "Update manifest"
	@npm version $(version)

	@echo '2. Build'
	@npm run build

	@echo '3. push'
	@git push --tags
	@git push
```

{{<alert warning>}}
Obsidianプラグインのリリースではバージョンにprefix `v`を付けてはいけません。[npmのversion prefixを変更する方法]などの方法でprefixを空にしてください。これを忘れるとプラグインがダウンロードできなくなります。

[npmのversion prefixを変更する方法]: https://publish.obsidian.md/mamansoft/Notes/npm%E3%81%AEversion+prefix%E3%82%92%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95
{{</alert>}}


### GitHubにリリース

GitHub Actionsを使ってタグがpushされたときに以下が自動実行されるようにします。

- 成果物をビルド
- リリースページの作成
- 成果物の一部をリリースページに配置
- Slackで通知

`.github/workflows/release.yaml`は以下のようになります。[create-release]でリリースページを作成し、 [upload-release-asset]で成果物を配置しています。

```yaml
name: "Release"

on:
  push:
    tags:
      - "*"

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v1
        with:
          node-version: 14.x

      - run: npm install
      - run: npm run build

      - name: Create Release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          draft: false
          prerelease: false

      - name: Upload main.js
        id: upload-main
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: ./main.js
          asset_name: main.js
          asset_content_type: text/javascript
      - name: Upload styles.css
        id: upload-styles
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: ./styles.css
          asset_name: styles.css
          asset_content_type: text/css
      - name: Upload manifest.json
        id: upload-manifest
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: ./manifest.json
          asset_name: manifest.json
          asset_content_type: application/json

      - name: "Slack notification (not success)"
        uses: homoluctus/slatify@master
        if: "! success()"
        with:
          type: ${{ job.status }}
          username: GitHub Actions (Failure)
          job_name: ":obsidian: Release ${{ github.ref }}"
          mention: channel
          mention_if: always
          icon_emoji: "github"
          url: ${{ secrets.SLACK_WEBHOOK }}

  notify:
    needs: release
    runs-on: ubuntu-latest

    steps:
      - name: "Slack Notification (success)"
        uses: homoluctus/slatify@master
        if: always()
        with:
          type: ${{ job.status }}
          username: GitHub Actions (Success)
          job_name: ":obsidian: Release ${{ github.ref }}"
          icon_emoji: ":github:"
          url: ${{ secrets.SLACK_WEBHOOK }}
```

Slackに関する設定は参考です。Slack通知が不要なら削除してください。


公開の手続き
------------

公式ドキュメントの手順に従います。

{{<summary "https://github.com/obsidianmd/obsidian-releases">}}

やることは[obsidian-releases/community-plugins.json]にプラグイン情報を追加してプルリクエストを出すだけです。

[obsidian-releases/community-plugins.json]: https://github.com/obsidianmd/obsidian-releases/blob/master/community-plugins.json

プルリクエストは[Obsidian]コアメンバーの方からかなりしっかりとレビューしていただけます😄  英語の添削やプラグインAPIの使い方、好ましい実装方法など大変勉強になりました✨

{{<summary "https://github.com/obsidianmd/obsidian-releases/pull/155">}}

WebWorkerを使った実装には近々チャレンジしたいと思っています。業務でも使えそうですし😉


総括
----

日本語のオートコンプリートができる[Obsidian]のプラグインを作成するにあたって、開発やリリースに必要な情報や実装の詳細を紹介しました。

日本の[Obsidian]ユーザーはまだ多くないと思っています。プラグイン作成者は尚更のことでしょう。このような活動が日本における(あわよくば世界でも..!)[Obsidian]の普及に貢献できれば嬉しく思います😆


### 🦉 執筆の元になったMinervaのNotes

※ 私が[Obsidian]でpublishしているナレッジページです

- [Various Complementsのオートコンプリート機能を実装する](https://publish.obsidian.md/mamansoft/Articles/Various+Complements%E3%81%AE%E3%82%AA%E3%83%BC%E3%83%88%E3%82%B3%E3%83%B3%E3%83%97%E3%83%AA%E3%83%BC%E3%83%88%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%99%E3%82%8B)
- [Various Complementsのリリースを自動化する](https://publish.obsidian.md/mamansoft/Notes/Various+Complements%E3%81%AE%E3%83%AA%E3%83%AA%E3%83%BC%E3%82%B9%E3%82%92%E8%87%AA%E5%8B%95%E5%8C%96%E3%81%99%E3%82%8B)
- [Obsidian PluginをCommunity Pluginとして公開](https://publish.obsidian.md/mamansoft/Notes/Obsidian+Plugin%E3%82%92Community+Plugin%E3%81%A8%E3%81%97%E3%81%A6%E5%85%AC%E9%96%8B)


[Obsidian]: https://obsidian.md/
[TypeScript]: https://www.typescriptlang.org/
[CodeMirror]: https://codemirror.net/
[TinySegmenter]: http://chasen.org/~taku/software/TinySegmenter/
[show-hint]: https://codemirror.net/doc/manual.html#addons
[create-release]: https://github.com/actions/create-release
[upload-release-asset]: https://github.com/actions/upload-release-asset


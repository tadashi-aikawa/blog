---
title: "Nuxt.js+TypeScriptでMonacoEditorを使ってみた"
slug: nuxtjs-typescript-monacoeditor
date: 2018-07-16T03:37:14+09:00
thumbnailImage: https://images.pexels.com/photos/3586/port-yachts-monaco-luxury.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260
categories:
  - engineering
tags:
  - typescript
  - vue
  - angular
  - nuxt
  - electron
  - monaco-editor
---

Nuxt.jsとTypeScriptの構成でMonaco Editorを使ってみました。  

<!--more-->

<img src="https://images.pexels.com/photos/3586/port-yachts-monaco-luxury.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"/>

<!--toc-->


はじめに
-------

### 経緯

前回、Nuxt.jsとTypeScriptでGitHub Viewerを作成する記事を執筆しました。

{{<summary "https://blog.mamansoft.net/2018/07/09/nuxtjs-typescript-github-viewer/">}}

その後、Windowsで動くIDEのようなモノを開発することになりました。  
最終的にMonaco Editorを採用することになりましたが、Web上に参考となる記事を見つけられず結構苦戦したので記事にすることにしました。


### 前提条件

以下の環境を想定して進めます。

* npm5
* Windows 10


### ソースコード

今回は公開していません。

### ツールのデモ

デモはありません。


利用技術
--------

以下の技術を利用しています。

* Vue.js
* Nuxt.js (1.3.x)
* TypeScript (2.7.x)
* Electron (2.0.4)
* Monaco Editor (0.13.1)
* monaco-editor-webpack-plugin (1.4.0)

Vue.js、Nuxt.js、TypeScript、Electronの説明について、本記事では割愛します。


Monaco Editor
-------------

### Monaco Editorとは

Microsoftが開発しているコードエディタです。  
明確な依存関係はありませんが、VS Codeのエディタ部分をOSSとして切り出したものだと思います。

{{<summary "https://microsoft.github.io/monaco-editor/">}}


### なぜMonaco Editor?

他のエディタと比べて、パフォーマンスやUXが優れているからです。

名前は挙げませんが、他にも色々なエディタを試してはみました。  
しかし、他のエディタは10万行のコードを貼り付けた時点でフリーズしてしまいます。

Monaco Editorはどうかって?  
もちろんすぐに操作可能です！ スクロールもスムーズですよ:smile:


vue-monaco
----------

Vueに関するもので一番スターが多かったpackageです。

{{<summary "https://github.com/egoist/vue-monaco">}}

試してみたところ動きませんでした。  
エラーから推測するに以下の点で相性が悪かったのではないかと考えております。

* TypeScriptに対応していない
* Electronに対応していない (windowを使う前提になっている)


Vueコンポーネントを自作する
---------------------------

探しても今回の構成に合致するものは見当たらなかったため自分で作る事にしました。  
メンテナンスする気はないのでGitHubに公開する予定はありません。


### MonacoEditor.vue

ソースコードです。  
とりあえず動くレベルのものです。不具合の修正、足りないPropertyやEventの追加は適宜行って下さい。

```typescript
<template>
  <div id="container" class="editor" v-bind:style="{width: width, height: height}"></div>
</template>

<script lang="ts">
  import {Component, Prop, Vue} from "nuxt-property-decorator"
  import * as monaco from 'monaco-editor';
  import IStandaloneCodeEditor = monaco.editor.IStandaloneCodeEditor;

  @Component({
    watch: {
      value(newValue) {
        this.editor.getModel().setValue(newValue)
      }
    }
  })
  export default class extends Vue {
    @Prop() value: string
    @Prop() width: string
    @Prop() height: string
    editor: IStandaloneCodeEditor

    mounted() {
      const root = document.getElementById('container')
      if (root !== null) {
        this.editor = monaco.editor.create(root, {
          value: this.value,
        });
        const model = monaco.editor.createModel(this.value)
        this.editor.setModel(model)
      }
    }
  }
</script>
```

以下は使い方の一例です。  
dataは表示させたいデータです。

```html
<monaco-editor :value="data" height="75vh"/>
```

`@Component`への宣言とimportも忘れないで下さい。

```typescript
import MonacoEditor from "~/components/MonacoEditor";

@Component({
  components: {
    MonacoEditor,
  },
})
```

他必要な機能はMonaco Editorのドキュメントを参考にして追加してみましょう。


### monaco-editor-webpack-plugin

実は上記コードだけでは動きません。  
`import * as monaco from 'monaco-editor';`に失敗するからです。

以下のwebpackプラグインを使用する必要があります。

{{<summary "https://github.com/Microsoft/monaco-editor-webpack-plugin">}}

Nuxt.jsを使用しているので`nuxt.config.js`に設定を追加します。

```javascript
const webpack = require('webpack');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');

// ...

build: {
  vendor: ['monaco-editor'],
  extend(config, {isDev, isClient}) {
    config.plugins.push(
      new MonacoWebpackPlugin(webpack)
    )
    if (isClient) {
      config.target = 'electron-renderer'
    }
  }
},
// ...
```

1つのソースでしかimportしない場合、vendorへの指定は不要です。

#### プラグインがやっていること

以下のページを参考にしてください。  
Web Workerを使用するためのファイル分割などを行っています。

{{<summary "https://github.com/Microsoft/monaco-editor/blob/master/docs/integrate-esm.md">}}

余談ですが、このプラグインは以下PRの要望に応える形で数ヶ月前に作成されました。

{{<summary "https://github.com/Microsoft/monaco-editor/issues/18">}}

それまでMonaco EditorをESM importすることはできませんでしたが、この対応によりそれが可能になりました。  
対応してくださったalexandrudima氏に大いなる感謝を！


総括
----

Nuxt.js+TypeScriptの構成にMonaco Editorを取り入れてみました。

以前にAngularで同じような対応をしましたが、ESM importできるようになっていたため簡単に実現することができたと思います。  
参考までにAngularで対応したときのコードへのリンクも掲載しておきます。

{{<summary "https://github.com/tadashi-aikawa/miroir/blob/master/src/app/services/monaco-editor-loader.ts">}}

上記Loaderを使用しているコードは以下です。

{{<summary "https://github.com/tadashi-aikawa/miroir/blob/master/src/app/components/editor/editor.component.ts">}}



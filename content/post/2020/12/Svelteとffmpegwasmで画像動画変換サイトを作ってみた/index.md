---
title: Svelteとffmpeg.wasmでメディア変換サイトを作ってみた
slug: svelte-ffmpeg-wasm-site
date: 2020-12-27T19:52:32+09:00
thumbnailImage: images/cover/2020-12-27.jpg
categories:
  - engineering
tags:
  - svelte
  - ffmpeg
  - wasm
  - typescript
  - vercel
  - prettier
  - idea
  - slack
---

Svelteとffmpeg.wasmを使って、メディア変換SPAサイトを作ってみました。

<!--more-->

{{<cimg "2020-12-27.jpg">}}

<!--toc-->


はじめに
--------

本記事は作業履歴に近いスタンスの記事です。  
利用技術の解説は行いません。参考リンクをご覧ください。

### なぜSvelteなのか?

今まで使ったことがなく、価値のあるものを実際に作ってみたかったからです。  
ReactやVueと比べて優れていると思ったから..といった理由はありません。

Svelteを含む、以下3つの技術には記事執筆中にはじめて触れました。

* Svelte
* rollup
* Wasm (使う側)
* Vercel


作ったもの
----------

FLOWERという名前のメディア変換ツールです。  
画像や動画の変換をブラウザだけで完結させたかったので作りました。

{{<summary "https://flower.vercel.app/">}}

{{<mp4 "resources/2020-12-27.mp4">}}

UIも寂しく、今はgif変換機能しかありません。

他にも同様の素晴らしいツールは沢山ありますが、自分で作った方が安心です😉  
また、Svelte + ffmpeg.wasmの開発経験を積みたかったというのが目的ですし😄

リポジトリはコチラです。

{{<summary "https://github.com/tadashi-aikawa/flower">}}


プロジェクトの作成
------------------

Svelteの公式ページを参考にプロジェクトを作成します。

{{<summary "https://svelte.dev/">}}

テンプレートリポジトリのREADMEを参考にします。

{{<summary "https://github.com/sveltejs/template">}}

```
# テンプレートをcloneしてプロジェクト作成
npx degit sveltejs/template flower

# 中に移動
cd flower

# TypeScriptプロジェクトに変換
node scripts/setupTypeScript.js
```

### パッケージのインストール

```
npm i
```

### 動作確認

```
npm run dev
```

http://localhost:5000/ にアクセスすると画面が表示されます。


ffmpeg.wasmのインストール
-------------------------

公式ドキュメントを参考にインストールします。

{{<summary "https://ffmpegwasm.github.io/#installation">}}

```
npm i @ffmpeg/ffmpeg
```

### importできるようにする

デフォルトではrollupがjsonの読みこみに対応していないため以下のエラーが出ます。

```
[!] Error: Unexpected token (Note that you need @rollup/plugin-json to import JSON files)
node_modules\@ffmpeg\ffmpeg\package.json (2:9)
```

`@rollup/plugin-json`使います。

```
npm install @rollup/plugin-json --save-dev
```

`rollup.config.js`の設定を忘れずに。

{{<stackoverflow "Sapper/Svelte rollup/plugin-json giving error with stripejs" "https://stackoverflow.com/questions/59899928/sapper-svelte-rollup-plugin-json-giving-error-with-stripejs">}}


Prettierのインストール
----------------------

自分でフォーマットを整えるのは苦行でしかありませんので使いましょう。  
prettier-plugin-svelteを使います。

{{<summary "https://github.com/sveltejs/prettier-plugin-svelte#readme">}}

```
npm i --save-dev prettier-plugin-svelte prettier
```


ソースコードを書く
------------------

### App.svelte

Svelteファイルはテンプレートで作成された`App.svelte`だけです。

```html
<script lang="ts">
  import { convertToGif } from "./converter";
  import type { BinaryFile } from "./converter";

  let selected: File;
  let gifPromise: Promise<BinaryFile>;

  export const changeFile = async (e) => {
    selected = e.target.files[0];
  };
  export const handleClickGif = async () => {
    gifPromise = convertToGif(selected);
  };
</script>

<style>
  main {
    text-align: center;
    padding: 10px;
    max-width: 1200px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: bold;
  }
</style>

<main>
  <h1>Flower</h1>

  <div class="center">
    <div>
      <input
        type="file"
        id="uploader"
        on:change={changeFile}
        style="padding: 30px; width: 480px;" />
    </div>
    {#if selected}
      <div style="font-size: 3em;">↓</div>
      <div><button on:click={handleClickGif}>gifに変換</button></div>
      {#if gifPromise}
        {#await gifPromise}
          <div
            style="width: 640px; height: 480px; border: #666666 dashed 2px;"
            class="center">
            gifに変換中...
          </div>
        {:then gif}
          <div
            style="display: flex; gap: 30px; border: dimgrey dotted 1px; padding: 30px">
            <div>
              <img
                src={gif.url}
                alt="result"
                style="object-fit: contain; max-height: 480px;" />
            </div>
            <div style="padding: 30px;">
              <a href={gif.url} download={gif.name}>
                <button>ダウンロード ({(gif.size / 1024).toFixed()}kb)</button>
              </a>
            </div>
          </div>
        {:catch error}
          <div
            style="width: 640px; height: 480px; border: #666666 dashed 2px;"
            class="center">
            {error.message}
          </div>
        {/await}
      {/if}
    {/if}
  </div>
</main>
```

特筆すべくはなんといっても`<script>`タグに書かれたコードの短さでしょう。

これはSvelte HTMLの`#await`ブロックによる効果です。  
Promiseのresolveした結果を受け取ってから、ステータスやデータオブジェクトに詰め直し、それをUIで条件分岐する必要がないためです。

{{<summary "https://svelte.dev/tutorial/await-blocks">}}

アプリケーションが大きくなって、複数の非同期状態を考慮する場合はまた別です。  
Viewは非同期処理の結果をStoreから受け取って描画した方がいいかもしれません。

少なくとも、今回のような単純なアプリの場合は記述がシンプルになります。

### converter.ts

ffmpeg.wasmを使ったコンバート部分は別ファイルにしました。

```typescript
import { createFFmpeg, fetchFile } from "@ffmpeg/ffmpeg";
const ffmpeg = createFFmpeg({ log: true });
// 非同期処置のため完了前に操作されるとエラーになるが、人間にはほぼ無理なので考慮しない
ffmpeg.load();

export type BinaryFile = {
  name: string;
  size: number;
  url: string;
};

export async function convertToGif(
  file: File,
  outputFileName?: string
): Promise<BinaryFile> {
  const outputName =
    outputFileName ?? `${file.name.replace(/\.[^/.]+$/, "")}.gif`;

  ffmpeg.FS("writeFile", file.name, await fetchFile(file));
  await ffmpeg.run(
    "-i",
    file.name,
    "-filter_complex",
    "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse",
    outputName
  );
  const data = ffmpeg.FS("readFile", outputName);

  const blob = new Blob([data.buffer], {
    type: "image/gif",
  });

  return {
    name: outputName,
    size: blob.size,
    url: URL.createObjectURL(blob),
  };
}
```

入力パスのファイルをgifに変換しています。  
メインは`ffmpeg.run`で渡しているコマンドで、前後はStreamを使って必要な入力や出力に繋げているだけです。

今はgifだけですが、`ffmpeg.run`のコマンドと`blob.type`を変えれば他にも使えます。  
関数のインタフェースも変更しなくていいはずです。



Vercelでデプロイする
--------------------

Vercelの公式ガイドを参考にします。

{{<summary "https://vercel.com/guides/deploying-svelte-with-vercel">}}

..といっても、やることはほぼなかったです..。  
リポジトリを指定してポチポチしていったら30秒くらいでデプロイ終わりました。  
世の中楽になりすぎですね🙀

### Slackで通知する

Slack integrationがあったので使ってみます。

{{<summary "https://vercel.com/integrations/slack">}}

インストールするリポジトリと通知先channelを指定するだけです。  
こちらもよしなにやってくれちゃいます..あなたが神か!?



トラブルシューティング
----------------------

### [!] Error: 'XXX' is not exported by src\converter.ts, imported by src\App.svelte

Svelteはinterfaceをサポートしなくなったので、typeを使わなければいけません。

> As we're only transpiling, it's not possible to import types or interfaces into your svelte component without using the new TS 3.8 type import modifier: import type { SomeInterface } from './MyModule' otherwise bundlers will complain that the name is not exported by MyModule.

{{<github "Typescript - Limitations | sveltejs/svelte-preprocess" "https://github.com/sveltejs/svelte-preprocess/blob/main/docs/preprocessing.md#typescript---limitations">}}

#### NG

```typescript
export interface BinaryFile {
  name: string;
  size: number;
  url: string;
}
```

```typescript
import { BinaryFile } from "./converter";
```

#### OK

```
export type BinaryFile = {
  name: string;
  size: number;
  url: string;
};
```

```typescript
  import type { BinaryFile } from "./converter";
```

### JetBrains IDEで『wrong attribute value』

`disabled`に変数の値を指定するとエラーになりました。

```html
button disabled={!selected}>gifに変換</button>
```

IntelliJ IDEAで無効にする方法はなさそうです。

{{<summary "https://intellij-support.jetbrains.com/hc/en-us/community/posts/360008267020-Disable-inspection-wrong-attribute-value-">}}

エラーになるわけではないため、今はそのままにしておきます。


所感
----

私のSvelteに対する印象は以下の通りです。  
概ね期待以上でした😄

※ 実行速度については体感できませんでしたが..

### 良かったこと

* IntelliJ IDEAのプラグインでそれなりに補完されていた
* セットアップが簡単
* Vercelでデプロイも簡単
* 記載するコード量が少ない/直感的
* ビルド結果は`bundle.js`と`bundle.css`だけ

### 改善の余地がありそう

* IntelliJ IDEAのTypeScriptサポートがもう一歩
* エコシステム..特にUIフレームワークが発展途上


総括
----

Svelteとffmpeg.wasmを使ってメディアを変換するSPAサイトを作ってみました。

今年に入って『次の時代はSvelteが来るだろう..』と勝手に思いつつも今まで触ってこなかったため、新年を迎える前に実績解除できたよかったです😊

中規模以上のプロダクトに利用するにはまだ不安があります。  
ただ、今回のような小規模SPAであれば使えるレベルまで到達していると思っています。  
UIフレームワークの状況を見つつ、FLOWER開発を通してウォッチしていくつもりです。

また、当初予定していなかったVercelを習得できたのは幸運でした。  
その勢いで当ブログもVercel移行してしまいましたし😜

2021年..仕事ではVue/Nuxtを使いつつもSvelteを盛り上げていきたいですね。

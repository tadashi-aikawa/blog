---
title: 2020年8月5週 Weekly Report
slug: 2020-08-5w-weekly-report
date: 2020-09-01T07:20:53+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

もうすぐリリースされるVue3について、新しいRFCの理解を深めました。  
また、viteを使って実際に動作を確認しました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

なし。


学んだこと
----------

### 【TypeScript】Prettier 2.1

Prettier2.1がリリースされました。

{{<summary "https://prettier.io/blog/2020/08/24/2.1.0.html">}}

TypeScript4.0がサポートされています👏  
他にも`--embedded-language-formatting=off`を指定すると、埋め込みコードの自動フォーマットを無効にできるようになっています。


読んだこと/聴いたこと
---------------------

### ゲームUXから学ぶプロダクトデザインのコツ 

多くの人を熱狂させるゲームから学ぶことは多いなと思いました。

{{<summary "https://uxmilk.jp/89776">}}

> UXデザイナーたちは、プロダクトはできる限り使いやすくデザインするべきだと考えています。ただし、ユーザーに若干の難解さを提供することで、実際のエンゲージメントは向上するのです。

とても親切で説明的なインタフェースのツールに愛着を感じないのはこの辺があるのかも..

> 一般的にUXデザインのベストプラクティスは、エンゲージメントのフローがユーザーに過剰な通知を送信することでオーバーなループにしないようにすることです。現在、ほとんどのソーシャルネットワークでは、関連する通知をグループ化することでこれを回避しています。

通知をグルーピング化することの重要性を知りました。

> もっとも魅力的なゲームは、本質的にやる気を起こさせるタスクを完了することで、プレイヤーに報酬を与えるゲームだと言えるでしょう（たとえば、プレイヤーへのごほうびとしてのコイン、ツール、武器、アップグレードなど、ゲーム内で利用できる報酬）。これらの報酬は、プレイヤーがナチュラルに完了を目指すことを楽しむタスクだと言えるでしょう

タスク管理や時間管理ツール、社内ツールにも報酬を入れようとしたけど上手くできたことがなかったです。  
というのもそれらのツールは、それ自体が生み出す時間や価値が報酬である気がしてなりません。

### 【Vue】まちにまった Vue.js 3

Vue3についての最新情報が分かりやすく紹介されています。

{{<summary "https://speakerdeck.com/kazupon/matinimatuta-vue-dot-js-3">}}

いくつか気になった点をピックアップ。

#### script setup

`<script>`ではなく`<script setup>`とすることで、Svelteみたいな書き方ができます。

```vue
<template>
  <button @click="inc">{{ count }}</button>
</template>

<script setup>
import { ref } from 'vue'

export const count = ref(0)
export const inc = () => count.value++
</script>
```

Svelteの存在は気になっていたものの、書き方の違いによる学習コストが気になっていました。  
React同様、VueがSvelteの記述に寄るなら1粒で3回美味しい😋

{{<summary "https://github.com/vuejs/rfcs/blob/sfc-improvements/active-rfcs/0000-sfc-script-setup.md">}}

なお、`Component Import Sugar`は様々な壁があるため一旦RFCからドロップされたようです。

{{<summary "https://github.com/vuejs/rfcs/pull/182#issuecomment-680290667">}}

その代わり、default exportが使えるようになるのでシンプルになるとのこと。

```vue
<script setup>
export { default as Foo } from './Foo.vue'
export { default as Bar } from './Bar.vue'
export const ok = Math.random()
</script>

<template>
  <Foo/>
  <Bar/>
  <component :is="ok ? Foo : Bar"/>
</template>
```

{{<github "Exposing Components" "https://github.com/vuejs/rfcs/blob/sfc-improvements/active-rfcs/0000-sfc-script-setup.md#exposing-components">}}

`setup="props"`を指定して、`props`をdeclareすることでTypeScriptの型推論が効くようです。

```vue
<script setup="props" lang="ts">
import { computed } from 'vue'

// declare props using TypeScript syntax
// this will be auto compiled into runtime equivalent!
declare const props: {
  msg: string
}

export const computedMsg = computed(() => props.msg + '!!!')
</script>
```

{{<github "With TypeScript" "https://github.com/vuejs/rfcs/blob/sfc-improvements/active-rfcs/0000-sfc-script-setup.md#with-typescript">}}

#### vue-composition-apiがproduction非推奨でなくなった

これは非常に嬉しいニュースでした😄  
UIライブラリのv3対応状況から、年内はVue2を使う機会が増えそうだったため。

### 【Rust】Rustのプロジェクトを始める前に知っておきたかったこと

Rustは機能や概念が多いので、全てを学んでから開発をするには腰が重すぎます。  
一方で最低限知っておいた良いこともあり.. その点がまとめられた記事。

{{<summary "https://qiita.com/maeda_/items/d765d514e7c72778f29f">}}

以下のポイントが参考になりました。

* 実行時まで具体的な型が分からない場合は`dyn`キーワードがつく
* heapでメモリ確保する場合は`Box<T>`を使う
* 参照 or 実体をもつ型は`Cow<'a B>`を使う

少しずつ『見たことある』と言えることを増やしていきたいと思ってます。

### そのリクエストパラメータ、クエリストリングに入れますか、それともボディに入れますか

API設計で非常に大事な基礎が紹介されています。  
パスとクエリの使い分けは非常に参考になると思います。

{{<summary "https://qiita.com/sakuraya/items/6f1030279a747bcce648">}}

最近では機会が減りましたが、一時期は仕事で巨大なAPI開発をしていました。  
その時の経験も踏まえて共感できたのが以下のフレーズ。

> 一番避けるべきは GET で削除機能を実現することです。
> Googleなどのクローラーがリンクをたどってコンテンンツを削除していく話は有名です。
> 読み取り専用であるGETは 安全な メソッドとして位置づけられています。

GETを使った追加/変更/削除..古いシステムなら目にする機会は多いと思います。  
うっかりブラウザでアクセスしてしまったときに..こんな顔になりますね🙁

### 【Vue】負債を返却しながら機能追加しなければならない状況で実践したフロントエンドのコンポーネント設計

フロントエンドのベースとなる重要な設計について紹介されています。

{{<summary "https://engineer.crowdworks.jp/entry/2020/08/26/170745">}}

ContainerとPresentationの違いは色々な考え方があると思います。  
私の場合は以下のような用語で区別しています。

| 名前      | Storeとの結びつき | UI   | Props        | Callback     |
| --------- | ----------------- | ---- | ------------ | ------------ |
| Container | State/Action      | あり | あってもよい | あってもよい |
| Component | なし              | あり | あり         | あってもよい |

ContainerにUIを許容している点が一般的な考え方と異なります。  
これは、そこを切り分けるメリットよりコストの方が大きいと思っているからです。

> Molecules: 独立して存在できるコンポーネントではなく、他のコンポーネントの機能を助けるヘルパーとしての存在意義が高いコンポーネント
> Organisms: 独立して存在できるスタンドアローンなコンポーネント

MoleculesとOrganismsの違いが曖昧だったので、なるほどと思いました。  
Vueのベストプラクティスで紹介されていた構成と異なるため躊躇していましたが、そろそろUI周りのpackage構成をAtomicデザインベースのものにしたいと改めて思いました。

### 【デスク環境】漫画家の作業環境とデスク周り

マンガ家の作業環境をインタビュー形式で紹介していく動画。  
デスクを分けて、作業用と思考用に使い分けるのはなるほどと思いました。

{{<youtube "0cY1QaRTWM8">}}


試したこと
----------

### 【Vue】Viteで最新のVue RFCを試す

先のセクションで話題に上がった新しいRFCについて、Viteで実際に試してみました。

{{<summary "https://github.com/vitejs/vite">}}

```
npm init vite-app vite-sample
cd vite-sample
npm install
npm run dev
```

構成はこんな感じです。

```
  .\vite-sample/src
├── ﵂  App.vue
├──   assets
│  └──   logo.png
├──   components
│  └── ﵂  Repository.vue
├──   index.css
└──   main.js
```

{{<file "App.vue">}}
```vue
<template>
  <div>
    <div style="display: flex; flex-wrap: wrap;">
      <repository
        :key="repo.id"
        v-for="repo in state.repositories"
        :name="repo.name"
        style="margin: 5px;"
      />
    </div>
    <div>
      <button @click="search">検索する</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from "vue";

export { default as repository } from "./components/Repository.vue";

export interface Repository {
  id: number;
  name: string;
}
type ReposResponse = Repository[];

const URL = "https://api.github.com/users/tadashi-aikawa/repos";

async function fetchRepositories(): Promise<ReposResponse> {
  return fetch(URL).then((r) => r.json());
}

export const state = reactive({
  repositories: [],
});

export const search = () =>
  fetchRepositories().then(async (items) => {
    state.repositories = items;
  });
</script>
```
{{</file>}}


{{<file "Respository.vue">}}
```vue
<template>
  <div class="card">{{ name }}</div>
</template>

<script setup="props" lang="ts">
import { ref, reactive, computed } from "vue";
import { Repository } from "../App.vue";

declare const props: {
  id?: number;
  name: string;
};

export const name = computed(() => props.name);
</script>

<style scoped>
.card {
  width: 200px;
  padding: 10px;
  background-color: antiquewhite;
  border: double 5px orange;
}
</style>
```
{{</file>}}

scriptタグにそのまま書けるのが超COOL😆


調べたこと
----------

なし


整備したこと
------------

### 【Windows Terminal】v1.2にアップデート

Windows Terminalのバージョンを1.2にアップデートしました。  
コマンドパレットが使えるようになったため、ショートカットキーを割り当てました。

```
    { "command": "commandPalette", "keys": "ctrl+shift+p" },
```



今週のリリース
--------------


### Togowl v2.14.0

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### エントリセレクタの表示順を『選択された回数が多い順』に変更

エントリセレクタにサジェストされる過去エントリを、エントリセレクタで選択された回数が多い順に変更しました。

{{<himg "resources/57d67b48.png">}}

以前は直近2週間で実行されたエントリの回数順でしたが、タスクリストから開始したエントリがエントリセレクタから選択されるケースが少なかったため変更しました。  
予定されたタスクと突発的なタスクの頻度は相関関係になかったという気づきです。


その他
------

今週後半から創の軌跡プレイが始まりました。  
既に20数時間とられています..しばらく本業の更新が鈍りそう..😅

{{<summary "https://www.falcom.co.jp/hajimari/">}}

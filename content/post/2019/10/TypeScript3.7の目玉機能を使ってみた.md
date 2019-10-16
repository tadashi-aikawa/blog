---
title: TypeScript3.7の目玉機能を使ってみた
slug: use-typescript3.7-great
date: 2019-10-16T21:29:45+09:00
thumbnailImage: https://cdn.svgporn.com/logos/typescript-icon.svg
categories:
  - engineering
tags:
  - typescript
---

TypeScript3.7のベータ版を試してみました。

<!--more-->

<img src="https://cdn.svgporn.com/logos/typescript-icon.svg"/>

<!--toc-->


はじめに
--------

TypeScript3.7のベータ版がリリースされたので試してみました。

基本的に以下の記事から、気になる機能を自分が書いたコードで試してみただけです。  
詳しい説明は本家のページをご覧下さい。

{{<summary "https://devblogs.microsoft.com/typescript/announcing-typescript-3-7-beta/">}}



プロジェクト準備
----------------

動作確認用のプロジェクトを準備します。  
適当なディレクトリを作成してその中に移動し、以下コマンドを実行します。

```bash
npm init -y
npm i typescript@beta ts-node
npx tsc --init
```

`main.ts`に1行書いて`npx ts-node main.ts`で実行できることを確認します。


Optional Chaining
-----------------

なんといっても一番注目すべき機能はこれでしょう！  
これで不要な三項演算子や`&&`チェーンの日々から解放されます。

以下のようなHumanクラスとそのインスタンスtaro,jiro,hanakoを作成します。  
hanakoはjiroが好き、jiroはtaroが好き、taroは誰も好きではありません。

```ts
interface Human {
  id: number;
  name: string;
  favorite?: Human;
}

const taro: Human = {
  id: 1,
  name: "taro"
};

const jiro: Human = {
  id: 2,
  name: "jiro",
  favorite: taro
};

const hanako: Human = {
  id: 3,
  name: "hanako",
  favorite: jiro
};
```

以下の要件を満たすコードを書いてみます。

* hanakoとjiroが好きな人の好きな人の名前を取得したい
* いない場合はundefined

### Optional Chainingなし (TypeScript3.6以前)

こんな感じに書いていました..。つらい。

```ts
// hanakoが好きな人の好きな人の名前を取得
console.log(hanako.favorite && hanako.favorite.favorite && hanako.favorite.favorite.name)
// -> taro

// jiroが好きな人の好きな人の名前を取得
console.log(jiro.favorite && jiro.favorite.favorite && jiro.favorite.favorite.name)
// -> undefined
```


### Optional Chainingあり (TypeScript3.7以降)

必要最低限の記述です！

```ts
// hanakoが好きな人の好きな人の名前を取得
console.log(hanako.favorite?.favorite?.name)
// -> taro

// jiroが好きな人の好きな人の名前を取得
console.log(jiro.favorite?.favorite?.name)
// -> undefined
```

しかも、VSCodeだと`?`が自動補完されます。これも凄い！

{{<himg "https://dl.dropboxusercontent.com/s/xcp80eq4k1mhcqq/20191016_2.gif">}}

`array?.[0]`や`handler?.()`みたいにArrayやFunctionにも使えます。  
`?.`が間に挟まると存在する場合だけ後続の処理に続く..という理解で概ねOKだと思います。

{{<warn "VSCodeが3.7の構文を解釈しない">}}
VSCodeが使用するTypeScriptのバージョンが`ワークスペースのバージョン`になっているか確認してください。  
デフォルトではグローバルにインストールされたバージョンが使用されます。

フッタに表示されるバージョンを見てください。

{{<himg "https://dl.dropboxusercontent.com/s/f8axc8j0k5zdk55/20191016_3.png">}}

クリックすると変更できます。

{{</warn>}}


Nullish Coalescing
------------------

`&&`の代わりに`??`を使うことでFalsyな値が正しく判定されます。  
`0`や`空文字`の場合を考える心配がなくなります。

### Nullish Coalescingなし (TypeScript3.6以前)

```ts
console.log(undefined || "値がないんじゃあああ!!!")
// -> 値がないんじゃあああ!!!
console.log(null || "値がないんじゃあああ!!!")
// -> 値がないんじゃあああ!!!
console.log({} || "値がないんじゃあああ!!!")
// -> {}
console.log([] || "値がないんじゃあああ!!!")
// -> []
console.log(0 || "値がないんじゃあああ!!!")
// -> 値がないんじゃあああ!!!
console.log("" || "値がないんじゃあああ!!!")
// -> 値がないんじゃあああ!!!
```

### Nullish Coalescingあり (TypeScript3.7以降)

```ts
console.log(undefined ?? "値がないんじゃあああ!!!")
// -> 値がないんじゃあああ!!!
console.log(null ?? "値がないんじゃあああ!!!")
// -> 値がないんじゃあああ!!!
console.log({} ?? "値がないんじゃあああ!!!")
// -> {}
console.log([] ?? "値がないんじゃあああ!!!")
// -> []
console.log(0 ?? "値がないんじゃあああ!!!")
// -> 0
console.log("" ?? "値がないんじゃあああ!!!")
// -> 
```

`{}`と`[]`はどちらもTrue判定されるので要注意。PythonだとFalseになる。

`Nullish Coalescing`は`Optional Chaining`との相性が抜群ですね😄

```ts
// jiroが好きな人のID

console.log(jiro.favorite?.id || "該当なし")
// -> 該当なし
console.log(jiro.favorite?.id ?? "該当なし")
// -> 0
```


総括
----

TypeScript3.7のベータ版の機能として、`Nullish Coalescing`と`Optional Chaining`を実際に試してみました。

この2機能を使うために、プロダクトのTypeScriptを3.7ベータにupgradeした方がよいレベルの素晴らしさです。  
事実、コメント欄にも『これはTypeScript4.0でしょ！』という意見が出ていました😘

その他にも`Recursive Type Aliases`や`Uncalled Function Checks`も気になっています。  
安定版リリースは11月を予定しているようです。楽しみですね！👍

{{<summary "https://github.com/Microsoft/TypeScript/wiki/Roadmap#37-november-2019">}}


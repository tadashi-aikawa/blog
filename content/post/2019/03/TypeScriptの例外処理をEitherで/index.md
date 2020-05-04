---
title: TypeScriptの例外処理をEitherで
slug: typescript-exception-with-either
date: 2019-03-26T20:33:38+09:00
thumbnailImage: images/cover/2019-03-26.jpg
categories:
  - engineering
tags:
  - typescript
---

TypeScriptの例外処理をEitherでスマートに記述する方法を紹介します。

<!--more-->

{{<cimg "2019-03-26.jpg">}}

<!--toc-->


はじめに
--------

TypeScriptにはEither型がありません。  
通常は[Union Types]を使って`Result | Error`のような表現をします。

[Union Types]: https://www.typescriptlang.org/docs/handbook/advanced-types.html#union-types

一方、関数型言語では同じことを表すのにEither型を使うことが多いです。  
Eitherは文脈を持つコードを書けるので、上手く使えばスマートになります。


お題
----

今回はお題として以下の要件を満たすコードを書き比べてみます。

* 3つのファイルを読み込んで、中身を結合し標準出力に出力する
* 読み込みに失敗したファイルは標準エラー出力にエラーメッセージとファイル名を出力する


### 構成

以下3つのファイルを用意します。

{{<file "a.txt">}}
a
a
a
{{</file>}}

{{<file "b.txt">}}
b
b
{{</file>}}

{{<file "c.txt">}}
c
{{</file>}}


TypeScriptの`compilerOptions.target`は`es2015`にしました。


### 期待値

例えば`a.txt`と`c.txt`の読みこみに成功、`bb.txt`の読みこみに失敗した場合、出力は以下を期待します。

```
a
a
a
ファイルの読みこみに失敗しました (./bb.txt)
c

```

{{<alert "info">}}
標準エラー出力の出力タイミングは同期しないので、出力場所は多少前後します
{{</alert>}}


Union Typesを使うケース
-----------------------

まずは[Union Types]を使うケースから紹介します。

様々な書き方があると思いますが、例えば以下の様に書けます。

{{<file "main.ts">}}
```ts
import { promises } from "fs";

const PATHS = [
    "./a.txt",
    "./bb.txt",
    "./c.txt",
]

const isError = (item: any): item is Error => item instanceof Error

const load = async (path: string): Promise<string | Error> =>
    await promises.readFile(path)
        .then(String)
        .catch(e => new Error(`ファイルの読みこみに失敗しました (${path})`))

async function main() {
    const results = await Promise.all(PATHS.map(load))
    results.map(x => isError(x) ?
        console.error(x.message) :
        console.log(x)
    )
}

main()
```
{{</file>}}

{{<warn "ExperimentalWarning: The fs.promises API is experimental">}}
`fs.promises`は試験的なAPIであるため表示される警告です。  
いきなり仕様が変わる点を許容出来れば大きな問題にはならないと思います。
{{</warn>}}



Eitherを使うケース
------------------

次にEitherを使うケースです。  
冒頭の通り、TypeScriptにEitherは無いのでfp-tsを使用します。

{{<summary "https://github.com/gcanti/fp-ts">}}

fp-tsはEitherに限らず、関数型の記載をするために必要な様々な機能が用意されています。

fp-tsのEitherを使うと先ほどのコードは以下の様に書けます。

{{<file "main.ts">}}
```ts
import { TaskEither, tryCatch } from "fp-ts/lib/TaskEither";
import { promises } from "fs";

const PATHS = [
    "./a.txt",
    "./bb.txt",
    "./c.txt",
]

const load = (path: string): TaskEither<Error, string> =>
    tryCatch(
        () => promises.readFile(path).then(String),
        e => new Error(`ファイルの読みこみに失敗しました (${path})`)
    )

async function main() {
    const results = await Promise.all(PATHS.map(x => load(x).run()))
    results.map(x => x.fold(
        e => console.error(e.message),
        console.log
    ))
}

main()
```
{{</file>}}


比較
----

今回の例による違いは、Eitherは[Type Guards]を使うためにErrorを定義する必要がないことだと思います。  
とはいえ`isError`を定義するだけなので全く手間にはなりません。

一方で受け取った結果を、同様に文脈を考慮して変換し続ける場合はEitherの方が優れていると考えています。  
なぜなら、fp-tsは関数型言語で便利な実装をする機能を沢山持っているからです。

[Type Guards]: https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-guards-and-differentiating-types


総括
----

TypeScriptの例外処理について、普通の書き方とEitherを使った書き方を紹介しました。

筆者の関数型言語力が不足しているため、Eitherのメリットを見いだすことはあまりできませんでした🙇  
もう一度、すごいH本を読んで修行してきます。

<a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F11709735%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fbook%2Fi%2F15889490%2F&link_type=pict&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0Iiwic2l6ZSI6IjQwMHg0MDAiLCJuYW0iOjEsIm5hbXAiOiJyaWdodCIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjEsImJidG4iOjF9" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=15889490&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F8850%2F9784274068850.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F8850%2F9784274068850.jpg%3F_ex%3D400x400&s=400x400&t=pict" border="0" style="margin:2px" alt="" title=""></a>

その際に新しい気づきがあったら、また記事にしていきたいと思います。

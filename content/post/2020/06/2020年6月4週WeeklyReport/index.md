---
title: 2020年6月4週 Weekly Report
slug: 2020-06-4w-weekly-report
date: 2020-06-28T12:46:20+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

ViteとTypeScript4.0のVariadic tuples、そしてRustの開発環境整備など。  
あと、見出しの構成を変えました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


見たこと/読んだこと
-------------------

### 【翻訳】技術的負債という概念の生みの親 Ward Cunningham 自身による説明

t-wadaさんの翻訳記事+所感。

{{<summary "https://t-wada.hatenablog.jp/entry/ward-explains-debt-metaphor">}}

以下は新しい発見でした。

* Ward Cunningham氏は技術的負債とは言ってない. **負債**である.
* 負債はドメイン知識に関するもの
    * 雑な設計を負債とは呼んでいない
* 最初から設計/実装をしっかりやることはむしろMust
    * そうしないと負債を返済できなくなる

完全同意です☺️

### ドラゴン桜2 10巻

ドラゴン桜は1からすべて読んでいます。  
教える側、学習する側のそれぞれについて新しい気づきを与えてくれます。

最近発売された10巻を読みました。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:504px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:240px"><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F6e47fcd725f1d2b512cf00a70083b2d7%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=20027931&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F5246%2F9784065195246.jpg%3F_ex%3D240x240&s=240x240&t=picttext" border="0" style="margin:2px" alt="" title=""></a></td><td style="vertical-align:top;width:248px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F6e47fcd725f1d2b512cf00a70083b2d7%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  >ドラゴン桜2（10） （モーニング　KC） [ 三田 紀房 ]</a></p><div style="margin:10px;"><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F6e47fcd725f1d2b512cf00a70083b2d7%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:0"></a><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F6e47fcd725f1d2b512cf00a70083b2d7%2F%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ==" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><div style="float:right;width:41%;height:27px;background-color:#bf0000;color:#fff !important;font-size:12px;font-weight:500;line-height:27px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td></tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

習慣化を促すには『仕組みを利用すること』が大切というフレーズが心に残りました。  
具体的なソリューションとしてはみんチャレが紹介されていました。

{{<summary "https://minchalle.com/">}}

『人は同じ属性/目的を持つ人と行動した方が習慣化しやすい』そうです。


試したこと
----------

### Vite

ViteはVue.jsの作者Evan Youさんがメインで開発しているビルドツールです。  
1.0.0-betaのフェーズに差し掛かっていたので試してみました。

{{<summary "https://github.com/vitejs/vite">}}

READMEに書かれている通りに実行したら、開発サーバが立ち上がりました。

```
npm init vite-app vite-use
cd vite-use
npm i
npm run dev
```

`package.json`の依存関係のシンプル。

```
  "dependencies": {
    "vue": "^3.0.0-beta.15"
  },
  "devDependencies": {
    "vite": "^1.0.0-beta.3",
    "@vue/compiler-sfc": "^3.0.0-beta.15"
  }
```

TypeScriptとSassを入れてみました。

```
npm i -D typescript sass
```

特別なことをしなくてもそのまま動きます。すごい！  
試しに作ったサンプルです。

```
 src
├──  App.vue
├──  assets
│  └──  logo.png
├──  components
│  └──  HelloWorld.vue
├──  index.css
├──  main.js
└──  util.ts
```

{{<file "App.vue">}}
```vue
<template>
  <img alt="Vue logo" src="./assets/logo.png" />
  <HelloWorld title="サンプルコード"/>
</template>

<script lang="ts">
import HelloWorld from './components/HelloWorld.vue'
import { defineComponent } from 'vue'

export default defineComponent({
  components: {
    HelloWorld
  }
})
</script>
```
{{</file>}}

{{<file "util.ts">}}
export const plusOne = (x: number): number => x + 1
{{</file>}}

{{<file "components/HelloWorld.vue">}}
```vue
<template>
  <h1>{{ title }}</h1>
  <p>Count: {{ count }}</p>
  <button @click="increment">カウントを増やす</button>
  <p><code>components/HelloWorld.vue</code> を変更するとホットリロードされます</p>
</template>

<script lang="ts">
import { plusOne } from "../util"
import { defineComponent, reactive, computed } from 'vue'

export default defineComponent({
  props: {
    title: { type: String, required: true }
  },
  setup() {
    const state = reactive({
      _count: 0,
    })

    function increment() {
      state._count++
    }

    return {
      count: computed(() => plusOne(state._count)),
      increment,
    }
  }
})
</script>

<style lang="scss">
p {
  code {
    color: red;
  }
}
</style>
```
{{</file>}}

#### 所感

TypeScriptやSassなどの拡張も含め、npm installするだけで使えのが素晴らしいですね。  
この辺のメンテナンスは面倒なので、そこをViteが担保してくれるのはアツイです..。

esbuildの速さはサンプルプロジェクトレベルだと実感できませんでした。  
tscより20～30倍速いと言われているので期待してます😊

### 【TypeScript】Variadic tuples

TypeScript4.0の目玉と呼ばれている機能が紹介されています。  
まだ仕様が変わるかもしれないので要注意とのこと。

{{<summary "https://fettblog.eu/variadic-tuple-types-preview/">}}

試してみました。

```
npm i -D typescript@next
```

主な特徴です。

* 末尾だけでなく先頭や途中を可変にできる
* 複数回登場させられる

シンプルな使い方の一例。

```typescript
type Foo<T extends unknown[]> = [string, ...T, number];
type T1 = Foo<[number, number]>;  // [string, number, number, number]
```

ここでは、元記事で途中にある`InferCallbackResults<T>`のみ詳しく説明します。

```typescript
type InferCallbackResults<T> = 
  T extends (... t: [...infer Arg, (res: infer Res) => any]) => any ? 
    Res : never
```

`InferCallbackResults<T>`は、最後の引数がcallback関数である関数の型をTにとりcallback関数の引数型を返却する型です。  
文字にすると意味が分からないと思うので、具体例を出します。

```typescript
// 最後の引数として指定されたcallbackの引数型を返却
type InferCallbackResults<T> = 
  T extends (... t: [...infer Arg, (res: infer Res) => any]) => any ? 
    Res : never

// InferCallbackResults<T>のTに指定する関数型
// 引数2つ + 最後にcallback関数
type ExampleFunc = (a: number, b: number, func: (answer: string) => number) => void;

// 期待値はstring. (answer: string) => number の answerに該当する型だから
declare const r: InferCallbackResults<ExampleFunc>;

// 型を確かめるための関数
function checkType<T>(a: T) {}

// rがstring型であることを確認する
checkType<string>(r)
// -> OK
```

`InferCallbackResults<T>`がなぜ最後の引数で指定されたcallback関数の引数型を返却するのかを見ていきましょう。


#### Type inference in conditional types

この辺で以前説明しています。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/2.8/#type-inference-in-conditional-types">}}

inferはキャプチャしたい型の直前につけます。  
なので、実質意味合いは以下のようになります。(コードとしては不正)

```
type InferCallbackResults<T> = 
  T が (... t: [...Arg, (res: Res) => any]) => any に割り当て可能なら Res そうでなければ never
```

#### 汎用関数型

全ての関数型は`(...arg: any[]) => any`と表現できます。  
これを先ほどの`(... t: [...Arg, (res: Res) => any]) => any`に割り当てると関係は以下になります。

| No  | 汎用表現  | 今回の表現                      |
| --- | --------- | ------------------------------- |
| ❶  | `(...arg` | `(...t`                         |
| ❷  | `: any[]` | `: [...Arg, (res: Res) => any]` |
| ❸  | `)=> any` | `)=> any`                       |

実質の違いは❷だけです。  
❷は引数表現であり、最後が`(res: Res) => any`で終わるという制約がついています。  

```
type InferCallbackResults<T> = 
  T が 引数の最後に (res: Res) => any 型の関数を持つなら Res そうでなければ never
```

よって`InferCallbackResults<T>`は最後の引数で指定されたcallback関数の引数型を返却することが分かります。

### 【Rust】疑問符演算子

以下のようなことを社内Rust勉強会で学びました。

{{<summary "https://cat-in-136.github.io/2018/04/rust-error-handling-question.html">}}

`?`が`unwrap()`と`return Err(Err)`を兼ね備えているのは本当に凄い！ 感動しました😍

```rust
let hoge = load_hoge()?;
return do_anything(hoge)
```

同じことを[owlelia]を使ってTypeScriptで書くと以下のいずれかになります。

`Goライクな書き方`
```typescript
const hogeOrErr = await loadHoge();
if (hogeOrErr.isLeft()) {
  return left(hogeOrErr.error);
}

return right(doAnything(hogeOrErr.value));
```

`関数型な書き方`
```typescript
const hogeOrErr = await loadHoge();
return hogeOrErr.mapRight(doAnything)
```

### 【Python】Loguru

Pythonのロギングライブラリ、Loguruを試してみました。

{{<summary "https://github.com/Delgan/loguru">}}

標準モジュールより設定が簡単で気軽に使えます。


調べたこと
----------

### WindowsのMakeをcmdで実行させる方法

Windowsで`sh.exe`にパスが通っていると、GNU Makeはそちらを優先するようです。

{{<summary "https://qiita.com/EmEpsilon/items/c1a0b5e60edfe71cb38a">}}

これではcmdを前提に作成したMakefileが、実行者の環境によって動かなくなってしまいます。  
MakefileでSHELLにcmdを指定することで解決しました。

```
SHELL=cmd
```

### 【TypeScript】Cannot find module 'tslib'

Owleliaの動作確認しようと思ったら見慣れぬエラーが発生しました。

単にtslibが依存関係に含まれていなかっただけです。  
大抵の場合、フレームワークなどの依存関係にtslibが含まれているため、今まで問題にならなかっただけでした..。

Owleliaの依存関係にtslibを追加して解決しました。

この問題は`--importHelpers`オプションが有効の場合のみ発生します。  
有効にしていなければ`tslib`は使用されず、トランスパイルされたjsファイルに直接埋め込まれるため。

### 【Jest】実行が遅い場合の対処法

`--maxWorkers=1`を指定すると速くなります。  
デフォルト値は3ですが、Workerの準備に時間がかかって遅くなっているとか..🤔

{{<github "https://github.com/kulshekhar/ts-jest/issues/259">}}
{{<github "https://github.com/kulshekhar/ts-jest/issues/259#issuecomment-504088010">}}
{{<github "https://github.com/facebook/jest/issues/8202">}}


整備したこと
------------

### 【Rust】IntelliJ IDEAでの開発環境整備

#### プロジェクト作成

* Windows
* rust-upがインストール済み

cargoでプロジェクトを作成して実行します。

```
$ cargo new cargo-use
$ cd cargo-use
$ cargo run
   Compiling cargo-use v0.1.0 (C:\Users\syoum\work\sandbox\rust\cargo-use)
    Finished dev [unoptimized + debuginfo] target(s) in 1.38s
     Running `target\debug\cargo-use.exe`
Hello, world!
```

#### IDEAで動かす

プラグインとしてIntelliJ Rustが必要です。

{{<summary "https://intellij-rust.github.io/">}}

作成したプロジェクトを読み込んでから、`main.rs`で実行します。

{{<himg "resources/2c2cc469.jpeg">}}

以前cargoを使わずにRustコードを読み込んだ時は、補完が効きませんでしたがCargoで作成したプロジェクトでは問題なく動きました。  
型推論やQuick Fixも問題なかったです。

せっかくなので`Cargo.toml`を`Cargo2.toml`としてコピーするコードを書いてみました。

```rust
use std::fs::{read_to_string, File};
use std::io::Write;

fn load_file(path: &str) -> std::io::Result<String> {
    read_to_string(path)
}

fn save_file(path: &str, contents: &str) -> std::io::Result<usize> {
    File::create(path)?.write(contents.as_ref())
}

fn main() -> std::io::Result<()> {
    let contents = load_file("Cargo.toml")?;

    match save_file("Cargo2.toml", &contents) {
        Ok(size) => eprintln!("Write size: {:?}", size),
        Err(err) => eprintln!("Error: {:?}", err)
    };

    Ok(())
}
```

#### Formatterの設定

rustfmtを使います。  
rustupでインストール時に同梱されているはず。

{{<summary "https://github.com/rust-lang/rustfmt">}}

IDEAでは以下のように設定します。

{{<himg "resources/b6fa72c7.jpeg">}}

ファイル保存時に自動でフォーマットされます👍

#### Linterの設定

rust-clippyを使います。  
rustupでインストール時に同梱されているはず。

{{<summary "https://github.com/rust-lang/rust-clippy">}}

IDEAでは以下のように設定します。

{{<himg "resources/b464e979.jpeg">}}

ファイル変更時に今まで出なかった警告が出るようになります。  
Result周りや所有権などですね👍😄

### HHKBの有線化

家で使用している`Happy Hacking Keyboard Professional HYBRID Type-S`を無線接続から優先接続に切り替えました。

{{<summary "https://www.pfu.fujitsu.com/direct/hhkb/detail_pd-kb820bs.html">}}

キーのつっかえや入力順の入れ替わりが頻繁にあったので調べたところ、Bluetoothの信号伝搬による問題であることが分かったからです。  
有線と無線それぞれについて、Vimで`h`と`l`を交互に連打したときの挙動の違いで検証しました。

PCからはスピーカーにBluetoothを使っているので、それが干渉したせいかもしれません..。  
ケーブルレスの佇まいが気に入っていたので残念ですが、こればかりは仕方ないかなと..😅

なお、会社ではBluetoothと有線の違いはありませんでした。  
やはり環境が大きく影響するようですね。

今週のリリース
--------------

### Owlelia v0.10.0

OwleliaはTypeScriptでDDD実装を補助するUtilityです。

{{<summary "https://github.com/tadashi-aikawa/owlelia">}}

2020-06-24現在では以下のような機能を提供しています。

* Value Object
* Entity
* Either
* Error

#### Either.orNull

leftの場合に`null`を返却します。  
既に実装済みである`Either.orUndefined`のnull版です。

```typescript
import { left } from "owlelia";

left("hoge").orNull()
// -> null
```

#### Either.biMap

leftとrightそれぞれについて、functorを指定して変換します。

```typescript
import { Either, left, right } from "owlelia";

const createEither = (num: number): Either<string, number> =>
  num > 0 ? right(num) : left("invalid error");

createEither(10).biMap(
  (err) => `${err} です`,
  (val) => val * 100
)
// -> Right { value: 1000, _type: 'right' }

createEither(-10).biMap(
  (err) => `${err} です`,
  (val) => val * 100
)
// -> Left { error: 'invalid error です', _type: 'left' }
```

### Togowl v1.14.0

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

新機能は2つです。その他はレイアウト修正やリファクタリングです。

#### カレンダーを単独メニューに切り出し

今までTop画面のタブにあったカレンダーを単独メニューに切り出しました。  
頻繁に計測画面と切り替えることがないため、画面の広さを活かすようにしています。

{{<himg "resources/21de5350.jpeg">}}

#### デジタルクロック

タスク未計測時、計測履歴カードの代わりにデジタルクロックを表示するようにしました。

{{<himg "resources/b996ba0e.jpeg">}}

その他
------

### 創の軌跡ムービー

創の軌跡発売日まで2ヶ月を切りました。  
今回公開されたデモムービーは3分以上あり、テンションも上がってきています😆

{{<summary "https://www.4gamer.net/games/490/G049043/20200626004/">}}


[owlelia]: https://github.com/tadashi-aikawa/owlelia

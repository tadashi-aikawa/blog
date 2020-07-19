---
title: 2020年7月1週 Weekly Report
slug: 2020-07-1w-weekly-report
date: 2020-07-05T20:08:07+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - wsl
  - webp
  - typescript
  - vue
  - golang
  - rust
  - netlify
  - python
  - hhkb
  - togowl
---

📰 **Topics**

WSL2の導入記事を執筆、インプットはVueに関するものが多めです。  
また、生活リズムを夜型→朝型に変更する計画を立てました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【WSL】WSL2でつくる快適なUbuntu環境

WSL2についてブログの記事を書きました。

{{<summary "https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/">}}

利用者向けであり、内部の細かい話は書いてありません。  
クリップボード同期の話はまとまっている情報が少ないので参考になればと思います。


見たこと/読んだこと
-------------------

### Safariのwebpサポート

Safari 14でサポートされるようです。  
これで主要ブラウザは全てサポート対象になりました。

{{<summary "https://developer.apple.com/documentation/safari-release-notes/safari-14-beta-release-notes#Media">}}

実際にjpegやpng、gif、mp4をffmpegで変換してみたらいずれもサイズがかなり削減されました。  
正式版がリリースされたらブログ記事の画像をwebpに統一して、webpに関する記事も書こうと思います。

### 批判が少しだけ上手くなる方法を考えてみた - メソッド屋のブログ

なんと急遽最終回に.. 毎回刺激的な内容でとても好きだったから残念です..😭

{{<summary "https://simplearchitect.hatenablog.com/entry/2020/06/30/080211">}}

自分は無名人ですけど、ある日を境にブログのコメント機能は付けないようにしました。  
メリットより圧倒的にデメリットが大きいと自分は感じたからです。

その意味で、記事の内容には非常に同感しました。

### sp.84【ゲスト: hiroki_daichi】プロジェクトから対立を減らす方法と、楽しい『エンジニアリング組織論への招待』を書いた理由 | しがないラジオ

『エンジニアリング組織論への招待』への著者、広木さんのお話が斬新な視点で大変面白かったです。

{{<summary "https://shiganai.org/ep/sp84-hiroki_daichi">}}

特に**スーパーマン(神)頼みはいかん**というのは完全同意です。  
リプレイス能力のない人が『リプレイスされれば解決する！』と言っていたらかなりの危険信号だと言えます。  
借金が増え続けている人が、『お上が徳政令を出してくれれば大丈夫！』と言ってるのと変わりありません。

元となっている書籍は以下です。  
普段あまり本を読みませんが、この本は発売直後に読んで感銘を受けたのを覚えています。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:504px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:240px"><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F13e97c1b6d1e82e6bf4fa215a98f2103%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=18989984&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F6053%2F9784774196053.jpg%3F_ex%3D240x240&s=240x240&t=picttext" border="0" style="margin:2px" alt="" title=""></a></td><td style="vertical-align:top;width:248px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F13e97c1b6d1e82e6bf4fa215a98f2103%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  >エンジニアリング組織論への招待 不確実性に向き合う思考と組織のリファクタリング [ 廣木大地 ]</a></p><div style="margin:10px;"><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F13e97c1b6d1e82e6bf4fa215a98f2103%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:0"></a><a href="https://hb.afl.rakuten.co.jp/ichiba/14601443.2e885255.14601444.9dd02d09/?pc=https%3A%2F%2Fproduct.rakuten.co.jp%2Fproduct%2F-%2F13e97c1b6d1e82e6bf4fa215a98f2103%2F%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjoxfQ==" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><div style="float:right;width:41%;height:27px;background-color:#bf0000;color:#fff !important;font-size:12px;font-weight:500;line-height:27px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td></tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

### 【Vue】ep.36 Vue 3 Study 「何が変わる？ Composition API」 | UIT INSIDE

Vue3のComposition APIについて、分かりやすく重要なポイントが説明されています。

{{<summary "https://uit-inside.linecorp.com/episode/36">}}

### 【TypeScript】TypeScript誕生の背景

JavaScriptの誕生からTypeScript誕生の経緯まで分かりやすく紹介されています。

{{<summary "https://book.yyts.org/overview/before-typescript">}}

### 【WSL】Running WSL GUI Apps on Windows 10

Windows10のWSL2でGUIアプリケーションを使うための設定が紹介されています。

{{<summary "https://techcommunity.microsoft.com/t5/windows-dev-appconsult/running-wsl-gui-apps-on-windows-10/ba-p/1493242">}}

### 【Vim】How Did Vim Become So Popular

Vimがどのようにして有名になったのかが紹介されています。

{{<summary "https://pragmaticpineapple.com/how-did-vim-become-so-popular/">}}

この記事を読んで、初めて`ed`をちゃんと使ってみました。  
`ex`コマンドの由来も`ed`の進化から来ていると思うと『なるほど』と思える興味深い話。

### 【Go】Goのジェネリクスについて

tenntennさんが登壇で使われていたスライド。  
Goのジェネリクスは個人的に最も注目している機能なのでウォッチしておきたいです。

{{<summary "https://docs.google.com/presentation/d/1OdVqicGYtjdkp9XTlQKR2B_5_RWpu97GmNOKw4cPRnU/edit#slide=id.p">}}

ジェネリクスがないのでGoをメインで使うことはありませんが、実装されたら情勢が変わるかもしれません。


試したこと
----------

### 【Rust】スライス型

配列型の所有権が奪われないよう、スライスを使う方法を学びました。

```rust
fn double(items: &[i32]) -> Vec<i32> {
    items.iter().map(|x| x * 2).collect()
}

fn main() {
    let xs = [1, 3, 7];
    let r = double(&xs);
    eprintln!("r = {:?}", r);
}
```

`&`といえば、文字列に関する型 `&str` も参照専用で似てますね。  
書き込みをする場合は`String`なので、`to_string`や`String::from`を使うとのこと。


### 【Rust】トレイト

トレイトは雑に言うとinterfaceのようなものです。  
ここではトレイトの詳細には触れません。

対象型に任意のトレイトを実装するには`impl 対象トレイト for 対象型`と書きます。  
これはプリミティブ型や既に定義済みの型にも有効です。

雑なコードですが`i32`に100倍する関数をもつトレイトを実装する例です。

```rust
trait SuperMultiple {
    fn mul100(&self) -> i32;
}

impl SuperMultiple for i32 {
    fn mul100(&self) -> i32 {
        self * 100
    }
}

fn main() {
    let num = 10;
    eprintln!("num.mul100() = {:?}", num.mul100());
}
```

### 【Rust】ジェネリクス

ジェネリクスはJavaやTypeScriptのように`<T>`で表現します。

```rust
use std::fmt::Debug;

fn print_all<T: Debug>(items: &[T]) {
    items.iter().for_each(|x| eprintln!("x = {:?}", x))
}

fn main() {
    let xs = [1, 3, 7];
    print_all(&xs)
}
```

`<T: Debug>`は`T`が`Debug`トレイトを継承するという制約。  
print構文で`{:?}`を指定した場合、`Debug`トレイトが必要になるためです。

制約が複数になる場合は`+`で繋ぐことができます。  
`Display`はprint構文で`{:}`を指定した場合に必要となるトレイトです。

```rust
use std::fmt::{Debug, Display};

fn print_all<T: Debug + Display>(items: &[T]) {
    items.iter().for_each(|x| {
        eprintln!("debug = {:?}", x);
        eprintln!("print = {:}", x);
    })
}
```

制約が長くなる場合は`where`構文で後ろに書くこともできます。

```rust
use std::fmt::{Debug, Display};

fn print_all<T>(items: &[T])
where
    T: Debug + Display,
{
    items.iter().for_each(|x| {
        eprintln!("debug = {:?}", x);
        eprintln!("print = {:}", x);
    })
}
```


調べたこと
----------

### 【Vue】Composition APIで未定義waringが出る

👇 こういうやつです。

```
vue.runtime.esm.js?2b0e:619 [Vue warn]: Property or method "mode" is not defined on the instance but referenced during render. Make sure that this property is reactive, either in the data option, or for class-based components, by initializing the property. See: https://vuejs.org/v2/guide/reactivity.html#Declaring-Reactive-Properties.
```

`nuxt.config.js`の`plugins`にcomposition-apiのjsファイルを指定し忘れていたからでした..。

```
// plugins/composition-api.js の場合
  plugins: ['@/plugins/composition-api'],
```

### 【Vue】vuex-module-decoratorsでStoreがundefinedになる

`store/index.ts`の作成を忘れていました。

```typescript
import { Store } from "vuex";
import { initialiseStores } from "~/utils/store-accessor";

const initializer = (store: Store<any>) => initialiseStores(store);
export const plugins = [initializer];

export * from "~/utils/store-accessor";
```

### 【Vue】StoreのStateを変更してもcomputedが再計算されない

Vueの`setup`関数内でcomputedを定義した場合の話です。  
それはStoreに依存するにもかかわらず、Storeの値が変更されても`id`が再計算されませんでした。

```typescript
    setup() {
        const id = computed(() => MemberStore.id)
    }
```

Storeのprivate propertyに初期値を設定しなかったのが原因でした。  
初期値を設定したら解決しました。

```diff
- private _id: Id | null;
+ private _id: Id | null = null;
```

{{<info "初期値としてのundefinedとnull">}}
Vueの監視対象プロパティには初期値を代入しないと、その後に値が入っても変更が通知されません。  
もちろん初期値に`undefined`を代入しても同じです。

一方`null`は値が無いことを意味するものの、実体はオブジェクトです。  
オブジェクトであるため監視対象になり、変更は通知されます。
{{</info>}}

### 【Netlify】Poetryを使ってビルド/デプロイすると時間がかかる

Mkdocsを使ったサイトの運営をしていますが、Poetryに変えてからNetlifyのデプロイに時間がかかるようになりました。  
`netlify.toml`はこんな感じです。

```
[build]
command = """
pip install -q poetry &&
poetry config virtualenvs.in-project true &&
poetry install -v &&
mkdocs build -d site
```

恐らく、Poetryを利用した場合にpipのキャッシュが効かなくなったからだと思っています。  
色々調べたのですが、pipと`requirements.txt`構成で作るのが手堅いと思いそうしました。

大体1分くらいビルド時間が縮まりました。

#### requirements.txtの作成

`poetry.lock`から`requirements.txt`を作るため以下コマンドを実行します。

```
poetry export -f requirements.txt -o requirements.txt
```

あとは`requirements.txt`をあわせてコミットしておけばOKです。  
自動化したい場合はpre-commitフックなどの仕組みを使うのもいいでしょう。

`netlify.toml`もシンプルになりました。

```
[build]
command = """
mkdocs build -d site
"""
publish = "site"
```

#### 直接成果物をデプロイする方法

Netlifyにデプロイだけを求めるのであれば、ローカルで成果物を保存`netlify-cli`を使うのも手です。

{{<summary "https://mottox2.com/posts/278">}}

ローカルの環境やキャッシュを利用できるためデプロイまでの時間は最も高速です。  
この対応をすると2～3分かかっていたデプロイが10秒程度になると思います。

一方、2～3分のリードタイムにはそこまで不満を感じていませんので対応は見送りました。

{{<info "Mkdocsについて">}}

Mkdocsについては以下の記事をご覧下さい。

{{<summary "https://blog.mamansoft.net/2019/07/14/create-site-markdown-by-mkdocs/">}}
{{</info>}}

### 【Python】Pipenvのinstallやlockに失敗する

しっかり確認したわけではありませんが、恐らく以下の事象に遭遇しました。

{{<summary "https://github.com/pypa/pipenv/issues/4349">}}

発生環境です。酷似しています。

* Gitリポジトリ
* UTF-8以外のファイルを扱っている
* Windows

`pip install pipenv==2018.11.26`に戻すと事象は解消します。  
清水川さんも言われているように、実行環境ではvenvとpipを使った方がいいのかもしれません..。

{{<summary "https://scrapbox.io/shimizukawa/Python%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6%E3%81%AEshimizukawa%E3%81%AE%E4%B8%BB%E5%BC%B5">}}

### 【Vue】composition-apiでcomputedが再計算されない

`computed(...)`の返却値をtemplateで参照している箇所が無かったからのようです。  
厳密にはreturnに含まれていないことが理由かもしれません。

Viewで参照しない場合は`reactive`や`ref`を使えということかな..? 🤔


整備したこと
------------

### 【キーボード】HHKB Professional HYBRID Type-Sのファームウェアアップデート

HHKBのキーが勝手に入力されてしまう問題が有線でも発生しました。  
ファームウェアが原因かもしれないので、最新版にアップデートしました。

{{<summary "https://happyhackingkb.com/jp/download/#tool">}}

ファームウェアのアップデートには`Happy Hacking Keyboardキーマップ変更ツール`が必要らしいのでインストールしました。  
ツールを起動し、ダウンロードしたファームウェアファイル(`.hfb`)をツールから読み込めばアップデートが開始されます。

今のところ事象は発生していません.. 少し様子見ですね。

### 【キーボード】HHKB吸振マットHG

HHKB Hybrid Type-S用の打鍵感を向上させるマットです。

{{<summary "https://www.pfu.fujitsu.com/direct/hhkb/hhkb-option/detail_pz-kbkmg-hybrid.html">}}

既に家で使用していましたが、打鍵感が少し改善された気がするので会社でも装着してみました。  
前より少しだけ指へのダメージが減った気がします.. (気のせいかも)

### 【Vue】composition-api用のIDEA live template

コンポーネント分割に対する心のハードルを少しでも下げるため、live templateを作成しました。

{{<file "vue">}}
```vue
<template></template>
<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  reactive,
  watch,
} from "@vue/composition-api";
export default defineComponent({
  components: {
    // SampleComponent,
  },
  props: {
    // hoge: { type: Object as () => Hoge, required: true },
    // huga: { types: Array as () => Huga[] },
    // hoho: { types: String, default: "huga" },
  },
  setup() {
    const state = reactive({
      prop: "",
    });
    const computedProp = computed(() => `${state.prop}--`);
    const handleAny = () => {};
    watch(
      () => state.prop,
      (p) => p
    );
    onMounted(() => {});
    return {
      state,
      computedProp,
      handleAny,
    };
  },
});
</script>
<style lang="scss" scoped></style>
```
{{</file>}}

開発をしながら徐々にバージョンアップできればと思っています。


今週のリリース
--------------

### Togowl v1.15.0 ～ v1.15.1

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### タスクリストの背景画像

タスクリストに背景画像を指定できるようにしました。

残タスクの数が少なくなるにつれて透過率が0に近づきます。  
全てタスクを終了させると0になるので、達成感のある画像を用意しましょう

{{<vimg "resources/ac303340.jpeg">}}

ちなみに上記画像は日本FALCOMの新作『創の軌跡』に登場するロイド・バニングスです。  
2ヶ月後の発売日までは軌跡キャラでテンションを上げていく予定です☺️

{{<summary "https://www.falcom.co.jp/hajimari/">}}

#### 設定画面のリニューアル

設定項目毎にbottom navigationでViewを分割しました。  
また、各項目で何のサービスと連携しているかを分かりやすくしました。

{{<vimg "resources/f5288700.jpeg">}}


その他
------

生活リズムを夜型から朝型に変えることにしました。  
7:30起床24:00就寝のリズムを2時間前倒しして、5:00起床22:00就寝を目指します。

変更の理由は2つです。

* 帰宅が24時を超えており健康に良くない
* 集中するための夜の時間が思ったより確保できない

リスクは朝出勤前に30分～1時間確保していた個人的な作業時間が無くなってしまうことです。  
少ししたら、更に早起きする/帰宅後に確保する など対策を検討する予定です。

明日から施行します 😆

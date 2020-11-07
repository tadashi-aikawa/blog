---
title: 2020年7月2週 Weekly Report
slug: 2020-07-2w-weekly-report
date: 2020-07-12T20:08:19+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

次世代フロントエンドの期待を背負うSvelteを初体験。  
GitHub ActionsやCIも強化し、9ヶ月ぶりにOwlMixinをリリースしました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【TypeScript】リリースノート v2.8

TypeScript v2.8のリリースノートをまとめ終わりました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/2.8/">}}

`Conditional Types`周りはかなり勉強になりました。  
以下の3つはオススメです。

* Conditional Types
* Distributive conditional types
* Type inference in conditional types

解釈間違っている箇所もあると思いますが..参考程度に😅

### 【Python】sql-alchemy-sandbox

SQLAlchemyの学習や動作確認のためsandboxを作成しました。  

{{<summary "https://github.com/tadashi-aikawa/sql-alchemy-sandbox">}}

基本的には公式ドキュメントに記載された内容です。

{{<summary "https://docs.sqlalchemy.org/en/13/">}}

完成したわけではなく作っただけです。ほとんど未完成。


読んだこと/聴いたこと
---------------------

### 悲しいほど｢心が弱い人｣に共通する3つの特徴

総合格闘家・朝倉未来さんの記事。  
ここで語られるマインドはエンジニアや他の職種にも共通すると思っています。

{{<summary "https://toyokeizai.net/articles/-/360424?utm_campaign=MKtkol_moments&utm_source=twitter&utm_medium=social">}}

> 目的意識をしっかり持つために大切なのは、今取り組んでいることが本当にやりたいことなのかどうかの再確認です。結局、本当にやりたいことでなければ全力をぶつけることはできないでしょう。
>
> そして、取り組んでいることが本当にやりたいことであれば、どんどん成長することができます。やりたいことではないのになんとなくやめることができず、ずるずると続けてしまう、というのも「弱さ」の表れです。もちろん、疲弊したときはしっかり休息をとって、モチベーションを回復させましょう

やりたいことを見つけて取り組めば成長はあとから付いてくる。  
やりたくないことを続けてしまうのが『弱さ』であると..なるほどです。

またリアルに視点を変えて客観視することの重要さも大変参考になりました。  
詳しくは記事の中で。

### ep.53 Vue 3 Study「Vue.js にもやってくる Fragment」

ReactのFragmentのようなものがVueにやってくるようです。  
無意味なdivタグや、CSSフレームワークのクラス階層制約から解き放たれると思うと嬉しい！

{{<summary "https://uit-inside.linecorp.com/episode/53">}}

### why does Jetbrains separate their products into multiple IDEs ?

JetBrainsはなぜ言語ごとにIDEを開発しているのか?という質問です。  
設定の同期などが面倒なためIntelliJ IDEAを使っていますので気になりました。

{{<summary "https://intellij-support.jetbrains.com/hc/en-us/community/posts/360006942459-why-does-Jetbrains-separate-their-products-into-multiple-IDEs-">}}

中の人が回答されています。  
歴史的経緯によるものらしいですが、気になるのは最後の文章。

> Only recently Java was refactored into a plug-in and the backend infrastructure for the paid plug-ins marketplace appeared. When this work is finished, we may consider providing a single IDE with several paid plug-ins so that you can build the IDE with the features that you need.

近い将来、単一のIDEベースに必要な言語プラグインを購読する未来がくるかもしれませんね😁


試したこと
----------

### Svelte

SvelteはVirtual DOMを使わずコンパイルでコードを最適化する思想のフレームワークです。  
TypeScript未対応のため様子見でしたが、対応されたようなので😁

{{<summary "https://svelte.dev/">}}

公式のトップページに従います。

```
npx degit sveltejs/template svelte-sandbox
cd svelte-sandbox
npm install
npm run dev
```

トップ画面が表示されます。  
`src/main.js`や`src/App.svelte`を編集するとホットリロードが走ります。

svelte-preprocessを使うと色々できそうです。

{{<summary "https://github.com/sveltejs/svelte-preprocess">}}

現時点では以下に対応しているみたいです。

* Sass / Stylus / Less / PostCSS
* TypeScript / CoffeeScript
* Pug
* Babel

TypeScript、Sass、Pugを使って`App.svelte`を書き直してみました。

{{<summary "https://github.com/sveltejs/svelte-preprocess/blob/master/docs/getting-started.md">}}

必要なパッケージをインストールします。

```
npm i svelte-preprocess typescript pug sass --save-dev
```

`rollup.config.js`に`autoPreprocess`設定を追加します。

```diff
+ import autoPreprocess from 'svelte-preprocess';
.
.
    plugins: [
      svelte({
+       preprocess: autoPreprocess(),
.
.
```

書き直してみました。

{{<file "src/App.svelte">}}
```vue
<script lang="ts">
  export let id: number;
  export let name: string = 'No name';
</script>

<template lang=pug>
  h1
    | Hello {name} (id: {id})!
  p
    | Visit the 
    a(href="https://svelte.dev/tutorial") Svelte tutorial 
    | to learn how to build Svelte apps.
</template>

<style lang="scss">
  template {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    font-size: 4em;
    font-weight: 100;
  }

  p {
    a {
      font-weight: bold;
      color: green;
    }
  }
</style>
```
{{</file>}}


{{<file "src/main.js">}}
```javascript
import App from './App.svelte';

const app = new App({
  target: document.body,
  props: {
    id: 123456,
    name: 'Mimizou'
  }
});

export default app;
```
{{</file>}}

こんな風に表示されます。LGTM😆

{{<himg "resources/69d7df16.jpeg">}}

今回は触ってみたかっただけなのでこの辺で..。  
TypeScriptをはじめとするエコシステムとの連携は好印象でした👍

sapperという人気フレームワークもあるみたいですし、IDEのサポートが整えば世代交代の可能性はある気がしました。

{{<summary "https://github.com/sveltejs/sapper">}}


### 【Node.js】ECMAScript Modules

今更ですがECMAScript Modulesのimportを試してみました。

{{<summary "https://nodejs.org/api/esm.html#esm_ecmascript_modules">}}

Node.jsのバージョンはv12.17.0です。

```
mkdir esm-test
cd esm-test
npm init -y
```

最小限のソースコードを作成します。

`sub.js`
```javascript
export function sum(x, y) {
  return x + y;
}
```

`main.js`
```javascript
import { sum } from "./sub.js";

console.log(sum(1, 10));
```

このまま実行すると以下の警告と共にエラーとなります。

```
$ node main.js
 Warning: To load an ES module, set "type": "module" in the package.json or use the .mjs extension.                                                                               C:\Users\s
```

拡張子を`.mjs`にしない場合は`package.json`に`type: module`を追加する必要があります。  
公式ドキュメントにも記載があります。

> Regardless of the value of the "type" field, .mjs files are always treated as ES modules and .cjs files are always treated as CommonJS.

つまり、拡張子によって判定方法が変わります。

| 拡張子 | 判定                                                   |
| ------ | ------------------------------------------------------ |
| .cjs   | CommonJSとする                                         |
| .mjs   | ES modulesとする                                       |
| .js    | typeがmoduleならES modules、それ以外ならCommonJSとする |

`type`を指定してもう一度実行します。

```javascript
$ node main.js                                                                                                                                                      07:23:02
(node:14324) ExperimentalWarning: The ESM module loader is experimental.
11
```

**ESM module loaderは試験的機能である**と表示されますがきちんと動きます。

{{<warn "実行できない場合..">}}
Node.jsのバージョンが古いと`node`コマンドに`--experimental-module`フラグが必要です。

* v12系の場合 12.17.0より前
* v13系の場合 13.2.0より前

{{<summary "https://nodejs.org/en/blog/release/v12.17.0/">}}
{{<summary "https://nodejs.org/en/blog/release/v13.2.0/">}}
{{</warn>}}

### 【正規表現】Regex101.com

正規表現の確認やテストを気軽にできるWebサイトです。

{{<summary "https://regex101.com/">}}

### 【Slack】サイドバーを隠して集中力を上げる

`Ctrl+Shift+d`で左側、`Ctrl+Shift+m`で右側のサイドバーを隠すことができます。  
これにより未読通知やリアクションなどが見えなくなるので集中力が上がります。

Slack自体を閉じる方法もありますが、以下2つの理由からサイドバー非表示を採用しました。

* Notificationが表示される (一目見て重要なものは確認したい)
* Slack自体が作業ログ保存場所として優れている


調べたこと
----------

### 【GitHub】latestが最新のタグを参照しない

GitHubのlatestが最新ではなく古いタグを指してしまう現象。  
Gitのタグを作成してpushするだけでなく、GitHubとして操作が必要です。

ghrを使ってデプロイすればOKです。

{{<summary "https://github.com/tcnksm/ghr">}}

```
# version 4.15.1の場合
ghr v4.15.1
```

### 【Python】SQLAlchemyで複合外部キーを指定する方法

今まで複数のColumnにForeignKeyを指定してましたが、ForeignKeyConstraintを使わなければダメでした。  
Column単位では単独で2つのカラムに複合キーが付けられていると見なされてそうです。

```python
class HogeEntity(BASE):
    __table_args__ = (
        ForeignKeyConstraint(
            ("column1", "column2"),
            ("other_table.column1", "other_table.column2"),
        ),
    )
```

### 【Python】PylintでUnicodeDecodeError

謎のエラーに苦しめられました。。

```
UnicodeDecodeError: 'cp932' codec can't decode byte 0x87 in position 74: illegal multibyte sequence
```

デバッグしたら、`pyproject.toml`で日本語を使っていたのが問題だったようです。  
`pyproject.toml`はUTF-8ですが、PylintがWindowsだとcp932を使うようになっていそうです..。

日本語を使うのやめて解決😜


整備したこと
------------

### 【GitHub】Codecovでカバレッジレポート

1年以上前から[Code Climate]のカバレッジが上手くとれなくなってしまったため、Codecovに移行しました。

{{<summary "https://codecov.io/">}}

GitHub Actionsの中でレポートを送信するようにしましたが、設定がほぼ不要で感動してます🤣  

1. CodeCovから対象のリポジトリを追加する
2. GitHub ActionsのYAMLファイルで`steps`配下に[codecov/codecov-action]を指定

```yaml
  - uses: codecov/codecov-action@v1
```

こんな風に表示されます。

{{<himg "resources/613db611.jpeg">}}

[Code Climate]: https://codeclimate.com/
[codecov/codecov-action]: https://github.com/marketplace/actions/codecov

### 【GitHub】MacOS/Windows/Ubuntuのマトリックスビルド

GitHub ActionsでOSとバージョンのマトリックスビルドに対応しました。  
以下のような感じです。

```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        python: ["3.6", "3.7", "3.8"]
    name: Python ${{ matrix.python }} on ${{ matrix.os }}
```

カバレッジなどのレポートは特定OS/特定バージョンのみにしています。

```yaml
  - uses: codecov/codecov-action@v1
    if: matrix.python == 3.8 && matrix.os == 'ubuntu-latest' && success()
    with:
      fail_ci_if_error: true
```

OS名にはシングルクォートが必要なので注意です。

### 【PowerShell】ffmpegのよく使うコマンドをエイリアスに設定

正確にはエイリアスではなく関数です。

```powershell
# mp4のサイズを圧縮
function remp4() { ffmpeg -i $args[0] -vcodec libx264 -crf 20 $args[1] }
# mp4をgifに変換 (画質をキープ)
function togif() { ffmpeg -i $args[0] -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" $args[1] }
```

### 【ネットワーク】ネットワークの有線環境整備

WiMaxで利用しているルータW06がノートPCと無線接続できなくなってしまいました。  
PC/ルータ共に他の機器同士では接続できるため、面倒なトラブルに遭遇したのかもしれません😭

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:504px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:240px"><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487c86.9985fa61.1c487c87.92aa04c9/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Ffarson%2F000000126527%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/1c487c86.9985fa61.1c487c87.92aa04c9/?me_id=1319583&item_id=10002624&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Ffarson%2Fcabinet%2F06706888%2F000000126526_main.jpg%3F_ex%3D240x240&s=240x240&t=picttext" border="0" style="margin:2px" alt="" title=""></a></td><td style="vertical-align:top;width:248px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487c86.9985fa61.1c487c87.92aa04c9/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Ffarson%2F000000126527%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  >【訳あり】UQ WiMAX モバイルルーター Speed Wi-Fi 高速通信 動画視聴 快適 USB接続 受信最大1.2Gbps ギガビット級 高速Wi-Fi 無線ルーター Wifiルーター モバイル ルーター タブレット パソコン HWD37SKU インターネット ビジネス 自宅 W06 白 送料無料</a></p><div style="margin:10px;"><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487c86.9985fa61.1c487c87.92aa04c9/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Ffarson%2F000000126527%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:0"></a><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487c86.9985fa61.1c487c87.92aa04c9/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Ffarson%2F000000126527%2F%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ==" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><div style="float:right;width:41%;height:27px;background-color:#bf0000;color:#fff !important;font-size:12px;font-weight:500;line-height:27px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td></tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

せっかくの機会なので、ルータとPCの接続をUSB-Cに切り替えました。  
W06のベストエフォートはUSB接続時のものであるため、有線であることを除けばメリットがあるからです。

ルータをPCの側に持ってくるとアンテナ感度が落ちるため、USB3.0を5M延長できるケーブルを購入しました。

{{<summary "https://www.amazon.co.jp/gp/product/B0179MXKU8/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1">}}

また、USB3.0のクチが足りなかったので以下のハブで拡張しました。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:504px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:240px"><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487a88.65c270ed.1c487a89.9bceac47/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fd-shop1one%2F4950190367185%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/1c487a88.65c270ed.1c487a89.9bceac47/?me_id=1297887&item_id=10221585&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fd-shop1one%2Fcabinet%2Fimage3%2Fb07j2p6j83.jpg%3F_ex%3D240x240&s=240x240&t=picttext" border="0" style="margin:2px" alt="" title=""></a></td><td style="vertical-align:top;width:248px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487a88.65c270ed.1c487a89.9bceac47/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fd-shop1one%2F4950190367185%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  >BUFFALO USB3.0 セルフパワー 4ポートハブ ブラック スタンダードモデル BSH4A125U3BK 【Nintendo Switch/Windows/Mac対応】</a></p><div style="margin:10px;"><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487a88.65c270ed.1c487a89.9bceac47/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fd-shop1one%2F4950190367185%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:0"></a><a href="https://hb.afl.rakuten.co.jp/ichiba/1c487a88.65c270ed.1c487a89.9bceac47/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fd-shop1one%2F4950190367185%2F%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjAsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ==" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><div style="float:right;width:41%;height:27px;background-color:#bf0000;color:#fff !important;font-size:12px;font-weight:500;line-height:27px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td></tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

以下のような構成ですが今のところ快適です☺️  
BluetoothやIHなどと干渉しないので接続も安定しました。

```
窓 | ルータ  <-----------(USB type-C 5M)----------------> (USB 3.1ハブ) <---> (EIZO モニタUSB 3.0ハブ) <---> PC
```

速度も無線接続時より上がった気がします。  
筆者の環境では100Mbpsくらいは出ます。


今週のリリース
--------------

### Togowl v1.16.0 ～ v1.16.2

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### タスクの期日変更

タスクの期日を任意の日付に変更できるようにしました。  
今までは『今日』『明日』だけでしたが、2日後以降にも設定できるようになりました。

{{<vimg "resources/togowl_1.16.2_1.gif">}}


### OwlMixin v5.6.0

OwlMixinはクラスインスタンスとjson,yamlなどのフォーマットを相互変換したり、メソッドチェーンによる関数型言語の書き方をサポートするMixinです。

{{<summary "https://github.com/tadashi-aikawa/owlmixin">}}

#### for_eachをTListとTIteratorに追加

```python
>> TIterator((1, 2, 3)).for_each(lambda x: print(x*2))
2
4
6
>>> TList([1, 2, 3]).for_each(lambda x: print(x*2))
2
4
6
```

#### count_byをTIteratorに追加

`TList`にのみ実装されていた`count_by`メソッドを`TIterator`にも実装しました。

```python
>>> TIterator((1, 1, 10, 20, 5, 100)).count_by(lambda x: len(str(x)))
{1: 3, 2: 2, 3: 1}
```

#### to_iteratorをTListに追加

`TIterator(TList([1, 2, 3]))`がメソッドチェーンでも実現できるようになりました。

```python
>>> TList([1, 2, 3]).to_iterator()
```


その他
------

### Markowlにはじめてレビューがついた

Markowlは今年公開したJetBrains製IDEのMarkdownプラグインです。

{{<summary "https://blog.mamansoft.net/2020/04/22/create-intellij-idea-plugin/">}}

`Simple but efficient` と嬉しいコメントをいただけました😆

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

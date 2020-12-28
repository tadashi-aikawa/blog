---
title: 2020年6月3週 Weekly Report
slug: 2020-06-3w-weekly-report
date: 2020-06-22T09:18:16+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

TypeScript x Nuxt x Vuetifyで作成されたTogowlの依存関係を一斉アップデートしました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


インプット
----------

### Python3.9

まだベータですが新機能の説明がされていました。

{{<summary "https://towardsdatascience.com/new-features-in-python39-2529765429fe">}}

気になる新機能は以下3つです。

#### Dictionary Unions

`|` でdictionaryのマージができます。  
`|=`で上書きです。

```python
>>> { "a": 1 } | {"a": 10, "b": 2 }
{ "a": 10, "b": 2 }
```

同じキーが存在する場合はMergeではなく、後の値で上書きされます。

#### Type Hints

従来 ジェネリクスが必要な型 `List[T]` `Dict[K, V]` などは typing で提供されていましたが、built-inで提供されるようになりました。  
`list[T]` や `dict[K, V]` といった書き方ができます。詳しくはPEP585にて。

{{<summary "https://www.python.org/dev/peps/pep-0585/">}}

#### String Methods

Stringにprefix/suffixを削除するメソッドが追加されました。

* removeprefix
* removesuffix

### Pythonを使って関数型プログラミング Part.1 - ログミーTech 

かなり本格的な内容です。  
Pythonでパターンマッチやモナドまで実現されているのがアツイですね😁

{{<summary "https://logmi.jp/tech/articles/322584">}}

### Goのジェネリクスを試せるPlayground

ジェネリクスが使えるならGoに戻ってみようかなという気になってきます。

{{<summary "https://go2goplay.golang.org/">}}

### 権限設計

流し読みですが、権限の世界は深いということを改めて実感。

{{<summary "https://kenfdev.hateblo.jp/entry/2020/01/13/115032">}}

私が好きなのは`RBAC(Role-Based Access Control)`ですね。

### ffmpegでmp4をgifに変換

拡張子をgifにするだけでOKです。

```
ffmpeg -i input.mp4 output.gif
```

画質の低下が気になる場合はパレットの設定をしましょう。  
ファイルサイズは2倍ほどになりますが、見た目がかなり改善します。

```
ffmpeg -i input.mp4 -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" output.gif
```

### VueUse

Vue Composition APIを使った便利Utilityです。

{{<summary "https://vueuse.js.org/?path=/story/docs--read-me">}}

Composition APIを使った実装のサンプルコードとしても興味深いです。

### Vuetify v2.3 へバージョンアップ

Vuetifyのv2.3系へバージョンアップしました。

{{<summary "https://github.com/vuetifyjs/vuetify/releases/tag/v2.3.0">}}

`v-virtual-scroll`が気になるので今度試してみたいです。  

#### v-calendarの変更点

stackとcolumnが適応される条件が変わった気がします..。

* 変更前
  * event**領域**の重なり具合を閾値にして適応する
* 変更後
  * event**期間**の重なり具合を閾値にして適応する

今まで重なった部分はスライドしてくれたのに、見にくくなってしまった..

{{<himg "resources/0a0a1cb2.jpeg">}}

カレンダーをそういう用途で使うな..ということかもしれません。

`event-overlap-mode`にfunctionを指定すれば、可能ではあります。  
以下のように `(day, dayEvents, timed, reset) => CalendarEventOverlapMode` なるfunctionを実装すれば..。

{{<summary "https://github.com/vuetifyjs/vuetify/blob/78b0ae2bd2d8b843417250f0cd3bcecf99604112/packages/vuetify/src/components/VCalendar/modes/stack.ts#L41">}}


### vue-awesome-swiperのメジャーバージョンアップ

Togowlで使っているvue-awesome-swiperをv4にアップグレードしました。

{{<summary "https://github.com/surmon-china/vue-awesome-swiper">}}

リリースノートのBreaking changeに対する内容は英語、他は日本語のセクションにしています。

#### Move Swiper dependencie to peerDependencies

SwiperがpeerDependenciesになったので別途インストールが必要になりました。

```
npm i swiper
```

#### Replace Swiper instance name to $swiper

Swiperインスタンスの名前が変わりました。  
使用している箇所を以下のように修正する必要があります。

```diff
- mySwiper.value.swiper.slideTo(1)
+ mySwiper.value.$swiper.slideTo(1)
```

#### Update the component name

コンポーネントの名前が一部変わりました。  
ケバブケースを使っている場合は影響ないと思います。

* swiper => Swiper
* swiperSlide => SwiperSlide

#### CSSのimport方法変更

`nuxt.config.js`で読み込んでいたCSSをtsファイルでimportするようにしました。  
今回のバージョンアップとは関係ないかもしれません..。

### uuidのメジャーバージョンアップ

なんでこんなに古かったの!?と思えるくらい上がりました😅

```
uuid ^3.4.0   →           ^8.1.0
```

`require`の部分が変わるだけなので修正は容易です。

```diff
- const uuidv4 = requrie("uuid");
+ const { v4: uuidv4 } = require("uuid");
```

### core-jsバージョンのコンフリクト解消

依存関係をすべて最新化した影響で、nuxtとfirebaseが利用するcore-jsのバージョンがconflictしました。  
firebaseは3系、nuxtは2系を使っていることが問題のようです。

以下のページに助けられました🙇‍♂️

{{<summary "https://tenderfeel.xsrv.jp/javascript/5204/">}}

nuxtにcore-jsの3系を使わせるという解決方法ですね😄  
Issueは上がっているので、そのうち対応される気はしてます。

{{<summary "https://github.com/nuxt/nuxt.js/issues/7484">}}


アウトプット(ドキュメント)
--------------------

### TypeScriptリリースノートおさらい

v2.7のリリースノートが終わりました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/releases/2.7/">}}

v2.8に着手を始めました。  
以前挫折したConditional Typesと正面から向き合います。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/releases/2.8/">}}


アウトプット(OSS)
-----------------

### Togowl v1.11.0～v1.13.0リリース

#### タスクの外部編集ボタン

スワイプで表示されるメニューに、タスクの外部編集ボタンを追加しました。  
タスク管理サービスのタスク編集ページをブラウザで開きます。

{{<vimg "resources/20200619_1.gif">}}

#### カレンダーのマルチレンジ対応

カレンダーのズームを2段階から8段階に増やしました。  
ズームレベルによって、レンジが月・週・4日・日と切り替わります。

{{<himg "resources/2020_06_22_1.jpeg">}}

{{<himg "resources/2020_06_22_2.jpeg">}}

{{<himg "resources/2020_06_22_3.jpeg">}}

#### Todoistのリンク形式に対応

Markdownだけでなく`URL (タイトル)`というリンク形式に対応しました。  
Todoistではタスク名をURLにすると、タスク名が自動的に上記名称へ変換されます。

{{<himg "resources/f7e4488c.jpeg">}}

この形式で登録されたタスクの見た目は以下のようになります。

{{<himg "resources/320b1f54.jpeg">}}

Togowlでもこの形式に対応しました。

{{<himg "resources/7ed0975e.jpeg">}}


変化
----

### DailyふりかえりでThinkSpaceを使わない

Dailyふりかえりの内容をThinkSpaceではなくブログに下書きするようにしました。  
Weekly Reportの執筆コストを下げるためです。

仕事の成果はThinkSpaceは引き続きThinkSpaceに登録していきます。  
1on1で話を広げるときに便利なので😊


その他
------

最近の出勤時間は12時～21時にしています。  
しかし、先週は忙しくて家に帰るのが毎日翌日になっていました..。

その疲れで土曜日の活動開始が午後からになり、日曜日の今日も引きずっています。  
朝のルーチンが壊れるだけで、1日の生産性が大きく下がることを痛感しました。

今週は遅くても23時前には家へ帰りたいと思います。目標は22時前です。

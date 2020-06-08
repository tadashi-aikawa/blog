---
title: Weekly Reportをはじめてみる
slug: start-weekly-report
date: 2020-06-08T09:47:07+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - rust
  - windows
  - terminal
  - powershell
  - jumeaux
  - markowl
  - togowl
  - ipad
  - make
  - vue
---

Weekly Reportをはじめることにしました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


はじめに
--------

### Weekly Reportとは

私が1週間何をやってきたかの記録です。  
具体的には以下の内容を記載する予定です。

| 内容         | 説明                                        |
| ------------ | ------------------------------------------- |
| インプット   | 学んだ事こと。技術的スキル/気づき/閃き など |
| アウトプット | OSSプロダクトやブログ記事 など              |
| 変化         | 新しく始めたこと など                       |
| 所感         | 思ったこと/感じたこと など                  |

### なぜWeekly Reportを始めるのか

理由は3つあります。

❶ ブログを書くまでのフットワークを軽くしたい  
❷ 尊敬している人は1週間のふりかえりを文章にまとめている  
❸ 単一記事にするほどではないが、誰かの役に立ちそうなネタがありそう

少し時間をとられてしまうという懸念もあります。  
ただ、今も一週間に1時間ほどふりかえりをしています。

構成や品質に拘らなければ、1時間という時間内に執筆可能では..と思っています。

### いつWeekly Reportを書くのか

基本的に日曜日です。  
事情によって前後することもありますが、±1日の範囲内で公開を目指します。

### 注意事項

Weekly Reportの内容は、他の記事と比べて記載内容の信憑性は落ちます。  
これはクオリティよりもスピードを重視するためです。

クオリティを重視すると、単一記事と変わらなくなってしまうのでそこは線引きします。  
日記のような感覚で見ていただけると幸いです🙇

### Weekly Reportのサンプル

今回ははじめてなので、次のセクションから試しに書いてみます。  
次回からは`2020年6月2週 Weekly Report`みたいなタイトルにする予定です。


インプット
----------

### uutils/coreutils

Rustで書きかえられたクロスプラットフォーム対応のcoreutilsであるuutils/coreutilsを使ってみました。

{{<summary "https://github.com/uutils/coreutils">}}

MinGWとの大きな違いは、ファイル名などを含めて文字化け問題に遭遇しにくいことです。

### mp4の動画サイズを抑える方法

ブログで使うmp4ファイルの容量が大きかったので、削減する方法を調べました。  
libx264コーデックを使うと1/3強まで削減できました👍

```
$ ffmpeg -i input.mp4 -vcodec libx264 -crf 20 output.mp4
```

{{<summary "https://qastack.jp/unix/28803/how-can-i-reduce-a-videos-size-with-ffmpeg">}}

### Markedをinlineで使う

MarkedはMarkdownをHTMLに変換するライブラリです。

{{<summary "https://github.com/markedjs/marked">}}

デフォルトだと改行なしテキストは`<p>`タグで外側を囲まれます。  
inlineでparseしたい場合、`<p>`タグの存在が不都合なケースもあります。

そこで、`InlineRenderer`を作り、inlineの場合は`<p>`タグで括らないように処理を上書きしました。

```js
const marked = require("marked");
const defaultRenderer = new marked.Renderer();
const InlineRenderer = new marked.Renderer();
InlineRenderer.paragraph = (text: string) => `${text}\n`;

export const toHTML = (markdown: string, inline: boolean = false): HtmlString =>
  marked(markdown, {
    breaks: true,
    renderer: inline ? InlineRenderer : defaultRenderer,
  });
```

かなり微妙なので、もっと良い方法があれば知りたいところです.. 😅


アウトプット(ドキュメント)
--------------------

### Windows Terminal + PowerShellの記事を公開

個人的にかなりの力作です☺️  
ターミナル/Windows好きの方は是非！

{{<summary "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}

### TypeScript v2.6のリリースノート

TypeScriptの理解を深めるため、過去のリリースノートを要約する作業をしています。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/">}}

今週でv2.6の内容が終わりました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/2.6/">}}


アウトプット(OSS)
-----------------

### Jumeaux v2.4.0～v2.4.1リリース

JumeauxはAPI差分確認ツールです。

{{<summary "https://blog.mamansoft.net/2019/04/15/api-diff-check-tool-jumeaux-1.0/">}}

今回こちらのv2.4.0～v2.4.1をリリースしました。

Slack通知設定に条件を指定できるようになりました。  
詳しくはリリースノートを参照してください。

{{<summary "https://tadashi-aikawa.github.io/jumeaux/ja/releases/v2/#241">}}


### Markowl v0.5.0リリース

MarkowlはJetBrains製IDEで利用可能な、Markdownプラグインです。

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

今はちょっとしたフォーマッターの機能しかありません。  
必要を感じたら、都度機能追加していく予定です😄

今回、こちらの軽微な修正をしました。

### Togowl v1.5.0～v1.7.0リリース

Togowlは1日のタスクを効率的にこなすためのツール(PWA)です。  
Todoist/TogglのAPIを利用しており、Windows/Mac/Android/iOSなどマルチプラットフォームで動作します。

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

開発している主な目的は2つです。

* 日々のタスクを効率的にこなす
* キャッチアップした技術でプロダクト開発したときの知見を得る

今回こちらのバージョンアップをしました。

#### Schedule画面を追加

タスクの整理に特化した画面を追加しました。

{{<himg "resources/ceee6f29.jpeg">}}

表示がコンパクトなため、並び替えや整理をするのに役立ちます。

#### タスク/エントリのMarkdown表記に対応

Todoistのタスク名やTogglのエントリ名にMarkdown表記が含まれるとき、それを反映するようにしました。

{{<himg "resources/707f13b0.jpeg">}}

リンクに限りSlack通知でも変換されます。

{{<himg "resources/c358ae93.jpeg">}}

#### プロジェクトカテゴリのカラー設定に対応

プロジェクトカテゴリでColorを設定できるようになりました。

{{<himg "resources/e171bd01.jpeg">}}

ここで設定したカラーはカレンダーで反映されます。

{{<himg "resources/f8471b91.jpeg">}}


変化
----

### ASUS ExpertBookの購入

7年以上使ってきたThinkPadと別れを告げて購入しました。

{{<summary "https://jp.store.asus.com/store/asusjp/ja_JP/pd/productID.5404863700/varProductID.5404863700/categoryID.5001803600">}}

後日、細かいレビューを書きたいと思います。  
今のところ、顔認証のロック解除や動作など快適ですね 😄

### 生活リズム

6月から通勤が再開しました。  
今まで自宅ワーク用に組んでいたスケジュールの知見を生かしつつ、以下のように変えました。

| 時間帯         | やること                                 |
| -------------- | ---------------------------------------- |
| 起床後         | ルーチン/ふりかえり/朝食/シャワー/身支度 |
| 出勤前(～11時) | クリエイティブな個人活動                 |
| 出勤中         | インプット(見る/読む)                    |
| 午前中         | 雑務                                     |
| 昼休み         | 自由時間                                 |
| 午後           | MTGなど                                  |
| 夕方           | 休憩                                     |
| 夜(～21時)     | 開発                                     |
| 退勤中         | インプット(見る)                         |
| 退勤後         | 軽食/シャワー/インプット(見る)           |

クリエイティブな活動は仕事/プライベートでそれぞれ2時間程度です。  
時間は短いですが、その分集中力が上がることを期待しています。

### iPad Proと共に過ごす

年度末に`iPad Pro12.9インチ`と`Apple Pencil`、`Magic Keyboard`を購入しました。

{{<summary "https://www.apple.com/jp/ipad-pro/">}}

{{<summary "https://www.apple.com/jp/apple-pencil/">}}

{{<summary "https://www.apple.com/jp/ipad-keyboards/">}}

自宅待機期間中の利用シーンは家のみでしたが、出勤が再開して幅が増えました。  
1週間使った限り、以下のように感じています。

* `iPad Pro`と`Apple Pencil`は持ち運ぶ価値がある
* `Magic Keyboard`は持ち運ばない方がいい (重い/そこまで使わない)
* ディスプレイやプロジェクターへのミラーリングも実用的
* 特に少人数でのMTGで効果がある

### ThinkSpaceを使い始める

上述したiPad ProでThinkSpaceのアプリを使い始めました。

{{<summary "https://apps.apple.com/jp/app/thinkspace/id1335574515">}}

ThinkSpaceは**付箋に手書きで文字/絵を描いて**情報を整理することができます。  
これは、JAM BoardやMiro、GoodNotesにはできないことなので思考整理が本当に捗ります☺️

来週のWeekly Reportでその辺お見せできればと思います。

### Rustを再び学び始める

数年前に一度チャレンジしてから、しばらくいじってなかったRustの学習を再開します。  
会社でRustに詳しい方が、所属PJ内で週1勉強会を開催しているので別PJながら便乗させてもらいました😉

オシャレなCLIコマンドの1つ or wasm周りで成果物を作れたらいいなと思っています。


### Makefile環境をbashに統一する

Windowsの場合にPowerShellを使うか悩みましたが、こだわるところでもハマりたいところでもないためBashに統一しました。

{{<summary "https://mimizou.mamansoft.net/it_note/tools/make/snippets/">}}

MinGWにPATHを通す前提は必要ですが、それくらいなら問題ないでしょう。

### watchEffectではなくwatchを使う

Vue.jsのComposition APIで`watchEffect`を使っていましたが`watch`にしました。  
`v-model`でbindしたstateの要素に代入したりすると予期せぬ挙動になったためです。

Composition API周りは近いうちにまとめて記事書きたいですね。


所感
----

そこまで分量ないだろと思って書き始めたら、意外とネタがありました..。  
内容よりペースを優先して、決められた時間で続けていければと思っています。


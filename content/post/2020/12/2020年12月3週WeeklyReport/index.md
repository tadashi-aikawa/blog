---
title: 2020年12月3週 Weekly Report
slug: 2020-12-3w-weekly-report
date: 2020-12-21T09:55:50+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
---

📰 **Topics**

この週の目玉は`Playwrightでe2eテストを書いてみた`のブログ記事です。  
先週から調べた内容を含めてまとめましたので是非ご覧ください😄

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### Playwrightでe2eテストを書いてみた

2~3年ぶりにe2eテストのブログ記事を書きました。

{{<summary "https://blog.mamansoft.net/2020/12/20/playwright-realtime-e2e-web-test/">}}

既に利用されている方にとっては当たり前の情報ばかりだと思います。  
一方、はじめて使う方にとっての参考になればと願っています。

より踏み込んだe2eテストノウハウは、今後実践を重ねたあとに執筆したいですね😁

### 【Element UI】el-menuでpathと同期するようにroutingしたい

調べると色々な方法が出てくるので、最もシンプルなケースを書きました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/element/faq/#pathrouting">}}

### 【Flexbox】縦の一番下に配置したい

サイドバーの一番下にユーザ情報や設定/ヘルプアイコンなどを載せたい場合。  
間の隙間を表現する1つの方法を書きました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/css/faq/#_4">}}

### 【Flexbox】要素に一定の間隔を開けたい

今までは子要素で`margin`かけていましたけど、`gap`というプロパティがあったのですね..。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/css/faq/#_5">}}


学んだこと
----------

### 【Windows】アドレスバーでコマンド実行

Windowsの標準エクスプローラーにて、アドレスバーでコマンド実行できることを知りました。

`cmd`ってカレントディレクトリでコマンドプロンプトを開きます。  
shellコマンドがインストールされていれば、`rm a* bb`みたいなコマンドも使えます。

### WebM

WebPの動画バージョンとのこと。

{{<summary "https://ja.wikipedia.org/wiki/WebM">}}

WebPと同じく、最新エンコーディングはSafari未対応らしいので様子見ですね。  
エンコーディング最適化したmp4の方がサイズ3倍以上小さかったですし。


読んだこと/聴いたこと
---------------------

### 「無人化システム」を駆逐する組織マネジメントとエンジニアリング

とてもいい記事です。  
今までZennで読んだ記事では圧倒的にNo1です。

{{<summary "https://zenn.dev/tmknom/articles/93f227ad5e55aa">}}

文章が分かりやすく面白いです。それでいて中身があります。  
よくある理想論を語るものではなく、現実的なアプローチが人間的な目線で語られています。

私もコアな無人化システムのリプレイスプロジェクトに軽いノリで投入されてことがあります。  
そのプロジェクトは失敗しましたが、その経験を元にして以降は一定の成果を出せています。

今日まで大切にしてきた学びや経験、それとほぼ同じ事がこの記事には書いてありました。  
エンジニアに限らず、プロジェクトをつくる全ての方に読んでいただきたいです。

> 善意の人への依存にはさらなる副作用があります。短期的には問題が解決したように見えるのです。しかしその問題解決は「対処療法」になります。なぜなら善意の人にとって無人化システムは、本来自分の問題ではないためです。そのため根本解決されません。するとどうなるかといえば、水面下で問題がさらに悪化します。

善意の人に対して適切な対応ができるか.. これがキモだと思っています。  
気持ちだけで乗り換えられるのであれば、このような記事が世の中で脚光を浴びないでしょう。

### エンジニアが「PMも兼任して」と言われたときの心構え

プロジェクトマネージャーはちゃんとやったことないですが、実質プロダクトマネージャーっぽいことはやっているので気持ち分かります。

{{<summary "https://zenn.dev/amakawa_yuki/articles/587985f1978015">}}

心に残ったポイントをいくつか。

> 達成感を得るために目の前のissueを片付けるのではなく、プロダクトとチーム全体を見た上で優先すべきことをやらなければいけません。そして、理解してもらいにくいからこそ「仕様書とDB構成の確認をしてました」だけではなくて、「現在のDB構成だと新機能のリリース後に他ツールとデータ連携ができなくなるリスクがあったので、仕様書と照らし合わせて確認していた」というように自分の作業の内容と意味を説明出来る必要があります。

仕事では価値にどう繋げているのかの説明は不可欠だと思います。  
そのため、長期間にわたるコツコツしたアウトプットの出ないやり方は避けています。  
具体的には以下を心掛けています。

* リアーキテクトは持て時間の全てを注ぎ込んで数日で終わらせる
* リファクタリングは新機能や不具合修正のついでにコツコツやる

なお、アーキテクチャの構成とサンプルは仕事とは別に下準備します。  
本当の大規模システムである場合は難しいと思いますが。

> 私も当初は、PMになってもスキル面で後輩に絶対負けない！くらいの対抗心を燃やしてましたが、チームでの成果を意識し始めてからは、スキル面で抜かされたら後輩に教えてもらおうくらいの気持ちです。

マネジメントやるならメンバにはそうあって欲しいですよね。  
逆にそうでないなら、マネージャーやるべきではないのかもと思ったりします。

> 私の場合、自分が担当しているツール名がslack内で使われるとメンションが飛んでくるように設定しています。こうすることで、新しい運用ルールが作られたり、別チーム内で起きている問題がすぐに分かります。おせっかいの一歩手前を狙って、積極的に巻き込まれていくことが重要です。

私もSlackをエゴサーチしてキャッチするようにはしています..が口出しするかは別ですね。  
あまりおせっかいすると、発言すべき場所で発言できない弱い組織になってしまいます。  
スルーした場合の損失と天秤にかけてですね。サービス障害になるなら必ず口出しします。

### cross-envの凍結

機能を受け入れすぎてしまいメンテナンス困難になってしまったとのこと。  
私も肝に銘じたいですね..。

{{<summary "https://github.com/kentcdodds/cross-env/issues/257">}}


今週のリリース
--------------

### Owlelia v0.18.0~v0.21.0

{{<summary "https://github.com/tadashi-aikawa/owlelia">}}

#### DateTimeのfunction/getter追加

| 追加機能              | 説明                   |
| --------------------- | ---------------------- |
| `DateTime.date`       | Nativeの`Date`型に変換 |
| `DateTime.year`       | 年の取得               |
| `DateTime.month`      | 月の取得(1はじまり)    |
| `DateTime.day`        | 日の取得               |
| `DateTime.plusMonths` | 月の加算               |

#### Date型からDateTimeのインスタンス作成が可能に

`DateTime.of(...)`の引数にNativeの`Date`型を受けつけるようになりました。


その他
------

### 黎の軌跡

Falcomの軌跡シリーズ新作『黎の軌跡』のサイトが公開されました！  
ゲームエンジンやシステム、キャラも一新していて超ワクワクします😚

{{<summary "https://2021.falcom.co.jp/kuro/">}}

しかも2021年発売予定とのことで.. 1年しか待たなくていいとか神すぎますね😭

### Quizletの単語数

先週は単語の追加ありませんでした。140のままです。  
今週は増やしたい..。

---
title: できれば使ってほしいIntelliJ IDEAのAction
slug: idea-actions-if-possible
date: 2019-05-22T15:49:01+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/e74ym27us2kz6yv/man-1205084_1280.jpg
categories:
  - engineering
tags:
  - idea
  - pycharm
---

[IntelliJ IDEA]でできれば使ってほしいActionをまとめてみました。  
Pythonのケースを扱うので[PyCharm]でも使えると思います。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/e74ym27us2kz6yv/man-1205084_128"/>

<!--toc-->


はじめに
--------

本記事は以前に書いた以下の続編です。

{{<summary "https://blog.mamansoft.net/2019/05/20/recommended-idea-actions/">}}

続編を書くつもりはあまり無かったのですが、日本の公式アカウントにリツイートいただけたので頑張ってみました😄

<a class="twitter-timeline" data-height="400" data-width="400" data-theme="dark" href="https://twitter.com/jetbrainsjp?ref_src=twsrc%5Etfw">Tweets by jetbrainsjp</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

以前に定義したランクに対して、本記事では **ランクC** のみを紹介します。

| ランク |               意味               |
| ------ | -------------------------------- |
| A      | 必ず使ってほしい                 |
| B      | 特別な理由がなければ使ってほしい |
| C      | できれば使ってほしい             |
| D      | どちらでもよい                   |


### 書き方のルール

できるだけ実際の業務中のようなシチュエーションを想定したいので、Actionごとに以下を記載します。

* {{<icon "comment">}} `モブプロやレビューでトリガーとなる台詞の例`
* {{<icon "cog">}} には`Action名の絶対パス`を記載
* {{<icon "keyboard">}} には`筆者が割りあてているショートカットキー`を記載

{{<why "デフォルトのショートカットキーを記載しないのはなぜ?">}}
個人的に『ショートカットキーは各自が直感的に使える設定をした方がよい』というポリシーがあるためです。

Action名が分かれば、`Actionの検索`からコマンドを探して実行できます。  
また、**その画面で`Alt+Enter`を押すと即座にショートカットキーを設定できます**ので、すぐに設定しましょう。

以下がその例です。

{{<himg "https://dl.dropboxusercontent.com/s/ljqkh754tq4yx5w/20190518_11.gif">}}

{{</why>}}


### 対象外とするAction

一般的なテキストエディタなどでも使える機能.. 例えば`Ctrl+z`でUndo、`Ctrl+f`で検索といったものは除外します。


### 環境

* OSはWindows
* IntelliJ IDEAのバージョンは2019.1 (Ultimate Edition)


表示系
------

### 設定を表示

* {{<icon "comment">}} `『設定を開いてもらって...』`
* {{<icon "cog">}} `Other | Settings...`
* {{<icon "keyboard">}} `Ctrl+j Shift+s`

そのままなのでGIFは省略します。  
[アクションの検索]で`settings`と入力してEnterでもいいので楽な方で。

### 定義をポップアップに表示

* {{<icon "comment">}} `『この関数/クラスの実装どんなだっけ?』`
* {{<icon "cog">}} `Main menu | View | Quick Definition`
* {{<icon "keyboard">}} `Alt+d`

[宣言に移動]はしたくないけど、定義を確認したいときに便利です。

{{<himg "https://dl.dropboxusercontent.com/s/3qx9b1a7hh5bfo0/20190522_2.gif">}}

### ドキュメントをポップアップに表示

* {{<icon "comment">}} `『この関数/クラスのドキュメントを見せてもらえますか?』`
* {{<icon "cog">}} `Main menu | View | Quick Documentation`
* {{<icon "keyboard">}} `Alt+s`

[宣言に移動]はしたくないけど、ドキュメントを確認したいときに便利です。

{{<himg "https://dl.dropboxusercontent.com/s/zpzqptju165rcxp/20190522_3.gif">}}

### 警告やエラーの詳細表示

* {{<icon "comment">}} `『エラーや警告が出ているので確認してみましょうか..』`
* {{<icon "cog">}} `Main menu | View | Error Description`
* {{<icon "keyboard">}} `Ctrl+1`

1回押すと概要が、2回押すと詳細が表示されます。

{{<himg "https://dl.dropboxusercontent.com/s/ivnppnvti3e72co/20190522_4.gif">}}

マウスHoverして`more...`を押しても表示されますが、キーボードの方が速いです。  
[次のInspectionに移動]して本コマンドで詳細を確認してから、[意図したアクションの提案]で修正が黄金コンボですね😉

### 再帰的に折りたたむ

* {{<icon "comment">}} `『折りたたんでもらって...』`
* {{<icon "cog">}} `Main menu | Code | Folding | Collapse Recursively`
* {{<icon "keyboard">}} `Ctrl+j Ctrl+h`

コードの見通しが悪かったり、特定箇所に集中したいとき使いましょう。

{{<himg "https://dl.dropboxusercontent.com/s/p027kl4sq0b59s9/20190522_13.gif">}}

マウスで端の`-`マークをクリックしても折りたためます。  
代替案があるためランクCにしています。

### 再帰的に展開

* {{<icon "comment">}} `『中開いてもらって...』`
* {{<icon "cog">}} `Main menu | Code | Folding | Expand Recursively`
* {{<icon "keyboard">}} `Ctrl+j Ctrl+l`

{{<himg "https://dl.dropboxusercontent.com/s/p13h9k3az6py3f6/20190522_14.gif">}}

1つずつ展開したい場合は`Recursively`無しのコマンドを実行するか、マウスで端の`+`マークをクリックします。


検索系
------

### 最近開いたファイルから検索

* {{<icon "comment">}} `『さっきのあのファイルを開いてもらって...』`
* {{<icon "cog">}} `Main menu | View | Recent Files`
* {{<icon "keyboard">}} `Ctrl+j e`

最近開いた順にファイルを表示して、更にインクリメンタルサーチで絞り込めます。

{{<himg "https://dl.dropboxusercontent.com/s/07kpipac3r8xjit/20190522_1.gif">}}

便利な機能ですが、[ファイル名でファイルを検索]や[最近移動した場所を検索]で代替が利くのでランクCにしています。


編集系
------

### 関数の抽出

* {{<icon "comment">}} `『この処理を関数に外出ししましょう』`
* {{<icon "cog">}} `Main menu | Refactor | Extract | Method...`
* {{<icon "keyboard">}} `Shift+Alt+m`

選択範囲の処理を関数として抽出します。

{{<himg "https://dl.dropboxusercontent.com/s/dpnnb0ap474zt76/20190522_8.gif">}}

複数の箇所で同一関数を抽出できる場合は、そのようにしてOKかの確認ダイアログが表示されます。


### 行の複製

* {{<icon "comment">}} `『行をコピペして...』`
* {{<icon "cog">}} `Editor Actions | Duplicate Entire Lines`
* {{<icon "keyboard">}} `yyp`

{{<himg "https://dl.dropboxusercontent.com/s/bxea9rj177qugbj/20190522_9.gif">}}

何も選択せずにコピー(Ctrl+c)すると、複製ではなく行全体をコピーします。

### 行の削除

* {{<icon "comment">}} `『行を削除して...』`
* {{<icon "cog">}} `Editor Actions | Delete Line`
* {{<icon "keyboard">}} `dd`

{{<himg "https://dl.dropboxusercontent.com/s/0mbgvjqgytes513/20190522_10.gif">}}

### 次の行に挿入して編集開始

* {{<icon "comment">}} `『次の行に...』`
* {{<icon "cog">}} `Editor Actions | Start New Line`
* {{<icon "keyboard">}} `o`

{{<himg "https://dl.dropboxusercontent.com/s/6d4iihd5wn0mhea/20190522_11.gif">}}

### 前の行に挿入して編集開始

* {{<icon "comment">}} `『前の行に...』`
* {{<icon "cog">}} `Editor Actions | Start New Before Line`
* {{<icon "keyboard">}} `O`

{{<himg "https://dl.dropboxusercontent.com/s/qbnvt2t9ow25193/20190522_12.gif">}}

### 選択範囲を徐々に拡張する

* {{<icon "comment">}} `『(今より広い範囲を示して)ここまで選択してもらって...』`
* {{<icon "cog">}} `Editor Actions | Extend Selection`
* {{<icon "keyboard">}} `Ctrl+s`

Actionするたびに少しずつ選択範囲が広がります。

{{<himg "https://dl.dropboxusercontent.com/s/5wxcrc0sdn5mquh/20190522_15.gif">}}


移動系
------

### 実装に移動する

* {{<icon "comment">}} `『(xxxの子クラスである)yyyのメソッドzzzの実装に飛んでもらって...』`
* {{<icon "cog">}} `Main menu | Navigate | Implementation(s)`
* {{<icon "keyboard">}} `Ctrl+j i`

継承をしている場合、その実装に移動します。  
[宣言に移動]の場合は親クラスのメソッドへ移動するため、動作が異なります。

{{<himg "https://dl.dropboxusercontent.com/s/lm50p5yi2si94c8/20190522_5.gif">}}

1つ目と2つ目の移動が本Actionで、3つ目の移動は[宣言に移動]です。

### 現在のファイルをプロジェクトツリーでアクティブにする

* {{<icon "comment">}} `『今の階層の1つ上に上がってもらって..』`
* {{<icon "cog">}} `Other | Select in Project View`
* {{<icon "keyboard">}} `Ctrl+j w`

{{<himg "https://dl.dropboxusercontent.com/s/mbxdo9tyk3ckc0q/20190522_6.gif">}}

プロジェクトツリー内はインクリメンタルサーチで移動可能なのも便利です。

### 最近開いた順にタブを復元する

* {{<icon "comment">}} `『さっき閉じたファイルをもう1度開いてもらって...』`
* {{<icon "cog">}} `Main menu | Window | Editor Tabs | Reopen Closed Tab`
* {{<icon "keyboard">}} `Ctrl+Shift+t`

GIFの前半で閉じた2つのファイルを、後半で復元しています。

{{<himg "https://dl.dropboxusercontent.com/s/zve3j4ukub62dn5/20190522_7.gif">}}


総括
----

[IntelliJ IDEA]のできれば使ってほしいランクCのActionを紹介しました。

このランクまで使いこなせれば、モブプロ中に困ることはほとんど無いと思います。

ランクDは少しマニアックなActionも登場しますので、また機会があればご紹介します。

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[PyCharm]: https://www.jetbrains.com/pycharm/
[宣言に移動]: https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#%E5%AE%A3%E8%A8%80%E3%81%AB%E7%A7%BB%E5%8B%95-%E4%BD%BF%E7%94%A8%E7%AE%87%E6%89%80%E4%B8%80%E8%A6%A7
[アクションの検索]: https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#action%E3%81%AE%E6%A4%9C%E7%B4%A2
[ファイル名でファイルを検索]: https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E5%90%8D%E3%81%A7%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E6%A4%9C%E7%B4%A2
[最近移動した場所を検索]: https://blog.mamansoft.net/2019/05/20/recommended-idea-actions/#%E6%9C%80%E8%BF%91%E7%A7%BB%E5%8B%95%E3%81%97%E3%81%9F%E5%A0%B4%E6%89%80%E3%82%92%E6%A4%9C%E7%B4%A2
[次のInspectionに移動]: https://blog.mamansoft.net/2019/05/20/recommended-idea-actions/#%E6%AC%A1%E3%81%AEinspection%E3%81%AB%E7%A7%BB%E5%8B%95
[意図したアクションの提案]: https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#%E6%84%8F%E5%9B%B3%E3%81%97%E3%81%9F%E3%82%A2%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E6%8F%90%E6%A1%88
---
title: 基本的には使ってほしいIntelliJ IDEAのAction
slug: recommended-idea-actions
date: 2019-05-20T21:40:09+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/atxizvmzlrltq66/josh-applegate-1357030-unsplash.jpg
categories:
  - engineering
tags:
  - idea
  - pycharm
---

[IntelliJ IDEA]で特別な理由がなければ使ってほしいActionをまとめてみました。  
Pythonのケースを扱うので[PyCharm]でも使えると思います。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/atxizvmzlrltq66/josh-applegate-1357030-unsplash.jpg"/>

<!--toc-->


はじめに
--------

本記事は以前に書いた以下の続編です。

{{<summary "https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/">}}

その中で定義付けたランクに対して、前回はランクAを紹介しました。

| ランク |               意味               |
| ------ | -------------------------------- |
| A      | 必ず使ってほしい                 |
| B      | 特別な理由がなければ使ってほしい |
| C      | できれば使ってほしい             |
| D      | どちらでもよい                   |

本記事では **ランクB** のみを紹介します。

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

### 関数などのパラメータ情報表示

* {{<icon "comment">}} `『その関数の引数なんでしたっけ?』`
* {{<icon "cog">}} `Main menu | View | Parameter Info`
* {{<icon "keyboard">}} `Ctrl+p`

関数の引数パラメータ情報を表示してくれます。

{{<himg "https://dl.dropboxusercontent.com/s/iaw1vjh5evbv3x3/20190520_4.gif">}}

現在位置の引数情報は太字で見やすいのでも良いですね。


検索系
------

### 宣言と使用場所を検索

* {{<icon "comment">}} `『そのクラスってどんな感じに使われていますか?』`
* {{<icon "cog">}} `Main menu | Edit | Find | Find Usages`
* {{<icon "keyboard">}} `Ctrl+j u`

クラス、関数、変数などの宣言場所と使用場所を検索します。  
[宣言に移動/使用箇所一覧]は移動に重点を置きますが、本機能は検索がメインです。

{{<himg "https://dl.dropboxusercontent.com/s/26qg15welmkbvoj/20190520_5.gif">}}

細かく分類されたり、Enterで移動せずにプレビューが見られる他、インクリメンタルサーチにも対応しています。  
また、`Recent Find Usages`を実行すると、最近表示したUsageを再検索します。

[宣言に移動/使用箇所一覧]: https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#%E5%AE%A3%E8%A8%80%E3%81%AB%E7%A7%BB%E5%8B%95-%E4%BD%BF%E7%94%A8%E7%AE%87%E6%89%80%E4%B8%80%E8%A6%A7

### 最近移動した場所を検索

* {{<icon "comment">}} `『xxxがあったさっきの場所に戻ってもらって..』`
* {{<icon "cog">}} `Main menu | View | Recent Locations`
* {{<icon "keyboard">}} `Ctrl+j l`

最近移動した箇所(ファイル名と周辺)を一覧で表示します。  
更にインクリメンタルサーチで検索結果が絞り込まれます。

{{<himg "https://dl.dropboxusercontent.com/s/unx5dbbimwu5n5r/20190520_10.gif">}}



編集系
------

### 直前に出現した単語で補完

* {{<icon "comment">}} `『xxxの...』 (xxxは直前に出てきた単語)`
* {{<icon "cog">}} `Main menu | Code | Completion | Cyclic Expand Word`
* {{<icon "keyboard">}} `Shift+Space`

直前に出現した順で単語を補完します。

{{<himg "https://dl.dropboxusercontent.com/s/3w948p8v212lyde/20190520_2.gif">}}

[コード補完]とは違い、文法や文脈は一切考慮しませんが予測はしやすいのでオススメです。

[コード補完]: https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#%E3%82%B3%E3%83%BC%E3%83%89%E8%A3%9C%E5%AE%8C-%E3%82%A4%E3%83%B3%E3%83%86%E3%83%AA%E3%82%BB%E3%83%B3%E3%82%B9

### 行のコメントアウト/コメントイン

* {{<icon "comment">}} `『そこをコメントアウト(解除)して』`
* {{<icon "cog">}} `Main menu | Code | Comment with Line Comment`
* {{<icon "keyboard">}} `Ctrl+/`

現在行をコメントアウトします。  
複数行選択している場合は、選択されている行全てをコメントアウトします。  
既にコメントアウトされている場合はコメントイン(コメントアウト解除)します。

{{<himg "https://dl.dropboxusercontent.com/s/s0zhj6r44iuz5ns/20190520_3.gif">}}

### 現在のハンクを元に戻す

* {{<icon "comment">}} `『そこリバート(元に戻)してもらって..』`
* {{<icon "cog">}} `Version Control Systems | Git | Rollback Lines`
* {{<icon "keyboard">}} `Ctrl+Alt+z`

現在のハンクに対し、バージョン管理下の状態に戻します。  
マウスでGuttarの差分表示をクリックしても同じですが、キーボード操作の方が速いです。

{{<himg "https://dl.dropboxusercontent.com/s/y8zwepo8x7hqo8a/20190520_9.gif">}}

『元に戻す』と言われた場合はUndoのケースもありますので、ちゃんと確認しましょう。

### 選択範囲/単語指定のマルチカーソル

* {{<icon "comment">}} `『型がxxxになっているところをyyyに変えましょうか』`
* {{<icon "cog">}} `Main menu | Edit | Find | Add Selection for Next Occurrence`
* {{<icon "keyboard">}} `Ctrl+k`

カーソル配下の単語に対して、出現箇所にカーソルを増やせます。

{{<himg "https://dl.dropboxusercontent.com/s/q4lgi6mwzvxkgp0/20190520_1.gif">}}

任意の選択範囲を指定することで、単語以外に対しても同じことができます。

見える範囲であれば検索+置換に比べ直感的に操作ができ、その後に操作を続ける場合も便利です。


移動系
------

### 指定行に移動

* {{<icon "comment">}} `『XX行目の..』`
* {{<icon "cog">}} `Main menu | Navigate | Line/Column..`
* {{<icon "keyboard">}} `Ctrl+l`

指定行に移動します。  
`:`で区切った後に数値を入れると、列数も指定できます。

{{<himg "https://dl.dropboxusercontent.com/s/2lwme1fhsirz4ew/20190520_6.gif">}}

### 最近開いた順でタブ切り替え

* {{<icon "comment">}} `『さっきのタブに戻ってもらって..』`
* {{<icon "cog">}} `Other | Switcher`
* {{<icon "keyboard">}} `Ctrl+Tab`

`Alt+Tab`のように最近開いた順でタブを切り替えます。

{{<himg "https://dl.dropboxusercontent.com/s/cga56305fsvu540/20190520_7.gif">}}

### 次のInspectionに移動

* {{<icon "comment">}} `『エラーと警告がありますね.. (移動して)』`
* {{<icon "cog">}} `Main menu | Navigate | Next Highlighted Error`
* {{<icon "keyboard">}} `Ctrl+Shift+j`

Inspectionとはエラーや警告のようなものです。

{{<himg "https://dl.dropboxusercontent.com/s/3efnvix0s0a2640/20190520_8.gif">}}

移動後に[意図したアクションの提案]とコンボを決めると非常に気持ちいいです😙

[意図したアクションの提案]: https://blog.mamansoft.net/2019/05/18/requirements-idea-actions/#%E6%84%8F%E5%9B%B3%E3%81%97%E3%81%9F%E3%82%A2%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E6%8F%90%E6%A1%88

### 前のInspectionに移動

* {{<icon "comment">}} `『エラーと警告がありますね.. (移動して)』`
* {{<icon "cog">}} `Main menu | Navigate | Previous Highlighted Error`
* {{<icon "keyboard">}} `Ctrl+Shift+k`

`次のInspectionに移動`とほぼ同じなのでGIFは省略します。


総括
----

[IntelliJ IDEA]で特別な理由がなければ使ってほしいランクBのActionを紹介しました。

需要があればランクCの紹介も予定しています。

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[PyCharm]: https://www.jetbrains.com/pycharm/

---
title: 必ず使ってほしいIntelliJ IDEAのAction
slug: requirements-idea-actions
date: 2019-05-18T17:47:12+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/1ly6ljj1rgna7sy/asian-1839802_1280.jpg
categories:
  - engineering
tags:
  - idea
  - pycharm
---

[IntelliJ IDEA]で必ず使ってほしいActionをまとめてみました。  
Pythonのケースを扱うので[PyCharm]でも使えると思います。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/1ly6ljj1rgna7sy/asian-1839802_1280.jpg"/>

<!--toc-->


はじめに
--------

IDEはテキストエディタと比べ、非常に沢山の機能があります。  
一方、その有り余る機能を使いこなせていないと思っている方も多いのではないでしょうか。

そこでIDEで有名な[JetBrains]の製品である[IntelliJ IDEA]について、以下のようにランク分けしてみました。

| ランク |               意味               |
| ------ | -------------------------------- |
| A      | 必ず使ってほしい                 |
| B      | 特別な理由がなければ使ってほしい |
| C      | できれば使ってほしい             |
| D      | どちらでもよい                   |

ランクAとBは使わないと生産性が著しく下がると思います。ペアプロやモブプロ、レビューでは是非使いましょう。  
ランクCとDは他のActionでも代替ができるため、個人の好みによると思います。

本記事では **ランクA** のみを紹介します。

{{<update "2019-05-20: ランクBの記事を書きました">}}
{{<summary "https://blog.mamansoft.net/2019/05/20/recommended-idea-actions/">}}
{{</update>}}

{{<update "2019-05-22: ランクCの記事を書きました">}}
{{<summary "https://blog.mamansoft.net/2019/05/22/idea-actions-if-possible/">}}
{{</update>}}

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


検索系
------

### Actionの検索

* {{<icon "comment">}} `『<コマンド名>を実行してください』`
* {{<icon "cog">}} `Main menu | Help | Find Action...`
* {{<icon "keyboard">}} `Ctrl+Shift+a`

フリーワードでActionを検索する最も大切な機能です。  
これさえあればショートカットキーが確認できるので、これだけは忘れずに。

{{<himg "https://dl.dropboxusercontent.com/s/64nxsnfskv23j0y/20190518_5.gif">}}

### ファイル名でファイルを検索

* {{<icon "comment">}} `『<ファイル名>開いてもらって...』`
* {{<icon "cog">}} `Main menu | Navigate | File`
* {{<icon "keyboard">}} `Ctrl+j f`

{{<himg "https://dl.dropboxusercontent.com/s/a7qiol2auh6987f/20190518_6.gif">}}

### ファイル内のシンボル検索

* {{<icon "comment">}} `『<関数名>の...』`
* {{<icon "cog">}} `Main menu | Navigate | File Structure`
* {{<icon "keyboard">}} `Ctrl+j o`

クラス、関数、プロパティなどを階層構造を保ったまま検索できます。

{{<himg "https://dl.dropboxusercontent.com/s/ocrxp30xwzzgx3k/20190518_7.gif">}}

### プロジェクト内の全文検索

* {{<icon "comment">}} `『プロジェクトのどこかでXXXって記載ありましたっけ?』`
* {{<icon "cog">}} `Main menu | Edit | Find | Find in Path...`
* {{<icon "keyboard">}} `Ctrl+j g`

検索条件はかなり細かく指定できます。

{{<himg "https://dl.dropboxusercontent.com/s/1hcegqk2jvsk6c1/20190518_8.gif">}}

### 呼び出し箇所を階層的に表示

* {{<icon "comment">}} `『この関数の影響範囲はどこまででしょうか?』`
* {{<icon "cog">}} `Main menu | Navigate | Call Hierarchy`
* {{<icon "keyboard">}} `Ctrl+j h`

関数の影響範囲を調べるのに便利です。

{{<himg "https://dl.dropboxusercontent.com/s/kxh9y47ocs7uzf5/20190518_4.gif">}}

宣言された行で実行すると使用箇所一覧が表示されます。


編集系
------

### コード補完(インテリセンス)

* {{<icon "comment">}} `『(コード補完が表示された前提で) XXXのYYYを呼び出して...』`
* {{<icon "cog">}} `Main menu | Code | Completion | Basic`
* {{<icon "keyboard">}} `Ctrl+Space`

`.`を打ったときに表示される候補を明示的に出す場合です。

### 変数名/関数名などの一括変更

* {{<icon "comment">}} `『この変数の名前を変えましょう』`
* {{<icon "cog">}} `Main menu | Refactor | Rename...`
* {{<icon "keyboard">}} `Shift+Alt+r`

{{<himg "https://dl.dropboxusercontent.com/s/2f0r7hs6baai6a7/20190518_1.gif">}}

### コードフォーマット

* {{<icon "comment">}} `『フォーマットかけましょう』 (言われる前にやるのがベスト)`
* {{<icon "cog">}} `Main menu | Code | Reformat Code`
* {{<icon "keyboard">}} `Ctrl+Shift+f`

{{<himg "https://dl.dropboxusercontent.com/s/kpv9a8lqt3hxa3i/20190518_2.gif">}}

本記事では紹介しませんが、ファイルを保存したときに自動でフォーマットがかかるとベストですね😄

### インポートの最適化

* {{<icon "comment">}} `『不要インポートを消しましょう』 (言われる前にやるのがベスト)`
* {{<icon "cog">}} `Main menu | Code | Optimize Imports`
* {{<icon "keyboard">}} `Ctrl+Shift+o`

使用していないインポートを削除したり、インポート文の順序を整理します。

{{<himg "https://dl.dropboxusercontent.com/s/rw0sv296hztj9as/20190518_3.gif">}}

本記事では紹介しませんが、ファイルを保存したときに自動でインポートが最適化されるとベストですね😄

### 意図したアクションの提案

* {{<icon "comment">}} `『そのエラー消しましょ.. (そうじゃなくて..そこでクイックフィックスして..)』`
* {{<icon "cog">}} `Other | Show Intention Actions`
* {{<icon "keyboard">}} `Alt+Enter`

Eclipseではクイックフィックスと呼ばれていた機能です。

{{<himg "https://dl.dropboxusercontent.com/s/7ly014ae4sd0jgp/20190518_12.gif">}}

Import文の自動補完は便利なので是非使いましょう。


移動系
------

### 宣言に移動/使用箇所一覧

* {{<icon "comment">}} `『(関数や変数を指して)飛んでもらって...』『この変数どこで使っていますか?』`
* {{<icon "cog">}} `Main menu | Navigate | Declaration`
* {{<icon "keyboard">}} `Ctrl+]`

マウスだと`Ctrl`を押しながらクリックですが、キーボードの方が速いです。

{{<himg "https://dl.dropboxusercontent.com/s/unerorf9buau58x/20190518_10.gif">}}

### 1つ前に戻る

* {{<icon "comment">}} `『さっきのところに戻ってもらって...』`
* {{<icon "cog">}} `Main menu | Navigate | Back`
* {{<icon "keyboard">}} `Alt+←`

宣言や別ファイルにジャンプした後、元のファイルに戻るため使います。

{{<himg "https://dl.dropboxusercontent.com/s/whg5zxp0xdn1f3w/20190518_9.gif">}}

GIFの前半は`宣言に移動`の挙動です。後半で本Actionを使っています。

### 1つ先に進む

* {{<icon "comment">}} `『(Backで少し戻って確認した上で) さっきのところに戻ってもらって...』`
* {{<icon "cog">}} `Main menu | Navigate | Back`
* {{<icon "keyboard">}} `Alt+→`

`1つ前に戻る`で戻った箇所のコードを確認したとき、その逆を辿って元のコードに戻るため使います。

動きのイメージは`1つ前に戻る`と同じなのでGIFは省略します。


総括
----

[IntelliJ IDEA]で必ず使ってほしいランクAのActionを紹介しました。

次はランクBの紹介を予定しています。

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[PyCharm]: https://www.jetbrains.com/pycharm/
[JetBrains]: https://www.jetbrains.com/

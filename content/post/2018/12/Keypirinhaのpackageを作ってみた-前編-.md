---
title: Keypirinhaのpackageを作ってみた -前編-
slug: create-keypirinha-package-phase1
date: 2018-12-09T02:42:38+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/tf0ur2bvlfjrd1i/piranha-2382115_960_720.jpg
categories:
  - engineering
tags:
  - keypirinha
  - ランチャー
---

KeypirinhaでSlackに通知された予定をTodoist形式に変換するpackageを作ってみました。  
本記事ではKeyprinhaのpackage(プラグイン)を作成する過程で学んだ事を紹介します。

<!--more-->

ボリュームがあるので前編と後編に分けます。

<img src="https://dl.dropboxusercontent.com/s/tf0ur2bvlfjrd1i/piranha-2382115_960_720.jpg"/>

<!--toc-->


はじめに
--------

### keypirinhaとは

Pythonで作られたWindows用のランチャーソフトです。  
Macの方に分かりやすく言うとAlfredのWindow版です。

{{<summary "http://keypirinha.com/">}}

keypirinha本体も非常に便利ですが、この記事では深掘りしません。


### 筆者の環境

* Windows10 Home 10.0.17134


packageについて
---------------

公式ドキュメントに沿って説明します。

{{<summary "http://keypirinha.com/contributions.html">}}


### packageとは何か

packageとはpluginとfileをグループ化したコンテナです。  
ディレクトリまたはzipアーカイブ形式を取ります。

### 4種類のpackage

packageは4つの場所に格納され、それぞれ意味合いが異なります。

先に紹介するものほど優先度が高く、同名のpackageがある場合は優先度の高いpackageが採用されます。

#### Live Package

気軽に弄ることができる個人的なpackageです。  
`\Keypirinha\portable\Profile\Packages`の中にディレクトリ形式で格納されるため変更も簡単です。

#### Installed Packages

非公式だがLive Pakcageとは異なり圧縮されています。
`\Keypirinha\portable\Profile\InstalledPackages`の中に拡張子`.keypirinha-package`を持つzipアーカイブとして存在します。

#### Official Packages

Installed Packageと基本は一緒ですが、公式認定されたものです。
`\Keypirinha\default\Packages`の中に拡張子`.keypirinha-package`のzipアーカイブとして存在します。

#### Internal Package

ハードコーディングされているpackageです。ファイルとして独立していません。


Hello World
-----------

[Live Package]配下にディレクトリを作成しpackageを作成していきます。  
まずはHello Worldのようなものを作ってみましょう。

{{<file "main.py">}}
```python
import keypirinha as kp


class Sample(kp.Plugin):
    def on_start(self):
        self.info("Welcome to Sample!!")
```
{{</file>}}

プラグインは有効パッケージリストに含まれる`*.py`を読み込みます。  
`main.py`は[Live Package]リストに含まれるため読み込まれます。

### ライフサイクル

`main.py`の`Sample`クラスは`keypirinha.Plugin`を継承しており、そこにはいくつかのライフサイクルメソッドが定義されています。

* `on_start()`: 初期化のときに呼ばれる
* `on_sugget()`: ユーザが入力するたびに呼ばれる
* `on_execute()`: ユーザが実行するたびに呼ばれる


入力内容をログに出す
--------------------

ユーザが入力した内容を逐次Consoleに出力してみましょう。

{{<file "main.py">}}
```python
import keypirinha as kp


class Sample(kp.Plugin):
    def on_start(self):
        self.info("Welcome to Sample!!")

    def on_suggest(self, user_input, items_chain):
        self.info(user_input)
```
{{</file>}}

入力時には`on_suggest()`が呼ばれるのでしたね。  
その引数である`user_input`には入力された文字列が入ってきますので、`Plugin.info`でConsoleに出力します。

{{<info "Consoleの確認方法">}}
Keypirinhaのアイコンを右クリックして表示されるメニューから`Open Console`を選択すると表示されます。
{{</info>}}


入力した文字を1文字ずつ分解してリストに出す
-------------------------------------------

入力した文字列に対して、候補一覧を出力してみましょう。

{{<file "main.py">}}
```python
import keypirinha as kp


class Sample(kp.Plugin):

    def create_suggestions(self, label: str):
        return self.create_item(
            category=kp.ItemCategory.USER_BASE + 1,
            label=label,
            short_desc='Short desc',
            target=label,
            args_hint=kp.ItemArgsHint.FORBIDDEN,
            hit_hint=kp.ItemHitHint.IGNORE
        )

    def on_start(self):
        self.info("Welcome to Sample!!")

    def on_suggest(self, user_input, items_chain):
        suggestions = [self.create_suggestions(w) for w in user_input]
        self.set_suggestions(suggestions, kp.Match.ANY, kp.Sort.NONE)
```
{{</file>}}

### set_suggestions

候補を出すには[set_suggestions]で[CatalogItem]のリストをセットします。  

上記コードでは候補を全て出力してソートもしません。

#### マッチ条件

* `DEFAULT`: `FUZZY`
* `FUZZY`: 入力に対してファジー検索でヒットした結果のみ表示する
* `ANY`: 入力にかかわらず全て表示する

{{<refer "keypirinha.Match" "http://keypirinha.com/api/module.html#keypirinha.Match">}}

サンプルコードでは`ANY`を指定しています。

#### ソート条件

* `DEFALUT`: `SCORE_DESC`
* `NONE`: ソートしない
* `LABEL_ASC`: labelのアルファベット昇順
* `TAREGET_ASC`: targetのアルファベット昇順
* `SCORE_DESC`: スコア大きい順 (`Math.FUSSY`との併用をする必要あり)

{{<refer "keypirinha.Sort" "http://keypirinha.com/api/module.html#keypirinha.Sort">}}

サンプルコードでは`NONE`を指定しています。

### create_item

[CatalogItem]を作成するには必ず[create_item]を使ってください。  
以下は必須なフィールドです。

* `label`: 表示される文字列
* `short_desc`: 表示される説明
* `target`: ユニークになるような文字列(識別子)
* `args_hint`: 引数設定
  * `FORBIDDEN`: 引数を受けつけない
  * `ACCEPTED`: 引数を任意で受けつける
  * `REQUIRED`: 引数が必須
* `hit_hint`: 履歴設定
  * `KEEPALL`: 引数込みで履歴に保存される
  * `NOARGS`: 引数なしで履歴に保存される
  * `IGNORE`: 履歴には保存されない
* `category`: ???

[Live Package]: #live-package
[set_suggestions]: http://keypirinha.com/api/plugin.html#keypirinha.Plugin.set_suggestions
[CatalogItem]: http://keypirinha.com/api/catalogitem.html#keypirinha.CatalogItem
[create_item]: http://keypirinha.com/api/plugin.html#keypirinha.Plugin.create_item


動作確認
--------

以下のようになればOKです :smile:

{{<himg "https://dl.dropboxusercontent.com/s/bisne4z1q9aq1b8/20181209-1.gif">}}


総括
----

Keypirinhaのpackage(プラグイン)について、簡単なものを作成して動かしてみました。

後編では更に実用的なものを作るための方法を紹介します。

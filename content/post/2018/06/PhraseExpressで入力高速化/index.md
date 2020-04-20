---
title: "PhraseExpressで入力高速化"
slug: phrase-express-snippet-manager
date: 2018-06-18T03:40:00+09:00
thumbnailImage: images/cover/2018-06-18.jpg
categories:
  - engineering
tags:
  - snippet-manager
  - phrase-express
  - idea
  - vim
  - vscode
---

入力を高速化するため、PhraseExpressというツールを導入してみました。

<!--more-->

{{<cimg "2018-06-18.jpg">}}

<!--toc-->


経緯
----

きっかけは会社のLT大会で紹介されたDashというツールです。

{{<summary "https://kapeli.com/dash">}}

Dashは2つの機能、Documentation BrowserとSnippet ManagerのツールでありMac専用でした。  
Windowsでも同じようなツールが無いか気になり調べてみたところ、PhraseExpressが候補にあがりました。


PhraseExpressとは
-----------------

色々な機能を持ったツールですが、今回はSnippet Managerとして使用しています。  
SnippetはShareしたりクラウドで共有することもできるようです。

{{<summary "https://www.phraseexpress.com/">}}

有償のPro版もありますが、私の場合は無償版で十分でした。  
※ Pro版と無償版の違いも分かっていません..

Portable版をダウンロードして、Dropboxで同期されたディレクトリに格納しています。  
どこでも同じ環境を使うことができるためです。


PhraseExpressの主な機能
-----------------------

私が利用している主な機能の紹介です。  
先ほども述べた通り、非常に多機能なツールのため紹介するのは一部機能のみとなります。


### Snippetによる即時展開

指定したフレーズを入力すると即時に展開されます。  
`Autotext`を`Execute immediately`にする必要があります。

{{<himg "resources/20180618-1.gif">}}


### Snippetのオートコンプリート

指定したフレーズから前方一致する候補を表示します。  
`Autotext`を`SmartComplete`にする必要があります。

{{<himg "resources/20180618-2.gif">}}


### フォームを利用した定型文挿入

文字列やカレンダーなどの入力フォームを表示させ、入力された値に基づいた定型文を挿入することができます。

{{<himg "resources/20180618-3.gif">}}


設定
----

デフォルトの設定ではSnippet入力後のカーソル移動などが遅いので設定を変更します。

* Expert Options
    * Text Insertion
        * Paste Method
            * `Paste text using the Windows Clipboard` に変更
                * デフォルトではkey入力により再現されるため、速度が遅くて動作がおかしくなることがある
            * `Restore clipboard contents after phrase insertion` を外す
                * 一部の環境では正しく挿入されないためクリップボードに残しておく
    * Delays
        * Delay Settings
            * `Program focus change delay`を50くらいにする
            * `Clipboard restore delay`を50くらいにする


環境と動作
----------

残念ながらPhraseExpressで全ての環境を賄うことはできませんでした..。  
上手く動いた環境とそうでなかった環境をそれぞれ紹介します。


### 上手く動いた環境

Windowsの以下ツールでは上手く動きました。

* Slack
* Todoist
* VS Code (Vimアドオンなしの場合のみ)
* Vim (Snippetによる即時展開の場合のみ)

Vimではオートコンプリートの動作が不安定ですが、TABボタンを押すと再び表示されるようになりました。  
また、Snippetの挿入に`Ctrl+V`を使っていると思われる関係上、以下の設定が必要です。

```
if 1
    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
endif
```

上記設定をすると、挿入モードとヴィジュアルモードで`Ctrl+V`は使えなくなります。  
必要になった場合は`Ctrl+Q`を使いましょう。


### 上手く動かなかった環境

フォーマットが崩れたり、Snippetのトリガーとなる文字が残ってしまったり..という問題が発生していました。

* VS Code(Vimアドオンあり)
* IntelliJ IDEA

VS Codeは使う機会が多くないため諦めることにしました。  
Vimアドオンの方が恩恵が大きいですからね..。

IntelliJ IDEAはLive Template機能と併用してみることにしました。  
Live Templateの方が高機能ですし、PhraseExpressが上手く動く環境と用途が分離できそうなので問題ないと思っています。

{{<himg "resources/20180618-4.gif">}}

IntelliJ IDEAのユーザ用設定ディレクトリ配下にある`config/templates` に言語ごとのファイルが作成されます。  
ここをDropboxで同期しておけば、PhraseExpressと同じく全ての環境で設定を共有することができます。


総括
----

PhraseExpressをインストールして環境毎に上手く動作するかを確認してみました。  
しばらくの間は以下のように使い分けをしてみます。

* ブラウザの操作はPhraseExpressをフル活用する
* Vimで使用するフレーズ即時展開にする
* IntelliJ IDEAでは利用せず、Live Templateを使用する
* VS Codeはどうするか迷っている...

Vimで開発するのはbashくらいなので、開発業務には使用しないと思います。  
そこはLive Templateを使う良いきっかけになったと考えておきます。


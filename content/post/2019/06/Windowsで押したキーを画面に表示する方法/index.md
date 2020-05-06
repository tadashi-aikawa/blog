---
title: Windowsで押したキーを画面に表示する方法
slug: show-push-keys-on-windows
date: 2019-06-09T19:15:04+09:00
thumbnailImage: images/cover/2019-06-09.jpg
categories:
  - engineering
tags:
  - keycastow
---

Windowsで押したキーを画面に次々と表示する方法を紹介します。

<!--more-->

{{<cimg "2019-06-09.jpg">}}

<!--toc-->


はじめに
--------

ブログでGIFを作ったり、プレゼンテーションでツールのデモをするとき以下のように感じたことはないでしょうか?  
**『この操作をしているときにどのキーが押されているのかを画面に表示したい..!!』** と..。

こういう感じのやつです😄
{{<himg "https://dl.dropboxusercontent.com/s/88dd6xraor1dbnf/20190609_1.gif">}}

Macでは候補がいくつかありますが、Windowsでは使いやすいツールがありませんでした。

そこで今回はWindowsでも使えるツールを探した結果、[KeyCastOW]を試してみました。

### 環境

|      対象       | バージョン |
| --------------- | ---------- |
| Windows 10 Home | 10.0.17134 |
| [KeyCastOW]     | 2.0.2.4    |


[KeyCastOW]
-----------

{{<summary "https://github.com/brookhong/KeyCastOW">}}

正式名称は`KeyCast On Windows`のようです。  
Mac用に`KeyCast`というOSSツールがあり、そのインスパイアにあたると思います。

### インストール

[Chocolatey]からインストールします。

exeファイルは以下2箇所にインストールされます。

* `C:\ProgramData\chocolatey\bin\keycastow.exe`
* `C:\ProgramData\chocolatey\lib\keycastow\tools\keycastow.exe`

exeを実行して、キーを打ってみると画面に表示されると思います。

{{<why "GitHubでexeが提供されていないのはなぜ?">}}
以下のIssueで言及されているように、マルウェアとしてレポートされてしまい消さざるを得なくなったとのことです..。
{{<summary "https://github.com/brookhong/KeyCastOW/issues/5">}}
{{</why>}}

### 動作速度

他の類似ツールと比較しても非常にスムーズな動きです。  
実行中の方が少し反応鈍くなりますが、必要なときだけ使うのであれば全く問題ないレベルだと思います。

PythonやAutoHotKeyでなく、C++で実装されているだけのことはあると思いました。


### 設定が永続化されない場合は..

設定を変更して`Save`しても、[KeyCastOW]を再起動すると元に戻ってしまう場合は`keycastow.exe`を`管理者として実行`してください。

[Chocolatey]経由の場合はiniファイルが`C:\ProgramData\chocolatey\lib\keycastow\tools\keycastow.ini`にインストールされます。  
このファイルには管理者以外の書き込み権限が付与されていないため、通常起動時は設定が永続化されません。

変更をしない場合は通常の起動でもOKです。

※ もっとスマートな解決策募集中です.. 🙇


### [AutoHotKey]と共存するには

私は[AutoHotKey]のヘビーユーザーです。  
[AutoHotKey]無しで開発をすることはあり得ませんし、Windowsを支持する最大の理由の1つにもなっています。

[AutoHotKey]はスクリプトの性質上、キーボードと連動するツールと非常に相性が悪いです。  
今までにWindowsで同様のツールを探しましたが、ほぼ全てのツールが[AutoHotKey]との連動が上手くいかずに断念しました。

しかし、[KeyCastOW]は条件を満たせば[AutoHotKey]と共存できます!! これは本当に素晴らしいことです👏

その条件とは **『[KeyCastOW]より後に[AutoHotKey]を起動すること』** です。  
`Reload This Script`による再起動でも問題ありません。

[AutoHotKey]をお使いの方は[KeyCastOW]を起動したあとに`Reload This Script`を実行するようにしていきましょう😄


### 筆者の設定

参考までに筆者の設定(iniファイル)を公開しておきます。

{{<file "keycastow.ini">}}
```ini
[KeyCastOW]
keyStrokeDelay=1000
lingerTime=1200
fadeDuration=310
bgColor=4934475
textColor=16777215
labelFont=E0FFFFFF000000000000000000000000BC020000000000000A02013153006F007500720063006500200043006F00640065002000500072006F000000000000000000000000000000000000000000000000000000000000000000000036
bgOpacity=200
textOpacity=200
borderOpacity=50
borderColor=0
borderSize=8
cornerSize=20
labelSpacing=1
maximumLines=10
offsetX=1192
offsetY=1560
visibleShift=0
visibleModifier=1
mouseCapturing=0
mouseCapturingMod=0
keyAutoRepeat=1
mergeMouseActions=1
alignment=1
onlyCommandKeys=0
tcModifiers=1
tcKey=66
branding=Hi there, press any key to try, double click to configure.
comboChars=<->
```
{{</file>}}

使用しているフォントは`Source Code Pro`です。

以上の設定をしてから撮影したGIFが以下です。

{{<himg "https://dl.dropboxusercontent.com/s/cg879uwauykns38/20190609_2.gif">}}

どうも私は無駄に`ESC`を押すクセがあるので、少しずつ直していかなければと思いました..😅


総括
----

Windows環境にて、[KeyCastOW]を使ってキーボードで押したキーを画面に次々と表示する方法を紹介しました。

Vimやショートカットキーに関する記事を書くときは一層捗ると思いますので是非試してみて下さい。
近々あるVimのプレゼンや、本ブログの記事でも有効活用していこうと思っています😄

[KeyCastOW]: https://github.com/brookhong/KeyCastOW
[Chocolatey]: https://chocolatey.org/search?q=keycastow
[AutoHotKey]: https://www.autohotkey.com/

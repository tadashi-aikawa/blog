---
title: Tablacus Explorerで選択画像を一括編集
slug: bulk-edit-images-by-tablacus-explorer
date: 2019-09-29T23:03:41+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/q3eafc0rtnumkw6/cheryl-winn-boujnida-cqgnUEOaW00-unsplash.jpg

categories:
  - engineering
tags:
  - Tags
---

[Tablacus Explorer]上で複数画像ファイルに対して一括編集できるような仕組みを作ってみました。  
本記事では、例してリサイズ(縮小のみ)を扱います。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/q3eafc0rtnumkw6/cheryl-winn-boujnida-cqgnUEOaW00-unsplas"/>

<!--toc-->


はじめに
--------

ブログやドキュメントを書くとき、画像を使うことが多々あります。

その際、オリジナルの画像はサイズがとても大きいです。  
特にデジカメで高解像度撮影した写真などは、普通に10MBを越えたりします。

一方、画像に拘らない人であればブラウザやスマホで閲覧する場合の解像度は1280～1920で問題ない場合があります。  
そこまで解像度を下げると、大抵の場合サイズは数百kb前半まで落ちます。

### 前提条件

OSはWindows10です。


画像の編集にIrfan View
----------------------

[Irfan View]は高速でコンパクトなグラフィックViewerです。

{{<summary "https://www.irfanview.net">}}

Viewerなので画像を1から作成することはできませんが、画像編集に関しては非常に高機能です。  
リサイズで解像度を落とすときに[Irfan View]をGUIとして使っていました。

しかし、ファイル数や頻繁が多くなるとGUIを操作してのリサイズが面倒になってきました。  
そこで、[Irfan View]を立ち上げずに目的を達成できないかを考えました。


Irfan Viewのコマンドラインオプション
------------------------------------

実は[Irfan View]にはコマンドラインオプションがあります。  
これを使って、引数で指定した画像をリサイズするバッチを作ってみました。

### リサイズのコマンド

`/resize`コマンドが使えるなら、以下が一番シンプルだと思います。

```bat
i_view64.exe c:\*.jpg /resize=(500,300) /convert=d:\temp\*.png
```

しかし、今回は以下の要件があったため別の手段をとりました。

* 縦と横の長い方に対して指定したサイズまで縮小したい
* 画像が指定サイズより小さい場合はそのままにしたい

{{<info "コマンドラインオプションのドキュメント">}}
IrfanViewディレクトリ配下の`i_options.txt`にはコマンドラインオプションに関する仕様が記載されています。  
リサイズ以外の操作をコマンドで定義したい場合は使ってみて下さい。
{{</info>}}


### 高度なバッチ変換

GUIで言うところの`File` > `Batch conversion/Rename..` > `Advanced`の設定が必要でした。

{{<himg "https://dl.dropboxusercontent.com/s/u4xgg0sj085cr4l/20190929_1.png">}}

実はコレ、`/advancedbatch`オプションでCLIコマンドでも実行できます。

```bat
i_view64.exe c:\*.jpg /advancedbatch /convert=d:\temp\*.png
```

ただし、[Irfan View]の設定に依存するため使うマシンによって異なる結果になるという問題があります。

### iniファイルを一時的に作成して指定させる

実行時にiniファイルを一時生成することで、環境に依存しない処理を定義できます。

{{<summary "https://stackoverflow.com/questions/46135442/how-to-resize-image-with-same-width-and-height-without-quality-loss-using-irfanv">}}

`/ini`オプションで`iniファイルのありか`を指定してやればOKです。  
たとえばこんな感じでしょうか。

```bat
i_view64.exe c:\*.jpg /advancedbatch /ini=%Temp% /convert=d:\temp\*.png
```

これは`%Temp%`配下に`i_view64.ini`ファイルがあるという想定のコマンドです。

### コード (batファイル)

そうして書いたコードがこちらです。  
この`iresize`コマンドは指定したファイルを上書き(リサイズ)します。

{{<file "iresize.bat">}}

```bat
@echo off
setlocal enabledelayedexpansion

set PX=%~1
(
    echo [Batch]
    echo AdvCanvas=0
    echo AdvNoEnlarge=1
    echo AdvResample=1
    echo AdvResize=1
    echo AdvResizeOpt=1
    echo AdvResizeRatio=1
    echo AdvResizeL=%PX%
    echo AdvSaveOldDate=1
    echo UseAdvanced=1
    echo\
    echo [PNG]
    echo SavePNGTransp=0
    echo SavePNGAlpha=0
    echo PngWndColor=1
    echo PngOut=0
    echo CompressionLevel=6
    echo\
    echo [JPEG]
    echo KeepCom=1
    echo KeepExif=1
    echo KeepIptc=1
    echo KeepQuality=1
    echo KeepXmp=1
    echo Save Progressive=1
    echo Save Quality=95
) >"%Temp%\i_view64.ini"

set /A ARGI=1
for %%f in (%*) do (
    if !ARGI! GTR 1 (
        "C:\Program Files\IrfanView\i_view64.exe" %%f /ini="%Temp%" /advancedbatch /convert=%%f
    )
    set /A ARGI=ARGI+1
)

del "%Temp%\i_view64.ini"
```

{{</file>}}

batの挙動は本記事の趣旨から逸れるため割愛します。  
[Irfan View]のiniファイルに関するポイントだけ表にまとめてみました。

|  パラメータ名  | 指定値 |                                意味                                |
| -------------- | ------ | ------------------------------------------------------------------ |
| UseAdvanced    | 1      | 高度な設定を使う                                                   |
| AdvResize      | 1      | リサイズする                                                       |
| AdvResizeRatio | 1      | 縦横比を保持して縮小する (0にすると縦横比が保持されない)           |
| AdvResizeOpt   | 1      | 縦と横の長い方に対して縮小サイズを指定する                         |
| AdvResizeL     | 128.00 | 縦と横の長い方を128に縮小する                                      |
| AdvResample    | 1      | サンプリングしなおす (0にするとサイズ変更後の画像がぎざぎざになる) |
| AdvCanvas      | 0      | キャンバスをいじらない (1にすると周囲に枠がついてしまう)           |
| AdvNoEnlarge   | 1      | 拡大はしない (0にすると指定サイズより小さいと拡大される)           |
| AdvSaveOldDate | 1      | 更新日時は上書きしない                                             |

### 実行

カレントディレクトリ配下にある1280x800の`sample1.png`を、640x400にリサイズしたい場合は以下のように実行します。  
第一引数に長い辺の縮小後ピクセルサイズを指定します。

```bat
iresize 640 sample1.png
```

複数変数やパターンも受けつけます。

```bat
iresize 640 sample*.png example*.png
```

これで、CLIコマンドとしては実行できるようになりました。  
あとは[Tablacus Explorer]からの実行だけです。


Tablacus Explorer
-----------------

[Tablacus Explorer]はアドオンで拡張できるエクスプローラ互換のタブ型ファイラです。

{{<summary "https://tablacus.github.io/explorer.html">}}

Windowsの標準ファイルエクスプローラーにはタブ機能がないため、それだけでも重宝します。  
あわせて多種多様なアドオンがあるため、カスタマイズ性は非常に高いツールです。

### コンテキストメニューにリサイズを追加する

右クリックを押した時に表示されるコンテキストメニューの項目を作成できます。  
もちろん、挙動も細かくカスタマイズできます😄

{{<refer "Tablacus Explorer 右クリックのカスタマイズ方法" "http://www.eonet.ne.jp/~gakana/tablacus/customize/rightclick/">}}

今回は **選択した画像すべてをアスペクト比を維持して長辺1280pxにリサイズしたい** ので以下のようなメニューを作成しました。

{{<himg "https://dl.dropboxusercontent.com/s/caffbsuh0txyml4/20190929_2.png">}}

先ほど作成した`iresize.bat`を呼び出しています。

### 実行

最後に動作確認です。

{{<himg "https://dl.dropboxusercontent.com/s/ay6ly9eutyqwiwh/20190929_3.gif">}}

上記だと`1280px`ではなく`128px`に変換していますが、変換処理は上手くできています👍


総括
----

[Irfan View]を使って、[Tablacus Explorer]から複数画像ファイルをリサイズする仕組みを作ってみました。

`bat`ファイルであるためターミナルからも実行できます。  
[Tablacus Explorer]以外のエクスプローラーからでも呼び出せれば同じことができるでしょう。

今回はリサイズだけでしたが、減色や回転、特殊効果なども[Irfan View]のコマンドオプションが対応していれば可能です。  
ファイルを上書きせずに別名で保存したり、クリップボードに登録させることもできます。

日々の執筆作業やドキュメント作成、業務の提携作業などが少しでも改善されることを願っています😄

[Irfan View]: https://www.irfanview.net
[Tablacus Explorer]: https://tablacus.github.io/explorer.html

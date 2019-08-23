---
title: AutoHotKeyで特定領域のウィンドウをアクティブにする
slug: activate-window-in-area-by-autohotkey
date: 2019-08-23T07:36:15+09:00
thumbnailImage: https://www.autohotkey.com/assets/images/ahk-logo-no-text241x78-180.png
categories:
  - engineering
tags:
  - autohotkey
---

[AutoHotKey]を使って、特定領域のウィンドウをアクティブにするスクリプトを書いてみました。

<!--more-->

<img src="https://www.autohotkey.com/assets/images/ahk-logo-no-text241x78-180.png"/>

<!--toc-->


はじめに
--------

開発をしていると、視界に入ったウィンドウをアクティブにしたいケースがあります。

* 該当ウィンドウにポインタを移動させてクリック
* 該当ウィンドウに移動するまで`Alt+Tab`を連打

このような方法でやりたいことはできますがスマートとは言えません。

> 『目の前にウィンドウがあるのになぜ瞬時に移動できないんだ。。』

こう思うわけです。

そこで、デスクトップ領域全体を6分割(縦2分割、横3分割)した任意領域にショートカットキーで移動できる仕組みを作りました。


AutoHotKey
----------

仕組みを実現するために[AutoHotKey]を使います。  
[AutoHotKey]はWindowsのための自動化用スクリプト言語です。

{{<summary "https://www.autohotkey.com/">}}

[AutoHotKey]は私がWindowsを使っている最大の理由でもあります😄

本記事では[AutoHotkey]の使い方について触れません。


実装
----

### 処理の流れ

以下のようなロジックでやりたいことを実現します。

1. 任意座標のウィンドウを取得する
2. ウィンドウをアクティブにする
3. 視覚的フィードバックをつける


### 任意座標のウィンドウを取得する

任意のx,y座標を指定したとき、そのウィンドウハンドラを取得する関数を作ります。  
[AutoHotKey]にそのような関数は用意されいないため、`DllCall`でWindowsのDllを呼び出します。


```ahk
;【概要】指定位置のウィンドウハンドラを取得する
;【引数】px: x座標, py: y座標
;【戻値】Window handler
getWindowHandlerAtPosition(px, py) {
    VarSetCapacity(POINT, 8, 0x00)
    NumPut(px, POINT, 0x00, "int")
    NumPut(py, POINT, 0x04, "int")
    HWND := DllCall("WindowFromPoint", "Int64", NumGet(POINT, 0x00, "int64"))
    ANCESTOR_HWND := DllCall("GetAncestor", "UInt", HWND, "UInt", GA_ROOT := 2)
    WinExist("ahk_id" . ANCESTOR_HWND)
    return %ANCESTOR_HWND%
}
```

今回使用するDll関数は`WindowsFromPoint`と`GetAncestor`です。

#### WindowsFromPoint

{{<summary "https://docs.microsoft.com/ja-jp/windows/win32/api/winuser/nf-winuser-windowfrompoint">}}

```cpp
HWND WindowFromPoint(
  POINT Point
);
```

`POINT`構造体(x,y座標)を入力として、ウィンドウハンドラを返却します。

#### GetAncestor

{{<summary "https://docs.microsoft.com/ja-jp/windows/win32/api/winuser/nf-winuser-getancestor">}}

```cpp
HWND GetAncestor(
  HWND hwnd,
  UINT gaFlags
);
```

ウィンドウハンドラ`HWND`の祖先ウィンドウハンドラを返却します。

#### 処理

1. `VarSetCapacity`で`POINT`構造体を8byte確保する
2. `NumPut`で`POINT`構造体に4byteづつ指定された座標のint値を入れる
3. `DllCall("WindowFromPoint"...)`でウィンドウハンドラを`HWND`に取得する
4. `DllCall("GetAncestor"...)`で祖先ウィンドウハンドラを`HWND`に取得する
5. 祖先ウィンドウハンドラが存在すればそれを返す


### ウィンドウをアクティブにする

先の関数を使った結果を[WinActive](http://ahkwiki.net/WinActive)に流し込みます。

```ahk
hwnd := getWindowHandlerAtPosition(x, y)
WinActive, ahk_id %hwnd%
```

{{<info "WinActiveの第1引数について">}}
以下のように様々な指定方法があります。

{{<summary "http://ahkwiki.net/Window">}}

慣れが必要ですが、知ってしまえばほぼ全ての操作が可能です。
{{</info>}}


### 視覚的フィードバックを付ける

ウィンドウがアクティブになったことが分かりにくいので、該当ウィンドウを軽くフラッシュさせます。

```ahk
;【概要】アクティブウィンドウをフラッシュします
;【引数】なし
;【戻値】なし
FlashWindow() {
    WinSet, Transparent, 128, A
    Sleep, 50
    WinSet, Transparent, OFF, A
}
```

[WinSet](http://ahkwiki.net/WinSet)を使って0.5秒だけ透過率50%にしてみました。  
擬似的にフラッシュのような効果を実現します。

### キーにバインドする

あとは任意のキーバインドに処理を記載します。

```ahk
$e::
    ActivateWindow(50, 50)
    FlashWindow()
return
```

これは`e`に`領域の左上にあるウィンドウをアクティブにする`というバインドです。

私の場合は特定モード時、6つに分割した領域へのアクティベートを以下のようにバインドしています。

* 左上: w
* 中央上: e
* 右上: r
* 左下: s
* 中央下: d
* 右下: f


総括
----

[AutoHotKey]を使って、特定領域のウィンドウをアクティブにするスクリプトを紹介しました。

見たウィンドウが一瞬でアクティブになるわけではありませんが、大いなる一歩にはなるのではないでしょうか。


[AutoHotKey]: https://www.autohotkey.com/

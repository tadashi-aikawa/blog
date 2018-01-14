---
title: "効率を2倍にするChrome Extension"
slug: awesome-chrome-extensions
date: 2018-01-14T00:00:00+09:00
thumbnailImage: https://lh3.googleusercontent.com/nYhPnY2I-e9rpqnid9u9aAODz4C04OycEGxqHG5vxFnA35OGmLMrrUmhM9eaHKJ7liB-=w300
categories:
  - engineering
tags:
  - google
  - google-chrome
  - ブラウザ
---

2018年になりましたので久々にGoogle ChromeのExtensionを見直してみました。  
厳選な審査の結果選ばれた4つのExtensionを紹介します。

<!--more-->

<!--toc-->


Vimium
------

Vim精神で作られたHackerのためのブラウザ...を実現するためのExtensionです。

{{<summary "https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb">}}

*『Vim? あのキーバインド気持ち悪いからそんなのいらないよ』* ですって?

ちょっと待って下さい！ Vimiumが素晴らしいのはキーバインドではなくその機能です。  
Vimを一切知らなくても大幅な作業効率向上が見込めます。

### オススメ機能

個人的なオススメ機能のピックアップです。  
方向キーに関する操作はAutoHotKeyで実現しているためピックアップしていません。

|                      機能名                      |  key  |                          機能の説明                           |
| ------------------------------------------------ | ----- | ------------------------------------------------------------- |
| Scroll a half page down                          | d     | 半ページ下にスクロール                                        |
| Scroll a half page up                            | u     | 半ページ上にスクロール                                        |
| Reload the page                                  | r     | ページをリロードする                                          |
| Copy the current URL to the clipboard            | yy    | 現在ページのURLをコピーする                                   |
| Open the clipboard's URL in a new tab            | P     | クリップボードのURLを新しいタブで開く                         |
| Focus the first text input on the page           | gi    | 表示範囲の先頭の入力欄に移動する                              |
| Open a link in the current tab                   | f     | 指定したリンクを開く                                          |
| Open a link in a new tab                         | F     | 指定したリンクを新しいタブで開く                              |
| Open multiple links in a new tab                 | Alt+f | 複数の指定したリンクを新しいタブで開く                        |
| Copy a link URL to the clipboard                 | yf    | 指定したリンクをコピーする                                    |
| Create a new mark                                | m     | マークする                                                    |
| Go to a mark                                     | \`    | マークに飛ぶ                                                  |
| Open URL, bookmark or history entry in a new tab | O     | ブックマーク/履歴をインクリメンタルサーチして新しいタブで開く |
| Open a bookmark in a new tab                     | B     | ブックマークをインクリメンタルサーチして新しいタブで開く      |
| Search through your open tabs                    | T     | Windowを越えて開いているタブをインクリメンタルサーチ          |
| Duplicate current tab                            | yt    | タブを複製する                                                |
| Close current tab                                | x     | 現在のタブを閉じる                                            |
| Move tab to new window                           | W     | 表示中のタブを新しいウィンドウとして独立させる                |

基本的に新しいタブを使うので、大文字の代わりに小文字のキーバインドを割り当てています。

### キーマップ

当然ですが、vimのようにキーバインドも自由自在です。  
Vimiumのオプション画面から`Custom key mappings`に設定を書き込みます。

私の場合はよく使うコマンドが大文字の場合、それを小文字に変更して割り当てています。

```
map t Vomnibar.activateTabSelection
map o Vomnibar.activateInNewTab
map b Vomnibar.activateBookmarksInNewTab
map p openCopiedUrlInNewTab
map w moveTabToNewWindow
```

### 惜しいところ

#### 特定のページでは動作しない

例えば新規タブ画面や拡張機能画面などです。

その場合だけ使わないようにすれば良いと思うかもしれません。  
ただ、タブを移動しているうちにそのタブがアクティブになってしまうと、そこから操作できなくなってしまいます。

上記が理由で`Go to previously-visited tab`をオススメ機能にピックアップしていません。

#### 特定のページでは動作させない方がよい

Gmailや各種Webツールではデフォルトのショートカットキーが割り当てられています。  
それがVimiumのキーバインドと競合してしまうという問題があります。

回避策は主に2つあります。

* 挿入モードにしてからショートカットキーを使う
* 該当ページではExtensionの機能を無効にする

挿入モードを利用すれば使い分けが可能です..が、都度切り替えをするのはかなり面倒です。  
個人的には機能を無効にした方がいいと思います。

Vimiumのオプション画面から`Excluded URLs and keys`に無効にするURLとkeyを設定しましょう。


CLUT: Cycle Last Used Tabs
--------------------------

最後に使用したタブを巡回するExtensionです。  
このExtensionを使うことで、`Alt+Tab`のようなタブ移動が可能になります。

{{<summary "https://chrome.google.com/webstore/detail/clut-cycle-last-used-tabs/cobieddmkhhnbeldhncnfcgcaccmehgn">}}

Vimiumとは異なり、ショートカットキーが重ならなければ全てのページで使用できると思います。  
押しやすいという理由から、ショートカットキーには`Ctrl+J`を割り当てています。

{{<alert "info">}}
ショートカットキーの割り当ては、拡張機能ページ最下部の`キーボードショートカット`から行います。
{{</alert>}}

なお、直近開いたタブが異なるウィンドウの場合でも対象になります。


JSON Viewer
-----------

Jsonをフォーマットして表示するExtensionです。

{{<summary "https://chrome.google.com/webstore/detail/json-viewer/gbmdgpbipfallnflgajpaliibnhdgobh">}}

他のExtensionより優れているポイントが3つあります。

* *表示が遅延評価* のため巨大なJSONでも初回表示が速い
* 全選択=>コピーでも正しいJSONフォーマットでコピーできる
* 正規表現で検索できる

特に1つ目の遅延評価表示は大きなポイントですね。


Create Link
-----------

最後は表示ページの各種リンクを作成するExtensionです。

{{<summary "https://chrome.google.com/webstore/detail/create-link/gcmghdmnkfdbncmnmlkkglmnnhagajbm?hl=ja">}}

デフォルトで指定した形式1つだけ、ショートカットキーを割り当てることができます。  
私の場合は`Plain Text`をデフォルトに指定しています。

Formatは改行を含めた形式 `%text%\n%url%` としています。  
ショートカットキーは`Ctrl+Y`に割り当てています。


総括
----

4つのExtensionを紹介しました。  

特にVimiumは作業効率を大幅に上げることができます。  
新年にVimを学んだおかげで、Vim関連ツールへの敷居が下がり開拓できたと思っています。

Vimに抵抗のある方も一度試してみてはいかがでしょうか?

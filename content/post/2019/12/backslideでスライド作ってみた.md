---
title: backslideでスライド作ってみた
slug: use-backslide-as-a-presentation-tool
date: 2019-12-08T23:58:50+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/2tgw62c1h1hdzpz/norman-tsui-KBKHXjhVQVM-unsplash.jpg
categories:
  - engineering
tags:
  - backslide
  - remark.js
  - reveal.js
  - scss
---

スライド作成に使うツールを[reveal.js]から[backslide]に乗り換えてみました。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/2tgw62c1h1hdzpz/norman-tsui-KBKHXjhVQVM-unsplas"/>

<!--toc-->


はじめに
--------

仕事でしばしばスライドを作る機会があります。  
その場合には以下のいずれかのツールを使ってきました。

|      使うツール      | 共有/共同編集が必要 | 凝ったプレゼンをしたい | ソースコードが多い |
| -------------------- | ------------------- | ---------------------- | ------------------ |
| Google Slides        | O                   | △                      | X                  |
| Microsoft PowerPoint | X                   | O                      | X                  |
| [reveal.js]          | X                   | X                      | O                  |

共有や共同編集をしたい場合は否応がなしにGoogle Slidesでしょう。  
細部まで作り込むには、Microsoft PowerPointの右に出る者はいません。

一方、それらに該当せずソースコードが多い場合などは[reveal.js]のようなHTML Presentation Frameworkが向いています。


HTML Presentation Frameworkに求めるもの
---------------------------------------

正確には[reveal.js]ではなく[vscode-reveal]を使っていました。  
VSCodeだけ完結するお手軽な拡張です。

{{<summary "https://marketplace.visualstudio.com/items?itemName=evilz.vscode-reveal">}}

しかし、半年ほど使ってみると物足りない点がいくつか出てきました。
HTML Presentation Frameworkに必要だと感じている機能は以下です。

|         要件         |              理由              |       [vscode-reveal]        |
| -------------------- | ------------------------------ | ---------------------------- |
| Markdownが使える     | シンプルになるから             | O                            |
| HTMLが使える         | 柔軟な編集が可能だから         | O                            |
| Hot reload           | 手動で都度リロードが面倒だから | X                            |
| 静的サーバにデプロイ | オリジナルを見てほしいから     | X (対応とあるが動かなかった) |

[vscode-reveal]に関しては、以下の点で不安もありました。

* 保存してリロードしても正しく反映されないときがある
* Markdownで表現できず、HTMLに頼ることが多く複雑になる

{{<warn "reveal.jsの挙動について">}}
上記は[vscode-reveal]における話です。  
[reveal.js]の場合は話が異なるかもしれません。

[reveal.js]: https://github.com/hakimel/reveal.js
[vscode-reveal]: https://marketplace.visualstudio.com/items?itemName=evilz.vscode-reveal
{{</warn>}}


backslide
---------

上記の不満点を全て解消してくれるのが[backslide]でした😄

{{<summary "https://github.com/sinedied/backslide">}}

内部は[remark.js]が使われており、[backslide]はそのラッパな位置づけです。

せっかくなのでここから先は[backslide]を使って作ったスライドで紹介させてください😉

　　　↓ 続きはスライドで

{{<summary "https://tadashi-aikawa.github.io/backslide-sample/dist/presentation.html">}}


総括
----

スライド作成に使えるHTML Presentation Frameworkとして[backslide]を紹介しました。  
シーンに応じて、Google SlidesのようなGUIツールと使い分けができればと思います。

[reveal.js]: https://github.com/hakimel/reveal.js
[vscode-reveal]: https://marketplace.visualstudio.com/items?itemName=evilz.vscode-reveal
[backslide]: https://github.com/sinedied/backslide
[remark.js]: https://github.com/gnab/remark

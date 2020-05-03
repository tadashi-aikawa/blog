---
title: "Write Blog Every Week 半年経過"
slug: write-blog-every-week-6-months
date: 2018-10-01T01:48:57+09:00
thumbnailImage: images/cover/2018-10-01.jpg
categories:
  - other
tags:
  - blog
---

Write Blog Every Week宣言をしてから半年が経過しました。


<!--more-->

{{<cimg "2018-10-01.jpg">}}

<!--toc-->


はじめに
--------

3ヶ月継続したときに以下の記事を執筆しています。

{{<summary "https://blog.mamansoft.net/2018/07/02/write-blog-every-week-3-months/">}}

この時に反省した点もあるのでそれを踏まえて直近3ヶ月間の振り返りをしてみました。


良かったこと
------------

### 記事が書きやすくなった

特に見た目がスッキリしたと思っています。  
これはHugoのShortCodes機能を充実させたことによる効果ではないかと考えています。

例えば以下のようなアコーディオンはShortCodesを使っています。

{{<himg "resources/20181001_1.gif">}}

ブログの記事(マークダウンファイル)には以下のように記載されています。

```html
{\{<info "Neovimのインストール方法">}}
内容..
{\{</info>}}

// 本当は`{\{`ではなく`{{`ですが、ShortCodeが展開されてしまうためこのように記載しています。
```


ShortCodesのhtmlファイルは以下です。  
Open時のアニメーションはCSSで実現しています。

```html
<details>
  <summary><i class="fa fa-info-circle alert-word-info" aria-hidden="true"></i> <em class="alert-word-info">{{ .Get 0 }}</em></summary>
  <div class="alert-box alert-box-info">
    {{ .Inner | markdownify }}
  </div>
</details>
```


### インプットをアウトプットして次のインプットに繋げられている

前回の反省点に上げたものです。  
この3ヶ月間はよくtryできたと思っています。

特に今すぐ書けないものをTODOとして後に回すやり方はかなり有効だと思いました。  
最近流行っている[Scrapbox]の思想もこれに近いところがあるかもしれません。

[Scrapbox]: https://scrapbox.io/product

なお、この3ヶ月間のインプットは以下の様なものです。

* Rustでツールを作成
* Goでツールを作成
* VueとNuxtでツール作成
* VMのUbuntuをTrustyからBionicにバージョンアップ
* Vim/VS Code/CLIなどの開発環境改善


反省点
------

### 執筆の時間が日曜深夜になってしまう

前回と同じ反省点です。。。改善できず。。  
ギリギリまで事を伸ばしてしまう私の悪い癖です :tired_face:

> 次の3ヶ月間はできれば土曜日、遅くても日曜の21時までに執筆完了することを目指したいと思います。

3ヶ月前の自分はこんなことを言ってしましたが、必要に迫られなければなかなか難しいですね..。  
継続はできているのでこのまま様子見してみます。


総括
----

Write Blog Every Weekを実践開始して半年継続したことを報告しました。  
いつもギリギリではありますが、ほぼ習慣化できてきたのは大きな進歩です。

2018年が終わるまで引き続き継続できるよう頑張ります。


### 余談

数日前に閃の軌跡4が発売されたのでプレイしています。  
英雄伝説シリーズは1から全てプレイしておりますが、今作は2003年から15年続いた軌跡シリーズ前半終了ということで節目ですね。

<a href="https://hb.afl.rakuten.co.jp/hgc/0b6fa604.dcc2d754.0b6fa605.dc4d2e1e/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fjism%2F4956027126932-54-27073-n%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fjism%2Fi%2F12015697%2F&link_type=pict&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0Iiwic2l6ZSI6IjQwMHg0MDAiLCJuYW0iOjEsIm5hbXAiOiJyaWdodCIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjEsImJidG4iOjF9" target="_blank" rel="nofollow" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0b6fa604.dcc2d754.0b6fa605.dc4d2e1e/?me_id=1206032&item_id=12015697&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fjism%2Fcabinet%2F0768%2F4956027126932.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fjism%2Fcabinet%2F0768%2F4956027126932.jpg%3F_ex%3D400x400&s=400x400&t=pict" border="0" style="margin:2px" alt="" title=""></a>

この影響で10月の記事は中身が薄くなってしまうかもしれませんがご了承を...


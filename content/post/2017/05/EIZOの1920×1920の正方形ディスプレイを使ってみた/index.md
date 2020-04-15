---
title: EIZOの1920×1920の正方形ディスプレイを使ってみた
slug: eizo-ev2730q-use
date: 2017-05-12T09:05:12+09:00
thumbnailImage: "images/cover/2017-05-12.jpg"
categories:
  - gadget
tags:
  - ディスプレイ
---


EIZOの正方形モニタ EV2730Q を1週間ほど使ってみたのでレビューします。

<!--more-->

{{<cimg "2017-05-12.jpg">}}

<!--toc-->


経緯
----

今までは同じEIZO社のL997を2台構成で使用していました。(片方縦置き)  
ただ、以下の理由で少し物足りなさを感じてモニタを増やしたいと思っていました。

* 会社では5画面で仕事をしている
* デスクが広いのでもう1画面置くことができる
* 正方形ディスプレイに凄く惹かれた

ちょうどボーナスも入ったばかりであり、腱鞘炎でノートPCの使用を禁止していたためポチってしまいました。

<div class="img-horizontal">
    <a href="https://hb.afl.rakuten.co.jp/hgc/0ef94cae.e2829df1.0ef94caf.dd6ba885/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbiccamera%2F4995047045526%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fbiccamera%2Fi%2F10812489%2F&link_type=pict&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0Iiwic2l6ZSI6IjQwMHg0MDAiLCJuYW0iOjEsIm5hbXAiOiJkb3duIiwiY29tIjoxLCJjb21wIjoiZG93biIsInByaWNlIjoxLCJib3IiOjEsImNvbCI6MH0%3D" target="_blank" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0ef94cae.e2829df1.0ef94caf.dd6ba885/?me_id=1269553&item_id=10812489&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbiccamera%2Fcabinet%2Fproduct%2F1487%2F00000003055119_a01.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbiccamera%2Fcabinet%2Fproduct%2F1487%2F00000003055119_a01.jpg%3F_ex%3D400x400&s=400x400&t=pict" border="0" style="margin:2px" alt="" title=""></a>
</div>


見た目
------

配置してみました。  
真ん中にEV2730Qを配置し、両端にL997縦置きという豪華構成です。

{{<himg "resources/36b499c3.png">}}

店頭で見るほど大きい印象は受けません。  
L997と比べて、何より軽く、薄い.. そしてベゼルが狭いのがいいですね。

なお、ドット欠けはありませんでした。  
最近ではEIZOのドット欠け保証がありますが、本製品は制度ができる前のものであるため保証対象外かもしれません。


画質
----

L997と比較しても目立った違いは感じません。  
大画面液晶にありがちな、ギラツブや文字が浮き出る感じもないです。

ドットピッチはL997より少し小さいので、文字も少し小さく見えます。  
読みやすい大きさとは言えませんが、支障が出るほど小さくも無いので許容範囲です。

ただし、画面調整は必要だと思います。  
カラー調整を以下の設定にすることでL997と並べても違和感が無くなりました。

* ブライトネス: 10
* コントラスト: 40
* 色温度: 5500K
* ガンマ: 2.2


使用感
------

### 疲れ

設定をした甲斐もあって、目の疲れはL997に近いレベルまで軽減できていると思います。  
また、上下の視野が今までの1.5倍以上になるため、首が疲れるか心配でしたが問題ありませんでした。

### 画面の使い分け

AutoHotKeyを使用してキーボードで瞬時にウィンドウできるようにしています。  
それもあり、3画面をそれぞれ縦で2分割して 実質6画面へウィンドウを移動できるようにしています。

コーディングするときは本モニタをフルスクリーンにして、両端液晶でデバッグ + 調べ物 + メモをすることが多いですね。  
先ほどの写真がそれにあたります。

{{<himg "resources/36b499c3.png">}}


### 正方形画面のメリット

予想通りのメリットは、コーディングの時に見渡しが良いことがです。  
縦にも横にも長いため、Viewを配置しつつ全体の雰囲気を俯瞰することができます。

1280 * 1024 程度のディスプレイだとこんな感じですが...

{{<himg "resources/20170512_2.png">}}

EV2730Qだとここまでになります !!

{{<himg "resources/20170512_3.png">}}

意外だったのはコーディングだけでなく、情報収集やネットサーフィンのやる気が大幅にアップすることでした。  
画面が一覧でき、正方形だと見栄えもよくなることが地味に効いているのかもしれません。


3画面構成の為に必要だったこと
-----------------------------

ディスプレイ自体は素晴らしいですが、初期設定で少しハマリポイントがありました。  
以下のドック 135Qバージョンを使っていますので、その前提になります。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #000000;background-color:#FFFFFF;width:410px;margin:0px;padding-top:6px;text-align:center;overflow:auto;"><a href="https://hb.afl.rakuten.co.jp/hgc/0b6fa80a.6ee2370b.0b6fa80b.eed34a43/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fpc-express%2F4560421491185%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fpc-express%2Fi%2F10546879%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0b6fa80a.6ee2370b.0b6fa80b.eed34a43/?me_id=1204227&item_id=10546879&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fpc-express%2Fcabinet%2Fximg336%2F4560421491185.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fpc-express%2Fcabinet%2Fximg336%2F4560421491185.jpg%3F_ex%3D400x400&s=400x400&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/0b6fa80a.6ee2370b.0b6fa80b.eed34a43/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fpc-express%2F4560421491185%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fpc-express%2Fi%2F10546879%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" style="word-wrap:break-word;"  >【送料無料】Lenovo 40A20170JP ThinkPad ウルトラドック - 170W【在庫目安:僅少】</a><br><span >価格：26233円（税込、送料無料)</span> <span style="color:#BBB">(2017/5/12時点)</span></p></div><br><p style="font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>


### デジタル出力の追加

ドックには出力端子が5つありますが、組み合わせ制限のためデジタル出力は2つまででした。  
公式サイトを調べたところ、USB3.0で出力ポートを増やす製品が紹介されていたため購入しました。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #000000;background-color:#FFFFFF;width:410px;margin:0px;padding-top:6px;text-align:center;overflow:auto;"><a href="https://hb.afl.rakuten.co.jp/hgc/103bee39.2804b6ae.103bee3a.d85bad97/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fioplaza%2F1000-00992315-00000001%2F&m=i%2F10221529%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/103bee39.2804b6ae.103bee3a.d85bad97/?me_id=1230072&item_id=10221529&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fioplaza%2Fcabinet%2Fimg001%2Fzlnv-0b47072.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fioplaza%2Fcabinet%2Fimg001%2Fzlnv-0b47072.jpg%3F_ex%3D400x400&s=400x400&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/103bee39.2804b6ae.103bee3a.d85bad97/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fioplaza%2F1000-00992315-00000001%2F&m=i%2F10221529%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" style="word-wrap:break-word;"  >【税込み】【メーカー保証】レノボ・ジャパン 0B47072</a><br><span >価格：7750円（税込、送料無料)</span> <span style="color:#BBB">(2017/5/12時点)</span></p></div><br><p style="font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

こちらを接続したところ、無事に3画面表示できました。  
VGAのアナログ出力では嫌な予感しかしないのでホッとしています。


### L997が縦画面にならない

2台あるL997の内1台のローテーション機能が上手く動きませんでした。  
こちらは、L997本体の画面設定変更から `その他` => `ActiveRotationⅡ` => `無効` にすることで解決しました。


その他注意ポイント
------------------

### DisplayPortで画面を表示できない

しばらく使っていたらある日、DisplayPortで画面が表示されなくなりました。  
DVIは問題無かったため端子やケーブルの不良を疑いましたが、コンセントの抜き差しで復帰しました。  
どうやら、DisplayPortは動作が不安定のようですね...

### DVIの画面表示はオススメできない

DisplayPortで表示できなくなった時に試しましたが、画面がカクカクします。  
これはフレームレートが60Hz => 30Hzに落ちてしまうからです。

<blockquote class="embedly-card"><a href="http://xn--pc-mh4aj6msdqgtc.com/column/video-output-types.html">HDMI、DVI、DisplayPortの違いは？ゲーミングPCの映像出力端子はどれが人気か調べました</a><p>デスクトップはノートパソコンとは違い、外部液晶モニターが必ず必要になります。デスクトップと液晶モニターを接続するために、それぞれが対応した映像出力端子のケーブルを用います。 BTOゲーミングPCの場合、グラフィックボードの映像出力端子と液晶モニターを接続することになり、HDMI、DVI、DisplayPortから選ぶことになります。 ...</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

1920*1920の解像度では、30Hzが限界でした。  
1秒間に30回再描画されれば十分だろうと思っていましたが、全然そんなことは無かったです。

また、私のWindows10環境では複数画面のうち最も低いフレームレートに統一されてしまいました。  
つまり、3画面中1つが30Hzだと他の画面でも30Hzになってしまいます。


総括
----

迷ったなら買いです！！ 間違い無し！！

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #000000;background-color:#FFFFFF;width:410px;margin:0px;padding-top:6px;text-align:center;overflow:auto;"><a href="https://hb.afl.rakuten.co.jp/hgc/0ef94cae.e2829df1.0ef94caf.dd6ba885/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbiccamera%2F4995047045526%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fbiccamera%2Fi%2F10812489%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0ef94cae.e2829df1.0ef94caf.dd6ba885/?me_id=1269553&item_id=10812489&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbiccamera%2Fcabinet%2Fproduct%2F1487%2F00000003055119_a01.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbiccamera%2Fcabinet%2Fproduct%2F1487%2F00000003055119_a01.jpg%3F_ex%3D400x400&s=400x400&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/0ef94cae.e2829df1.0ef94caf.dd6ba885/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbiccamera%2F4995047045526%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fbiccamera%2Fi%2F10812489%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjB9" target="_blank" style="word-wrap:break-word;"  >【送料無料】 EIZO 26.5型 LEDバックライト搭載液晶モニター FlexScan EV2730Q（ブラック）　EV2730Q-BK[EV2730QBK]</a><br><span >価格：106812円（税込、送料無料)</span> <span style="color:#BBB">(2017/5/11時点)</span></p></div><br><p style="font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

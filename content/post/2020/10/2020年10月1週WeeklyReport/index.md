---
title: 2020年10月1週 Weekly Report
slug: 2020-010-1w-weekly-report
date: 2020-10-05T08:18:12+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

引き続き内容は少なめ..業務の都合上、Go現中心です。  
創の軌跡をやっとクリアしたので、次のレポートはアウトプットを出していきたい。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【Python】Poetryでプロジェクトディレクトリに仮想環境作る方法

Version1.0より前とはコマンドが変わっていました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/python/poetry/snippets/#_6">}}


学んだこと
----------

### 【Golang】テストに必要な技術について

サンプルコードで示せるほどまとまっていないため、利用した技術だけメモ書き程度に。  
後ほど、これらをまとめて記事にしたいです。

#### 委譲できるクラスを作る

InterfaceとStruct、Methodを使って、コンストラクタでclientを委譲できる設計にします。  
`NewXXXService(apiClient)`みたいな感じです。

プロダクションとテストで渡す`apiClient`を変えることでテストできるコードになります。

#### モックの作成

標準のmockを使います。

{{<summary "https://github.com/golang/mock">}}

`go generate`を使って対象コードに修正が入ったら、Mockコードを自動生成できるようにします。

```
//go:generate mockgen -source .\\projects.go -destination ..\\..\\..\\mock\\client\\bitbucket_client\\workspaces\\mock_projects.go
```

`go generate`の書き方でいくつかハマりました..。

* 引数は記載されたソースディレクトリからの相対パス (ルートからの方法もある?)
* `// go:generate` とスペースを入れてはいけない
* 全階層を調べる場合、パスには`./...`を指定する

#### assertライブラリ

『ライブラリに頼らずif文でしっかり書こう！』というのが推奨されてました。  
ただ、私は本質と外れるコードを書きたくなかったので`testify`を使いました。

{{<summary "https://github.com/stretchr/testify#installation">}}

GitHub CLIだって`testify`使ってますし🤗

{{<github "https://github.com/cli/cli/blob/trunk/go.mod#L27">}}


読んだこと/聴いたこと
---------------------

### 【Golang】GOPATH に(可能な限り)依存しない Go 開発環境(Go 1.15 版)

ModulesやGOPATH周りの理解が甘かったので参考になりました。

{{<summary "https://zenn.dev/tennashi/articles/3b87a8d924bc9c43573e">}}

`GOPATH`のデフォルトは`~/go`であり、引き続きこちらを使っていこうと思います。  
特別な拘りはないため、デフォルトを使った方がリスクは低いので。

開発場所を`$GOPATH/src`に縛りたくないので、`GO111MODULE=on`は必須です。  
v1.16からはそれも不要になるとのことで楽しみです😆

{{<summary "https://github.com/golang/go/issues/41330">}}

### 【Golang】CodeReviewComments/Receiver Type

Go言語のコードレビューコメントガイドに、Receiverをポイント型にすべきの項目がありました。

{{<summary "https://github.com/golang/go/wiki/CodeReviewComments#receiver-type">}}

重要だと思ったポイントは以下。

* レシーバーが変更されるならポインタでなければいけない
  * 値型だと変更されないので
    * 値がコピーされた方が変更されるのでエラーにはならない
* レシーバーの構造が大きいならポインタの方がいいかもしれない
  * よほど巨大でなければコピーコストよりヒープコストの方が高いという話も..
* レシーバーのプロパティに変異可能なポインタがなければ、値型の方がいいかもしれない
  * 変異しない(Immutable)であることを主張できる

迷ったらポインタにしておけ..と最後にありますが、適切かは都度意識していきます。


試したこと
----------

### スマホのTOPから必須でないアプリを消す

『起動しやすい場所にアイコンがあるアプリほど起動する』という仮説に基づき、つい開いてしまうSlackをスマホTOPから削除してみました。  
まだ1～2日ですが効果を実感しています。以下のような感じによくなる。

```
スマホでロック画面解除
↓
Slackアイコンをタップしようとして無いことに気付く
↓
『じゃあいいか.. 別のアプリでも起動させようかな..』
```

あとは率先して起動させたいアプリをセットしてどうなるかですね。

### 【AutoHotkey】押しっぱなし回避用設定

AutoHotKeyの押しっぱなし問題を少しでも回避できないかと以下の設定を追加しました。

```ahk
; 変数名解決時に環境変数を見ない (パフォーマンス改善による押しっぱなし対策)
#NoEnv
; 10msのコマンド間スリープを0にする (パフォーマンス改善による押しっぱなし対策)
SetBatchLines, -1
```

あまり期待はしていませんが、少し様子を見てみます。  
なお、以下は既に設定済みです。

```ahk
; キーボードフックを使用する (押しっぱなし防止対策)
#InstallKeybdHook
; 入力モードで割り込みを禁止する (押しっぱなし防止対策)
SendMode Play
```

以下のサイトを参考にしています。

{{<summary "https://did2memo.net/2013/10/03/autohotkey-ctrl-key-is-stuck/">}}

{{<summary "http://ahkwiki.net/Performance">}}

{{<summary "https://sites.google.com/site/agkh6mze/howto/scripting">}}


調べたこと
----------

なし。

整備したこと
------------

なし。

今週のリリース
--------------

なし。

その他
------

創の軌跡、10/1アップデート含めてようやく一通りクリアしました!  
プレイ時間は175時間程度です。

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:504px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:240px"><a href="https://hb.afl.rakuten.co.jp/ichiba/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16317895%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowLCJhbXAiOmZhbHNlfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=20007019&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F8400%2F4956027128400.jpg%3F_ex%3D240x240&s=240x240&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a></td><td style="vertical-align:top;width:248px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/ichiba/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16317895%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowLCJhbXAiOmZhbHNlfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  >英雄伝説 創の軌跡　通常版</a><br><span >価格：3630円（税込、送料無料)</span> <span style="color:#BBB">(2020/10/5時点)</span></p><div style="margin:10px;"><a href="https://hb.afl.rakuten.co.jp/ichiba/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16317895%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowLCJhbXAiOmZhbHNlfQ%3D%3D" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:0"></a><a href="https://hb.afl.rakuten.co.jp/ichiba/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16317895%2F%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIyNDB4MjQwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowLCJhbXAiOmZhbHNlfQ==" target="_blank" rel="nofollow sponsored noopener" style="word-wrap:break-word;"  ><div style="float:right;width:41%;height:27px;background-color:#bf0000;color:#fff!important;font-size:12px;font-weight:500;line-height:27px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td></tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

9月は時間とられてエンジニアリングが全然できませんでしたが、今月は挽回していきたいですね。


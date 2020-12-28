---
title: 2020年11月1週 Weekly Report
slug: 2020-11-1w-weekly-report
date: 2020-11-09T08:28:42+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
---

📰 **Topics**

新しいことをアウトプット/インプット、バランスよくできた一週間でした。  
久々にWebフロントエンドをガッツリ触り、Togowlもリリースしています。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### JetBrains IDEやVS Codeでも使える10のVimプラグイン

私は実践Vimの大ファンです。  
デフォルトを愛する清書を読んだあと、その先にある至高のVimmerを目指すために書きました。

{{<summary "https://blog.mamansoft.net/2020/11/03/jetbrains-ide-vs-code-vim-plugin-10/">}}

この記事では、現実的得られる生産性とメンテコストの落としどころを模索しました。  
その上で使った方がいいと判断した10のプラグインを紹介しています。

是非、実践Vimも読んでみてください..!!

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="background-color:#FFFFFF;width:410px;margin:0px;padding-top:6px;text-align:center;overflow:auto;"><a href="https://hb.afl.rakuten.co.jp/hgc/14a76b37.c0914a83.14a76b38.d3a9cd94/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Frakutenkobo-ebooks%2F6e08bf5776463bf5a3cbc33848706e1f%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Frakutenkobo-ebooks%2Fi%2F13115341%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MCwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjowLCJjb2wiOjB9" target="_blank" rel="nofollow" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/14a76b37.c0914a83.14a76b38.d3a9cd94/?me_id=1278256&item_id=13115341&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Frakutenkobo-ebooks%2Fcabinet%2F4574%2F2000001734574.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Frakutenkobo-ebooks%2Fcabinet%2F4574%2F2000001734574.jpg%3F_ex%3D400x400&s=400x400&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/14a76b37.c0914a83.14a76b38.d3a9cd94/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Frakutenkobo-ebooks%2F6e08bf5776463bf5a3cbc33848706e1f%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Frakutenkobo-ebooks%2Fi%2F13115341%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiI0MDB4NDAwIiwibmFtIjoxLCJuYW1wIjoiZG93biIsImNvbSI6MCwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjowLCJjb2wiOjB9" target="_blank" rel="nofollow" style="word-wrap:break-word;"  >実践Vim 思考のスピードで編集しよう！【電子書籍】[ Drew　Neil ]</a><br><span >価格：2419円</span> <span style="color:#BBB">(2018/1/9時点)</span></p></div></td></tr></table>

### 【Git】tigのインストール方法

ターミナルで動く対話型gitクライアントtigのインストール方法を簡潔にまとめました。

{{<summary "https://mimizou.mamansoft.net/it-note/tools/tig/#tig-top">}}

初見だと見逃しやすいマルチバイト文字対応バージョンも記載しています。


学んだこと
----------

### DNSの名前解決について調べる方法

名前解決に関するトラブル..その場凌ぎでなんとなく対処してきましたが、この機会によく使うコマンドだけ整理してみました。

#### 結果だけに興味あるとき

`nslookup`を使うのがよさそうです。  
WindowsでもLinuxでもデフォルトで使えるのが強みですね。

```
$ nslookup blog.mamansoft.net
Server:         172.24.192.1
Address:        172.24.192.1#53

Non-authoritative answer:
blog.mamansoft.net      canonical name = modest-turing-f3415c.netlify.com.
Name:   modest-turing-f3415c.netlify.com
Address: 157.230.37.202
Name:   modest-turing-f3415c.netlify.com
Address: 157.230.35.153
Name:   modest-turing-f3415c.netlify.com
Address: 2400:6180:0:d1::4df:d001
Name:   modest-turing-f3415c.netlify.com
Address: 2400:6180:0:d1::57a:6001
```

#### DNSサーバから返却される詳細情報が知りたいとき

`dig`を使うのがよさそうです。  
利用するためにはインストールする必要がありそう。

```
$ dig blog.mamansoft.net
; <<>> DiG 9.16.1-Ubuntu <<>> blog.mamansoft.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 61611
;; flags: qr rd ad; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;blog.mamansoft.net.            IN      A

;; ANSWER SECTION:
blog.mamansoft.net.     0       IN      CNAME   modest-turing-f3415c.netlify.com.
modest-turing-f3415c.netlify.com. 0 IN  A       157.230.37.202
modest-turing-f3415c.netlify.com. 0 IN  A       157.230.35.153

;; Query time: 20 msec
;; SERVER: 172.24.192.1#53(172.24.192.1)
;; WHEN: Tue Nov 03 20:05:39 JST 2020
;; MSG SIZE  rcvd: 164
```

名前解決サーバ動詞の詳細を追いたい場合は`+trace`オプションを付けます。

```
$ dig blog.mamansoft.net +trace
; <<>> DiG 9.16.1-Ubuntu <<>> blog.mamansoft.net +trace
;; global options: +cmd
.                       469996  IN      NS      e.root-servers.net.
.                       469996  IN      NS      f.root-servers.net.
      ---- --------------  中略  ------------------------
.                       469996  IN      NS      c.root-servers.net.
.                       469996  IN      NS      d.root-servers.net.
;; Received 811 bytes from 172.24.192.1#53(172.24.192.1) in 860 ms

net.                    172800  IN      NS      i.gtld-servers.net.
net.                    172800  IN      NS      e.gtld-servers.net.
      ---- --------------  中略  ------------------------
net.                    172800  IN      NS      g.gtld-servers.net.
net.                    86400   IN      DS      35886 8 2 7862B27F5F516EBE19680444D4CE5E762981931842C465F00236401D 8BD973EE
net.                    86400   IN      RRSIG   DS 8 1 86400 20201116050000 20201103040000 26116 . kl+yKFOz23cE+eBETpDNRCIiajYJr8UUppc6cPtfRc5gGstjCHQPxbuu 7Si2bS3g/1z3Xyfv0NJLzzLV9tW5XCPTP5z2hoI7jKtmx81KR3MBOkMt FVKlU7UOfvJsHceMqb8p2x7lNVaebkn/rEjMpdnmDhIrdwUuil5QhG0y X3ascnXcNQLqnp7MCDZLLTjOU9sO3bn5P2toiIYcJs0GKvJCE6OK7AM/ S7d5cGb3ADjKwWIDEz3cnuPFs8xp3XimCXHcEkhcrUW50b2Aw3jh64bF b8Qz9wNkUGmeuFjDbz2Yhd6PqtbA9pRlqfqs6iHvWc9alzLeq0kOrJTD 5xjMJg==
;; Received 1175 bytes from 202.12.27.33#53(m.root-servers.net) in 50 ms

mamansoft.net.          172800  IN      NS      dns01.muumuu-domain.com.
mamansoft.net.          172800  IN      NS      dns02.muumuu-domain.com.
      ---- --------------  中略  ------------------------
;; Received 653 bytes from 192.12.94.30#53(e.gtld-servers.net) in 120 ms

blog.mamansoft.net.     3600    IN      CNAME   modest-turing-f3415c.netlify.com.
;; Received 93 bytes from 202.239.23.40#53(dns01.muumuu-domain.com) in 70 ms
```

見方は以下のサイトなどで説明されています。

{{<summary "https://www.kangetsu121.work/entry/2019/08/05/232306">}}


### Brotli

gzipに変わる圧縮方式であるBrotliを初めて知りました。

{{<summary "https://blog.redbox.ne.jp/cdn_brotli.html">}}

きっかけはNetlifyのコンテンツがgzipされない原因を調査していたときに見つけたページ。

{{<summary "https://community.netlify.com/t/bundle-file-not-served-gzip/16808">}}

これ..Brotliが使われていることを意味するんですね。

> x-content-encoding: br

Chrome Dev ToolsのNetworkタブを見ると、圧縮後と圧縮前のサイズが確認できます。

{{<himg "resources/44c820ab.jpeg">}}

### Web Share API

スマホやタブレットで使用する`共有`機能を実現するAPIです。  

{{<summary "https://developer.mozilla.org/ja/docs/Web/API/Navigator/share">}}

ステータスはまだドラフトなので仕様から消える可能性はありますが、Android ChromeとiOS Safariが対応しているため現時点ではかなり有用です。  
同様の機能を実現するクリップボード周りのAPIがモバイルだと課題山積みとなっているため、モバイルの共有方法としては非常に期待しています。

以下はcanvasのデータをblobに変換し、pngとして共有するコードです。

```typescript
canvas.toBlob(async (blob: Blob | null) => {
  if (!blob) {
    showError("Fail to capture a daily calendar.");
    return;
  }

  const image = new File(
    [blob],
    `${state.currentDate.displayDate}.png`,
    {
      type: "image/png",
    }
  );
  try {
    await (navigator as any).share({
      files: [image],
    });
    showSuccess(`Success to capture a daily calendar.`);
  } catch (e) {
    showError(`Fail to capture a daily calendar. ${e}`);
  }
});
```

`share`関数には`files`を指定していますが、これは先のMDNに記載されていない仕様です。  
これは最近査定されはじめたWeb Share API Level 2の仕様です。

{{<summary "https://w3c.github.io/web-share/">}}

Level 2ではテキストだけでなく、画像なども共有可能になっています。すごい！

モバイルでは一通り対応しているように見えますが、バージョンによっては部分的だと思います。

{{<himg "resources/f4d3dc10.jpeg">}}

以下の環境では動作を確認しました。

* Android10
    * Chrome v86
* iPadOS
    * v14以上
    * Safariの実験的機能で`Web Share API Level 2`が有効

Safari14もデフォルトでは使用できなかったため、一般向けに実装するのは時期早々かもしれません。


読んだこと/聴いたこと
---------------------

### 合理的な選択の末に、いつの間にか世の中に取り残される感覚

とても切ない..しかしこの上なく真理を言い当てているなと感じる記事でした。

{{<summary "https://yashio.hatenablog.com/entry/20201102/1604315162">}}

年をとると学ぶ意欲が落ちるのは、脳が劣化するからではない..。  
時間に対する考え方が変わり、時間を投資する恐れが増えるのだと。

> キャッチアップしなくなったのは、自分の興味や関心の方向が定まってきたからなんじゃないかという気がしている。有限な時間の使い方・振り分け方をコントロールしたいという感覚がより強くなっている。（というより「時間は有限だ」という感覚が、年齢を重ねると強くなってくるというか。）昔は自分に合うかどうか、面白いかどうかは知らんけどとにかくやってみよう、それから考えようという態度だった。でも今はほとんど無意識に、自分にとって必要なことかどうか、時間を費やす優先順位がどうかを考えて取捨選択している気がする。それは仕事を始めて余暇の時間が減ったからかもしれないし、既に取り組んでいることにもっとちゃんと注力したいと思っているからかもしれない。好奇心の総量自体は変わらなくても、その方向や幅が固まってきている。そのこと自体は全然悪いことじゃなくても、ただその副作用として取り残される。

最近、少しでも気を抜くとこれになります。  
新しいことを始めない最強の言い訳として..。

たとえ誰からも評価されなかったとしても、幅を狭めないよう生きていきたいですね。

### Why I'm switching from Vim to IntelliJ

VimからIntelliJ IDEAにメイン開発環境をシフトした話です。  
私も現在はIntelliJ IDEAをメインにしており、この記事にはほぼ完全同意でした。

{{<summary "https://browntreelabs.com/from-vim-to-intellij/">}}

Vimは動作が軽いものの、各種開発をするためには馬鹿にならない準備のコストが必要です。  
しかも、それらの環境整備によってVimが重くなり..実はIntelliJ IDEAを使った方がパフォーマンス面でも優れていた.. なんという本末転倒な事態にも散々遭遇してきました。  
Vimの体験は非常に刺激的ですが、チーム開発であればなおのことです。

一方でVimのキーバインドや思想はIntelliJ IDEAでも大いに活用できます。  
先日、そのような落とし所を模索した記事を書きましたのでよろしければ。

{{<summary "https://blog.mamansoft.net/2020/11/03/jetbrains-ide-vs-code-vim-plugin-10/">}}

### What's the deal with SvelteKit?

SvelteKitの目指すところについて説明されている公式の記事です。

{{<summary "https://svelte.dev/blog/whats-the-deal-with-sveltekit">}}

フロントエンドの世界もまたパラダイムシフトの時期を迎え、その先ではbundleがなくServerlessが主体となった世界があるであろう..。  
Svelteはそれを見据えてSvelteKitを開発し、その完成をもってversion1.0としたい..  
という趣旨の内容でした。

ドキュメントやサポートもなく、開発中のものでよければいじることはできるみたいです。

```
npm init svelte@next
```

Svelteは4ヶ月前に少し触ってみて..その時はやはりVueだなと思っていました。

{{<summary "https://blog.mamansoft.net/2020/07/12/2020-07-2w-weekly-report/#svelte">}}

ただ、パラダイムシフトの先まで見据えての戦略となれば話は変わりますね。

個人的には数年後、これが数年前のReactと同じ状態になるのではと思っています。  
bundle地獄や環境構築から抜け出した世界が見てみたいですね😁



試したこと
----------

### 【TypeScript】html2canvas

HTMLを解析して結果をcanvasに描画するマッチョなライブラリ。  
スター数は20000超えと大人気です。

{{<summary "https://html2canvas.hertzen.com/">}}

VuetifyのCalendarコンポーネントでスクロールされる部分を一発スクリーンショット撮れないかな..と思って試しました。

使い方はとても簡単でした。  
特定クラスのDOMをcanvasに変換し、さらにバイナリにして操作するコードです。

```typescript
import html2canvas from "html2canvas";

const canvas = await html2canvas(
  document.querySelector<HTMLElement>(".v-calendar-daily__pane")!,
  {
    backgroundColor: "#1E1E1E",
  }
);

canvas.toBlob(async (blob: Blob | null) => {
    // blobを料理する
}
```

なお、Cross Originから取得している画像ファイルなどは表示されません。  
Optionに`allowTrait: true`を指定すると表示されますが、そうすると`toBlob`や`toDataUrl`が使えなくなります。

{{<summary "https://developer.mozilla.org/ja/docs/Web/HTML/CORS_enabled_image">}}

サーバサイドでCORS対策をすればいいのですが、なかなか面倒ですよね..。  
他に解決策もなさそうなので、Cross Originの画像は一旦諦めることにしました😢


調べたこと
----------

なし


整備したこと
------------

### 【Google Chrome】Bookmark Sidebar

サイドビューに特化したGoogle Chromeのブックマーク管理拡張です。

{{<summary "https://chrome.google.com/webstore/detail/bookmark-sidebar/jdbnofccmhefkmjbkkdkfiicjkgofkdh/related?hl=ja">}}

名前こそシンプルですが私は感動しました😭  
機能は勿論のこと..チュートリアル、デザイン、コンテンツの内容などUXが素晴らしいです。  
今まで使った拡張の中で1番と言っても過言ではないくらい。

見た目もオシャレです。アニメーションも心地よいですよ👍

{{<himg "resources/75e2935c.jpeg">}}

検索やソート順も設定できます。

{{<himg "resources/f3514c4e.jpeg">}}

設定画面も格好良くて気が利いています..!!

{{<himg "resources/9e54ae10.jpeg">}}

しばらく使ってみて、手放せなくなったら寄付したいと思ってます。  
それくらい感動しました😁

### 【Vim】CamelCaseMotionの導入

CamelCaseやlower_caseなどで単語ごとに移動できるモーションを導入しました。  
Vim、JetBrains IDE、VS Codeのそれぞれで使えます。

`]`をで開始するようにしています。

#### Vimの場合

Vundle利用時。

```vim
Plugin 'bkad/CamelCaseMotion'
let g:camelcasemotion_key = ']'
```

#### JetBrains IDEの場合

デフォルトで`]`に割り当てられています。

#### VS Codeの場合


設定でONにします。

```json
  "vim.camelCaseMotion.enable": true,
```

キーバインドも。

```
    {
      "before": ["]"],
      "after": ["<leader>"]
    },
```

### 【Vim】Fernの導入

NerdTreeのようなファイラーです。  
プラグイン形式を採用しており、必要な機能のみを導入する思想です。

{{<summary "https://github.com/lambdalisue/fern.vim">}} 

非同期に処理が行われるため、別の動作を妨げることはないのがポイント。  
ただ描画に関しては別なので、jk押しっぱなし時の描画速度は落ちます。  

`.vimrc`の設定はこんな感じです。

```vim
Plugin 'lambdalisue/fern.vim'
nnoremap <C-j>w :Fern %:h -drawer -width=50<cr>
Plugin 'lambdalisue/nerdfont.vim'
Plugin 'lambdalisue/glyph-palette.vim'
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
Plugin 'lambdalisue/fern-renderer-nerdfont.vim'
let g:fern#renderer = "nerdfont"
Plugin 'lambdalisue/fern-git-status.vim'
```

実現している付加機能は以下。

* `<C-j>w`でカレントバッファに対するツリーを表示
* Nerdfontによるカラーアイコン表示
* Gitステータスの表示

なぜかWindowsだとGitステータスは表示されませんが、Vimにそこまで求めていないので個人的には問題ないです。


### 親ディレクトリに移動するエイリアスの設定

普段よく使うこの移動コマンド。

```
cd ..
```

入力数は少ないですが、チリも積もると馬鹿になりませんよね。  
こちらをエイリアスに登録しました。

#### PowerShell

```powershell
function ..() { cd ../ }
function ...() { cd ../../ }
function ....() { cd ../../../ }
```

#### Bash

```bash
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
```

### 【Git】Git LFS管理をやめる

本ブログとMimizou RoomのGit LFS管理をやめました。  
理由は以下。一言で言うとLFSのユースケースに適さなかっただけです。

* 10Mを超えるような大きなファイルはない
    * 必要なら外部参照にする
* GitHubのLFS Storage容量を使いたくない
    * 1GB制限があるので気を遣う
* 一度コミットしたリソースを変更する機会はほぼない
* NetlifyなどでデプロイするときLFS起因で失敗することがしばしばある

対象リポジトリについては以下の流れを実施しました。

```bash
git lfs uninstall
rm .gitattributes
git lfs ls-files
# begin
git rm --cached **/*.png
# end これを拡張子分繰り返す
git add --all
git commit -m "Git LFSをやめる"
git push
# 一度Localをキレイにする(.git/lfs削除が主な目的)
rm -rf リポジトリ
# cloneしなおし
git clone リポジトリ
```

{{<refer "Git LFS管理しているファイルを通常のGit管理に戻す方法" "https://note.com/nanase_jp/n/nc3933f2bf285">}}


今週のリリース
--------------

### Togowl v2.15.0

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### DailyカレンダーのShare機能

CalendarのDaily表示時のみ、共有ボタンから表示日のカレンダー画像を共有できます。  

{{<vimg "resources/523be439.jpeg">}}

以下の環境における動作を確認しています。

* Android10
    * Chrome v86
* iPadOS
    * v14以上
    * Safariの実験的機能で`Web Share API Level 2`が有効

また、以下の環境で動作しないことも確認済みです。

* PC/iPadOSのChrome

共有するカレンダー画像はpngです。  
プロジェクトアイコンは表示されませんが1日の予定が全て入ります。

やや強引な実装をしているため、どこかのバージョンで非対応になる可能性があります🙇‍♂️

共有できる画像イメージです。

{{<vimg "resources/823841e1.jpeg">}}

縦に長いですねw


その他
------

### Quizletの単語数

本日時点での単語数は83(+15)です。

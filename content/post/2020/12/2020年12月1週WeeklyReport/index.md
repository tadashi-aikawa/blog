---
title: 2020年12月1週 Weekly Report
slug: 2020-12-1w-weekly-report
date: 2020-12-07T20:14:14+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
---

📰 **Topics**

インプットと共にアウトプットを形に出せた一週間でした。  
`学んだこと` `試したこと` `調べたこと` の項が `書いたこと` に移るのは良きこと😊

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【ブログ】NuxtでPWAが更新されない問題の調査

[Togowl]のデプロイをしたのに、 リロードしても最新にならないトラブルに遭遇しました。  
関連記事を探しても、バージョンを下げるといった消極的な方法しかなかったので書きました。

[Togowl]: https://github.com/tadashi-aikawa/togowl

{{<summary "https://blog.mamansoft.net/2020/12/02/nuxt-pwa-not-updating/">}}

結論から言うと、現時点で依存関係を最新にすれば恐らく解決します。  
ただ、うまくいかなった理由やPWAの基礎知識は知っておいても損はないと思います。

### 【TypeScript】リリースノート v3.5

TypeScript v3.5のリリースノートをまとめ終わりました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/3.5/">}}


### psql

たまにPostgreSQLをターミナルで操作するのですが、毎回psqlコマンド忘れるので書きました。

{{<summary "https://mimizou.mamansoft.net/IT_Note/tools/psql/">}}

### Vueのイベント修飾子で伝播を停止させる

クリックを親に伝播させたくないとき、`<div @click.stop="onClick">hoge</div>`のように書けます。  
今まで`stopPropagation`を真面目に実装していました..。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/vue/faq/#_2">}}



学んだこと
----------

なし.. というよりは学びをすべてアウトプットしてしまった感じです。


読んだこと/聴いたこと
---------------------

### 仕事への向き合い方を考える　ジョブ・クラフティングとは？

当事者意識をベースに『Job』『Career』『Calling』の仕事観を持つお話。

{{<summary "https://note.com/yawarakamegane/n/nd54bd9626678">}}

見方によって変わりますが、概ねCallingで仕事させてもらっているかなと思っています。  
私が提供したい価値はEfficiencyです。

関わっているサービスはその限りでありませんが、社内でサービスをつくっている人達をサポートするツールを提供/開発させてもらっているので。

### 【Golang】実用 Generics: Python の itertools を Go 2 に移植してみた

Go2のジェネリクスを使ってPythonのitertoolsを実装してみた記事です。  
ジェネリクスにはかなり期待しているので読んでみました。

{{<summary "https://www.zopfco.de/entry/2020/12/01/173210">}}

いや、ほんとこの一文に尽きますね。  
私も絶対に`interface{}`を使いたくありません..。

> Go においては、コードの再利用性や短さのために interface{} を使った処理を書くことは一般的に悪手とされる*2。実際の型 (underlying type) が int だったり string だったりする interface{} を加工するには、 type assertion なる概念で事前に具体的な型を「主張」することになるのだが、ちょっとミスると即 panic するため極めて危険だ*3。最後の手段として reflection を使ったとしても、同様あるいはそれ以上の地獄が待ち構えていることだろう*4。

go2goなんてものがあるのですね..!!  
`dev.go2go`ブランチで開発されているようです。

{{<summary "https://github.com/golang/go/tree/dev.go2go/src/cmd/go2go">}}

ジェネリクスを試してみたいならこれを使えばよさそう。

### 指導者は自分を棚にあげるべき理由

自分ができていないから言わない..ではダメだよという話。

{{<summary "https://neko-luna.com/leader-is-should-put-myself-on-the-shelf">}}

私も普段から棚に上げつつ、指摘したから自分も気を付けないとと奮い立たせています。  
相手ではなく自分にもメリットのある話。

* 他人への指導を通して、自分自身が気付かなかった自分自身へのFBになる
* 他人に指導することで、今後自分がその事柄をしっかり行うようになる

信頼関係がないと面倒毎が増えるリスクがあるため、避けたくなる気持ちは分かりますけどね。

### 【GitHub】The State of the Octoverse

GitHubの年次レポートです。

{{<summary "https://octoverse.github.com/">}}

3年前にはじめて10位にランクインしたTypeScriptが、4位まで浮上していて嬉しかったです☺

TypeScriptをはじめたのは2016年頭、会社で導入(恐らく初)したのも同じ頃です。  
当時は新しいプロダクトも当たり前のようにJavaScriptで書かれていてモヤモヤしていましたが、最近では大抵のケースで『TypeScriptを使うか?』の検討が行われていることも裏付けになりますね。

5以上の社内プロダクトで使ってきた限りでは後悔したことはありません。  
感謝は星の数ほど🌠😉

TypeScriptは **『本来ないはずの型があると思い込ませている中途半端な言語だ』** という方もいますが、実装の手段としている身からすれば十分です。

### Understanding Memory Leaks in Nodejs

Node.jsのメモリリークについて、とても分かりやすく説明された記事。  
もちろんJavaScriptにも置き換えられます。

{{<summary "https://blog.bitsrc.io/memory-leaks-in-nodejs-54ac7bbd4173">}}

今まで見た記事の中では一番分かりやすく、そして必要なところまでは踏み込んでいると感じました。  
気をつけたほうが良さそうな項目のみピックアップします。

#### global変数はGCされない

サイズの大きいglobal変数を使う時は注意が必要です。  
どうしても必要な場合はGCさせるため、不要になった時点で`undefined`を代入しましょう。

#### DOMへの参照が残っているとDOMを消してもGCされない

`const ref = document.getElementById("...")`で取得した参照`ref`が有効なら、取得元のDOMを`document.body.removeChild(...)`などで削除してもメモリには残り続けます。  
参照を保存した変数に`undefined`を代入しましょう。

#### Listenerで使っている変数はListenerを削除しないとGCされない

`element.addEventListener`で追加したListenerが不要になったら、`element.removeEventListener`で削除しましょう。

#### Closureの中で定義した変数は未使用でもGCされない

Closureが返却するFunction内で使われている/いないに関わらず、代入した変数が有効な内はGCされません。  
不要な変数は削除し、必要な場合はClosureの返却値がリークしないように気を付けましょう。

#### timerはクリアしなければGCされない

`setInterval`には`clearInterval`、`setTimeout`には`clearTimeout`がそれぞれ必要です。  
特に`setTimeout`は一度きりの処理であるため、clearを忘れがちです。

{{<why "setTimeoutは本当にメモリリークするのか?">}}
記事には書かれていましたが身に覚えがないので少し調べてみました。  
しばらくすればGCが呼ばれるという内容も多く目にするので問題ないのかもしれません..。
{{</why>}}


試したこと
----------

なし。


調べたこと
----------

なし。


整備したこと
------------

### IntelliJ IDEA 2020.3

Stableがリリースされましたのでバージョンアップしました。

{{<summary "https://www.jetbrains.com/ja-jp/idea/whatsnew/">}}

気になった機能をピックアップします。

#### IntelliJ IDEA をファイルを開くためのデフォルトアプリケーションに設定

ダブルクリックでIntelliJ IDEAから開けるようにできるアレです。  
ターミナルからもファイル名を指定するだけで開けるのは便利です😄

#### Gitステージのサポート

今までは独自のchangelistで管理されていましたが、ようやくGit標準のステージが入りました。  
ただし、初期設定は無効なので`Settings / Preferences | Version Control | Git`に移動して`Enable staging area`をチェックする必要があります。

慣れていないせいもあり、今はデメリットだけが目に付いてしまいます。

* 手動でStageするのが面倒くさい (`Ctrl+Alt+a`を使っても)
* 毎回`Staged`と`Unstaged`が折りたたまれる

探せば設定があるかもしれませんが一旦様子見で。

#### Code With Me EAP

リアルタイムに共同編集できるプラグインのEAP版。  
VSCodeでは1年以上前からある機能ですが、本格的な開発にVSCodeだと心許ないこともありJetBrains IDEを使い続けているので今後に期待しています。

JetBrainsサーバにソースコードをアップロードしなければいけないと聞いていたため、業務利用は厳しいと思っていたのですが、いつの間にかオンプレ対応されてますね。

{{<summary "https://blog.jetbrains.com/blog/2020/10/13/cwm-on-premises-eap/">}}

### Node.jsをv14.15.1にバージョンアップ

Node.jsのLTSが少し前にv12からv14に変わったためバージョンアップしました。

{{<summary "https://nodejs.org/ja/blog/release/v14.15.0/">}}

開発プロダクトも順次v14にしていく予定です。

`Windows`
```
scoop update nodejs-lts
```

`Ubuntu`
```
$ n lts
```


今週のリリース
--------------

### Togowl v2.19.1 ～ v2.22.1

#### 今日より前のタスクを一番上に表示

やり残したタスクが一目瞭然になりました。  
まあ..日が変わる前にすべて終えることをオススメしますが😅

{{<himg "resources/2.20.0-1.gif">}}

#### タスク検索タブを開いたとき入力欄にフォーカスを移す

フォーカスをあわす手間が省けます。

{{<himg "resources/2.20.0-2.gif">}}

#### 繰り返しタスクのアイコン表示

PCはホバー、スマホの場合はクリックで表示されます。

{{<himg "resources/2.21.0-1.gif">}}

#### タスク検索リストに計測開始ボタンを追加

{{<himg "resources/2.21.0-2.jpeg">}}

『タスクは必ず本日のリストに登録してから計測すべし』という方針のため外した機能です。  
しかし、以下のケースは↑のメリットより手間が上回るため追加しました。

* 数分～十数分の隙間時間ができた
* 隙間時間内だけ実施し、完了しなかったら当初の予定通り進める

本日の計画を立てないままタスクに取り組むための機能ではありませんゆえ..。

#### Time Dividerのデザイン変更

Schedulerタブと同様、TimerタブでもTime Dividerのレイアウトを変えました。  
表示は変わりましたが、今までと同様にTodoistの1タスクとして扱えます。

{{<vimg "resources/f077b558.jpeg">}}


その他
------

### Quizletの単語数

本日時点での単語数は123(+18)です。  
毎日すべての単語を単語帳学習していますが、100を超えてから大変になってきました😅

---
title: 2020年10月4週 Weekly Report
slug: 2020-10-4w-weekly-report
date: 2020-10-26T10:18:11+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - typescript
  - vscode
  - javascript
  - nodejs
  - golang
  - scala
  - vim
  - nerdtree
  - pixel
  - gruvbox
  - pytest
  - markowl
  - jumeaux
---

📰 **Topics**

幅広いインプットをしつつ、Pythonのアウトプットを出した週になりました。  
Pixel5の導入やJumeauxの1000commit達成など、個人的な節目もあった一週間でした。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【TypeScript】リリースノート v3.2

TypeScript v3.2のリリースノートをまとめ終わりました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/3.2/">}}

目玉機能はありませんが、エッジケースで利用できる機能が多かったイメージです。


学んだこと
----------

なし..ですが他の取り組みによる副次的な学びは多数ありました。


読んだこと/聴いたこと
---------------------

### 【VSCode】The Era of Visual Studio Code

Visual Studio Codeの時代であることを丁寧に説明してくれている記事。

{{<summary "https://blog.robenkleene.com/2020/09/21/the-era-of-visual-studio-code/">}}

今までは数年単位で流行りのエディタが変わり、学習コストの割が合わないと思っていた。  
...がVS Codeは違う..!!  今後10年以上に渡ってExcelのように使われ続けるだろうというもの。

Microsoftが牽引するOSSであり、毎月のようにかなりの対応がリリースされているので納得です。  
もちろん、機能も一級品。

私が使うエディタ3本柱は `IntelliJ IDEA` `Vim` `VS Code` ですが、万人に1つお勧めするとしたら間違いなく`VS Code` でしょう。

ワガママを言うなら、Vim拡張を使ったときのパフォーマンスが難点かなと思っています。  
そのため、大きなファイル編集や通常の開発では `IntelliJ IDEA` を使っています。

一方、WSLやリモートサーバ内で開発したり、学習目的では`VS Code`を使います。  
`IntelliJ IDEA`は便利に使うなら有料必須であり、リモート連携にも課題があるためです。

### 【JavaScript】Why Should You Use Top-level Await in JavaScript?

Top level awaitをなぜ使うのか紹介されている記事。

{{<summary "https://blog.bitsrc.io/why-should-you-use-top-level-await-in-javascript-a3ba8139ef23">}}

ずっと『Top Level awaitはindex.tsでasync mainを書かなくてもよくする機能だ』と思い込んでいましたが、実際は非同期処理を含むモジュールの初期化処理を助けるものであるということが分かりました。  
だからTypeScriptのリリースノートでは、**モジュールのtop levelである**という前提が書かれていたのですね。

{{<summary "https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-8.html#top-level-await">}}

DBを使うモジュールでその初期化(非同期処理)を含む具体例はイメージしやすかったです。

### 【Node.js】Node.js v15 の主な変更点

Node.js v15の内容について丁寧に解説されています。  
LTSバージョンではないためv16まで様子見する予定ですが、v15の変更点は把握しておきたいですね。

{{<summary "https://shisama.hatenablog.com/entry/2020/10/21/004612">}}

`Logical assignment operators`は破壊的な感じであまり好きになれないですね..。  
`Unhandled Rejections`が発生したとき終了ステータスが1に変わるのは良い流れだと思います.. 既存コードがいきなり落ちる未来が見えますが..😭

### 【Golang】Goはクリーンアーキテクチャの思想を活かせるか？ DMMのゲームプラットフォームにGo言語を選んだ理由

Goでクリーンアーキテクチャした話。  
最近GoでDDDしたばっかりだったため『ウンウン』と言いたくなる良記事でした。

{{<summary "https://logmi.jp/tech/articles/323451">}}

> Goを使った開発で、一番僕がいいと思ったのは言語として提供されるフォーマットがあること。複数人で開発していても、ちゃんとLinterかけてもらえれば書き方の差分が出ない点は素晴らしいです。

> あと、言語として提供されるパッケージ管理。Go Modulesが出てきてから管理については、一切考えなくて済むので便利です。

> あとは後方互換性の高さ。今日も更新があったのかな？　ちゃんと互換性をもったマイナーバージョンアップをするので、特に書き直しが必要なアップデートは今まで経験したことがありません。

> チームで開発していてけっこう簡単に覚えられるので、学習コストも低いかなというイメージをもちました。やはり難しいのは設計やアーキテクチャを考えたりドメイン分析するところですかね。そういうところに時間を使えるので、学習コストの低さはチームとか組織で開発する時にはメリットになりうるかなと思っています。

『エコシステムや後方互換性が整備されているから、設計にコストをかけられる』というメリットはまさに本質だなと思っています。

### 【Python】Pythonで型を極める【Python 3.9対応】

Python最新バージョンでの型について重要なポイントを紹介されています。

{{<summary "https://qiita.com/papi_tokei/items/bf652696d6b98f23565a">}}

`Final`は初めて知りました。  
ただ、すべての型に`Final[int]`とするのは少し過剰かなという気がしています。

脆弱性に直結するライブラリならともかく、プロダクトでは可読性を下げる要因にもなります。  
Immutabilityを担保するため..としても、それを守らない人は`Final`を外してくるでしょう。  
そのレビューコストは、変数に再代入されるそれとそこまで変わらないと思っています。

### 【Scala】さらなる型安全性を求めて ~ Refinement TypeをScalaで実現する ~

Scalaで手堅い型をどのように表現するかという内容。  
TypeScriptでもRefined Typesという概念があるので馴染みやすかったです。

{{<summary "https://engineering.visional.inc/blog/168/scala-refined-newtype/">}}

最新更新していませんが、TypeScriptでDDDを助長するライブラリOwleliaを開発しています。

{{<summary "https://www.npmjs.com/package/owlelia">}}

ここで値オブジェクトを表現する際にRefined Typesの考え方を採用しています。  
ライブラリ自体の機能ではなく、あくまで使い方(Sample)としてですが..。

### ”Fastify” Node.js用Webフレームワーク - 共同開発者Matteo Collina氏へのインタビュー

高速なNode.jsフレームワークFastify開発者の方に対するインタビュー記事。  
とても良いことが書いてありました☺️

{{<summary "https://www.infoq.com/jp/articles/fastify-nodejs-web-framework-interview/">}}

> "パフォーマンス"を後で考えることはできない、ということ。最初から考えておかなくてはなりません。"スクラッチから書き直す"大きな理由のひとつは、パフォーマンスなのです。

これはガチです..。  
パフォーマンスは後から改善できる楽観的な前提はやめてほしい。

> Denoのシェア拡大に向けたマーケティングアプローチは好きではないので、その件についてツィートしている人たちのフォローは止めました。例えば、メンテナのひとりはパリのある講演で、Denoが"Node.jsをぶち壊す(destroy Node.js)"と主張しています(その部分は、講演の記録からは除外されています)。同じような"Node.jsをぶち壊す"というツイートはコミュニティのあちらこちらに見られますし、Denoのツィッターアカウント自体も、Node.jsをジョークで挑発しているのです。技術的な面からは、彼らがベンチマークに使用しているテクノロジは、公平な比較を行っていません。私が2020年5月に行った計測(他の人による実証もあります)では、合成負荷(synthetic load)によるテストにおいて、Node.jsはDenoの2倍近い速度を達成しています。

Denoの動向..追ってはいますが、未だに開発するぞという気にはならないです。  
今のNode.jsが多くの問題を抱えていることは分かりますが、全てを切り捨ててメインストリームを移行させるのは現実的ではないのでは..と思っています。  
せめてnpm pacakgeをサポートしてくれれば..。

### Evan You On Vue 3 and On Creating an Open Source Framework

Vue生みの親であるEvan Youさんに対するインタビュー記事。  
言葉に重みがありますね。

{{<summary "https://www.monterail.com/blog/vue-3-evan-you-interview-features">}}

> After leaving your 9-5 job to do something that resonates with you deeply, what is the biggest reward for you? Building something that people find helpful or being able to set your own course and make big decisions, etc.?

『一般の仕事スタイルをやめた後、もっとも報酬と感じたのは何か?』という質問に対し..

> I’d say it’s the feeling of being in control - once I’ve experienced that I can never imagine going back to big companies again.

『自分をコントールできる感覚』という答え。  
分かります。多少キツくてもコントロールしている感覚があれば楽しめますから。

> If someone was to ask you what are the most important aspects of building an open-source framework, what would you advise?

『オープンソースフレームワークをつくることで大切なことは？』という質問に対し..

> Know what you are getting into. Writing the code is the easy part - most of the work is in maintenance and community building.

『コードを書くことは簡単な方で..メンテナンスとコミュニティ構築こそが大事だ』との回答。  
コミュニティ構築には関わったことありませんが、人や利権が絡むので大変だという印象は強いですね。


試したこと
----------

なし。


調べたこと
----------

### 【Python】No module named 'virtualenv.seed.via_app_data'エラー

Poetryで仮想環境作成しようとしたとき以下のエラーが出ました。

```
ModuleNotFoundError: No module named 'virtualenv.seed.via_app_data'
```

なぜかvirtualenvを認識しなかったようで、以下コマンドでインストールしたら解決しました。

```
pip install -U virtualenv
```

{{<github "#1873 No module named 'virtualenv.seed.via_app_data'" "https://github.com/pypa/virtualenv/issues/1873">}}

### 【Python】Windowsでシンボリックリンクが作成できない

こんなエラーです。  
管理者権限がなければシンボリックリンクは作成できません。


```
>       os.symlink(key, latest, True)
E       OSError: [WinError 1314] クライアントは要求された特権を保有していません。: 'dummy hash' -> 'tmpdir/latest'
```

調べてみると、Python3.8以上なら開発者モードを有効にすれば作成できるとのこと。

{{<summary "https://stackoverflow.com/questions/44377651/python-symlink-in-windows-10-creators-update">}}

`開発者向け機能を使う`を選んで..

{{<vimg "resources/7672733c.png">}}

`開発者用モード`をオンに..

{{<himg "resources/6b4a45f3.png">}}

確認ダイアログで`はい`を選ぶと..

{{<himg "resources/3aa38bb4.png">}}

シンボリックリンクを作成できるようになりました👍

### 【Python】PoetryでexportがRecursionErrorになる

v1.1.3で発生。

```
$ poetry export -f requirements.txt -o requirements.txt
  .
  .
  RecursionError
  maximum recursion depth exceeded while calling a Python object
```

v1.1.4にバージョンアップしたらなおりました。

{{<github "#3237 locker: handle cyclic dependencies during walk" "https://github.com/python-poetry/poetry/pull/3237">}}


整備したこと
------------

### Pixel5

スマートフォンをPixel5に変更しました🥳  
数日使ってみての所感です。

* はやい
* コンパクトでよい
* Android最新のジェスチャーいい..けどPie Controlの方が上かな..
* 超広角カメラ..イイ!!

こんな記事も..!!

{{<summary "https://www.gizmodo.jp/2020/10/google-pixel-5-review.html">}}

しばらく使ったらレビュー記事を書きたいと思います。

### 【Vim】NerdTreeの導入

NerdTreeを追加しました。

{{<summary "https://github.com/preservim/nerdtree">}}

デフォルトは表示オフにしています。  
`<C-j>w`で現在ファイルをアクティブしつつツリー表示。

```vim
" NerdTree
Plugin 'preservim/nerdtree'
let NERDTreeShowHidden=1 
nnoremap <C-j>w :NERDTreeFind<cr>
```

隠しファイルも対象にしたいので`NERDTreeShowHidden`を設定しています。

### 【VSCode】Gruvboxテーマ

VSCodeのテーマをGruvboxに変更しました。

{{<summary "https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox">}}

最近設定見直しているVimでもGruvboxを使っていますがシック&オシャレの良いテーマです☺️

### 【Python】batsのテストをpytestに移行

[Jumeaux](https://tadashi-aikawa.github.io/jumeaux/)のe2eテストをbatsからpytestに移行しました。  
理由は2つです。

* Windowsでもテストしたい (PythonさえあればOKにしたい)
* 表現や補完を強化したい

テスト実行前にsubprocessでサーバ起動する処理で少しハマりましたが、無事稼働しました。  
Windowsのテスト実行時間はLinuxの5～10倍かかるのが難点ですが..仕方ないか😅

現時点のソースコードは以下。

{{<summary "https://github.com/tadashi-aikawa/jumeaux/tree/c0e201769f30a3c74807a8dfad86cd78c0acd425/e2e">}}

`@pytest.mark.skipif(exec_all is False, reason="Need not exec all test")`は特定テストだけを実施するために用意した苦肉の策です。  
コマンドで指定すればいいと言われればそれまでなのですが、こっちの方が楽なんですよね..。


今週のリリース
--------------

### Markowl v0.7.1

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

#### ヘッダPrefixに関するアクション後のカーソル位置を改善

`Draw H2 Prefix`のようなprefixをつけるアクション実行後、実行前の状態を考慮して最適な位置にカーソルを移動するようにしました。

{{<himg "resources/markowl.gif">}}



その他
------

Jumeauxのコミット数が1000を超えました🥳  
私が開発しているプロダクトの中では初の1000超えです。

{{<himg "resources/9bd5fd7e.jpeg">}}

{{<summary "https://github.com/tadashi-aikawa/jumeaux">}}

リポジトリ作成から5年強..、実質の開発開始からは4年弱..よく続けてこられたなと思います。

{{<himg "resources/a1587823.jpeg">}}

↑のコミット数が900弱なのはマージコミットとかを含まないからかな..🤔

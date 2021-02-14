---
title: 2020年の振り返り
slug: good-bye-2020
date: 2021-01-01T13:39:12+09:00
thumbnailImage: images/cover/2021-01-01.jpg
categories:
  - other
---

あけましておめでとうございます🌅  
今年もよろしくお願いします😁

2020年も終わりましたので..毎年恒例のふりかえり記事です。  
コロナで休日も家にいたせいか、例年よりアウトプットが多い気がします。

<!--more-->

{{<cimg "2021-01-01.jpg">}}

<!--toc-->


エンジニア10年の節目
--------------------

まずはじめに..2020年4月で社会人歴およびエンジニア歴10年を迎えました。  
10年前、社会人になる前は色々な不安がありました。

* 社会人としてやっていけるのか..
* 会社は数年後もちゃんとあるのだろうか..
* プログラミング嫌い(ほぼ未経験)なのにエンジニア続けていけるのか..
* 35歳定年説ｺﾜｲ

結果論ですが、これらの不安は見事に打ち消されました。  
10年経った今でも、エンジニアとして日々楽しく仕事をさせていただいております。

もちろん自分でもある程度努力をしてきたつもりです。  
それでも、この10年に巡り会った人との縁があってこそ今の自分がいます。

特に、共に切磋琢磨してきたエンジニアおよび上長の皆さん。  
この場を借りてコッソリと感謝の意をこめさせてください🙇‍♂️

10年後もまた良い報告ができますように..。


さて、本題に入りましょう。


ブログの運営状況
----------------

### 投稿記事数

今年1年で **49記事** 書きました。  
昨年は45記事なので+5ですね。引き続き昨年超えできました😄

ただ、49記事のうち29記事はWeekly Reportなので純粋な比較はできません。  
Weekly Reportも情報量はかなりありますが、専用記事とターゲットが違いますので。

### 人気記事

今年のアクセスベスト10を紹介します。

| 位    | ページタイトル                                                       | 作成日時   | 今年のページビュー | 前年位 |
| ----- | -------------------------------------------------------------------- | ---------- | ------------------ | ------ |
| **1** | [git bashを格好良くしてみた]                                         | 2018/06/04 | 7192               | 2      |
| **2** | [VSCodeをVimmer好みにしてみた]                                       | 2018/09/17 | 6376               | 1      |
| **3** | [Windows TerminalとPowerShellでクールなターミナル環境をつくってみた] | 2020/05/31 | 4019               |        |
| 4     | [Dockerを跡形も無く消して入れ直してみた]                             | 2017/11/28 | 3835               | 4      |
| 5     | [Cmderでオシャレにcmd.exeを使う -前編-]                              | 2018/11/18 | 3066               | 3      |
| 6     | [VSCodeVimの設定を見直す]                                            | 2019/02/01 | 2773               | 6      |
| 7     | MAMANのITブログ                                                      |            | 2667               | 8      |
| 8     | [TypeScript+Expressの快適な開発環境を作ってみた]                     | 2019/08/12 | 2389               | 圏外   |
| 9     | [逆引きlodash Array/Collection/Object編]                             | 2019/02/14 | 2324               | 圏外   |
| 10    | [すべての図をdraw.ioで管理するメリット]                              | 2020/01/06 | 2106               |        |

[git bashを格好良くしてみた]: https://blog.mamansoft.net/2018/06/04/make-git-bash-look-good/
[VSCodeをVimmer好みにしてみた]: https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/
[Windows TerminalとPowerShellでクールなターミナル環境をつくってみた]: https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/
[Dockerを跡形も無く消して入れ直してみた]: https://blog.mamansoft.net/2017/11/28/reinstall-docker/
[Cmderでオシャレにcmd.exeを使う -前編-]: https://blog.mamansoft.net/2018/11/18/use-cmd-elegant-on-cmder-phase1/ 
[VSCodeVimの設定を見直す]: https://blog.mamansoft.net/2019/02/01/review-vscode-vim-setting/
[TypeScript+Expressの快適な開発環境を作ってみた]: https://blog.mamansoft.net/2019/08/12/develop-express-with-typescript-cool-environment/
[逆引きlodash Array/Collection/Object編]: https://blog.mamansoft.net/2019/02/14/lodash-by-usecase-array-collection-object/
[すべての図をdraw.ioで管理するメリット]: https://blog.mamansoft.net/2020/01/06/benefits-manage-all-diagrams/

今年執筆した記事は2つだけです。  
ターミナル、エディタ、IDEに関する記事が上位を独占しています。

12月に集計を絞ってみると、2020年に書いた以下記事もベスト10入りしています。

* 5位: [WSL2でつくる快適なUbuntu環境](https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/)
* 8位: [WSL2でつくる快適なUbuntu環境Ⅱ](https://blog.mamansoft.net/2020/07/26/efficient-wsl2-with-ubuntu2/)
* 9位: [mermaidでラクラクMarkdown作図](https://blog.mamansoft.net/2019/12/17/write-diagram-with-mermaid/)

WSL2は出たばかりだったので来年の方が期待できるかもしれません。

### リソースをリポジトリに同梱

今まで画像や動画といったリソースはDropboxで管理していました。  
しかし、以下の理由からリポジトリに含めることにしました。

* Dropboxに配置して共有リンクを取得し、記事に挿入するのが面倒
* リソースをリポジトリに含めてもサイズや運用面で大きな弊害はない
* Dropboxのサービス状況を気にする必要がない

はじめはGit LFSで管理していましたが、あとで使わない方がいいことが分かったため今は普通に管理しています。

{{<summary "https://blog.mamansoft.net/2020/11/09/2020-11-1w-weekly-report/#gitgit-lfs%E7%AE%A1%E7%90%86%E3%82%92%E3%82%84%E3%82%81%E3%82%8B">}}


### Weekly Reportの開始

アウトプットしようと思いつつ、中途半端なクオリティに納得いかずpublishできない..  
そんな悪癖をなおすため、内容ではなく期間で記事をpublishすることにしました。  

それがWeekly Reportです。

{{<summary "https://blog.mamansoft.net/2020/06/08/start-weekly-report/">}}

Weekly Reportは無事2020年終わりまで半年以上続きました👍  
良い影響も与えられて嬉しい限りです😊

{{<twitter "1330438686933090306">}}

### デプロイ先をVercelに変更

ブログとサイトのデプロイ先をNetlifyからVercelに変更しました。

{{<summary "https://blog.mamansoft.net/2020/12/28/2020-12-4w-weekly-report/#%E3%83%96%E3%83%AD%E3%82%B0%E3%82%B5%E3%82%A4%E3%83%88%E3%82%92netlify%E3%81%8B%E3%82%89vercel%E3%81%B8%E7%A7%BB%E8%A1%8C">}}

レイテンシの差分は思ったより体感として感じている気がします。


購入ガジェット
--------------

今年もいくつか新しいガジェットを購入しました。  
ただ、今年はあまり記事にしなかったのでWeekly Reportの断片を紹介します。

### iPad ProとApple Pencil

手書きデバイスが欲しかったので、3月上旬にヨドバシカメラに行って触ってみたところ..あまりの素晴らしさにApple Shopで購入してしまいました。  
この後、コロナでテレワークに切り替わったため、MTGのときにホワイトボード代わりとして大活躍してくれました。

{{<summary "https://blog.mamansoft.net/2020/06/08/start-weekly-report/#ipad-pro%E3%81%A8%E5%85%B1%E3%81%AB%E9%81%8E%E3%81%94%E3%81%99">}}

出社に戻って半年経った今でも毎日持ち歩いており、仕事でも使っています。  
お気に入りアプリはConceptです。後で出てきます。

### EIZO EV2780

2560 x 1440 27型のディスプレイです。  
USB Type-Cに接続するだけでOKなのが嬉しい。

{{<summary "https://www.eizo.co.jp/products/lcd/ev2780/">}}

今思うと、横幅が広すぎ+字が小さすぎかなと思っています。  
私は24型のFull HDが性に合っているのかもしれません。

### ASUS ExpertBook

ThinkPadも7年使ってきたので、この機会に..と思い買い換えました。

{{<summary "https://blog.mamansoft.net/2020/06/08/start-weekly-report/#asus-expertbook%E3%81%AE%E8%B3%BC%E5%85%A5">}}

コンパクト/軽量であることに当時魅力を感じていましたが、今は不要だったかなと思ってます。  
今年は外出が少なかったからからもしれませんが..。

USB Type-Cが2ヶ月くらいで故障したことを除けば概ね満足しています。

### Google Pixel 5

前のスマホがトイレでお亡くなりになったので購入しました。

{{<summary "https://blog.mamansoft.net/2020/10/19/2020-10-3w-weekly-report/#google-pixel-5">}}

『最新のスマホならローエンドでもゲームしなければ問題ない』  
そんな風に思っていた時期が私にもありました..そんなことない！ 世界変わるから！！  

{{<summary "https://blog.mamansoft.net/2020/10/26/2020-10-4w-weekly-report/#pixel5">}}

気付かせてくれた🚽に感謝🙏


### ネットワーク周りのいろいろ

新しいWi-Fiルータが無線を受けつけず.. 新しいパソコンがUSB Type-Cを受けつけず.. と散々な状態だったので力尽くで有線ネットワーク環境を整理しました。  
本来なら無線でシンプルな配線なのに。。😭

{{<summary "https://blog.mamansoft.net/2020/07/12/2020-07-2w-weekly-report/#%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%81%AE%E6%9C%89%E7%B7%9A%E7%92%B0%E5%A2%83%E6%95%B4%E5%82%99">}}
{{<summary "https://blog.mamansoft.net/2020/08/24/2020-08-4w-weekly-report/#usb-type-c-%E3%81%A7%E7%B5%A6%E9%9B%BB%E3%81%A8hdmi%E5%87%BA%E5%8A%9B%E3%82%92%E5%85%BC%E3%81%AD%E3%82%8B">}}



開発環境の改善
--------------

### Windows TerminalとPowerShell

この改善はゲームチェンジャーだったと思います。  
コロナによるテレワーク終了前日に気合いを入れて記事も書きました。

{{<summary "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}

はてなでも今まででダントツトップでした。はじめて3桁いきました。

{{<summary "https://b.hatena.ne.jp/entry/s/blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}

コメントにもあるとおり、細かいところではつらみも残りますけどね..😅

### WSL2

WSL2の正式版がリリースされたので環境を整備しました。  
ドサクサに紛れてbashとエコシステムの整備もしています。

{{<summary "https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/">}}
{{<summary "https://blog.mamansoft.net/2020/07/26/efficient-wsl2-with-ubuntu2/">}}
{{<summary "https://mimizou.mamansoft.net/it-note/tools/docker/#ubuntu-on-wsl2">}}

なお、UbuntuのGUIを使うのは面倒なので諦めました。  
Vcxsrv使えば可能ですが、日本語入力周りが不安定ですし..。

それならばWindowsですべて開発できる努力をした方がマシとなりました。

### IntelliJ IDEA、VSCode、VimでのVim操作性統一

極力使っているツールによって頭の切り替えが不要なように整理しました。

{{<summary "https://blog.mamansoft.net/2020/11/03/jetbrains-ide-vs-code-vim-plugin-10/">}}

あまり見られてはいませんが個人的に自信作の記事です。  
Vimを愛する人には是非見て欲しい！

### PyPIにCIでリリース

GitHub Actionsを使ってリリースできるようにしました。

{{<summary "https://blog.mamansoft.net/2020/12/01/2020-11-4w-weekly-report/#pythongithub-actions%E3%81%A7%E3%83%AA%E3%83%AA%E3%83%BC%E3%82%B9%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB%E3%81%99%E3%82%8B">}}

### Ditto

Windowsのクリップボード管理ソフトです。  
画像ファイルなどにも対応しており、インクリメンタルサーチもできるのでオススメ。

{{<summary "https://blog.mamansoft.net/2020/06/15/2020-06-2w-weekly-report/#ditto">}}

CLCL -> Clibor -> Ditto という移り変わりです。

### draw.io

今まで悩んでいた図の管理について、draw.ioで統一するようにしました。

{{<summary "https://blog.mamansoft.net/2020/01/06/benefits-manage-all-diagrams/">}}

ブログはもちろんのこと、ConfluenceやVSCodeでも使えるので仕事でもOK👍

### Miro

オンライン高機能ホワイトボードサービスです。

{{<summary "https://miro.com/">}}

コロナでテレワークになってから見かけて使うようになりました。  
仕事でもプライベートでも、誰かと視覚的にやりとりするのに便利です。

特にiPad x Apple Pencilとの相性が抜群です。  
キャンバスが大きくなると挙動がかなり不安定になるのが玉にキズですが..😅

共有の必要がなく、手書きだけでよい場合はConceptの方が便利ですね。

### Concept

数ヶ月色々なメモアプリを使ってきましたがConceptに落ち着きました。

{{<summary "https://concepts.app/ja/">}}

Conceptに決めたレポートのセクションはコチラ。

{{<summary "https://blog.mamansoft.net/2020/07/27/2020-07-4w-weekly-report/#concept">}}

プレゼン表示は想定外の嬉しさ😁

{{<summary "https://blog.mamansoft.net/2020/08/02/2020-08-1w-weekly-report/#concept%E3%81%AE%E3%83%97%E3%83%AC%E3%82%BC%E3%83%B3%E8%A1%A8%E7%A4%BA">}}

### Codecov

カバレッジの計測について、Code ClimateからCodecovに移行しました。

{{<summary "https://blog.mamansoft.net/2020/07/12/2020-07-2w-weekly-report/#githubcodecov%E3%81%A7%E3%82%AB%E3%83%90%E3%83%AC%E3%83%83%E3%82%B8%E3%83%AC%E3%83%9D%E3%83%BC%E3%83%88">}}

### Bookmark Sidebar

シンプルでクール、しかも使いやすいChromeのブックマークに関する拡張機能です。

{{<summary "https://blog.mamansoft.net/2020/11/09/2020-11-1w-weekly-report/#google-chromebookmark-sidebar">}}


学習
----

### DDD

DDDについて深く学び経験できた1年間だったと思います。

はじめのきっかけは[Togowl]でした。  
[Togowl]を開発しながら値オブジェクトの表現について悩みました。

{{<summary "https://blog.mamansoft.net/2020/02/19/express-value-object-by-typescript/">}}

ここには書けませんが、仕事でもはじめてDDDな開発が継続できています。  
ドメインモデルをしっかり定義して..開発前にドメインエキスパートと認識あわせて..。

一度この流れに慣れてしまうとDDDナシの開発には戻れませんね。無駄が多すぎて。

### Open API

Open APIをはじめて使いました。  
仕事でリアーキテクトしてたレガシーシステムがあまりに意味不明だったので..。

{{<summary "https://blog.mamansoft.net/2020/11/03/2020-10-5w-weekly-report/#openapi-specification">}}

### Kotlin

Kotlinを使って普段使うものをはじめて作りました。  
JetBrains IDEで使えるMarkdownのフォーマットプラグインです。

{{<summary "https://blog.mamansoft.net/2020/04/22/create-intellij-idea-plugin/">}}

もちろんIDEA Vimありきなのでコチラとあわせてお使いください。

{{<summary "https://blog.mamansoft.net/2020/05/03/more-vimmer-intellij-idea-plugin/">}}

### TypeScript

#### リリースノートおさらい (v2.0~v3.6)

リリースノートを読み返して日本語でまとめる..ということを1年間続けていました。  
v2.0から1日1セクションを目標に初めて、今v3.7の途中です。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/typescript/releases/">}}

目的はTypeScript力の向上です。  
歴史を知ることで、質問に対する回答のクオリティも上がったと思ってます。

#### デコレータ

TypeScriptでデコレータをはじめて作りました。

{{<summary "https://blog.mamansoft.net/2020/11/23/2020-11-3w-weekly-report/#typescript%E3%83%87%E3%82%B3%E3%83%AC%E3%83%BC%E3%82%BF%E3%81%AE%E6%9B%B8%E3%81%8D%E6%96%B9">}}

#### Playwrightでe2eテスト

ここ2~3年でe2eテストの敷居も下がったものです。時代に追いつきました。

{{<summary "https://blog.mamansoft.net/2020/12/20/playwright-realtime-e2e-web-test/">}}


### Rust

2年ぶりに少しだけ本気を出して学習しました。少しだけです..。  
The bookで理解したことを日本語で4章途中までまとめました。

{{<summary "https://mimizou.mamansoft.net/it-note/languages/rust/thebook/1_getting_started/">}}

他にもATLrusというAtlassianのAPIを使ったニッチなCLIツールを作りました。

学びは記事1つ分くらいありました。

{{<summary "https://blog.mamansoft.net/2020/08/24/2020-08-4w-weekly-report/#rustcli%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%A6%E3%81%BF%E3%81%9F">}}
{{<summary "https://blog.mamansoft.net/2020/11/03/2020-10-5w-weekly-report/#rustthiserror%E3%81%A8anyhow%E3%81%AE%E3%82%A8%E3%83%A9%E3%83%BC%E3%83%8F%E3%83%B3%E3%83%89%E3%83%AA%E3%83%B3%E3%82%B0%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6">}}

muslビルドも以前と同様Dockerでできました。

{{<summary "https://blog.mamansoft.net/2020/09/23/2020-09-3w-weekly-report/#rustatlrus%E3%81%AEmusl%E3%83%93%E3%83%AB%E3%83%89">}}
{{<summary "https://blog.mamansoft.net/2020/11/03/2020-10-5w-weekly-report/#rustgithub-actions%E3%81%A7musl-build">}}


### Golang

#### CLIライブラリ

プライベートでは開発していませんが、仕事でいくつかCLIを作りました。  
そこでCobraやViper、zerologなどの著名ライブラリを使いました。

{{<summary "https://blog.mamansoft.net/2020/09/14/2020-09-2w-weekly-report/#golangcobra">}}
{{<summary "https://blog.mamansoft.net/2020/09/14/2020-09-2w-weekly-report/#golangzerolog">}}

設計はDDDで行い、Application ServiceのFactoryでAPI Clientなどを注入できるようにして、Testableなコードを書けました。  
今までは外部からAPI Clientを注入せずにテスト用のServiceを別途実装していましたが、それがDDDとして望ましい設計ではないことに気付きました。

{{<summary "https://blog.mamansoft.net/2020/10/05/2020-010-1w-weekly-report/#golang%E3%83%86%E3%82%B9%E3%83%88%E3%81%AB%E5%BF%85%E8%A6%81%E3%81%AA%E6%8A%80%E8%A1%93%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6">}}

エコシステムも最新化しました。Go Moduleとか。

{{<summary "https://blog.mamansoft.net/2020/09/14/2020-09-2w-weekly-report/#ideago%E8%A8%80%E8%AA%9E%E3%81%AE%E9%96%8B%E7%99%BA%E7%92%B0%E5%A2%83">}}

#### Goroutine

何かと理由をつけて逃げていたGoroutineを克服しました。

{{<summary "https://blog.mamansoft.net/2020/11/23/2020-11-3w-weekly-report/#golanggoroutine%E3%81%A7%E4%B8%A6%E8%A1%8C%E5%87%A6%E7%90%86">}}


### Svelte

前から気になっていたSvelteを触ってみました。

{{<summary "https://blog.mamansoft.net/2020/07/12/2020-07-2w-weekly-report/#svelte">}}

まだα版以下ですが、FLOWERというWebツールも作りました。

{{<summary "https://blog.mamansoft.net/2020/12/27/svelte-ffmpeg-wasm-site/">}}

今後機能を増やしつつSvelteを引き続きウォッチしていきます。

### 英語

10月中旬からQuizletというクラウド英単語学習サービスをはじめました。

https://quizlet.com/ja

自分で単語登録できるのがウリで、日々読んでいる英語の技術記事から分からなかった単語を毎日登録・学習するようにしています。  
2ヶ月半で登録単語数は150になりました💪


エンジニアリング
----------------

GitHubで管理しているリポジトリの成果についてです。  
2020年に作ったリポジトリには簡単に紹介文を添えます。

### Togowl

昨年の年末年始にリポジトリを作成し、間違いなく今年一番開発したプロダクトです。  
1年間で400近いコミットをしました。

Todoist/Toggl/Slackと連携して、タスク/時間管理を一元化するツールです。  
Windows/Mac/Linux/Android/iOS、主要ブラウザで使えます。Foo!!

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

60回ほどリリースしています。

| リリースの種類           | 回数 |
| ------------------------ | ---- |
| メジャーバージョンアップ | 2    |
| マイナーバージョンアップ | 37    |
| パッチバージョンアップ   | 19    |

Togowlの開発を通して様々なことを勉強させてもらいました。  
年末にきっかけをくれた某kbys氏には感謝しています🙏

* DDDと共に成長していくプロダクトの作り方
* 複数のWeb Socket APIを使ったリアルタイムアプリケーション設計
* TypeScript + Nuxt + Vuetifyのベストプラクティス
* クロスプラットフォーム/クロスブラウザ/レスポンシブ対応のPWA開発
* タスク管理と時間管理に関するドメイン知識
* Todoist/TogglのAPIおよびWebでの利用方法

**Togowlは自分が毎日自分で使っているツールである**ためモチベーション維持が楽でした。  
Togowlで学んだ技術は仕事でも活かせたので一石二鳥です。  
間違いなく昨年のThe best of productです😊

### Owlelia

TypeScriptでDDDするためのベースとなるライブラリです。  
Togowlが光の立役者なら、Owleliaは間違いなく陰の立役者です。

{{<summary "https://github.com/tadashi-aikawa/owlelia">}}

30回ほどリリースしています。

| リリースの種類           | 回数 |
| ------------------------ | ---- |
| メジャーバージョンアップ | 0    |
| マイナーバージョンアップ | 23    |
| パッチバージョンアップ   | 9    |

Owleliaは2020年以降に作ったすべてのTypeScriptプロダクトで利用しています。  
プライベート/仕事を問わずです。

主役はvo、entity、either、errorですが、オマケでつけたdatetimeがいい仕事しています。  
日時に関するドメインはTogowlでも仕事でも頻繁に使うため、かなり恩恵を得ています。

間違いなく今年も更新が多くなるライブラリだと思います。  
今年はv1.0を出したいですね。

### Markowl

JetBrains IDEでMarkdownを編集するとき、痒い所に手を届かせるプラグインです。  
なにより自分が使うので本気でした。

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}
{{<summary "https://github.com/tadashi-aikawa/markowl">}}

30回ほどリリースしています。

| リリースの種類           | 回数 |
| ------------------------ | ---- |
| メジャーバージョンアップ | 0    |
| マイナーバージョンアップ | 6    |
| パッチバージョンアップ   | 6    |

規模は小さいですが、ターゲットの広いMarkowlも新たな経験をさせてくれました。

* 初Kotlin 
* 初JetBrains IDEプラグイン
* 初ちゃんとしたIssue対応

今年も必要に応じてバージョンアップしていきたいですね👍

### FLOWER

年末にSvelteではじめて作ったメディア変換サイトです。  
まだバージョニングは愚か、`package.json`の記載も適当です😅

{{<summary "https://github.com/tadashi-aikawa/flower">}}

これから年々Svelteの時代がくると個人的に思っています。  
その流れをキャッチアップする上でも..今年はFLOWERを育てていきます🌺

あ、FLOWERは勉強目的だけではなく実用面も意識しています。  
画像と動画の変換やサイズ削減に興味ありましたら是非試してみてください😉

{{<summary "https://flower.vercel.app/">}}

### ATLrus

Atlassianツールの操作を行うRust製CLIです。  
Rustの勉強を兼ねて、仕事で必要だったため作りました。

{{<summary "https://github.com/tadashi-aikawa/atlrus">}}

バージョニングはしていますがリリースは1回きりです。  
今のところ、あまりメンテするモチベはありません。

Rustは言語としての魅力がありつつも、実用面ではGolangに軍配が上がります。  
しかし、以下の観点から継続的に学んでいきたいと思っています。

* 必要になったとき使えるようにしたい
* Wasmとその可能性
* 設計をはじめエンジニアとして全体のスキルアップになる

### Jumeaux

{{<summary "https://tadashi-aikawa.github.io/jumeaux/">}}

バージョンはv2.2.0からv2.7.0まで上がりました。

| リリースの種類           | 回数 |
| ------------------------ | ---- |
| メジャーバージョンアップ | 0    |
| マイナーバージョンアップ | 5    |
| パッチバージョンアップ   | 1    |

主な対応は以下3つです。

* POSTのraw対応
* Slack通知機能の強化
* Windowsサポート (開発/実行ともに)
    * e2eテストをbatsからpytestに移行

{{<summary "https://tadashi-aikawa.github.io/jumeaux/ja/releases/v2/#240">}}

### Miroir

{{<summary "https://tadashi-aikawa.github.io/miroir/#/">}}

バージョンはv1.0.0からv1.1.0まで上がりました。

| リリースの種類           | 回数 |
| ------------------------ | ---- |
| メジャーバージョンアップ | 0    |
| マイナーバージョンアップ | 1    |
| パッチバージョンアップ   | 0    |

Angular9およびJumeauxのPOST rawに対応しただけです。  
メインで利用している技術がVue/Nuxtであり、仕事でしか利用されないツールなので積極的に改修することはありませんでした。

これからも必要最低限の対応になると思います。

### Owlora

{{<summary "https://github.com/tadashi-aikawa/owlora">}}

今年はリリースしませんでした。

最近は使っていないので、事実上開発は凍結しています。  
中期のスケジューリングやReactを使う必要が出たら復活するかもしれません。

### OwlMixin

{{<summary "https://github.com/tadashi-aikawa/owlmixin">}}

バージョンはv5.5.0からv5.6.0まで上がりました。

| リリースの種類           | 回数 |
| ------------------------ | ---- |
| メジャーバージョンアップ | 0    |
| マイナーバージョンアップ | 1    |
| パッチバージョンアップ   | 0    |

Python3.9をサポートしただけです。  
今年は仕事でPythonを使う予定があるため昨年よりバージョンアップするかもしれません。

### owcli

{{<summary "https://github.com/tadashi-aikawa/owcli">}}

今年はリリースしませんでした。  
今年は仕事でPythonを使う予定があるためバージョンアップするかもしれません。

### gowl

{{<summary "https://github.com/tadashi-aikawa/gowl">}}

今年はリリースしませんでした。

Bitbucket Cloud対応やmainブランチ対応など、やることはあります。  
ただ、私のユースケースにあわないため優先度は低めです。気が向いたらやるかも。


その他
------

### 創の軌跡

軌跡シリーズ前半の最終作『創の軌跡』が発売されました。

{{<summary "https://www.falcom.co.jp/hajimari/">}}

やりこみ要素がかなりのボリュームで、合計200~300時間くらいプレイしたと思います。  
後半戦では9割くらいのキャラが登場しないため、オールスターな感じでした。

### 薬屋のひとりごと

なんとも言えぬ面白さがあって全巻買ってしまいました。

{{<summary "https://www.amazon.co.jp/%E8%96%AC%E5%B1%8B%E3%81%AE%E3%81%B2%E3%81%A8%E3%82%8A%E3%81%94%E3%81%A8-1%E5%B7%BB-%E3%83%87%E3%82%B8%E3%82%BF%E3%83%AB%E7%89%88%E3%83%93%E3%83%83%E3%82%B0%E3%82%AC%E3%83%B3%E3%82%AC%E3%83%B3%E3%82%B3%E3%83%9F%E3%83%83%E3%82%AF%E3%82%B9-%E6%97%A5%E5%90%91%E5%A4%8F%EF%BC%88%E3%83%92%E3%83%BC%E3%83%AD%E3%83%BC%E6%96%87%E5%BA%AB%EF%BC%8F%E4%B8%BB%E5%A9%A6%E3%81%AE%E5%8F%8B%E7%A4%BE%EF%BC%89-ebook/dp/B0757MTWDV">}}


総括
----

本当は2020年中に書きたかったのですが、思った以上にネタが多くて年が明けてしまいました..。

そういえば2020年は年始に目標を立てていませんでした..。  
ただ、都度何をすべきか考えてその時やるべきことをやれたと思っています。  
それが成果にも繋がっているのかなと。

今年は情報整理の革命をしていきたいと考えています。  
変わらず精進していきたいと思いますので、今年もよろしくお願いします👊

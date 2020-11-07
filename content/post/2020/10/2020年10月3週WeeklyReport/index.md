---
title: 2020年10月3週 Weekly Report
slug: 2020-10-3w-weekly-report
date: 2020-10-19T10:10:06+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
---

📰 **Topics**

久しぶりにVimの環境を本気で整備しなおしました。  
QuizletやPixelの導入、Go/Python/TypeScriptと学習のバランスも良い週でした。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【TypeScript】VSCodeでよく作るTypeScriptの学習環境

TypeScriptの仕様確認をするため、VSCodeを使うことが増えたので記事を書きました。

{{<summary "https://blog.mamansoft.net/2020/10/14/vscode-typescript-learning/">}}

勉強会などでTypeScriptの環境構築してもらうときの参考資料としても使えるかなと。  
プロダクト開発用ではないため、ES Lintなどは外しています。


学んだこと
----------

### 【Python】ジェネレータ内包表記とyieldの異なる挙動について

ジェネレータ内包表記とyieldはほぼ同じだと思っていましたが、ファイルなどcontextを使う処理では決定的な違いがあることを知りました。

以下のコードは実行すると`I/O operation on closed file`エラーになります。

```python
def read() -> Iterator[str]:
    with open("hoge.txt") as f:
        return (line for line in f)  # returnした時点で関数は終了し、fileは閉じられる


def main():
    iter = read()
    # この時点でfileは閉じている
    for v in iter:  # イテレータアクセスでfileにアクセスされるが時既に遅し..
        print(v)
```

一方、yieldを使った以下のコードは動きます。

```python
def read() -> Iterator[str]:
    with open("hoge.txt") as f:
        for line in f:
            yield line  # 関数の中断であるため、fileは閉じられない(開き続ける)


def main():
    iter = read()
    for v in iter:  # イテレータアクセスが進むとread()のyieldが都度再開する
        print(v)
```


### 【Golang】オプショナルパラメータの実現方法

Goの関数定義では引数のOptional指定ができないためテクニックが必要です。

{{<summary "https://raahii.github.io/posts/optional-parameters-in-go">}}

`引数用の構造体を用意する`を使ったことはありますが、愚直なやり方に疑問を感じていました。  
primitive型のポインタを指定するため、一旦変数に格納するのも冗長だなと..。

`Appliable Functional Option Pattern`は知らなかったので参考になりました。
以下の点は気になりますが、トレードオフなので仕方なしですかね..。

* 引数名が分かりにくい
* 引数の数だけ設定関数を用意しなければいけない

primitiveのポインタがNullableという共通認識はアリだと思っているので、必要な場合は`引数用の構造体を用意する`を使う可能性が高そうです。

...もちろん、Optional引数なしで実装するのが一番望ましいと思ってます。


### 【Golang】名前付き戻り値

関数の戻り値に名前を付けられます。  
冒頭での`var`宣言が不要になるため状況によっては可読性が上がると思いました。

```go
package main

import "fmt"

func filter(nums []int, min int) (filtered []int, rejected []int) {
	for _, n := range nums {
		if n >= min {
			filtered = append(filtered, n)
		} else {
			rejected = append(rejected, n)
		}
	}
	return
}

func main() {
	filtered, rejected := filter([]int{1, 2, 3, 4, 5}, 3)
	fmt.Printf("OK: %v, NG: %v", filtered, rejected)
	// -> OK: [3 4 5], NG: [1 2]
}
```

また、名前付き戻り値を使った方がメモリ効率がいいみたいです。

{{<summary "https://medium.com/eureka-engineering/named-return-values-7f485d867df0">}}

ただ、名前付き関数はImmutableでなくなってしまうので長い処理には不向きかなと。


読んだこと/聴いたこと
---------------------

### 最新研究からわかる 学習効率の高め方

直感による認知バイアスを排除し、研究結果を考察して効率的な勉強法を模索する記事。

{{<summary "https://www.furomuda.com/entry/2020/10/04/031633">}}

私が言語の学習をする場合、以下のような手順をとることが多いです。

```
1. CLIからコマンドを指定してHTTP GETで取得したデータを表示するプロジェクトを作る
2. 1と並行して..実装に必要そうな情報をなるべく公式ドキュメントから都度学習する
3. 自分が欲しいプロダクトを作る
4. 3と並行して..都度必要になった情報をなるべく公式ドキュメントから都度学習する
```

記事の用語に当てはめると以下の関係になるでしょう。

| 記事の用語 | 言語学習の用語         |
| ---------- | ---------------------- |
| 勉強       | ドキュメントからの学習 |
| テスト     | 開発                   |

開発では一度習得した技術も使います。変数の宣言は数え切れないほどするでしょう。  
一方、学習は開発(テスト)で躓いた箇所に対してのみ行います。

これは`【全テスト】【弱点勉強】`パターンにあたると思っています。

この記事内に収まる結論では、`【全テスト】【弱点勉強】`の学習効率が最も高いとされていました。  
私の直感は間違っていなそうで良かったです☺️

### コミュニケーション能力をウリにする人が醜悪な理由

コミュニケーション能力の活かし方が紹介されています。文体は過激ですが...😅

{{<summary "https://www.furomuda.com/entry/20060414/1144999515">}}

価値を生み出すためには相手のことを知る必要があるということ。

> そして、自分が価値を生み出すためには、まずは、具体的に何が価値であるかを感じ取り、見いださなければなりません。自分がやった行為は、それが誰かほかの人たちの喜び、幸せ、楽しさ、得になって初めて、それが価値になるのであって、その行為自体が絶対的な価値を持つことなどあり得ません。

価値を判断するためには空気を読む力が必要で、そのためのコミュニケーション能力だと主張されています。

> だから、そのために、空気を読む能力が必要なのです。コミュニケーション能力や政治能力が必要なのです。空気を読み、何が価値であるかを的確に感じ取り、空気の中で価値があるとみなされるものを生み出す能力を育て、自らを築き上げるためにこそ、空気を読む能力が必要とされる。

既に存在する空気にあわせて価値を提供するのは最も楽な方法だと思います。  
一方、自分として譲れない価値観があり、それを提供したいと考える人もいるでしょう。

その場合は、それが価値として認められるよう空気を再構築する力が必要かなと思いました。  
空気を壊して再創造する力.. そのためにもコミュニケーション能力は必要になると思います。

空気は読めるようになった方がいい、されどその空気に流されなければいけないということはない..
必要に応じて空気を壊す力が必要..というのが私の考えです。

### 【Golang】Goのgoroutine, channelをちょっと攻略！

go routineやchannelの概念について、今までで一番分かりやすかったです。

{{<summary "https://qiita.com/taigamikami/items/fc798cdd6a4eaf9a7d5e">}}

APIに複数回アクセスする処理の速度がボトルネックになってきたので、go routineを理解していきたいですね。


試したこと
----------

### Quizlet

英単語を覚えるために[Quizlet]というWebサービスをはじめました。  
[Quizlet]に決めたポイントは以下です。

* 自分で単語帳管理ができる
* PCで単語登録ができる
* スマホで勉強ができる
* クラウド同期できる
* 様々な形式で学習できる

[Quizlet]: https://quizlet.com/

### 【IDEA】IntelliJ IDEA 2020.3のLightEdit mode

`idea`コマンドのLightEdit modeの挙動が変わりました。

{{<summary "https://blog.jetbrains.com/idea/2020/10/intellij-idea-2020-3-eap4/#lightedit_improvements">}}

| 機能             | 2020.2までの挙動             | 2020.3の挙動                     |
| ---------------- | ---------------------------- | -------------------------------- |
| `idea <file>`    | LightEdit modeで<file>を開く | 現在のプロジェクトで<file>を開く |
| `idea -e <file>` | なし                         | LightEdit modeで<file>を開く     |

また、ステータスバーからLightEdit modeで開いたあとに別途プロジェクトを指定して開きなおしが可能になりました。  
LightEdit modeは機能がかなり限定されているため、現在のプロジェクトに開けるのは便利です。


調べたこと
----------

### Google Pixel 5

Pixelの話で世間が盛り上がっていたためちょっと調べてみました。

{{<summary "https://store.google.com/jp/product/pixel_5?utm_source=google&utm_medium=cpc&utm_campaign=japac-JP-ja-dr-bkws-super-all-buy-e-dr-1008675&utm_content=text-ad-none-none-DEV_c-CRE_471780528383-ADGP_Hybrid+%7C+AW+SEM+%7C+BKWS+~+EXA+%7C+Pixel+5+%7C+%5B1:1%5D+%7C+JP+%7C+JA+%7C+google+pixel+5-KWID_43700056997833461-aud-836620208859:kwd-911917677795-userloc_1009317&utm_term=KW_google%20pixel5-ST_google+pixel5&gclid=CjwKCAjwz6_8BRBkEiwA3p02VZvUNnO3r00lM13VJppNfPxopvwbqYhwW_D00sDyWClqAuKdkSOAjBoC6mcQAvD_BwE&gclsrc=aw.ds">}}

今のスマホは1～2年前くらいに前機種をトイレに落としてしまったので、急ぎ繋ぎで購入したものです。  
大きな不満はないものの、スペック不足によるカク付きを感じていました。

{{<summary "https://telektlist.com/smartphone_info/asus-zenfone-max-pro-m1-zb601kl/#:~:text=Zenfone%20Max%20Pro%20(M1)%E3%81%AF,%E3%82%92%E6%8C%81%E3%81%A4Android%E3%82%B9%E3%83%9E%E3%83%BC%E3%83%88%E3%83%95%E3%82%A9%E3%83%B3%E3%81%A7%E3%81%99%E3%80%82">}}

そんな折りにPixel 5が登場というNewsに背中を押されて購入を決意しました。  
Nexusの時代はずっと使っていましたが、Pixelが日本で発売されなくなってからはASUSのZenfoneを使っていたのでGoogleのリファレンス機は久しぶりです。

CPUスペックはハイエンドをやめたようですが、ブラウザ操作がカクつかなければ個人でOK。  
むしろ、液晶サイズ落とさずにコンパクト&電池持ちUP&防水なら大歓迎です！

{{<summary "https://kuromanekineko.com/pixel5/781/">}}


整備したこと
------------

### 【Vim】IDEA/VSCodeでも使えるVimプラグインを導入

以下の理由から、素のVimにプラグインは導入しないようにしていました。

* 環境によって操作が変わるので頭の切り替えが大変
    * IntelliJ IDEAやVS CodeでVim操作を行うとき
    * Local環境とRemote環境
    * WindowsとLinux or WSL
* プラグインが原因でVimが動かなくなりメンテコストがあがる
* 素のVimを使う機会がそこまでない

ただ、少し状況が変わったためプラグイン導入を再開することにしました。

* Remote環境を除き、どの環境でもプラグインの恩恵を得られるようになった
* Remote環境のVimは使うとしても短時間であるためボトルネックにならない
* Vundleのプラグイン管理はコストかからなそう
* 開発以外の用途では素のVimを使いたいシーンがしばしばある

詳しい内容は別途記事にする予定ですが、導入成果だけ箇条書きします。

* `morhetz/gruvbox`
* `machakann/vim-highlightedyank`
* `machakann/vim-sandwich`
* `easymotion/vim-easymotion`
* `vim-scripts/ReplaceWithRegister`
* `kana/vim-textobj-user`
* `kana/vim-textobj-entire`
* `tpope/vim-commentary`
* `mg979/vim-visual-multi`
* `airblade/vim-gitgutter`
* `itchyny/lightline.vim`
* `ctrlpvim/ctrlp.vim`

どの機能もキーバインド含め、以下の環境で統一可能なものです😁

* IntelliJ IDEA (JetBrains IDE)
* VS Code
* Windows Vim (on Powershell)
* Linux Vim (on WSL2)

### 【GitHub】GitHub Actions CIのPython3.9対応

Python3.9に対応していたのでCIに追加しました。

ただ、`lxml`を利用しているプロダクトで以下のエラーが発生しました。

```
src/lxml/includes/etree_defs.h:14:10: fatal error: libxml/xmlversion.h: No such file or directory
```

調べてみるとこんな情報が..

{{<summary "https://stackoverrun.com/ja/q/6369371">}}

`sudo apt -y install libxml2-dev libxslt1-dev` を追加することで解決しました。  
GitHub Actionsが利用しているPython3.9イメージの問題なのか違うのかは不明です..。


今週のリリース
--------------

なし

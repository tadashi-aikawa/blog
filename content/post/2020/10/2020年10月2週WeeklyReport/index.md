---
title: 2020年10月2週 Weekly Report
slug: 2020-10-2w-weekly-report
date: 2020-10-12T08:14:56+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - kotlin
  - golang
  - git
  - github
  - atlassian
  - bitbucket
  - kindle
  - markowl
---

Go言語とGitLFSについて学びを深めた一週間でした。  
このブログはLFSを使っていますが元に戻そうかなと検討中です..🤔

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

なし。


学んだこと
----------

### 【Kotlin】ラムダ式でreturnするときの挙動

関数`foo`内のreturnは関数`foo`に対するreturnになるようです。  
他言語では`forEach`が指定するラムダ式の戻り値になることが多いので斬新でした。

```kotlin
fun foo(ints: List<Int>): Int {
    ints.forEach {
        if (it == 0) return -1 // fooの戻り値が-1になる
        print(it)
    }
}
```

ラムダ式に対するreturnを行う場合は以下のように`@forEach`と対象を指定します。

```kotlin
fun foo(ints: List<Int>) {
    ints.forEach {
        if (it == 0) return@forEach -1 // forEachで指定したラムダ式の戻り値が-1になる
        print(it)
    }
}
```

{{<refer "https://stackoverflow.com/questions/40160489/kotlin-whats-does-return-mean">}}

### 【Golang】色々なパスの取得方法

よく使うパスの取得方法について調べてみました。

* goファイル配置パス
* 実行ファイル配置パス
* カレントディレクトリのパス

以下のような構成で..

```
  .
├──   dist
│  └──   study.exe
├──   go.mod
├──   main.go
└──   sub
   └──   sub.go
```

` main.go`
```go
package main

import "work/sandbox/golang/study/sub"

func main() {
	println(sub.GetThisFilePath())
	println(sub.GetExecutorPath())
	println(sub.GetCurrentDirectoryPath())
}
```

` sub.go`
```go
package sub

import (
	"os"
	"runtime"
)

// sub.go が配置されたファイルのパスを取得する
func GetThisFilePath() string {
	_, fName, _, _ := runtime.Caller(0)
	return fName
}

// 実行ファイル(exe)のパスを取得する
func GetExecutorPath() string {
	executable, _ := os.Executable()
	return executable
}

// カレントディレクトリ(作業ディレクトリ)のパスを取得する
func GetCurrentDirectoryPath() string {
	path, _ := os.Getwd()
	return path
}
```

実行するとこうなります。  
※ 区切り微妙に文字違いますが..

```
~\work\sandbox\golang\study $ .\dist\study.exe
C:/Users/syoum/work/sandbox/golang/study/sub/sub.go
C:\Users\syoum\work\sandbox\golang\study\dist\study.exe
C:\Users\syoum\work\sandbox\golang\study
```

{{<stackoverflow "How to get the directory of the currently running file?" "https://stackoverflow.com/questions/18537257/how-to-get-the-directory-of-the-currently-running-file">}}


### 【Golang】開発しやすそうなパッケージ構成について

Effective Goにもあるとおり、パッケージ名はソースのあるディレクトリ名が良いと思いました。

{{<summary "http://go.shibu.jp/effective_go.html#id7">}}

こんな感じでディレクトリは意味をもつ階層にしつつ..

```
  .
├──   go.mod
├──   main.go
└──   utils
   ├──   math
   │  └──   math.go
   └──   string
      └──   regexp.go
```

package名はディレクトリ名とあわせます。

`utils/math/math.go`
```go
package math

func Sum(x, y int) int {
	return x + y
}
```

ファイル名ではなくディレクトリ名なのがポイントですね。

`utils/string/regexp.go`
```go
package string

import "regexp"

func Match(pattern, value string) bool {
	matched, _ := regexp.MatchString(pattern, value)
	return matched
}
```

`main`はこんな感じです。  
`package名.関数`という呼び出し方も不自然で自然ですね。

`main.go`
```go
package main

import (
	"work/sandbox/golang/study/utils/math"
	"work/sandbox/golang/study/utils/string"
)

func main() {
	println(string.Match("[a-z]{4}", "hoge"))
	println(string.Match("[a-z]{4}", "hog"))

	println(math.Sum(1, 2))
}
```

もし名前が衝突する場合は別名importします。  
たとえば`app`配下と`domain`配下で`user`というpackageが重複する場合..

```go

import (
	userApp "work/sandbox/golang/study/app/user"
	domainApp "work/sandbox/golang/study/domain/user"
)
```

このようにすれば分かりやすいですね😄  
冗長ではなく、むしろ必要な命名要素です。


読んだこと/聴いたこと
---------------------

### 【Git】小さな画像ファイルはGit LFSで管理しない方がよい理由

画像(バイナリ)ならなんでもGit LFSにしておけばいい！..というわけではなさそうです。

{{<summary "https://www.gitlab.jp/blog/2020/07/10/how-to-migrate-git-lfs/">}}

Git LFSは実体パスへのハッシュを管理するので、実体は通常Clone時に取得します。  
ファイル数が多いとその時間がかかり、まして変更されないならGit objectとして管理した方がいいのでは..と。

このブログも画像/動画はGit LFSで管理しています。  
GitHubは1ファイル100MBの制限、リポジトリは1GB以下が理想としています。

{{<summary "https://docs.github.com/en/free-pro-team@latest/github/managing-large-files/what-is-my-disk-quota">}}

今後もブログが長く続いたら1GBを超える可能性があるのでLFSにしましたが、少し迷いますね..。  
一度アップロードされた画像ファイルを変更することはないですし、デプロイではHEADのワークツリーを使うためGit objectとして管理した方が早そうな気がしてきました..🤔

### 【GitHub】ストレージと帯域幅について

GitHubでGit LFSを使った時、ストレージと帯域幅がどう計算されるかについてです。

{{<summary "https://docs.github.com/en/free-pro-team@latest/github/managing-large-files/about-storage-and-bandwidth-usage">}}

雑にいうと以下のような感じ。

* pushするとストレージが増える
* pullすると帯域幅が増える

無料だとそれぞれ1GBが上限のようですね。

### 【Git】GitLFSは大容量のファイル用！webサイトの画像管理をしてみたけど意味なかった

GitHubを使っている方で、同じような結論に辿り着いているのを見つけました。

{{<summary "https://usomitainikagayakumachi.tokyo/2019-02-28_introduction_the_git_lfs/">}}


試したこと
----------

なし


調べたこと
----------

### 【Atlassian】Bitbucket CloudでGit LFSにかかるコスト

フリープランだと1GB、有料プランだと5～10GBまでは無料で使えるらしいです。

{{<summary "https://support.atlassian.com/bitbucket-cloud/docs/storage-policy-for-git-lfs-with-bitbucket/">}}

それ以降は`100GB`ごとに`10$/月`のコストがかかります。  
100GBだと月に1000円強といったところでしょうか。

個人はともかく企業で使う場合は良心的なお値段ですね😄


整備したこと
------------

### 【Kindle】スマホにKindleアプリをインストール

今までKindleの書籍は`Kindle Oasis` -> `iPad Pro`という風にデバイスを変えてきました。  
今回はそれに加え、スマートフォンにKindleアプリをインストールしてみました。

理由は『iPad Proを取り出して書籍を読む/読み続けるのはハードルが高い』からです。  
そのため、ちょっとした空き時間は読書ではなくSNSを見てしまうわけです..😭

領域は狭く多少見づらいですが、いつでも片手でサクっと見られるのはスマホならではです。  
これで毎日少しずつでも読書が進まないか..試してみます。


今週のリリース
--------------

### Markowl v0.7.0

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

#### HeaderのPrefix表記に対応

今までHeaderはLine表記のみでしたが、Prefix表記にも対応しました。

{{<himg "https://github.com/tadashi-aikawa/markowl/raw/master/docs/images/draw-header-prefix.gif">}}

詳細はREADMEをご覧下さい。

{{<summary "https://github.com/tadashi-aikawa/markowl">}}

以下のFeature request対応です。

{{<summary "https://github.com/tadashi-aikawa/markowl/issues/2">}}


#### Undo/Redoの処理をatomicに

今までMarkowlの操作単位とUndo/Redoの単位が統一されていませんでした。  
今回の対応によってMarkowlの操作単位でUndo/Redoできるようになりました。


その他
------

今週は仕事でnoteの記事を執筆してました。  
そこで痛感しましたね.. 如何にHugoを使ったブログ執筆環境が素晴らしいかということを！！

この恵まれた環境にて..率先して記事を書かねば..と改めて思いました(・_・)(._.)

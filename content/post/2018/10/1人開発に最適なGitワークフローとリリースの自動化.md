---
title: 1人開発に最適なGitワークフローとリリースの自動化
slug: own-development-git-workflow-release-automation
date: 2018-10-29T00:47:12+09:00
thumbnailImage: https://images.unsplash.com/photo-1531517647563-118f2dbd3ba6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6af7ad68a645531521d7caa470a4d121&auto=format&fit=crop&w=1050&q=80
categories:
  - engineering
tags:
  - git
  - bash
---

1人で開発するのに最適なGitワークフローとリリースを自動化する方法について紹介します。
リリース時の作業を以下3ステップにできます。

1. 対象バージョンの最新release branchをcheckout
2. `make release`
3. Pull Requestのマージ

<!--more-->

<img src="https://images.unsplash.com/photo-1531517647563-118f2dbd3ba6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6af7ad68a645531521d7caa470a4d121&auto=format&fit=crop&w=1050&q=80"/>

<!--toc-->


はじめに
--------

皆さんは業務でリリース作業をしていますか?  
リリースの為に手順書と睨めっこして緊張しながらリリースしていませんか?

旧GitHubフローみたく『masterブランチを常にデプロイすればリリースは必要ない』と言われるかもしれません。  
しかし常にデプロイされてしまう環境は業務フローにあわなかったり、場合によってはデプロイを躊躇させてしまうこともあるでしょう。

私は業務とプライベートあわせて計10にも及ぶツールを運用しています。  
その末に辿り着いた1人で開発するのに適したGitワークフローとリリース自動化手法を紹介します。


### 前提

以下がインストールされている必要があります。

* git
* make
* bash


Owlフロー
---------

私が使用しているGitワークフローのルールを紹介します。  
名前が無いと文書が書きにくいので`Owlフロー`という名前を付けます。

コミットグラフは以下のようになります。

{{<himg "https://dl.dropboxusercontent.com/s/mc158fuc9e4qlf2/20181030_1.png">}}

{{<info "どこかで見たことがあるなら...">}}
ここで紹介するワークフローは、もしかすると既に存在するものかもしれません。  
その場合は名前を教えていただけると嬉しいです ☺
{{</info>}}

### 前提

リリースバージョン`1.4.1`を次回リリースするケースを説明します。

### `release branch`を作成する

次回リリースバージョンの名前でbranchを作成します。  
これを`release branch`と呼びます。

```
$ git checkout -b 1.4.1 origin/1.4.1
```

Gitフローではリリース直前にリリースブランチを作成しますが、本フローでは開発開始時に`release branch`を作成します。

### `release branch`から`topic branch`を作成する

新機能や不具合修正に関する`topic branch`を、リリースしたいバージョンに紐づく`release branch`から作成します。

```
# current branchが1.4.1
$ git checkout -b feature/topic1 origin/feature/topic1
```

### `topic branch`を`releaes branch`にマージする

`topic branch`の開発が完了したら`release branch`にマージします。

```
$ git commit ...
$ git commit ...
.
.
$ git checkout 1.4.1
$ git merge feature/topic1 --no-ff
```

こうしていくつかのtopicに対して`topic branch`を作成し、それら全てを`release branch`にマージします。

### `release branch`を`master`にマージする

実際はリリース作業後に`master`へマージします。

リリース作業の概要と自動化は次のセクションで説明します。


Owlフローのメリット/デメリット
------------------------------

### メリット

#### コミットグラフがとても見やすい

トピックの対応バージョンを予め決めているのでコミットグラフが非常に見やすくなります。  
各`release branch`の終点にタグが打たれます。

{{<himg "https://dl.dropboxusercontent.com/s/mc158fuc9e4qlf2/20181030_1.png">}}

#### リリース時のバージョン指定で緊張しない

リリース作業のバージョン指定... 間違えると面倒なので緊張しますよね。  
Owlフローではカレントブランチ名称からバージョンを取得可能なため、ブランチ名があっていればバージョン指定は不要です。

1人開発の場合は他の影響を気にする必要がなく、手元のブランチも常に最新であることが多いです。  
そのため、スムーズに開発からリリース作業へ入ることができます。

### デメリット

#### トピックのリリースバージョンを後から変更しにくい

トピックの対応バージョンを先に決めてしまうので、リリースバージョン変更時は面倒です。  
`topic branch`を`release branch`にマージしなければいいのですが、次の`release branch`へ綺麗にリベースできる保証はありません。

その点、Gitフローは`develop`にマージするだけなのでよくできていますね。

以下のケースではデメリットが顕著ではないため気にしなくていいと思います。

* 機能ベースでリリースする戦略
* 複数人で作業する機会が少ない


リリース作業
------------

Makefileに記載することでリリース作業を自動化します。

### 前提

リリース実行の前に以下が完了していることを確認してください。

* リリースversionの対応が全てcommit/pushされていること (リリースノート更新含む)

ここから実際の作業です。

### 対象バージョンの`release branch`をチェックアウト

`release branch`の最新情報を取得します。  
JenkinsなどのCIを使用する場合は、`release branch`を指定すると思います。

既に`release branch`がcheckout済みのローカルで実行する場合は以下のようになると思います。

```
$ git checkout 1.4.1 && git pull
```

### `make release`

チェックアウトしたブランチが最新で正しければコマンドはこれだけです。

### Pull Requestのマージ

`make release`に成功すると、最後にPull RequestのURLが表示されます。  
デプロイされた成果物の動作確認後、URLを開いてPull Requestを作成=>マージしましょう。


Makefileの中身
--------------

前セクションの`make release`について、`Makefile`の一例を見てみましょう。

{{<file "Makefile">}}
```make
MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
ARGS :=
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9_-]+: $(MAKEFILE_LIST) | sed 's/://')

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9][a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

version := $(shell git rev-parse --abbrev-ref HEAD)

#------

package-linux:
	@mkdir -p dist
	GOOS=linux GOARCH=amd64 go build -a -tags netgo -installsuffix netgo --ldflags '-extldflags "-static"' -o dist/miroir

clean-package:
	rm -rf dist

release: clean-package
	@echo '1. Update versions'
	@sed -i -r 's/const version = ".+"/const version = "$(version)"/g' args.go

	@echo '2. Packaging'
	make package-linux
	tar zfc dist/miroir-$(version)-x86_64-linux.tar.gz dist/miroir --remove-files

	@echo '3. Staging and commit'
	git add args.go
	git commit -m ':package: Version $(version)'

	@echo '4. Tags'
	git tag v$(version) -m v$(version)

	@echo '5. Push'
	git push

	@echo '6. Deploy package'
	ghr v$(version) dist/

	@echo 'Success All!!'
	@echo 'Create a pull request and merge to master!!'
	@echo 'https://github.com/tadashi-aikawa/miroir-cli/compare/$(version)?expand=1'
	@echo '..And deploy package!!'
```
{{</file>}}

ポイントだけピックアップして紹介します。


### `version`の取得

git rev-parseコマンドの結果からリリースする`version`を取得します。

```
version := $(shell git rev-parse --abbrev-ref HEAD)
```

`git rev-parse`はGitの情報を取得するコマンドのようです.. (詳しくは分からず..)

{{<refer "Git Pro" "https://git-scm.com/docs/git-rev-parse">}}

それぞれ以下のような結果を返します。

```
# HEADのハッシュ値
$ git rev-parse HEAD
1c1338854431979c8ff1420d9526fe213b4fcda2
# --shortで短縮ハッシュ値
$ git rev-parse --short HEAD
1c13388

# --abbrev-ref でカレントブランチ名
$ git rev-parse --abbrev-ref HEAD
0.2.0
```

### `sed -i`によるバージョン置換

リリースの度、機械的に更新するのが各ファイルに記載されたバージョンです。  
`sed`の`-i`オプションを使って入力ファイルを直接書き換えます。

```
	@sed -i -r 's/const version = ".+"/const version = "$(version)"/g' args.go
```

上記は`args.go`の中に記載された`const version = "x.y.z"`を`const version = "1.4.1"`に置換します。

{{<info "テンプレートファイルを使う方法">}}
他にもテンプレートファイルを作成し、それを入力に固定文字列を置換した結果を正規ファイルとして上書きする方法もあります。
{{</info>}}

### commit/tag

バージョンに依存するコミットメッセージやタグ付けは以下のように自動化してpushもできます。

```
	@echo '3. Staging and commit'
	git add args.go
	git commit -m ':package: Version $(version)'

	@echo '4. Tags'
	git tag v$(version) -m v$(version)

	@echo '5. Push'
	git push
```

### デプロイ

今回の例では成果物をGitHubのリリースページにアップロードするため、[ghr]を使用します。

[ghr]: https://github.com/tcnksm/ghr

```
	@echo '6. Deploy package'
	ghr v$(version) dist/
```

先日[ghr]でGitHubに成果物をアップロードする記事を書きましたのでこちらも参考にしてください。

{{<summary "https://blog.mamansoft.net/2018/10/22/ghr-deploy-to-github/">}}

{{<why "ghrを使うならタグ付けコマンドは不要...?">}}
不要です。[ghr]にはタグを作成してpushする機能があります。  
本記事では[ghr]以外でデプロイする場合も考慮しているため冗長な記述になっています。

[ghr]: https://github.com/tcnksm/ghr
{{</why>}}


### Pull Request URLの案内

最後に`release branch`を`master`にマージするGitHubのプルリクURLを表示します。

```
	@echo 'Success All!!'
	@echo 'Create a pull request and merge to master!!'
	@echo 'https://github.com/tadashi-aikawa/miroir-cli/compare/$(version)?expand=1'
```


### 他のGitワークフローへの適応

ここで紹介した自動化の手法はOwlフローでなくても適応できます。  
Gitフローならブランチ名の取り方を変更..、リリースブランチがないフローでもversionを外から指定すればOKです。

Owlフローを使用する場合もcheckoutで`release branch`を指定するため、実質version指定と変わりありません。


### テストについて

テストがあるならバージョン置換の前に実行しておきましょう。  
例えば以下のような記載です。

```make
test: ## Test
	@echo Start $@
	@pipenv run pytest $(ARGS)
	@echo End $@


test-cli: ## Test on CLI
	@echo Start $@
	@make start-api 2> /dev/null
	@-bats test.bats
	@make stop-api
	@echo End $@


release:
	@echo '0. Install packages from lockfile and test'
	@pipenv install --deploy
	@make test
	@make test-cli
```

総括
----

1人で開発するのに適したOwlフロー、リリースを自動化するMakefileの記載例について紹介しました。

選択肢の1つとして『こんな方法もあるんだ』と思っていただければ幸いです。


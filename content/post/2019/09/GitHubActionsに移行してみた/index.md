---
title: GitHub Actionsに移行してみた
slug: migrate-to-github-actions
date: 2019-09-11T10:38:49+09:00
thumbnailImage: https://cdn.svgporn.com/logos/github-icon.svg
categories:
  - engineering
tags:
  - github
---

[Travis CI]から[GitHub Actions]に移行してみました。

<!--more-->

{{<cimg "https://cdn.svgporn.com/logos/github-icon.svg">}}

<!--toc-->


GitHub Actionsとは
------------------

GitHubが提供するCI/CDの仕組みです。

{{<summary "https://github.com/features/actions">}}

`yaml`ファイル1つであらゆる処理を実行できるのがポイント。  
雑に言うと、[Jenkinsfile]のGitHub版みたいなイメージでOKです。

[GitHub Actions]そのものの経緯や、料金、仕様、使い方などは以下のサイトが丁寧で分かりやすかったです。

{{<summary "https://www.kaizenprogrammer.com/entry/2019/08/18/205010">}}

本記事では基本的な部分は割愛しますので、そちらをご覧下さい。


なぜGitHub Actionsを使うのか
----------------------------

以下の理由から、当初は興味がありませんでした。

* [HCL]よりYAMLが好き
* [Travis CI]で十分やりたいことができるし、移行が面倒
* CI/CDではなくイベントトリガーアクションがメイン(に思えた)
* ビジュアルエディタは気になりつつも必要性を感じない

しかし、今年になって一気に変わりました。

* YAMLで書ける！
* CI/CDがメイン
* GitHubリポジトリとの強力で安心な連携 (同じGitHubですから)
* Matrix Buildができる
* Dockerを使える
* Dockerを使わなくても色々できそう
* (ネットを見る限り) ビルド待ち時間が無さそう

元々できたこともあると思いますが、この辺が魅力に感じたので使うことにしました。


移行前と移行後
--------------

### 対象リポジトリ

私が開発している[owcli]というCLIフレームワークでやりました。

{{<summary "https://github.com/tadashi-aikawa/owcli">}}

{{<info "owcliの宣伝">}}
APIフレームワークに見られるような、階層構造開発できるCLIフレームワークです。  
巨大CLIを作りたい場合など是非お試し下さい😄

* コマンド/サブコマンドまで対応し、各helpドキュメントも自動生成
* 引数情報は自動でClassに変換
* 関数型言語のようなメソッドチェーン

少し古いバージョンですが以前書いた記事はこちら。

{{<summary "https://blog.mamansoft.net/2019/04/24/subcommand-supported-docopt-base-cli-framework/">}}
{{</info>}}




### 移行前のファイル

[Travis CI]のYAMLは以下です。

`travis.yml`

```yaml
language:
  - python
matrix:
  include:
  - python: "3.6"
    dist: xenial
  - python: "3.7"
    dist: xenial
install:
  - pip install pipenv
  - make init
script:
  - make test-cli
notifications:
  slack:
    secure: zxxxxx
```

[Travis CI]は`language: python`を指定することで、PythonやMake, batsなどが入ったVMが提供されていました。  
そのため、yamlファイルだけを見ると[Travis CI]のほうがシンプルだと思います。


### 移行後のファイル

行数は3倍になりました。

`.github/workflows/e2e.yml`

```yaml
name: "e2e tests"

on:
  push:
    paths:
      - '.github/**/*'
      - 'owcli/*'
      - 'owcli/**/*'
      - 'tests/*'
      - 'tests/**/*'
      - 'Pipfile.lock'
  schedule:
    - cron: '0 0 * * *'

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python: [ '3.6', '3.7']
    name: Python ${{ matrix.python }}

    steps:
    - name: Checkout a repository
      uses: actions/checkout@v1
    - name: Install bats
      run: sudo npm install -g bats
    - name: Set up Python
      uses: actions/setup-python@v1
      with:
        python-version: ${{ matrix.python }}
    - name: Install dependencies
      run:  |
        python -m pip install --upgrade pip pipfile-requirements
        pipfile2req > requirements.txt
        pip install -r requirements.txt
    - name: Test with bats
      run: bats tests/test.bats
    - name: Slack notification
      uses: homoluctus/slatify@master
      if: always()
      with:
        type: ${{ job.status }}
        job_name: ":python:*${{ matrix.python }}* e2e tests"
        icon_emoji: "tio2"
        url: ${{ secrets.SLACK_WEBHOOK }}
```

しかし、この比較はフェアではありません。  
今回の移行に伴い、ファイルに含まれる情報として以下のような差分があるのです。

* 変更時にジョブを実行するファイルを制限する
* 定期実行する
* makeを使わない
* pipenvを使わない
  * pipenvを使うことにより、travis.yamlの方はMatrix buildがちゃんとできていなかった
* Slackのメッセージを細かく制御する

本記事は**比較すること自体が目的ではない**ため、ご了承ください。


YAMLファイル作成中に疑問に思ったことと回答
------------------------------------------

### Actionの一覧はどこにある?

`actions`にぶら下がっているリポジトリがそのようです。

{{<summary "https://github.com/actions">}}

### 定期的に実行する方法は?

`on.schedule`にcron形式で設定すればOKでした。

{{<summary "https://help.github.com/en/articles/workflow-syntax-for-github-actions#onschedule">}}

こんな感じですね。

```yaml
on:
  schedule:
    - cron: '0 0 * * *'
```

### Status badgeが欲しい

Markdownの場合、以下のように書けばOKです。

```md
[![Actions Status](https://github.com/{ユーザ名}/{リポジトリ名}/workflows/{ワークフロー名}/badge.svg)](https://github.com/{ユーザ名}/{リポジトリ名}/actions)
```

[owcli]だと下記のように書きます。

```md
[![Actions Status](https://github.com/tadashi-aikawa/owcli/workflows/e2e%20tests/badge.svg)](https://github.com/tadashi-aikawa/owcli/actions)
```

表示結果↓
[![Actions Status](https://github.com/tadashi-aikawa/owcli/workflows/e2e%20tests/badge.svg)](https://github.com/tadashi-aikawa/owcli/actions)

**参考**: [Automating your work with Github Actions](https://bpaulino.com/entries/10-automating-your-work-with-github-actions)

### Pathsの構文がよく分からない...

[owcli]でもこう書いていますのでお察しかもしれませんが..

```yaml
on:
  push:
    paths:
      - '.github/**/*'
      - 'owcli/*'
      - 'owcli/**/*'
      - 'tests/*'
      - 'tests/**/*'
      - 'Pipfile.lock'
```

公式では『`.gitignore`の書き方でOK』と説明されているようですが、実際はそうなっていないとのこと。

**参考**: [GitHub Actions 入門](https://www.kaizenprogrammer.com/entry/2019/08/18/205010#fn:2)

### 不要なWorkflowの結果を消したい

試行錯誤した過去のWorkflowがずっと残っており、邪魔なので消したいです..。

{{<himg "resources/20190911_1.png">}}

今のところ消し方が分かりません.. ご存知の方いらっしゃいましたらTwitterにコメントいただけると大変助かります🙇



ビルドスピードとキャッシュ
--------------------------

### ビルドキャッシュの対応有無

[GitHub Actions]は現時点でビルドキャッシュに対応していないようです。

{{<summary "https://github.community/t5/GitHub-Actions/Github-Action-Build-Caching/td-p/27598">}}

Dockerでそれまでの結果をキャッシュ化したい場合は、Dockerイメージを作ってアップロードする必要がありそうです。

> I want a predefined Docker container to be spun up and get right to work. You can have that too! If you create a Docker image and upload it to Docker Hub or another public registry, you can instruct your Action to use that Docker image specifically using the `docker://` form in the `uses` key.

[HCL]だった時代にはDockerfileの結果はキャッシュとして考慮されていたようですね。

> I can confirm that the previous HCL syntax version of Actions does show "Using cache" when building from a Dockerfile as seen here. However, since upgrading to the yml workflows, it stopped caching, as seen in the lack of "Using cache" here.

今後のアップデートに期待したいところですが、構造を考えると難しそうな気がします..。

### ビルドスピードを上げるには

インストールやビルドのタスクをできるだけ高速化することが大事だと思いました。

たとえば、[owcli]のテストで使う[Bats]は複数のインストール方法があります。

* npm
* ソースからビルド
* Docker

実際に比較していませんが、この中で最速なのは恐らく`npm`です。  
`npm install -g bats`は12秒で終わりました。

[GitHub Actions]が利用するイメージはかなり全部盛りです。  
Ubuntu 18.04 LTSの場合は以下に記載されたpackageが入っています。

{{<summary "https://help.github.com/en/articles/software-in-virtual-environments-for-github-actions#ubuntu-1804-lts">}}

ビルドキャッシュが使えない以上、イメージに含まれているpackageを最大限に利用してジョブを作成していきましょう👍

### 並列処理/最大20並列の恩恵

たとえ他のCIサービスより1つのジョブを実行する時間がかかっても、**最大20並列できる**というのは圧倒的メリットです😄

Matrix Buildをしているプロダクトなら、総合的には[GitHub Actions]の方が早くジョブの実行が完了するのではないでしょうか。


Slack通知
---------

現状、[GitHub Actions]はSlack通知の仕組みを提供していません。  
Slack通知は必須のため、Actionをいくつか調べたところ以下を利用させていただくことにしました。

{{<summary "https://github.com/homoluctus/slatify">}}

### Slatifyに決めた理由

一番の決め手はTwitterでお声がけいただいたことですね😃

{{<summary "https://twitter.com/homines22/status/1170319309219852291?s=20">}}

もちろん、それだけではありません。

* Ownerの技術的背景に親近感を感じた (TS/Python/Goなど)
* Ownerが日本人
* 機能が必要十分で直感的だった
* 要望をFBしたらスピーディーに対応いただけた

SlackのActionが今後沢山出てきそうですが、個人的に応援しております👍

### 設定方法

[owcli]では以下の様な設定にしています。

```yaml
    - name: Slack notification
      uses: homoluctus/slatify@master
      if: always()
      with:
        type: ${{ job.status }}
        job_name: ":python:*${{ matrix.python }}* e2e tests"
        icon_emoji: "tio2"
        url: ${{ secrets.SLACK_WEBHOOK }}
```

事前準備として、リポジトリの秘密情報`SLACK_WEBHOOK`にSlack Incoming Webhooks URLを設定する必要があります。

通知の結果はこのように表示されます。

{{<himg "resources/20190911_2.png">}}

今後、失敗したときはメンションを飛ばすようにするかもしれません。 (`job_name`に入れればいけそう)


総括
----

[Travis CI]から[GitHub Actions]に移行したとき、気になったことと知見をまとめてみました。

今のところ、イベント発生からジョブ実行までの間にほぼラグはありません。  
また、ジョブの実行速度自体も非常に高速です。

現状は招待制ベータであるため、利用ユーザはそこまで多くないと思います。  
実際、私も申し込みをしてから利用開始までは**1ヶ月くらい**かかりました。  
**正式にサービスインした後もこのスピード感が維持されるか**は要注目です。

ただ、スピード感が落ちたとしても[GitHub Actions]は間違い無く有用です。
そのため、[owcli]以外のプロジェクトも[GitHub Actions]に随時移行していきます。

[Travis CI]: https://travis-ci.org/
[GitHub Actions]: https://github.com/features/actions
[Jenkinsfile]: https://jenkins.io/doc/book/pipeline/jenkinsfile/
[HCL]: https://github.com/hashicorp/hcl
[owcli]: https://github.com/tadashi-aikawa/owcli
[Bats]: https://github.com/bats-core/bats-core

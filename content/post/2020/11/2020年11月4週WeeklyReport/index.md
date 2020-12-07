---
title: 2020年11月4週 Weekly Report
slug: 2020-11-4w-weekly-report
date: 2020-12-01T09:50:02+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
---

📰 **Topics**

今週はインプット少なめな反面、アウトプットが多かったです。  
PWAのキャッシュ問題に悩まされていますが、それは来週への課題ということで。。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【ffmpeg】画像をfaviconに変換したい

たまに必要になるのでffmpegを使った手順を追加しました。

{{<summary "https://mimizou.mamansoft.net/it_note/tools/ffmpeg/faq/#favicon">}}

### 【IDEA】WindowsでMakeコマンドを実行したい

`Run/Debug Configurations`の書き方にいつも悩むので追加しました。

{{<summary "https://mimizou.mamansoft.net/it_note/tools/idea/faq/#windowsmake">}}

### GitHub ActionsのCookbook

GitHub Actionsで『〇〇がしたい！』と探す手間を省くため、レシピ集を作りました。  
まだREADMEもない試作段階ですが、育てていくつもりです。

{{<summary "https://github.com/tadashi-aikawa/github-actions-cookbook">}}



学んだこと
----------

なし


読んだこと/聴いたこと
---------------------

### 【Rust】Rustで書かれた新しい高速JavaScriptリントツール、RSLint

Rustで作られたJavaScriptのリンターです。  
**エラー回復**の機能を持ち合わせているのが凄いですね。

{{<summary "https://www.infoq.com/jp/news/2020/11/rslint-fast-rust-js-linter/">}}

まだ開発初期であり、IntelliJ IDEAとの相性はよくなさそうなため様子見です。


試したこと
----------

### noborus/trdsql

CSV, LTSV, JSON, TBLNをSQLとして扱えるCLIツールです。  

{{<summary "https://github.com/noborus/trdsql">}}

セパレータの個数が統一されていなくても動くのは便利ですね。  
あとSJIS対応していれば仕事でも使えたのですが.. それは無理難題ですよね😅


調べたこと
----------

なし


整備したこと
------------

### 【Python】Pypiのトークンを使ってPackageをpublishする

PyPIにPublishするとき、ユーザ/パスワードではなくトークンを使うようにしました。  
アカウント設定画面からpackageごとに作れます。

{{<himg "resources/faa7a268.jpeg">}}

あとはセットすればOK。Poetryを使うなら以下を参照。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/python/poetry/snippets/#idpassword">}}


### 【Python】GitHub Actionsでリリースできるようにする

リリース物の作成、Publishまでを行うGitHub Actionsを追加しました。  
重要なポイントだけ抜き出します。

```yaml
on:
  workflow_dispatch:
    inputs:
      version:
        description: "Release version (ex: 2.3.1)"
        required: true

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: "3.8"

      - name: Install Poetry
        run: |
          python -m pip install --upgrade pip poetry --pre
          poetry config pypi-token.pypi ${{ secrets.PYPI_TOKEN }}
      - run: |
          git config user.email "github-actions@users.noreply.github.com"
          git config user.name "GitHub Actions"
      - name: Release
        run: make release version=${{ github.event.inputs.version }}
```

`secrets.PYPI_TOKEN`は先ほど紹介したPyPIのトークンです。  
忘れがちですが`git config`が必要です。

YAMLファイル全体とMakefileは以下を参照してください。

* {{<icon "github">}} [`.github/workflows/release.yaml`](https://github.com/tadashi-aikawa/jumeaux/blob/v2.7.0/.github/workflows/release.yaml)
* {{<icon "github">}} [`Makefile`](https://github.com/tadashi-aikawa/jumeaux/blob/v2.7.0/Makefile)


今週のリリース
--------------

### Jumeaux v2.6.0

Notifierに`slack@v2`を追加し、Block Kitを用いたリッチな通知ができるようになりました。

{{<himg "resources/0358d294.jpeg">}}

詳細や他のリリース内容は[リリースノート](https://tadashi-aikawa.github.io/jumeaux/ja/releases/v2/#260)をご覧下さい。

### Jumeaux v2.7.0

Challengeの各フローにかかる時間をログへ出力できるようになりました。

```
[1 / 2] --------------------------------------------------------------------------------
[1 / 2]  1. /same-1.json
[1 / 2] --------------------------------------------------------------------------------
[1 / 2] One   URL:   http://localhost:8000/api/one/same-1.json?
[1 / 2] Other URL:   http://localhost:8000/api/other/same-1.json?
[1 / 2] One:   200 / 2.02s / 107b / application/json
[1 / 2] Other: 200 / 2.03s / 107b / application/json
[1 / 2] ⏰ One   res2res:   0.0ms
[1 / 2] ⏰ Other   res2res:   0.0ms
[1 / 2] ⏰ One   res2dict:   0.0ms
[1 / 2] ⏰ Other   res2dict:   0.0ms
[1 / 2] ⏰ Diff diagnosis:   0.0ms
[1 / 2] ⏰ Judgement:   0.0ms
[1 / 2] O (200 - 200) <2.02s - 2.03s> {HttpMethod.GET} /same-1.json
[1 / 2] ⏰ Store criterion:   3.003ms
[1 / 2] ⏰ Did challenge:   1.079ms
```

詳細や他のリリース内容は[リリースノート](https://tadashi-aikawa.github.io/jumeaux/ja/releases/v2/#270)をご覧下さい。

### Togowl v2.18.0 ～ v2.19.0

幅1260px以上のウィンドウで表示されるメモの表示領域をタブ化し、タスク検索できるようにしました。

{{<himg "resources/b297c687.jpeg">}}

半角スペース区切りでAND検索です。  
`#`始まりの単語はプロジェクト検索となり、スピーディーな検索ができます。(サジェストはなし)

{{<mp4 "resources/2020-12-01.mp4">}}

ドラッグ&ドロップによる移動とタスク開始はできません。

ドラッグ&ドロップは技術的な課題によるものです。  
タスク開始を外したのは『突発的にタスクを開始するなら、予定を見直した上で開始すべき』というTogowlの思想に反するからです。  
本日の予定で適切な場所にセットしてから開始しましょう😉


その他
------

### Quizletの単語数

先週忘れていました。。  
本日時点での単語数は105(+12)です。

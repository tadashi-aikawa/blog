---
title: GitHub Actionsに移行して2週間経った
slug: two-weeks-after-moving-to-githubactions
date: 2019-09-23T00:22:35+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/krkrooas9kaunlg/agenda-black-calendar-273011.jpg
categories:
  - engineering
tags:
  - github
---

[GitHub Actions]に移行して2週間が経ちましたので、その間の変化を振り返ってみます。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/krkrooas9kaunlg/agenda-black-calendar-27301"/>

<!--toc-->

移行直後に執筆した以下記事からの変更点や続きです。

{{<summary "https://blog.mamansoft.net/2019/09/11/migrate-to-github-actions/">}}


対応リポジトリと概要
--------------------

PythonとTypeScriptで書かれたリポジトリ計4つに導入しました。  
環境は全て`ubuntu/latest`です。

|       リポジトリ名        |    言語    |      テスト内容       |
| ------------------------- | ---------- | --------------------- |
| [tadashi-aikawa/owlmixin] | Python     | [pytest with doctest] |
| [tadashi-aikawa/owcli]    | Python     | [Bats]                |
| [tadashi-aikawa/jumeaux]  | Python     | [pytest] and [Bats]   |
| [tadashi-aikawa/togowl]   | TypeScript | [Jest]                |

[tadashi-aikawa/owlmixin]: https://github.com/tadashi-aikawa/owlmixin
[tadashi-aikawa/owcli]: https://github.com/tadashi-aikawa/owcli
[tadashi-aikawa/jumeaux]: https://github.com/tadashi-aikawa/jumeaux
[tadashi-aikawa/togowl]: https://github.com/tadashi-aikawa/togowl

[pytest with doctest]: http://doc.pytest.org/en/latest/doctest.html


stepsのnameは可能なら省略したほうがよい
---------------------------------------

省略してもブラウザのページには`uses`のaction名が表示されます。  
ソースコードの冗長なコメントと同じく、見れば分かるものには`name`を付けない方がよいと思います。

例えば以下の設定があるとします。

```yaml
steps:
  - name: Checkout repository
    uses: actions/checkout@v1
  - name: Setup nodejs
    uses: actions/setup-node@v1
    with:
      node-version: ${{ matrix.node }}

  - name: Install dependencies
    run: npm install
  - name: Build
    run: npm run build
  - name: Unit test
    run: npm test
```

[GitHub Actions]やnpmを使っている人であれば、`name`の説明は自明であるためノイズにしかなりません。  
`name`を取っ払うと以下のようになります。

```yaml
steps:
  - uses: actions/checkout@v1
  - uses: actions/setup-node@v1
    with:
      node-version: ${{ matrix.node }}

  - run: npm install
  - run: npm run build
  - run: npm test
```

シンプルでLGTM😄  
逆に`name`を付けるのは以下のようなケースだと考えています。

### runが複数行に渡っている

`name`が無いとパッと見ただけでは何をしているのか分からないと思います。

```yaml
- name: Install dependencies
  run: |
      python -m pip install --upgrade pip pipenv
      sed -ri 's/python_version = ".+"/python_version = "${{ matrix.python }}"/g' Pipfile
      pipenv install --dev --skip-lock
```

[GitHub Actions]以外でも使うのなら、Makefileに定義すれば`name`は不要になりますね👍

### runは単一行だが、やっていることが分かりにくい

以下はPipfileのPythonバージョンをmatrixで指定したバージョンに置換しています。

```yaml
- run: sed -ri 's/python_version = ".+"/python_version = "${{ matrix.python }}"/g' Pipfile
```

一瞬だと分からないのではないでしょうか。

### blockの設定行が5行以上

内容は分かりやすくても、5行以上に渡る項目は`name`を付けた方が分かりやすいです。

```yaml
- name: "Slack Notification (success)"
  uses: homoluctus/slatify@master
  if: always()
  with:
    type: ${{ job.status }}
    username: GitHub Actions (Success)
    job_name: ":python: All tests"
    icon_emoji: ":renne:"
    url: ${{ secrets.SLACK_WEBHOOK }}
```

これは *テスト全体の成功をSlackへ通知* です。


通知の最適化
------------

Matrix Buildの数だけ通知が来るため、Slackの画面が一瞬で占有されていました..。

失敗がない場合はリポジトリに対して1通だけ通知するようにしました。

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: ['10.x', '12.x']
    name: Node ${{ matrix.node }}

    steps:
      # ... 省略 ...

      - name: 'Slack notification (not success)'
        uses: homoluctus/slatify@master
        if: '! success()'
        with:
          type: ${{ job.status }}
          username: GitHub Actions (Failure)
          job_name: ':togowl: :nodejs:*${{ matrix.node }}* Tests'
          mention: channel
          mention_if: always
          icon_emoji: 'tio2'
          url: ${{ secrets.SLACK_WEBHOOK }}

  notify:
    needs: test
    runs-on: ubuntu-latest

    steps:
      - name: 'Slack Notification (success)'
        uses: homoluctus/slatify@master
        if: always()
        with:
          type: ${{ job.status }}
          username: GitHub Actions (Success)
          job_name: ':togowl: :nodejs: All tests'
          icon_emoji: ':renne:'
          url: ${{ secrets.SLACK_WEBHOOK }}
```

**成功以外**という条件の書き方がなかなか見つからず苦戦しました..。  
`if: '! success()'`と書けばOKです。`!`後のスペースがミソ😢

また、失敗した場合はユーザー画像を変更し、Channelに通知させています。  
`username`を変更しないと、同一ユーザと見なされて画像が変わらないので注意です。

作者の方に相談したらすぐ実装してくださり圧倒的感謝🙏

{{<summary "https://twitter.com/homines22/status/1175780265903325184?s=20">}}

その他の部分は参考にさせていただいた以下ブログをご覧ください。

{{<summary "https://sue445.hatenablog.com/entry/2019/09/09/233119">}}


よく使う処理のスニペット
------------------------

{{<warn "スニペットはGistの内容に追従します">}}
執筆時点の内容とは限りません。ご了承下さい。
{{</warn>}}


### Pipenvで依存関係インストール

Pipenvを使う場合の準備です。

<script src="https://gist.github.com/tadashi-aikawa/2bfc154d0d64f4e8b321ff96676dc6a1.js?file=pipenv.yaml"></script>

### Code Climateでテストレポート登録

テスト結果を[Code Climate]に送る場合です。

<script src="https://gist.github.com/tadashi-aikawa/2bfc154d0d64f4e8b321ff96676dc6a1.js?file=code-climate.yaml"></script>


よく使うワークフローファイルのテンプレート
------------------------------------------

Actionのリポジトリを作成するほどではないため、Gistで管理することにしました。

{{<warn "スニペットはGistの内容に追従します">}}
執筆時点の内容とは限りません。ご了承下さい。
{{</warn>}}


### Nodeプロジェクト

npmを使ってCIするケースです。

<details>
  <summary>展開する</summary>
  <script src="https://gist.github.com/tadashi-aikawa/2bfc154d0d64f4e8b321ff96676dc6a1.js?file=node.yaml"></script>
</details>

### Pipenvプロジェクト with Bats

[Pipenv]で環境構築し、[pytest]と[Bats]を使ってCIするケースです。

<details>
  <summary>展開する</summary>
  <script src="https://gist.github.com/tadashi-aikawa/2bfc154d0d64f4e8b321ff96676dc6a1.js?file=pipenv-bats.yaml"></script>
</details>

[Bats]によるCLIテストが不要ならそこだけ削除してください。


総括
----

[GitHub Actions]に移行してから2週間経って所感とノウハウをまとめました。

今も動作は高速なおかげで、心地よい開発ができています🙂  
変数機能に対応すると記述がシンプルになったり幅が広がりそうなので、密かに期待しています。

[GitHub Actions]: https://github.com/features/actions
[Code Climate]: https://codeclimate.com
[pytest]: http://doc.pytest.org/en/latest
[Bats]: https://github.com/bats-core/bats-core
[Jest]: https://jestjs.io/ja/
[Pipenv]: https://docs.pipenv.org/

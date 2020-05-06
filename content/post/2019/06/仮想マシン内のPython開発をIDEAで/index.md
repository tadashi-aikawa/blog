---
title: 仮想マシン内のPython開発をIDEAで
slug: develop-python-in-virtual-machine-with-intellij-idea
date: 2019-06-29T19:28:42+09:00
thumbnailImage: images/cover/2019-06-29.jpg
categories:
  - engineering
tags:
  - python
  - idea
  - pycharm
---

仮想マシン(Ubuntu)のPythonプロジェクトを、ホスト(Windows)の[IntelliJ IDEA]で開発できるようにしてみました。

<!--more-->

{{<cimg "2019-06-29.jpg">}}

<!--toc-->


はじめに
--------

5月に[VS Code]でリモート開発できるようになった旨の記事を書きました。

{{<summary "https://blog.mamansoft.net/2019/05/04/vscode-over-wsl-ssh-docker/">}}

あれから、Linuxで稼働するプロジェクトの開発はできるだけ[VS Code]を使うようにしてきました。  
しかし、IDEとして見ると、[IntelliJ IDEA]を恋しくなることが多々ありました。

『[IntelliJ IDEA]でも[VS Code]と近しい開発ができないだろうか..』

そのような経緯からチャレンジしてみました。

結論から言うと、 **[VS Code]ほどではないが現実的に開発できる状態までいける** と思います。


### 前提

以下の環境で動作確認しています。

|      環境       |       バージョンなど       |            備考            |
| --------------- | -------------------------- | -------------------------- |
| ローカル        | Windows10 (10.0.18362)     | [IntelliJ IDEA]動作環境    |
| リモート        | Ubuntu in VM (18.04.1 LTS) | Pythonプロジェクト動作環境 |
| [Vagrant]       | 2.2.0                      |                            |
| [Virtual Box]   | 5.2.20 r125813             |                            |
| [IntelliJ IDEA] | 2019.1.3                   |                            |

{{<warn "無料版では使えません">}}
本記事はUltimate版のみの機能を必要とします。  
Community版を利用されている場合は[Ultimate版]の試用/購入を検討してみてください。

[Ultimate版]: https://www.jetbrains.com/idea/buy/#personal?billing=yearly
{{</warn>}}


IntelliJ IDEAの設定
-------------------

### デプロイ設定

リモート環境へのデプロイ設定が必要です。  
設定の`Build, Execution, Deployment` > `Deployment`から追加しましょう。

{{<himg "resources/20190629_1.png">}}

`Test Connection`をクリックして接続できればOKです。

設定名(ubuntu)や `Host` `User name` `Authentication` には適切な値を設定してください。


### SDKの設定

プロジェクトのSDKにSSH Interpreterを設定しましょう。  
`Existing server configuration`で先ほど作成したデプロイ設定を選択します。

{{<himg "resources/20190629_2.png">}}

次に`リモートのインタープリタへのパス`と`リモートの同期先`を指定します。

{{<himg "resources/20190629_3.png">}}

{{<refer "リモート Python インタープリターの構成" "https://pleiades.io/help/idea/configuring-remote-python-sdks.html">}}

{{<warn "同期すると改行コードで大量に差分が出る..">}}
LF改行に統一しましょう。
{{</warn>}}


### 再起動

設定が終わったら[IntelliJ IDEA]を再起動します。


動作確認
--------

### テスト

まずはテストを実行してみます。

```
Testing started at 20:17 ...
ssh://vagrant@ubuntu:2222/home/vagrant/.local/share/virtualenvs/jumeaux-kkpgPyTd/bin/python -u /home/vagrant/.pycharm_helpers/pycharm/_jb_pytest_runner.py --path /home/vagrant/git/github.com/tadashi-aikawa/jumeaux/tests
Launching pytest with arguments /home/vagrant/git/github.com/tadashi-aikawa/jumeaux/tests in /home/vagrant/git/github.com/tadashi-aikawa/jumeaux/tests
============================= test session starts ==============================
```

[IntelliJ IDEA]上で結果が表示され、上記のようにログでリモートに接続された旨が表示されていればOKです。

勿論、デバッグ実行した場合はブレイクポイントで止まりますよ😄

{{<himg "resources/20190629_4.png">}}

接続の関係上、ローカル実行より速度は低下します。  
仕組み上、避けられない問題だと思いますので気にしません。


### 実行

普通に実行してみます。  
デバッグができていたので当然成功します。

```
ssh://vagrant@ubuntu:2222/home/vagrant/.local/share/virtualenvs/jumeaux-kkpgPyTd/bin/python -u /home/vagrant/git/github.com/tadashi-aikawa/jumeaux/jumeaux/executor.py init simple
✨ [Create] config.yml
✨ [Create] requests
✨ [Create] templates with a api directory
```

このコマンドはWorking Directory配下にファイルを作成するです。  
作成先は**ローカルではなくリモートのみ**になるようです。


開発フローの考慮
----------------

同期の挙動を考慮する必要があるため、開発フローは厳格にした方がよいと思いました。

|      タスク      | ローカル | リモート |                   備考                   |
| ---------------- | -------- | -------- | ---------------------------------------- |
| ソースコード変更 | O        | X        | リモート→ローカルへは同期されないから    |
| package更新      | X        | O        | インタープリタはリモートだから           |
| Git操作          | O        | X        | リモート→ローカルへは同期されないから    |
| リリース前確認   | X        | O        | git pull. 実際に動かすのはリモートだから |
| リリース         | X        | O        | Windowsではできないから                  |
| リリース後作業   | O        | X        | git pull                                 |

リモート環境のソースコードは参考程度に考えましょう。  
ローカルとブランチが同期していないため、特にGitの差分を気にしてはいけません。

そのため、リリース前確認/リリースのフェーズではローカルは一切触らず、リモートの適切なブランチで作業が必要です。  
ローカルを触っていけないのは、ローカルを触るとリモートへの同期が走るためです。

リモートのリリース作業中に発生した変更点は、ローカルにてGitから取得しましょう。


総括
----

Windowsの[IntelliJ IDEA]でUbuntuのPythonプロジェクトを開発できるようにしてみました。

[VS Code]みたく完全にリモート環境に入り込んで開発できるわけではなく、それなりに気を使う必要があります。  
それでも[IntelliJ IDEA]を使うメリットはそれを上回ると信じています。

しばらく使ってみて、他に注意点が出てくるかもしれません。  
その時は加筆します。

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[VS Code]: https://code.visualstudio.com/
[Vagrant]: https://www.vagrantup.com/
[Virtual Box]: https://www.virtualbox.org/

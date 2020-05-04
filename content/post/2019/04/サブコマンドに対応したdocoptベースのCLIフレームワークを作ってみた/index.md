---
title: サブコマンドに対応したdocoptベースのCLIフレームワークを作ってみた
slug: subcommand-supported-docopt-base-cli-framework
date: 2019-04-24T19:47:58+09:00
thumbnailImage: images/cover/2019-04-24.jpg
categories:
  - engineering
tags:
  - python
---

サブコマンドに対応したdocoptベースのCLIフレームワークを作ってみました。

<!--more-->

{{<cimg "2019-04-24.jpg">}}

<!--toc-->


はじめに
--------

私は[docopt]が好きです。  
ほぼ全ての言語で可能な場合は[docopt]を使うようにしています。

そんな[docopt]ですが、私が理想とするCLI開発のため足りないと感じるモノがいくつかありました。  
それらを得るため、[docopt]をベース(依存)とした新しいCLIフレームワークをPythonで作ってみました。


docopt
------

### docoptとは

CLIのインターフェースを記載すると、自動的に引数へと変換してくれる言語です。

{{<summary "http://docopt.org/">}}

詳しくは上記サイトに説明されていますが、オススメのポイントは以下です。

* docと仕様が乖離しない
* helpコマンドで出力するメッセージとしても使える
* Usageのパターン以外を受けつけないので組み合わせValidationがシンプル

### コードと実行例

例えば以下のような`main.py`を作成します。

{{<file "main.py">}}
```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Naval Fate.

Usage:
  app ship new <name>...
  app ship <name> move <x> <y> [--speed=<kn>]
  app -h | --help
  app --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --speed=<kn>  Speed in knots [default: 10].
"""


from docopt import docopt


def main():
    args = docopt(__doc__)
    print(args)


if __name__ == '__main__':
    main()
```
{{</file>}}

`docopt(__doc__)`で引数を解析して、結果を辞書型にします。

Usageに沿ったパターンで実行すると以下のようになります。

```
$ python main.py ship your_ship move 10 20 --speed 7
{'--help': False,
 '--speed': '7',
 '--version': False,
 '<name>': ['your_ship'],
 '<x>': '10',
 '<y>': '20',
 'move': True,
 'new': False,
 'ship': True}
```

パターンに違反するとUsageが表示されます。

```
$ python main.py wrongcommand
Usage:
  app ship new <name>...
  app ship <name> move <x> <y> [--speed=<kn>]
  app -h | --help
  app --version
```

`-h`または`--help`でdocの内容全てがヘルプとして表示されます。

```
$ python main.py -h
Naval Fate.

Usage:
  app ship new <name>...
  app ship <name> move <x> <y> [--speed=<kn>]
  app -h | --help
  app --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --speed=<kn>  Speed in knots [default: 10].
```


### docoptに足りないと感じるモノ

とてもクールなツールですが、CLIを作るために以下を欲しくなるときがあります。

#### ディレクトリ階層に沿ったcommand/subcommandの実装

現状では、`docopt(__doc__)`の結果を受け取り、コマンド名やサブコマンド名がキーの値を取得して分岐する必要があります。

APIフレームワークのようにディレクトリ階層に沿った管理ができれば分かりやすいと思いました。

#### command/subcommandごとに階層化されたヘルプの表示

`-h`でヘルプを表示する場合を考えてみてください。  
その前にどの階層まで入力されているかで、知りたい情報が変わるのではないでしょうか。

* `app -h`の場合
    * 全体の説明
    * 受けつけるオプションは何か
    * コマンドはどのようなものがあるのか
* `app command -h`の場合
    * commandの説明
    * commandが受けつけるオプションは何か
    * commandに続くサブコマンドはどのようなものがあるのか
* `app command subcommand -h`の場合
    * command subcommandの説明
    * command subcommandが受けつけるオプションは何か

これらをdocoptで実装するのは非常に大変です。

#### パース後に分かりやすい名前でインスタンスにパース

パース後、辞書のキーは非常にストレートです。

```python
{'--help': False,
 '--speed': '7',
 '--version': False,
 '<name>': ['your_ship'],
 '<x>': '10',
 '<y>': '20',
 'move': True,
 'new': False,
 'ship': True}
```

ただ、実装時は以下のような名称がいいのではないでしょうか。(コマンド引数であることは分かりやすいですが)

* `--speed`より`speed`
* `<name>`より`name`


owcli
-----

docoptに欲しいモノを実現するため、作ったCLIフレームワークがowcliです。

{{<summary "https://pypi.org/project/owcli/">}}

まだバージョンは0.2.0ですが、自分が開発しているプロダクトに取り込みながら1.0を目指します。


### 特徴

owcliはライブラリでもあり、CLIでもあります。  
記述量を少なくするための特徴があります。

* ディレクトリ構成からcommand/subcommandに対応
* ディレクトリ階層に沿ったヘルプを表示できる
* コマンド引数はpythonicなプロパティ名を持ったインスタンスに自動変換される

なお、依存モジュールとして[Jumeaux]でも使っている自家製package.. OwlMixinを使用しています。

{{<summary "https://pypi.org/project/owlmixin/">}}

[Jumeaux]: https://pypi.org/project/jumeaux/


owcliを使ってみる
-----------------

### プロジェクト作成

まずはowcliをインストールします。  
グローバルにインストールしたくない場合は適当な仮想環境を使って下さい。

```
$ pip3 install --user owcli
```

ヘルプを見てみましょう。

```
$ owcli -h
Usage:
  owcli <command> [<subcommand>] [<args>...]
  owcli <command> [<subcommand>] (-h | --help)
  owcli (-h | --help)
  owcli --version

Commands:
  init                Command1
```

`init`コマンドがありますね。  
では`init`コマンドの詳細を見てみましょう。

```
$ owcli init -h
Command1

Usage:
  owcli init <root> [-n <your_name>|--name <your_name>] [-m <mail_address>|--mail <mail_address>]
  owcli init (-h | --help)

Options:
  <root>                         Root directory.
  -n, --name <your_name>         Your name.
  -m, --mail <mail_address>      Your mail address.
  -h --help                      Show this screen.
```

owcliをプロジェクトを初期化するコマンドが分かりました。  
当然ですが、owcliのCLI機能もowcliを使っています😉

owcli-testというCLIのプロジェクトを作ってみましょう。  
雛形としてサンプルプロジェクトが作成されます。

```
$ owcli init owcli-test
------------------------
| Create entries...    |
------------------------
📂 /home/vagrant/tmp/owcli-test
 ∟📄 README.md
 ∟📂 owcli-test
   ∟📂 commands
     ∟📂 cmd1
       ∟📄 __init__.py
       ∟📄 main.py
     ∟📄 __init__.py
     ∟📂 cmd2
       ∟📂 subcmd2
         ∟📄 __init__.py
         ∟📄 main.py
       ∟📄 __init__.py
       ∟📄 main.py
       ∟📂 subcmd1
         ∟📄 __init__.py
         ∟📄  main.py
   ∟📄  __init__.py
   ∟📄  main.py
 ∟📄  Pipfile
 ∟📄  setup.py

------------------------
| Next you have to ... |
------------------------
$ cd owcli-test
# Change python_version in Pipfile if you don't want to use specified version.
$ pipenv install
$ pipenv run python owcli-test/main.py --help
```

`commands`配下には`コマンド`>`サブコマンド`の順にディレクトリが作成されます。  
その中にある`main.py`がそれぞれのエントリポイントです。

例えば、`commands/cmd2/subcmd1/main.py`は`owcli cmd2 subcmd1`というコマンド・サブコマンドのエントリポイントです。


### 仮想環境構築

`owcli init`は`Pipfile`を用意してくれます。  
仮想環境の作成しましょう。

```
$ cd owcli-test
$ pipenv install
$ pipenv shell
```


### 実行

動作確認として`cmd2 subcmd1`を実行してみましょう。  
owcliをCLIとして実行したときと同様、階層化ヘルプで安心してコマンドを入力できます。

```
$ ./owcli-test/main.py -h
Usage:
  owcli-test <command> [<subcommand>] [<args>...]
  owcli-test <command> [<subcommand>] (-h | --help)
  owcli-test (-h | --help)
  owcli-test --version

Commands:
  cmd1                Command1
  cmd2                Command2

$ ./owcli-test/main.py cmd2 -h
Usage:
  owcli-test cmd2 [<subcommand>] [<args>...]
  owcli-test cmd2 (-h | --help)

Subcommands:
  subcmd2                       Subcommand2
  subcmd1                       Subcommand1

$ ./owcli-test/main.py cmd2 subcmd1 -h
Subcommand1

Usage:
  owcli-test cmd2 subcmd1 <names>... [-f|--flag]
  owcli-test cmd2 subcmd1 (-h | --help)

Options:
  <names>...                           Names
  -f --flag                            Flag
  -h --help                            Show this screen.
```

最終的には以下のコマンドを実行してみました。

```
$ ./owcli-test/main.py cmd2 subcmd1 name1 name2 -f
flag: true
names:
  - name1
  - name2
```

引数がyamlで表示されました。

なお、存在しないサブコマンドを実行すると以下のような表示になります。

```
$ ./owcli-test/main.py cmd2 hoge

| Subcommand `hoge` is not found in `cmd2` command.
| Show available subcommands.
`-------------------------------------------------------------------------------

  subcmd2                       Subcommand2
  subcmd1                       Subcommand1
```


### ソースコード確認

最後に実行したサブコマンドのエントリポイントである`commands/cmd2/subcmd1/main.py`の実装を見てみましょう。

{{<file "commands/cmd2/subcmd1/main.py">}}
```python
"""Subcommand1

Usage:
  {cli} <names>... [-f|--flag]
  {cli} (-h | --help)

Options:
  <names>...                           Names
  -f --flag                            Flag
  -h --help                            Show this screen.
"""
from owlmixin import OwlMixin, TList


class Args(OwlMixin):
    names: TList[str]
    flag: bool


def run(args: Args):
    print(args.to_yaml())
```
{{</file>}}

サブコマンド名までは全て`{cli}`に含まれるため、このサブコマンドの記述だけに集中できます。

エントリポイントは`run(args: Args)`です。  
`args`はパースされた引数の情報が`Args`クラスのインスタンスとして入ってきます。  
上記コードでは、`args`をyamlとして出力しているだけです。

`Args`のプロパティが`int`など数値の場合、文字列ではなく数値にオートキャストされます。  
また、以下のようにプロパティ名をpythonicな名称に自動変換します。

* `--flag`を`flag`
* `<names>`を`names`
* `--multi-word`は`multi_word`

{{<why "OwlMixinやTListの仕様は??">}}
以下の仕様書をご覧下さい。
{{<summary "https://tadashi-aikawa.github.io/owlmixin/">}}

大まかな使い方/イメージを掴みたい場合はGitHubのREADMEをオススメします。

{{<summary "https://github.com/tadashi-aikawa/owlmixin">}}

よく使うのは以下2つです。

* `TOption[T]`
    * Optionモナドのようなラッパ
    * `optional`とは違い`get`などで中身を取り出す必要がある
* `TList[T]`
    * `List`に関数型言語チックな実装を加えた型
    * `map`や`filter`などが使える
{{</why>}}


サブコマンドを持たないコマンドを作りたい場合は、該当ディレクトリ直下の`main.py`に同様の実装をしてください。

なお、コマンドかサブコマンドかは階層構造にのみ依存します。  
そのため、**`main.py`を移動するだけでコマンドの名称/階層変更ができる**という強みがあります。


総括
----

サブコマンドに対応したdocoptベースのCLIフレームワーク、owcliを作ってみました。

本当は以下のようなことも書きたかったのですが、長くなりそうなので次の機会にします。

* owcliの実装と設計思想
* owcliで作成したCLIツールをリリースするときのお膳立て
* 今後の展望


[docopt]: http://docopt.org/

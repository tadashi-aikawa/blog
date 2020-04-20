---
title: "Anacondaを使ってみた"
slug: use-anaconda
date: 2018-06-11T05:02:00+09:00
thumbnailImage: https://upload.wikimedia.org/wikipedia/en/thumb/c/cd/Anaconda_Logo.png/200px-Anaconda_Logo.png
categories:
  - engineering
tags:
  - python
  - anaconda
  - windows
---

WindowsでAnacondaの環境を作成してみました。

<!--more-->

{{<cimg "https://upload.wikimedia.org/wikipedia/en/thumb/c/cd/Anaconda_Logo.png/200px-Anaconda_Logo.png">}}


<!--toc-->


Anacondaとは
------------

最も有名なPythonのData Scienceプラットフォームです。

{{<summary "https://www.anaconda.com/">}}

データ解析に適した環境が全て準備されており、pipとは異なる独自のパッケージ管理方式を採用しています。


なぜAnaconda
------------

普段はLinuxで[pipenv]を使っておりますが、仕事で以下の環境が必要になったためです。

* Windows
* 緯度経度を扱うことができる
* jupyter notebookが使えると嬉しい

緯度経度のパッケージに[pyproj]を使うのですが、WindowsではLinuxとは異なり`pip install`以外にも依存性の解決が必要です。  
またjupyter notebookやrequests, pyyamlなどよく使用するパッケージも含まれているため試してみました。

一方、新しいコマンドを覚えたなくてはいけないことやサイズが大きいことが少し気になっています。  
それでもWindows特有の問題でハマるというリスクを回避できることに価値があると思っています。

[pyproj]: https://pypi.org/project/pyproj/
[pipenv]: https://docs.pipenv.org/


インストール
------------

[Chocolatey]でインストールします。

[Chocolatey]: https://chocolatey.org/

```
cinst anaconda3 --params="/AddToPath:1"
```

{{<alert "warning">}}
データ容量が大きいため、ネットワークが不安定だと失敗することがあります。
{{</alert>}}


### Condaの最新化

condaは最新ではないため最新化します。

```
conda update -n base conda
```


仮想環境
--------

### 作成

`conda create`で`<myenv>`という名前の仮想環境を作ります。

```
conda create --name <myenv>
```

成功すると`C:\tools\Anaconda3\envs\<myenv>`に環境が作成されます。


### 使用

`activate`で環境名を指定します。  

```
activate github
```

この状態で`conda install`を実行するとパッケージをインストールできます。  
以下は[pyproj]をインストールするコマンドです。

```
conda install -c conda-forge pyproj 
```

環境の使用をやめる場合は`deactivate`を実行します。


### 確認

環境を確認するコマンドをいくつか紹介します。

| コマンド                | 説明                                                          |
|-------------------------|---------------------------------------------------------------|
| `conda info`            | 現在の環境情報を確認                                          |
| `conda info --envs`     | 存在する全ての仮想環境を確認                                  |
| `conda list -n <myenv>` | 環境`<myenv>`にインストールされているとパッケージリストを表示 |


### 削除

環境を削除をするときは`conda remove`コマンドを使用します。

```
conda remove -n <myenv> --all
```


Jupyter Notebook
----------------

実行ソースと結果の共有に重きを置いたインタラクティブな開発環境です。

{{<summary "http://jupyter.org/">}}

詳細はまたの機会にしまして、ここでは実行方法だけを説明します。

Jupyter Notebookはグローバル環境にインストールされていますので実行するだけです。

```
jupyter-notebook
```

Vimのキーバインディングを使用したかったので拡張機能セットの以下をインストールしました。

```
conda install -c conda-forge jupyter_contrib_nbextensions
```


総括
----

WindowsでAnacondaをインストールし、condaコマンドで環境をいじってみました。  
また、Jupyter Notebookを少し触ってみました。

condaコマンドや仮想環境の挙動で気になる点がいくつか残っているため、もう少し調べてみたいと思います。


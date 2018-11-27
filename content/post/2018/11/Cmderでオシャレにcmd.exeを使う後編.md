---
title: Cmderでオシャレにcmd.exeを使う -後編-
slug: use-cmd-elegant-on-cmder-phase2
date: 2018-11-26T03:39:23+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/3sciy8337ls1bvn/20181126_1.png
categories:
  - engineering
tags:
  - windows
  - terminal
  - cmd
  - cmder
  - powerline
---

前回の記事 [Cmderでオシャレにcmd.exeを使う -前編-](/2018/11/18/use-cmd-elegant-on-cmder-phase1/)の続きです。

<!--more-->

<a href="https://dl.dropboxusercontent.com/s/3sciy8337ls1bvn/20181126_1.png">
  <img src="https://dl.dropboxusercontent.com/s/3sciy8337ls1bvn/20181126_1.png"/>
</a>

<!--toc-->


はじめに
--------

前回の記事を読んでいると前提で話を進めます。  
もし前回記事をご覧になっていない方は必要に応じてご覧下さい。

{{<summary "https://blog.mamansoft.net/2018/11/18/use-cmd-elegant-on-cmder-phase1/">}}

今回の記事は見た目よりも実用性が中心となります。


Owl Cmder Tools
---------------

今回紹介するコマンドや設定の大部分は以下のリポジトリに含まれています。  
手元にcloneされている前提で進めます。

{{<summary "https://github.com/tadashi-aikawa/owl-cmder-tools">}}

[Owl Cmder Tools]: https://github.com/tadashi-aikawa/owl-cmder-tools


Powerlineの更なる強化
---------------------

前回の記事で [Gitリポジトリの情報を更に詳しく表示する](https://blog.mamansoft.net/2018/11/18/use-cmd-elegant-on-cmder-phase1/#git%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E3%81%AE%E6%83%85%E5%A0%B1%E3%82%92%E6%9B%B4%E3%81%AB%E8%A9%B3%E3%81%97%E3%81%8F%E8%A1%A8%E7%A4%BA%E3%81%99%E3%82%8B) というセクションがありました。

[Owl Cmder Tools]ではより高機能に..簡単にインストールできるようにしました。  
ブログから変更点を確認して直接ソースコードをいじる必要はありません。当然ですね :kissing_heart:

### 前提

* [AmrEldib/cmder-powerline-prompt](https://github.com/AmrEldib/cmder-powerline-prompt)がインストール済

### インストール方法

[Owl Cmder Tools]の`config/powerline_git.lua`を`%cmder_root%/config/`配下にコピーするだけです。

### 読み方

Gitに関する表示についてのみ説明します。

ブランチマークの隣には現在のブランチ名が表示されます。

![alt](https://dl.dropboxusercontent.com/s/27tgi9bs1y59y9l/20181126_7.png)

ワークスペースに変更がある場合は色が変わり、変更内容によってマークが変わります。

![alt](https://dl.dropboxusercontent.com/s/j41nigodj8msadi/20181126_2.png)

* `*`は変更
* `-`は削除
* `?`は未管理

ステージングエリアにaddされたエントリ数はカメラマークと一緒に表示されます。  

![alt](https://dl.dropboxusercontent.com/s/oklhgnj08j83gdj/20181126_3.png)

ハロウィンマークはファイル名変更です。

![alt](https://dl.dropboxusercontent.com/s/3m4djh78f2ntopk/20181126_4.png)

pushされていないコミット数はクラウドマークと一緒に`↑`で表示されます。

![alt](https://dl.dropboxusercontent.com/s/1gq5ibdjiqqeqyp/20181126_5.png)

逆にfetch済みだがmergeしていないコミット数は`↓`で表示されます。

![alt](https://dl.dropboxusercontent.com/s/96fu0wyyhladm6x/20181126_6.png)

左側がファイルシステムであり、右に行くにつれてリモートリポジトリに近い...とイメージできるようにしました。

{{<warn "競合した場合は...">}}
専用の表現が用意されています... が2018/11/26時点ではちゃんと実装していません。  
競合した場合の判断は各自でお願いします。
{{</warn>}}


便利なコマンド群
----------------

できるだけ思考と行動を一体化するためにオリジナルコマンドをいくつか用意しています。

コマンドは全てbatファイルとなっており、PATHが通っていればどこからでも実行できます。  
また全てのコマンドは[fzf]のIFを使用しています。


### 必要な準備

[Owl Cmder Tools]の`bin`を環境変数PATHに追加してください。

コマンドごとに必要なツールや準備があります。

| コマンド名 | 必要なツール  |                         準備                         |
| ---------- | ------------- | ---------------------------------------------------- |
| cdg        | [fzf], [gowl] |                                                      |
| cdr        | [fzf], [fd]   |                                                      |
| cdz        | [fzf]         | `config/cdz.lua`を`%cmder_root%/config/`配下にコピー |
| gc         | [fzf]         |                                                      |
| gcr        | [fzf]         |                                                      |
| r          | [fzf]         |                                                      |
| vimd       | [fzf], [fd]   |                                                      |
| vimf       | [fzf], [fd]   |                                                      |

各コマンドの説明はイメージ画像を交えて紹介します。

[fd]: https://github.com/sharkdp/fd
[fzf]: https://github.com/junegunn/fzf
[gowl]: https://github.com/tadashi-aikawa/gowl

前回の記事に沿って準備をしている場合はgowl以外のツールがインストール済みだと思います。


### cdg

fzfの対話IFを使ってローカルのGitリポジトリへ移動します。

{{<himg "https://dl.dropboxusercontent.com/s/q0hzd2u9w77r703/20181126_8.gif">}}

第1引数に正規表現を指定すると、大文字小文字を区別せずに部分一致で初期候補を絞り込めます。

{{<info "Windowsでコマンドの実行結果をfzfに渡す方法">}}
Bashだとcdgは以下の様に書けます。
```bash
cd $(gowl list | fzf)
```
Windowsでは`for /f "usebackq"`構文によって、これを実現しています。
```bat
for /f "usebackq" %t in (`gowl list ^| fzf`) do cd %t
```
{{</info>}}



### cdr

fzfの対話IFを使ってカレントディレクトリ配下のディレクトリへ移動します。

{{<himg "https://dl.dropboxusercontent.com/s/oyw3s3mrph4n0wf/20181126_9.gif">}}

第1引数に正規表現を指定すると、大文字小文字を区別せずに部分一致で初期候補を絞り込めます。

### cdz

fzfの対話IFを使って最近移動したディレクトリへ移動します。

{{<himg "https://dl.dropboxusercontent.com/s/fv2mye0tz4451u7/20181126_10.gif">}}

移動履歴は`%home%/.cdz`ファイルに記録されるため、cmderを起動しなおしても候補は保持されます。

第1引数に正規表現を指定すると、大文字小文字を区別せずに部分一致で初期候補を絞り込めます。

### gc

fzfの対話IFを使ってローカルのブランチをチェックアウトします。

{{<himg "https://dl.dropboxusercontent.com/s/5lmcr1nh5yn6vue/20181126_11.gif">}}

### gcr

gcのリモートブランチ版です。

{{<himg "https://dl.dropboxusercontent.com/s/3wp4peevta5bzh3/20181126_12.gif">}}

リモート名は`origin`固定です。つまり`git checkout -b <branch> origin/<branch>`が実行されます。

### r

fzfの対話IFを使ってコマンド履歴を検索します。  
コマンドを選択すると内容がクリップボードにコピーされます。

{{<himg "https://dl.dropboxusercontent.com/s/yx5ryev5i7j4rj9/20181126_13.gif">}}

{{<warn "シングルクォーテーションを含むコマンドに注意">}}
シングルクォーテーションを含むコマンドは正しくコピーされません。
{{</warn>}}


### vimd

fzfの対話IFを使ってカレントディレクトリ配下のディレクトリをvimで開きます。

{{<himg "https://dl.dropboxusercontent.com/s/110msv8thi90s4f/20181126_14.gif">}}


### vimf

fzfの対話IFを使ってカレントディレクトリ配下のファイルをvimで開きます。

{{<himg "https://dl.dropboxusercontent.com/s/dcr4q0nuvbvwhmr/20181126_15.gif">}}


総括
====

全2回にわたり、Cmderを使ってWindowsの`cmd.exe`をオシャレで快適に使う方法を紹介しました。

ターミナル環境は世界を変えますので皆さんも是非チャレンジしてみてください。

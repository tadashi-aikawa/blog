---
title: WSL/SSH/Dockerを越えてVSCodeを使う
slug: vscode-over-wsl-ssh-docker
date: 2019-05-04T11:52:42+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/bqs82plydercwdd/vidit-goswami-684033-unsplash.jpg
categories:
  - engineering
tags:
  - vscode
  - wsl
  - docker
  - windows
  - ubuntu
---

VS Codeがリモート対応し始めたので試してみました。

<!--more-->

{{<warn "2019-05-04: 現在 本記事で使用する機能は安定版ではありません!!">}}
公式にも記載がある通り、本記事で使用するVS Codeおよび拡張機能は2019-05-04現在安定版ではありません。  
問題の生じる可能性が通常版より高いことを理解した上でお試し下さい。
{{</warn>}}

{{<update "2019-06-18: 現在はVSCode安定版に本機能が取り入れました">}}
Visual Studio Code Insidersのインストールは必要ありません。
記事中のVisual Studio Code Insidersは、通常のVSCodeに置き換えてお読み下さい。
{{</update>}}


<img src="https://dl.dropboxusercontent.com/s/bqs82plydercwdd/vidit-goswami-684033-unsplas"/>

<!--toc-->


はじめに
--------

2019-05-01に以下の記事を書きました。

{{<summary "https://blog.mamansoft.net/2019/05/01/sshcode-makes-vscode-everywhere/">}}

この記事を書いていた時はかなりエキサイティングでした。  
しかし、翌日に謀ったようなタイミングで公式から以下のブログが投下されました。

{{<summary "https://code.visualstudio.com/blogs/2019/05/02/remote-development">}}

ラフに要約すると以下です。

* ホストマシン以外の環境で開発できる仕組みを作った
* 対応環境は以下
    * WindowsからWSL
    * SSHできる環境
    * Docker
* Insider版の`Remove Development`拡張で試してみてほしい

🤓『sshcodeの記事書く必要なかったんや... orz』

そういう訳で本記事を書くことにしました。

### 想定する読者

以下の環境/知識があること。

* VS Code
* WSL
* VM

以下の知識があること。

* Docker
* Python
* Nginx


環境
----

|        対象        |                               バージョン                               |
| ------------------ | ---------------------------------------------------------------------- |
| Windows 10 Home    | 10.0.17134                                                             |
| VS Code            | 1.34.0-insider (user setup) (473af338e1bd9ad4d9853933da1cd9d5d9e07dc9) |
| Remote Development | 0.12.0                                                                 |

接続先の環境は別途記載します。


準備
----

### Visual Studio Code Insidersのインストール

新機能をいち早く試すためのInsiders版をインストールする必要があります。  
2019-05-04現在、通常版では試せません。

{{<summary "https://code.visualstudio.com/insiders/">}}

Chocolateyではインストールできないので、上記から普通にインストールします。  
通常版に取り込まれれば不要になるので、拘る必要も無いですね。

{{<why "Insider版のExtensionや設定はどこに..?">}}
通常版と並行して使う場合、Extensionや設定の同期がしたくなります。  
その際、インストール先を把握しておくと便利だと思います。

以下はWindowsの場合です。

|   項目    |           VS Codeの場所            |            VS Code Insidersの場所             |
| --------- | ---------------------------------- | --------------------------------------------- |
| Extension | `%HOME%\.vscode\extensions`        | `%HOME%\.vscode-insiders\extensions`          |
| 設定      | `%HOME%\AppData\Roaming\Code\User` | `%HOME%\AppData\Roaming\Code - Insiders\User` |

設定のパスはスペースを含むので、Symlinkを貼る場合は注意してください。  
Mklinkに渡すパスをダブルクォーテーションで囲むなどの大作が必要です。
{{</why>}}

{{<why "Insider版をCLIとして実行するには..?">}}
`code-insiders`コマンドが使えます。  
勿論、`code-insiders --install-extension`コマンドでExtensionをインストールすることも可能です。
{{</why>}}

### Remote Development拡張のインストール

VS Code Insidersを立ち上げてインストールしてください。

CLIを使う場合は以下のコマンドになります。

```
$ code-insiders --install-extension ms-vscode-remote.vscode-remote-extensionpack
```


WSL
---

WSLの環境は`16.04.3 LTS (Xenial Xerus)`です。  
`Remote-WSL: New Windows`を実行します。

{{<himg "https://dl.dropboxusercontent.com/s/t536qxuwek78c6s/20190504_1.png">}}

新しいウィンドウが立ち上がるとWSL上で`WS Code Server`のインストールが始まります。

左下の表示がWSLなればOKです。  
ターミナルを起動するとWSLのbashが起動します。

{{<himg "https://dl.dropboxusercontent.com/s/xut4tlktvrz8nuu/20190504_2.png">}}

*フォルダーを開く* で開くディレクトリを指定できます。  
ファイルエクスプローラーのように、入力とEnterでサクサク対象を探せます。

{{<himg "https://dl.dropboxusercontent.com/s/ugec9mvjxrk6bel/20190504_3.gif">}}


### Pythonを実行してみる

試しにWSL上でPythonを実行してみます。

言語のExtensionはローカルではなく、リモートにインストールする必要があります。

{{<himg "https://dl.dropboxusercontent.com/s/fw46lz7a7d1ypeo/20190504_4.png">}}

インストール完了したら、再読込して`main.py`を作成します。

```python
def main():
    xs: List[int] = [1, 3, 5, 7, 9]
    it: Iterable = map(lambda x: x*2, xs)
    print(list(it))


if __name__ == "__main__":
    main()
```

そのまま実行すると、ターミナルViewが起動して実行コマンドと結果が出力されます。  
実際に何のコマンドが実行されているかも直感的に確認できるので便利ですね。

デバッグ? 勿論できますよ😁

{{<himg "https://dl.dropboxusercontent.com/s/s4mrnzv9s2bx5cb/20190504_5.png">}}


SSH
---

SSHできる環境として、VirtualBoxで作成したLocal VMのUbuntuにアクセスしてみます。  
OSは`18.04.1 LTS (Bionic Beaver)`です。

*Remote-SSH: Connect Current Window to Host...* などコマンドからの接続も可能ですが、今回は`Remote - SSH`ビューを使います。

{{<vimg "https://dl.dropboxusercontent.com/s/o04mhm1gfedn4yn/20190504_6.png">}}

接続先は`.ssh/config`ファイルなどによって特定されます。  
一度リモートで開いたプロジェクトは接続先配下にショートカットができます。  
(上記画像では`go-sam-sample`)

できることはWSLの場合とほぼ一緒なので割愛します。

* リモートのディレクトリやファイルを選択して開くことができる
* リモートのターミナルを開くことができる
* 一部のExtensionはリモートでインストールが必要
* デバッグができる

私はUbuntu on VMで開発することが多いので、この機能が一番重宝すると感じています。


Docker
------

最後はDocker Containerに対してアクセスしてみます。  
Windowsなので上手く出来る気がしませんが...。

### Docker Toolboxのインストール

Chocolateyでインストールします。

```
$ cinst docker-toolbox
```

インストーラーは以下のオプションで実行されるようになっており、VirtualBoxユーザとしても安心です。

* VirtualBoxはインストールしない
* Kitematicはインストールしない
* docker-composeはインストールする
* Git for Windowsはインストールする (本当はしたくないけど無効にできないとか..)

WindowsメニューからDocker Quickstart Terminalを起動すると専用VMが作成されます。  
終わったら以下のコマンドを実行して動作確認します。

```
$ docker run hello-world
```

`Hello from Docker!`と沢山のメッセージが表示されれば成功です。

ターミナルやVS Codeを再起動すると、ターミナルはVS Code上でも認識するようになります。

{{<himg "https://dl.dropboxusercontent.com/s/o1bnkyowaniahug/20190504_7.png">}}

{{<warn "コマンドプロンプトのdockerコマンドやVS CodeでImageやContainerを見られない..">}}
コマンドプロンプトやVS Codeを再起動して試してみてください。  
再起動をしていない場合は動きません。
{{</warn>}}

{{<why "Docker Desktop for Windowsにしないのはなぜ..?">}}
本当は *Docker Desktop for Windows* にしたいのですが、以下の記載から断念しました。

{{<summary "https://docs.docker.com/docker-for-windows/install/">}}

> Note: If your system does not meet the requirements to run Docker Desktop for Windows, you can install Docker Toolbox, which uses Oracle Virtual Box instead of Hyper-V.

Virtual Boxは使っていますので..🤒  
仕事に支障なければHyper-Vへ移行するのもアリかもです。
{{</why>}}

### Containerの起動

今回はnginxのイメージでコンテナを作成してみます。

{{<summary "https://hub.docker.com/_/nginx">}}

```
$ docker run --rm -d -p 8080:80 nginx
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
ea6a3a04c368        nginx               "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:8080->80/tcp   affectionate_cohen
```

Docker Quickstart Terminalで表示されていたVMのIP、192.168.99.100へ疎通確認します。

```
$ curl 192.168.99.100:8080
```

HTMLが返却されればOKです。


### ContainerをVS Codeにアタッチ

*Remote-Containers: Attach to Running Container...* コマンドからの接続も可能ですが、今回は`Docker`ビューを使います。

{{<vimg "https://dl.dropboxusercontent.com/s/4sos8tuoucm8eak/20190504_8.png">}}

今までと同じ要領でドキュメントルートの`/usr/share/nginx/html`を開きましょう。  

{{<himg "https://dl.dropboxusercontent.com/s/w5ry9fqph9bnjo9/20190504_9.png">}}

当たり前のように表示されました。  
Containerは便利CLIやVim環境が乏しいため、VS Codeのメリットを予想以上に感じられました。


### Containerからドキュメントをいじる

最後にContainer内を直接いじってみましょう。  
実際の開発ではVolume Mountなどを使うと思いますが..今回だけは特別ですよ😙

`mamansoft.html`というファイルを追加します。

{{<himg "https://dl.dropboxusercontent.com/s/vln3dkpuhka9tan/20190504_10.png">}}

保存したら、`192.168.99.100:8080/mamansoft.html`にアクセスして確認してみましょう。

{{<himg "https://dl.dropboxusercontent.com/s/i6gdnxxid19i2hf/20190504_11.png">}}

Excellent!!  ちょっとした動作確認ならVMを作らずともイケますね😄


その他
------

地味に便利だったポイントとして、`FILE: 最近開いた項目...`で全リモート環境を選べることです。

{{<himg "https://dl.dropboxusercontent.com/s/niirllij47d3oc6/20190504_12.png">}}

どのプロジェクトを開くかだけを知っていれば、どこに接続するかを意識しなくて良いのは素晴らしいと思いました。



総括
----

VS Codeのリモート開発機能を一通り試してみました。

アナウンス前日にsshcodeの記事を書いたこともあり、多少懐疑的な目を持っていたのは事実です..  
が、そんな心配を吹き飛ばす素晴らしさでした!!👏 さすが公式です!!🙇

記事にはしていませんが、Cent OS7でも普通に動きました。  
alpha版とされていますが、今のところ動かない環境や不具合を見かけていません。

一刻も早くInsider版を卒業して、Stable版に導入されることを願っております🙏

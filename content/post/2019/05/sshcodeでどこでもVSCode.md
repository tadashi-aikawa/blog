---
title: sshcodeでどこでもVS Code
slug: sshcode-makes-vscode-everywhere
date: 2019-05-01T12:29:30+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/byvuemmupa95tyy/ben-white-138743-unsplash.jpg
categories:
  - engineering
tags:
  - vscode
  - code-server
---

sshcodeを使って、どこでもVS Codeを使えるようにしてみました。

<!--more-->

{{<alert "danger">}}
本記事の公開翌日にMicrosoft公式から、同機能の案内がありました。  
特別な理由が無ければそちらを使うことを推奨します。

それについての記事も書きました。

{{<summary "https://blog.mamansoft.net/2019/05/04/vscode-everywhere-as-official/">}}
{{</alert>}}


<img src="https://dl.dropboxusercontent.com/s/byvuemmupa95tyy/ben-white-138743-unsplas"/>

<!--toc-->


はじめに
--------

### 動作条件

**どこでも** と言いましたが以下の条件を満たす場合に限ります。

💻 接続元の条件

* [sshcode]が動作すること
  * 執筆時点だとLinuxとMacOS、WSLはOK。Windowsはダメ(WSL使おう)

💻 接続先の条件

* [code-server]が動作すること
  * 執筆時点だとLinuxとOS XはOK。Windowsはダメ


### 前提条件

今回は **Local VMで起動しているDesktopではないUbuntu環境に配置されたソースを編集すること** を要件とします。  
つまり、Localhost以外のケースについては扱いません。


### 確認環境

以下の環境で確認しました。  
勿論、条件を満たしていれば他の環境でも動くはずです。

#### 接続元(ホスト)

|      対象       |         バージョン         |
| --------------- | -------------------------- |
| Windows 10 Home | 10.0.17134                 |
| Google Chrome   | 74.0.3729.108 (64ビット)   |
| WSL Ubuntu      | 16.04.3 LTS (Xenial Xerus) |
| Vagrant         | 2.2.0                      |
| VirtualBox      | 5.2.20 r125813 (Qt5.6.2)   |


#### 接続先(VM/ゲスト)

|    対象     |         バージョン          |
| ----------- | --------------------------- |
| Ubuntu      | 18.04.1 LTS (Bionic Beaver) |


code-server
-----------

リモートでVS Codeを起動し、ブラウザを経由してアクセス可能にしてくれるツールです。

{{<summary "https://github.com/cdr/code-server">}}

執筆時の最新バージョンは`1.939-vsc1.33.1`です。

### インストール

READMEに書かれているバイナリをダウンロードする方法を使いました。

```
$ wget https://github.com/cdr/code-server/releases/download/1.939-vsc1.33.1/code-server1.939-vsc1.33.1-linux-x64.tar.gz
$ tar zvfx *.g
$ mv code-server1.939-vsc1.33.1-linux-x64/code-server .
```

### 起動

```
$ ./code-server --allow-http --no-auth .
```

localhostに対する通信なので、セキュリティ面はユルユルにします。

* `--allow-http`: httpsではなくhttpでアクセスを許可するオプション
* `--no-auth`: パスワード認証を不要にするオプション

### 使用する

以下のログが出力されていると思いますので、`http://localhost:8443`にアクセスします。

```
INFO  Starting webserver... {"host":"0.0.0.0","port":8443}
```

上手くいけばこんな感じに画面が表示されます。

<a href="https://dl.dropboxusercontent.com/s/vv0bf86dlw3upna/20190430_1.png">
    <img src="https://dl.dropboxusercontent.com/s/vv0bf86dlw3upna/20190430_1.png"/>
</a>

### 気になるところ

[code-server]は素晴らしいです。  
VS Codeのほとんどの機能をブラウザ上でそのまま再現してくれます。

しかし、気になる点もあります。

#### 設定やプラグインの管理が少し面倒

ホストOSでVS Codeを使用している場合、設定(キーバインド含む)やインストールExtensionをいじる機会が多いと思います。  
その際、code-server側の設定を同期するのが少し面倒です。

#### 一部のショートカットキーがブラウザに奪われる (`Ctrl+W`, `Ctrl+N`など)

私はGoogle Chromeを使っていますが、一部のショートカットキーはブラウザの仕様によりブラウザが優先されてしまいます。  
そこだけ気をつければいいのですが、見た目がVS Codeと同じため頭の切り替えは困難です。

上記2つの気になる点を解消するため、sshcodeを使います。


sshcode
-------

sshを通して、[code-server]を自動インストール+起動してくれるツールです。

{{<summary "https://github.com/cdr/sshcode">}}

執筆時の最新バージョンは`0.7.0`です。

### インストール

```
$ wget https://github.com/cdr/sshcode/releases/download/v0.7.0/sshcode-linux-amd64.tar
$ tar vfx *.tar
```

接続元(ホスト)からは接続先(ゲスト)にssh接続さえできれば、[sshcode]をインストールするだけでOKです。  
接続先(ゲスト)に[code-server]をインストールする必要はありません。

### 実行

```
$ ./sshcode vagrant@ubuntu
```

上手くいけばブラウザっぽくない以下ウィンドウが表示されます。

<a href="https://dl.dropboxusercontent.com/s/gko3whn2ut84npj/20190430_2.png">
    <img src="https://dl.dropboxusercontent.com/s/gko3whn2ut84npj/20190430_2.png">
</a>

{{<info "開くディレクトリを指定したい場合">}}
`./sshcode vagrant@ubuntu /tmp`のように最後の引数で指定できます。

ただし、ホームディレクトリを`~`と表すことはできませんので注意してください。
{{</info>}}

{{<why "code-serverが毎回ダウンロードされるのはなぜ..?">}}
sshcodeはcode-serverを`/tmp`配下にインストールするからです。

`/tmp`は特定のタイミングで中身が削除されます。  
例えば、それがVM Ubuntu上であれば仮想マシンを停止(`vagrant halt`)したタイミングで削除されます。

常に最新のVS Codeに追随できる..と考えれば悪いコストではありません。  
Extensionやユーザ設定はホームディレクトリ配下に保存されているので問題ありませんし。
{{</why>}}


#### sshcodeの処理について

[sshcode]はsshごしに[code-server]をインストールした後、以下の処理をしています。

* Extensionの同期
* 設定(キーバインド含む)の同期
* 接続元のGoogle Chromeをappモードで起動  (Google Chromeにショートカットキーを奪われなくなる😄)

Extensionと設定の同期元はデフォルト値が設定されています。

一方、WSLで実行するとWSLのホームディレクトリを参照してしまいます。  
必要に応じて環境変数でWindowsのホームディレクトリ配下を指定するようにしてください。

* `VSCODE_EXTENSIONS_DIR`: Extensionのディレクトリ
* `VSCODE_CONFIG_DIR`: 設定のディレクトリ

実際のコマンドは以下の様になります。

```
$ VSCODE_CONFIG_DIR=/mnt/c/Users/syoum/AppData/Roaming/Code/User VSCODE_EXTENSIONS_DIR=/mnt/c/Users/syoum/.vscode/extensions ./sshcode vagrant@ubuntu
```

コマンドが長いのでaliasの利用をお勧めします。

{{<file "fishの例">}}
```
alias ucode "env VSCODE_CONFIG_DIR=/mnt/c/Users/syoum/AppData/Roaming/Code/User VSCODE_EXTENSIONS_DIR=/mnt/c/Users/syoum/.vscode/extensions sshcode vagrant@ubuntu"
```
{{</file>}}

こんな感じで実行できればCoolですね😉

```
$ ucode /your/project/path
```

{{<warn "一部のExtensionが毎回同期されてしまう...">}}
`VSCODE_EXTENSIONS_DIR`配下のディレクトリに同一Extensionが複数バージョン無いか確認してください。

ホストのVS Code起動中にExtensionの自動更新が実行されると、旧バージョンを含む2つのバージョンを保持します。  
この状態でsshcodeを実行すると以下の無限ループに陥ります。

1. ホストのVS Codeでは新旧2つのバージョンが存在する
2. code-server側は最新のExtensionしか存在しないため、旧バージョンのExtensionをcode-serverへ同期する
3. code-serverが起動されると、旧バージョンは不要なため削除される
4. 1に戻る

同期前にVS Codeを起動しなおすか、Extensionの自動更新をOFFにするとこの問題は解消します。  
Positiveに考えれば、Extensionの更新を教えてくれる..とも言えます。
{{</warn>}}


総括
----

[code-server]と[sshcode]を利用することで、GUIを持たないUbuntuに対してVS Codeで開発できるようにしました。

[code-server]単体でも、工夫すればショートカットキー問題や設定同期問題は解消できます。  
ですが、開発に集中するためにも全て上手くやってくれる[sshcode]の利用をオススメします。

{{<why "sshcodeを使わずにショートカットキー問題を解消する方法はあるの?">}}
Chromeをアプリモードで立ち上げるとショートカットキーが奪われなくなります。

{{<summary "https://www.softantenna.com/wp/tips/chrome-app-mode/">}}

また、ランチャーやスタートメニューにもアプリのように登録されるのでVS Codeと同じ起動感を味わえます。

sshが使えなかったり、同期が必要ない場合はこの方法の方が良いかもしれません。
{{</why>}}


[sshcode]: https://github.com/cdr/sshcode
[code-server]: https://github.com/cdr/code-server

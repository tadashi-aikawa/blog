---
title: "Dockerを跡形も無く消して入れ直してみた"
date: 2017-11-28
thumbnailImage: https://s3-us-west-2.amazonaws.com/svgporn.com/logos/docker.svg
categories:
  - engineering
tags:
  - centos
  - docker
---

以下の理由からDockerを最新にしてみました。

* サーバの容量が無くなってきた
* DockerのImageやContainerが管理しきれなくなってきて消した
* ブログ(Wordpress)のコンテナが再帰不能になった

<!--more-->

<!--toc-->


はじめに
--------

さくらVPSを使っています。OSバージョンは以下の通りです。

```sh
$ cat /etc/os-release
NAME="CentOS Linux"
VERSION="7 (Core)"
```

関係ありませんが、他にJenkinsとNginx(proxy専用)がインストールされています。

{{<alert danger>}}
本記事は執筆時点のやり方です。必ず公式ドキュメントを確認の上、自己責任で実施してください。
{{</alert>}}


DockerとDocker Composeの削除
----------------------------

既存のDockerとDocker Composeを削除します。

<blockquote class="embedly-card"><h4><a href="https://docs.docker.com/engine/installation/linux/docker-ce/centos/#install-using-the-convenience-script">Get Docker CE for CentOS</a></h4><p>To get started with Docker CE on CentOS, make sure you meet the prerequisites, then install Docker. Prerequisites Docker EE customers To install Docker Enterprise Edition (Docker EE), go to...</p></blockquote>


### Dockerの削除

docker-ceを入れていたのでyumで削除します。  
またDocker関連のモノも一掃したいので、`/var/lib/docker` を削除します。

```sh
$ sudo yum remove docker-ce
$ sudo rm -rf /var/lib/docker
```

これで数十GB減りました。


### Docker Compose削除

実行ファイルを削除します

```sh
$ sudo rm /usr/local/bin/docker-compose
```


Dockerのインストール
--------------------

リポジトリを取得してインストールします。

```sh
$ wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.09.0.ce-1.el7.centos.x86_64.rpm
$ sudo yum install docker-ce-17.09.0.ce-1.el7.centos.x86_64.rpm
```

Dockerを起動させます。

```sh
$ sudo systemctl start docker
```

Dockerバージョンの確認をしておきます。

```sh
$ sudo docker version
Client:
 Version:      17.09.0-ce
 API version:  1.32
 Go version:   go1.8.3
 Git commit:   afdb6d4
 Built:        Tue Sep 26 22:41:23 2017
 OS/Arch:      linux/amd64

Server:
 Version:      17.09.0-ce
 API version:  1.32 (minimum version 1.12)
 Go version:   go1.8.3
 Git commit:   afdb6d4
 Built:        Tue Sep 26 22:42:49 2017
 OS/Arch:      linux/amd64
 Experimental: false
```

Jenkinsから実行できるようにするため、Jenkinsユーザをdockerグループに所属させます。

```sh
$ sudo usermod -aG docker your-user
```


Docker Composeのインストール
----------------------------

続いてDocker Composeのインストールです。

<blockquote class="embedly-card"><h4><a href="https://docs.docker.com/compose/install/">Install Docker Compose</a></h4><p>You can run Compose on macOS, Windows, and 64-bit Linux. Prerequisites Docker Compose relies on Docker Engine for any meaningful work, so make sure you have Docker Engine installed either...</p></blockquote>

該当するディストリビューションのリリース物をGitHubから取得します。

```sh
$ sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

バージョンを確認しましょう。

```sh
$ docker-compose --version
docker-compose version 1.17.0, build ac53b73
```


以上です。

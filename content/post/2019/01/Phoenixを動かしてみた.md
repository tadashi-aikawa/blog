---
title: Phoenixを動かしてみた
slug: phoenix-challenge
date: 2019-01-18T23:10:10+09:00
thumbnailImage: https://cdn.svgporn.com/logos/phoenix.svg
categories:
  - engineering
tags:
  - elixir
  - phoenix
---

Phoenixというフレームワークを触ってみました。

<!--more-->

<img src="https://cdn.svgporn.com/logos/phoenix.svg"/>

{{<warn "本記事の内容を過信しないでください">}}
動かしてみただけのため、記事の途中ところどころに疑問を散りばめています。  
初めてElixirにチャレンジした開発者が、いきなりPhoenixを動かしてみちゃいました... というコラムとしてご覧下さい。

正しい情報が欲しい方は公式ドキュメントやチュートリアルなどをオススメします。
{{</warn>}}

<!--toc-->


Phoenixとは
-----------

スピードと保守性に妥協せず作り上げた生産的なWebフレームワークです。

{{<summary "https://phoenixframework.org/">}}

利用言語はElixirで、Erlang VMの能力を利用して何百万もの接続を処理するポテンシャルを持ちます。

{{<why "なぜPhoenix?">}}
アイコンと名前が格好良かったからです...。不死鳥好きなので😅

後付けで他にもいくつか理由があります。

* 数年ほどアプリケーションサーバ開発と向き合えていなかったので遅れを取り戻したい
* Elixirに興味があった
  * 実用的な関数型言語として (Haskellは実用化のハードルが高い)
  * Erlangの特徴であるアクターモデルを学習したかった
{{</why>}}


準備
----

公式サイトを参考にPhoenix v1.4.0のインストールをします。

{{<summary "https://hexdocs.pm/phoenix/installation.html">}}

ドキュメントを見ると、Phoenixをインストールする前にいくつかの依存関係を解決する必要があるようです。


### Elixirのインストール

私のWindowsにはElixirがインストールされていません。  
[Chocolatey](https://chocolatey.org/search?q=elixir)を使ってインストールします。

```
$ cinst elixir
```

依存packageのerlangと、elixirがインストールされます。

```
$ elixir --version
Erlang/OTP 21 [erts-10.2] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1]

Elixir 1.8.0 (compiled with Erlang/OTP 20)
```

バージョンは1.8.0がインストールされました。  
Erlangはバージョン18以上を必要としますが、バージョン21のため問題ありません。


### Phoenixのインストール

Elixirのビルドツール`mix`でインストールします。

{{<summary "https://hexdocs.pm/mix/Mix.html">}}

以下のコマンドでhexとPhoenix v1.4.0をインストールします。

```
$ mix archive.install hex phx_new 1.4.0
...
* creating c:/Users/syoum/.mix/archives/phx_new-1.4.0
```

{{<why "hexって何?">}}
Erlangエコシステムのためのパッケージマネージャーです。  
Pythonのpip、JavaScriptのnpmみたいなものです。
{{<summary "https://hex.pm/">}}

それに対してmixはJavaScriptのwebpackみたいなものなのでしょうか...🤔

別の機会にPhoenixを使わず、Elixir+mixの挙動を確かめてみたいですね。
{{</why>}}


`~/.mix/archives/...`配下にbeamファイルが沢山できました。

{{<why "beamファイルって何?">}}
Erlangの実行バイナリに使う拡張子です。Windowsのexeみたいなものです。
{{</why>}}


### PostgreSQLのインストール

PhoenixではデフォルトでPostgreSQLを使います。  
今回はVagrantで作成した仮想マシン上にDockerを使って準備しました。

```
$ docker run -p 5432:5432 --name phoenix-test -e POSTGRES_PASSWORD=password -d postgres
```

Windowsに直接インストールしても問題ないはずです。


動かす
------

実際に動かしてみます。

{{<summary "https://hexdocs.pm/phoenix/up_and_running.html">}}


### プロジェクトの作成

helloプロジェクトを作成してみます。

```
$ mix phx.new hello
...
* running mix deps.get
* running mix deps.compile
* running cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development
...
```

{{<why "mixのコマンドはどこでどう解釈されるのか?">}}
現時点でmixの挙動を詳しく追い切れてはいません。  
後日調べた上でまとめたいと思っています。
{{</why>}}


assetsの中はnodeとwebpackで整備されるようです。  
既にnodeはインストール済みのため、nodeのインストール処理は走りませんでした。


### データベースの作成

Phoenixが使用するデータベースを作成します。  
データベースを操作するためにEctoを使っています。

{{<summary "https://hexdocs.pm/ecto/Ecto.html">}}

helloプロジェクトの中に入り、`ecto.create`を実行します。

```
$ cd hello
$ mix ecto.create
...
Generated hello app
The database for Hello.Repo has been created
```

{{<error "パスワード認証に失敗してしまう..">}}
以下のようなエラーが表示される場合はユーザ(postgres)に対するパスワードが正しく設定されていません。

```
11:18:18.291 [error] GenServer #PID<0.329.0> terminating
** (Postgrex.Error) FATAL 28P01 (invalid_password) password authentication failed for user "postgres"
    (db_connection) lib/db_connection/connection.ex:84: DBConnection.Connection.connect/2
    (connection) lib/connection.ex:622: Connection.enter_connect/5
    (stdlib) proc_lib.erl:249: :proc_lib.init_p_do_apply/3
Last message: nil
State: Postgrex.Protocol
** (Mix) The database for Hello.Repo couldn't be created: killed
```

`config/dev.exs`で設定されているpasswordを変更しましょう。  

```elixir
# Configure your database
config :hello, Hello.Repo,
  username: "postgres",
  password: "ここにパスワードを入れる",
  database: "hello_dev",
  hostname: "localhost",
  pool_size: 10
```

passwordがデフォルトの`postgres`である場合、このエラーは出ないと思います。  
デフォルトで良いかは別問題ですが...
{{</error>}}

PostgreSQLの中を見ると、`hello_dev`というデータベースが作成されていました。  
この時点でテーブルは存在しません。


### アプリケーションの起動

ついに起動の時がやってきました。  
管理者権限で以下のコマンドを実行します。

```
$ mix phx.server
```

{{<warn "シンボリックリンクが作成できない とwarningが出る場合は...">}}
Windowsのターミナルを管理者権限で起動していることを確認してください。  
以下のエラーにあるとおり、管理者権限が無い場合はシンボリックリンクを作成できないので、動作に問題が発生します。

> [warn] Phoenix is unable to create symlinks. Phoenix' code reloader will run considerably faster if symlinks are allowed. On Windows, the lack of symlinks may even cause empty assets to be served. Luckily, you can address this issue by starting your Windows terminal at least once with "Run as Administrator" and then running your Phoenix application.
{{</warn>}}

http://localhost:4000 にアクセスして以下の画面が表示されればOKです😄

{{<himg "https://dl.dropboxusercontent.com/s/6hvrk0h6savirpb/20190119_1.png">}}


総括
----

Elixir未経験者の私が、Phoenixを動かしてみました。  
Phoenixで簡単なWebアプリケーションを作成するために、まずはElixirの勉強をしてみたいと思います。

少しバージョンは古いかもしれませんが以下のページを参考にさせていただきます🙇

{{<summary "https://elixirschool.com/ja/">}}

---
title: "RustでLinux用シングルバイナリを作るまで"
slug: rust-linux-single-binary
date: 2018-08-20T00:45:37+09:00
thumbnailImage: images/cover/2018-08-20.jpg
categories:
  - engineering
tags:
  - rust
  - musl
  - docker
  - ubuntu
  - centos
---

Linux環境なら実行可能なシングルバイナリをRustで作ってみました。  
かなりハマッたので経緯とシンプルな解決方法を共有します。

<!--more-->

{{<info "すぐに解決方法だけを知りたい方へ">}}
以下をご覧下さい。

1. [muslビルド用のDockerイメージでビルドする](/2018/08/20/rust-linux-single-binary/#muslビルド用のdockerイメージでビルドする)
2. [OpenSSLを使う場合の注意](/2018/08/20/rust-linux-single-binary/#opensslを使う場合の注意)
{{</info>}}

{{<cimg "2018-08-20.jpg">}}

<!--toc-->


はじめに
--------

### 経緯

二週間前にRustでツールを作り始めた記事を書きました。  
本文にもある通り、シングルバイナリを作成できどこでも実行できると思ったのが理由の1つです。

{{<summary "https://blog.mamansoft.net/2018/08/06/rust-clitool-create/">}}

しかし世の中はそう甘くありませんでした。  
何が起きたかは次章で説明します。


### 筆者の環境

WindowsをホストOSとして、VMで`16.04.5 LTS (Xenial Xerus)`を使っています。  
Rustのコンパイルも上記VMのUbuntu上で行っています。

### 筆者のスペック

先の記事にある通り、C系やローレイヤーの知識に疎いです。  
そのおかげで随分と苦戦しました。


### 対象ツール

今回対象としたのは以下のツールです。  
Miroirをお使いでなければ利用価値は全く無いと思いますので参考程度に..

{{<summary "https://github.com/tadashi-aikawa/miroir-cli">}}


普通にビルドしてはどこでも実行できない
--------------------------------------

有識者の方なら当たり前の話なのですが、私の中では`シングルバイナリ = どこでも実行できる`と浅はかな思い込みがありました。


### リリースビルドと動作確認

まずRelease buildを実行するわけです。

```
$ cargo build --release
```

実行すると普通に動作します。

```
$ ./miroir --help
Miroir CLI

Usage:
  miroir get summaries --table=<table>
  miroir get report <key-prefix> --bucket=<bucket> [--bucket-prefix=<bucket-prefix>] [--format]
  miroir create --table=<table> --bucket=<bucket>
  miroir prune  --table=<table> --bucket=<bucket> [--bucket-prefix=<bucket-prefix>] [--dry]
  miroir --help

Options:
  -h --help                          Show this screen.
  -f --format                        Pretty format
  -d --dry                           Dry run
  --table=<table>                    DynamoDB table name
  --bucket=<bucket>                  S3 bucket name
  --bucket-prefix=<bucket-prefix>    S3 bucket prefix (directory)
```


### 別サーバで動作確認

作成されたバイナリを別環境.. 今回はCentOS7のサーバに移動して実行します。

```
$ ./miroir --help
./miroir: error while loading shared libraries: libssl.so.1.0.0: cannot open shared object file: No such file or directory
```

実行に失敗します。エラーメッセージを見ると`libssl.so.1.0.0`というshared objectがオープンできないようです。


実行できない理由を探る
----------------------

### Shared objectと動的リンク

C系初心者の私にはshared objectが何者かを調べる必要がありました。

{{<summary "http://e-words.jp/w/.so%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB.html">}}

そこから分かったことは以下4点です。

* `.so`ファイルのことをshared object fileと呼ぶ
* Unix系OS共有ライブラリのファイル形式
* 単体では起動できず他のプログラムにリンクして呼び出されるもの
* 動的リンク(dynamic link)形式と呼ばれ、静的リンク(static link)で作成された`.a`ファイルとは真逆

一言で言うと**実行ファイルを実行するために必要な依存関係**のことですね。


### Shared objectが見つからない理由

Localでは見つかったShared objectがなぜ別サーバでは見つからないのでしょうか。  
理由は簡単.. インストールされている動的ライブラリが異なるからです。

`ldconfig -p`というコマンドを使用すれば、設定された共有ライブラリを調べることができるようです。

{{<summary "http://www.dn-web64.com/archives/web/ld_library/">}}

早速実行してみます。

#### Ubuntu環境(VM)

```
$ ldconfig -p | grep libssl.so.1.0.0
        libssl.so.1.0.0 (libc6,x86-64) => /lib/x86_64-linux-gnu/libssl.so.1.0.0
```

`/lib/x86_64-linux-gnu`配下の共有ライブラリを見ているようです。

#### CentOS環境

```
$ ldconfig -p | grep libssl.so.1.0.0
```

該当する共有ライブラリは見つからないのでエラーになるわけですね。  
では`libssl.so`がインストールされていないのか..そんなわけはなさそうです。

```
$ ldconfig -p | grep libssl.so
        libssl.so.10 (libc6,x86-64) => /lib64/libssl.so.10
        libssl.so (libc6,x86-64) => /lib64/libssl.so
```

どうやらバージョンやリンクの仕方が異なるようです。


### Shared object問題を解決するには

上記調査から、実行するサーバでは`libssl.so.1.0.0`の共有ライブラリを解決しなければならないことが分かりました。  
しかし実行サーバに対して対象のsoファイルを都度配置してしまうと、シングルバイナリのメリットが損なわれてしまいます。

そこでShared objectを使わない方法.. 静的リンクのみでシングルバイナリをビルドすることを目標とします。


muslを使った完全な静的リンク
---------------------------

詳しい方にお聞きしたところ、muslというライブラリを使うと完全な静的リンクを実現できることが分かりました。

{{<summary "https://www.musl-libc.org/">}}

軽量、高速、シンプルな標準ライブラリを目指しているようです。

> Using musl maximizes application deployability. Its permissive MIT license is compatible with all FOSS licenses, static-linking-friendly, and makes commercial use painless too. Binaries statically linked with musl have no external dependencies, even for features like DNS lookups or character set conversions that are implemented with dynamic loading on glibc. An application can really be deployed as a single binary file and run on any machine with the appropriate instruction set architecture and Linux kernel or Linux syscall ABI emulation layer.

* 最高のデプロイ性
* MITライセンス
* 単一バイナリをLinuxカーネルまたはそれに準拠する環境で実行できる

良いことずくめですね。乗るしかないこのビッグウェーブに。


Rust+muslでシングルバイナリを作成する
-------------------------------------

あとはmuslを使ってビルドをするだけです。


### muslを使わないシングルバイナリ

`ldd`コマンドで動的リンクを確認することができます。

```
$ ldd miroir
	linux-vdso.so.1 =>  (0x00007fff371ec000)
	libssl.so.1.0.0 => /lib/x86_64-linux-gnu/libssl.so.1.0.0 (0x00007f5b62467000)
	libcrypto.so.1.0.0 => /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 (0x00007f5b62023000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f5b61e1f000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f5b61c16000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f5b619f9000)
	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f5b617e3000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f5b61418000)
	/lib64/ld-linux-x86-64.so.2 (0x00005562b0934000)
```

激しく依存していますね..。  
これがゼロになればOKです。


### muslビルド用のDockerイメージでビルドする

Dockerを使うのが一番速くて楽です。  
私の環境に不備があったせいかOpenSSLのビルドが成功しなかったため、VMで直接ビルドすることは諦めてしまいました..。

以下のイメージを使用します。

{{<summary "https://github.com/emk/rust-musl-builder">}}

実行に必要なのは以下1コマンドだけです。

```
$ docker run --rm -it -v `pwd`:/home/rust/src ekidd/rust-musl-builder cargo build --release
```

{{<alert success>}}
fishの場合は\`pwd\`が(pwd)になります。
{{</alert>}}

しばらく待って成功したら`ldd`コマンドで依存関係を確認します。  
`target/release`配下ではなく、`target/x86_64-unknown-linux-musl/release`配下なのでお間違えないよう..。

```
$ ldd miroir
        not a dynamic executable
```

Oh..!! Dockerはやはり素晴らしかったのだ。。


### CentOS環境で実行する

musl無しだと失敗していた環境で実行してみます。

```
$ ./miroir --help
Miroir CLI

Usage:
  miroir get summaries --table=<table>
  miroir get report <key-prefix> --bucket=<bucket> [--bucket-prefix=<bucket-prefix>] [--format]
  miroir create --table=<table> --bucket=<bucket>
  miroir prune  --table=<table> --bucket=<bucket> [--bucket-prefix=<bucket-prefix>] [--dry]
  miroir --help

Options:
  -h --help                          Show this screen.
  -f --format                        Pretty format
  -d --dry                           Dry run
  --table=<table>                    DynamoDB table name
  --bucket=<bucket>                  S3 bucket name
  --bucket-prefix=<bucket-prefix>    S3 bucket prefix (directory)
```

完璧ですね！


OpenSSLを使う場合の注意
-----------------------

rust-musl-builderのREADMEに記載がある通り、OpenSSLを使用している場合は一手間必要です。  
OpenSSLの証明書関連処理をするために`openssl_probe`が必要です。

{{<summary "https://crates.io/crates/openssl-probe">}}

### Cargo.tomlの編集

dependenciesに`openssl-probe = "0.1.2"`を追加します。

### main.rsに処理を追加

`init_ssl_cert_env_vars()`を実行します。

```rust
extern crate openssl_probe;
...
fn main() {
    openssl_probe::init_ssl_cert_env_vars();
    ...
}
```

これで問題なくビルド+実行できるはずです。


総括
----

Rustでビルドした実行ファイルを、Linuxならどこでも実行できるシングルバイナリにする方法について  
Dockerを使った解決方法を紹介しました。

Dockerを使わない方法についても今度時間があればスキルアップを兼ねてチャレンジしてみたいとは思っています。  
恐らく以下の通りやればできるはず...

{{<summary "https://doc.rust-jp.rs/the-rust-programming-language-ja/1.6/book/advanced-linking.html">}}


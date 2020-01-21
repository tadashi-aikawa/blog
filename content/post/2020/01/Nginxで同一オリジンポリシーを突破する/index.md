---
title: Nginxで同一オリジンポリシーを突破する
slug: cors-with-nginx-from-browser
date: 2020-01-21T21:20:43+09:00
thumbnailImage: https://cdn.svgporn.com/logos/nginx.svg
categories:
  - engineering
tags:
  - nginx
  - cors
  - toggl
---

ブラウザから異なるオリジンのAPIにアクセスすると、しばしばCORSエラーが発生します。  
この記事ではNginxを使って解決する方法を紹介します。

<!--more-->

<img src="https://cdn.svgporn.com/logos/nginx.svg"/>

<!--toc-->


用語の説明
----------

簡単に用語の説明をします。  
詳しい内容はリンク先をご覧下さい。

### オリジン

URLのスキーム、ホスト、ポートのことです。

{{<refer "MDN web docs - Origin (オリジン) -" "https://developer.mozilla.org/ja/docs/Glossary/Origin">}}

たとえば、`http://hogehoge:8080`はオリジンです。

### 同一オリジン

2つのURLが同じスキーム、ホスト、ポートである場合、それらは同一オリジンであると言います。

{{<refer "MDN web docs - Origin (オリジン) -" "https://developer.mozilla.org/ja/docs/Glossary/Origin">}}

たとえば、`http://hoge:80/aaa`と`http://hoge/bbb`は同一オリジンです。

* スキームは`http`で同一
* ホストは`hoge`で同一
* ポートは`80`で同一 (後者は省略されているだけ)

### 同一オリジンポリシー

あるオリジンから取得した文書やスクリプトから、別のオリジンのリソースにアクセスできない仕組みです。  
言い換えると、文書やスクリプトからアクセスできるリソースは同一オリジンに限定されます。

{{<refer "MDN web docs - 同一オリジンポリシー -" "https://developer.mozilla.org/ja/docs/Web/Security/Same-origin_policy">}}

本来はセキュリティにおける重要なルールですが、別オリジンのリソースにアクセスする機会が増えた現代では逆に問題となることがあります。

### CORS

正式名称は`Cross Origin Resource Sharing`でオリジン間リソース共有と呼ばれています。

{{<refer "MDN web docs - オリジン間リソース共有 (CORS) -" "https://developer.mozilla.org/ja/docs/Web/HTTP/CORS">}}

CORSは異なるオリジンへのリソースアクセスをブラウザに許可させることができます。  
ただし、異なるオリジンサーバが返却するレスポンスヘッダ`Access-Control-Allow-Origin`に、アクセス元のオリジンが含まれている必要があります。


CORSが障壁となるケース
----------------------

先ほど紹介した用語を使って、CORSをざっくり表現すると以下の図になります。

{{<svg "20200121_1.svg">}}

`http://other`オリジンが`http://one`オリジンのアクセスを許容してくれれば問題ありません。  
具体的には以下の様なレスポンスヘッダを返す場合です。

* `Access-Control-Allow-Origin: http://one`
* `Access-Control-Allow-Origin: *`

`http://other`のAPIを`http://one`と同じプロジェクトが開発していれば問題ありません。  
そのようなレスポンスヘッダを付ければいいだけです。

問題となるのは、それぞれの開発プロジェクトが異なる場合です。  
その場合はAPI提供元に対して、`Access-Control-Allow-Origin`ヘッダに自身のオリジンを追加してもらう必要があります。

それが難しい場合、Proxyとして仲介サーバを立てる解決方法があります。  
リクエストヘッダとレスポンスヘッダを調整してCORSを成功させるのです。


NginxでHTTPS
------------

ここからはNginxで具体的に行った設定を紹介します。  
今回は[Toggl]を外部APIとして想定します。

まずはNginxでHTTPSを使うために証明書を作成します。  
以下を参考にしました。

{{<summary "https://qiita.com/HeRo/items/f9eb8d8a08d4d5b63ee9">}}

### certbotのインストール

公式ドキュメントに従ってインストールします。 (Ubuntu)

{{<summary "https://certbot.eff.org/docs/install.html">}}

```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot
# Nginx用プラグイン
sudo apt-get install python-certbot-nginx
```

### 証明書作成

公式ドキュメントに従って作成します。

{{<summary "https://certbot.eff.org/docs/using.html#nginx">}}

例は`proxy.example.net`というドメインに対して作成する場合です。

```
certbot --nginx -d proxy.example.net
```

色々聞かれますのでしっかり答えましょう😉

成功すると、conf配下に指定したドメイン名のファイルができます。  
既にある場合は以下のような情報が記載されています。

```
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/proxy.example.net/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/proxy.example.net/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = proxy.example.net) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  listen       80;
  server_name  proxy.example.net;
    return 404; # managed by Certbot
}
```

HTTPSに関することは今回のメインでないため、詳細は割愛します。


設定したこと
------------

結論から言うと、以下の設定をしました。

```
server {
  server_name  proxy.example.net;
  charset      UTF-8;

  location /toggl.com/ {
      proxy_http_version 1.1;
      proxy_pass https://toggl.com/;

      proxy_hide_header Access-Control-Allow-Origin;
      add_header Access-Control-Allow-Origin *;
      proxy_hide_header Access-Control-Allow-Headers;
      add_header Access-Control-Allow-Headers *;
      proxy_hide_header Access-Control-Allow-Methods;
      add_header Access-Control-Allow-Methods *;
  }

  listen 443 ssl; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/proxy.example.net/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/proxy.example.net/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
  if ($host = proxy.example.net) {
    return 301 https://$host$request_uri;
  } # managed by Certbot


  listen       80;
  server_name  proxy.example.net;
    return 404; # managed by Certbot
}
```

HTTPSに関するところを除いた重要部分は以下です。

```
server {
  server_name  proxy.example.net;
  charset      UTF-8;

  location /toggl.com/ {
      proxy_http_version 1.1;
      proxy_pass https://toggl.com/;

      proxy_hide_header Access-Control-Allow-Origin;
      add_header Access-Control-Allow-Origin *;
      proxy_hide_header Access-Control-Allow-Headers;
      add_header Access-Control-Allow-Headers *;
      proxy_hide_header Access-Control-Allow-Methods;
      add_header Access-Control-Allow-Methods *;
  }
```

### 設定とアクセスの概要

上記設定後の各サーバにおけるやりとりは図のようになります。

{{<svg "20200121_2.svg">}}

### 設定当初に遭遇したエラー

先ほど紹介した設定ではエラーが出ませんが、そこに行き着くまでにハマッた点があります。

```
Access to XMLHttpRequest at 'https://proxy.example.net/hooks.slack.com/services/AAAAAA/BBBBBB/cccccccccccccccccccccc' from origin 'http://localhost:3000' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: The 'Access-Control-Allow-Origin' header contains multiple values '*, *', but only one is allowed.
```

#### 説明

`Access-Control-Allow-Origin`に複数の値が指定されてしまったというエラーです。

#### 理由

`localhost`からのリクエストに対し、Togglは`Access-Control-Allow-Origin: *`を付与します。  
`add_header`はレスポンスヘッダに追記するため、このケースでは`*`が2つ指定されました。

#### 対策

`localhost`以外のリクエストに対し、Togglは`Access-Control-Allow-Origin`を返却しません。  
この仕様を利用し、`proxy_hide_header`を使って`Access-Control-Allow-Origin: http://localhost:3000`を隠すようにしました。

これで安心して`add_header`により`Access-Control-Allow-Origin: *`を追加できます。

このような特徴はAPIの仕様に依存するため、連携するAPIごとに設定を分ける必要があります。


総括
----

Nginxを使ってCORSを成功させるためのProxyサーバを構築する方法を紹介しました。

ただ、正攻法は`Access-Control-Allow-...`ヘッダに追加してもらうことです。  
追加してもらえるなら是非お願いしてみましょう😄

[Toggl]: https://toggl.com/

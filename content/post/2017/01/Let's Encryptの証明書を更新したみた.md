---
title: Let's Encryptの証明書を更新してみた
slug: update-lets-encrypt
date: 2017-01-23T00:00:00+09:00
thumbnailImage: "https://dl.dropboxusercontent.com/s/7vcibs3of2g7omg/20170123_1.png"
categories:
  - engineering
tags:
  - https
  - ssl
---

Let's Encryptで作成した証明書の更新をしてみました。

<!--more-->

{{<summary "https://letsencrypt.jp/docs/using.html#renewal">}}

<!--toc-->


nginxの停止
-----------

更新時に80/443ポートを使用するため、プロキシサーバとして使用しているnginxを停止します。

```
$ systemctl stop nginx
```


更新
----

`cerbot renew` コマンドを使用します。  
まずは `--dry-run` モードでリハーサルを実施します。

```
$ certbot renew --dry-run

-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/mamansoft.net.conf
-------------------------------------------------------------------------------
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates below have not been saved.)

Congratulations, all renewals succeeded. The following certs have been renewed:
  /etc/letsencrypt/live/mamansoft.net/fullchain.pem (success)
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates above have not been saved.)
```

問題なさそうなので、 `--dry-run` なしで実行します。

```
$ certbot renew

-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/mamansoft.net.conf
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
new certificate deployed without reload, fullchain is
/etc/letsencrypt/live/mamansoft.net/fullchain.pem
-------------------------------------------------------------------------------

Congratulations, all renewals succeeded. The following certs have been renewed:
  /etc/letsencrypt/live/mamansoft.net/fullchain.pem (success)

$ systemctl start nginx
```


nginxの起動
-----------

nginxを起動します。

```
$ systemctl start nginx
```

期限が更新されたことを確認します。

<div class="img-horizontal">
    <a href="https://dl.dropboxusercontent.com/s/7vcibs3of2g7omg/20170123_1.png"><img src="https://dl.dropboxusercontent.com/s/7vcibs3of2g7omg/20170123_1.png" /></a>
</div>

<div class="img-horizontal">
    <a href="https://dl.dropboxusercontent.com/s/h75x1p0xb3j0ks4/20170123_2.png"><img src="https://dl.dropboxusercontent.com/s/h75x1p0xb3j0ks4/20170123_2.png" /></a>
</div>


無停止更新したい場合
--------------------

[Webrootプラグイン](https://letsencrypt.jp/docs/using.html#webroot)を使用するとnginxを停止せずに更新できます。  
ただ、証明書作成時にWebrootプラグインを使用していることが条件です。 `--standalone` で作成した場合は作り直す必要があります。

<a class="embedly-card" href="https://letsencrypt.jp/docs/using.html#webroot">ユーザーガイド - Let's Encrypt 総合ポータル</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

そうしないと以下のようなエラーになります。

```
$ certbot renew --webroot --dry-run
-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/mamansoft.net.conf
-------------------------------------------------------------------------------
2017-01-22 14:23:07,185:WARNING:certbot.renewal:Attempting to renew cert from /etc/letsencrypt/renewal/mamansoft.net.conf produced an unexpected error: Missing command line flag or config entry for this setting:
Select the webroot for mamansoft.net:
Choices: ['Enter a new webroot']

(You can set this with the --webroot-path flag). Skipping.
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates below have not been saved.)

All renewal attempts failed. The following certs could not be renewed:
  /etc/letsencrypt/live/mamansoft.net/fullchain.pem (failure)
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates above have not been saved.)
1 renew failure(s), 0 parse failure(s)
```

私の場合、無停止が必須では無かったため作り直さずにnginxを停止して更新しました。


総括
----

Let's Encryptで作成したSSL証明書の期日を更新しました。  
これから作られるのであれば、Webrootプラグインで証明書を作った方がいいと思います。



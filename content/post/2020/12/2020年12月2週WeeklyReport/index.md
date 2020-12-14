---
title: 2020年12月2週 Weekly Report
slug: 2020-12-2w-weekly-report
date: 2020-12-15T08:32:28+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
---

e2eテストを本格導入するためPlaywrightの知見を集めた一週間でした。  
詳細は別途記事にして公開する予定です。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### el-inputでEnterが押された時に処理を実行したい

Element UIのInputコンポーネントでEnterが押された時にコールバック関数を呼ぶ方法です。

{{<summary "https://mimizou.mamansoft.net/IT_Note/languages/typescript/element/faq/#el-inputenter">}}

### 【Rust】WIP: [The book] 4. Understanding Ownership

途中までですが、しばらくRustを学習する機会がなさそうなのでアップしました。

{{<summary "https://mimizou.mamansoft.net/IT_Note/languages/rust/thebook/4_understanding_ownership/">}}

所有権という非常に大事なところです。


読んだこと/聴いたこと
---------------------

### Playwright公式ドキュメント

Microsoftが提供するe2eテストライブラリPlaywrightのドキュメントを読みました。

{{<summary "https://playwright.dev/#">}}

現在、記事を執筆中ですのでここでは詳しい説明はしません。

### Playwright vs Cypress

e2eテストツールのPlaywrightとCypressを比較した記事です。

{{<summary "https://medium.com/sparebank1-digital/playwright-vs-cypress-1e127d9157bd">}}

しっかり裏付けて取っていませんが、ざっくり比較です。

|                   | Cypress               | Playwright            |
| ----------------- | --------------------- | --------------------- |
| 特徴              | オールインワン        | Puppeteerのラッパ     |
| ターゲット        | 初心者                | 中級者以上            |
| ブラウザ          | Chromeメイン(Firefox) | Chrome/Firefox/Webkit |
| タブ/ドメイン操作 | 単独                  | 複数                  |
| Electron対応      | 非公式であり?         | なし?                 |

こうしてみると結構ターゲットが異なるなという印象です。

### Playwright vs. Puppeteer: Which should you choose?

e2eテストの歴史を踏まえた上で、PlaywrightとPuppeteerのどっちを使うべきか書かれた記事です。

{{<summary "https://blog.logrocket.com/playwright-vs-puppeteer/">}}

本文のクオリティも高いですが、特に歴史的経緯が大変勉強になりました。

### ゼロイチ思考とグラデーション思考 〜NGメイクは誰が決める？

ゼロイチの両極端な思考ではなく、間をとれるような思考をしましょうという記事。

{{<summary "https://note.com/llminatoll/n/n153771398b5b">}}

私も5年前くらいはゼロイチ思考が強く、それが改善点だとFBしてもらってからはいくらかグラデーション思考になったと思っています。  
気を抜くと元に戻ってしまうのでかなり意識はしていますが..😅

一方でそれをバランスおじさんと卑下する人達もいるので難しい限りです..  
バランスおじさんいいと思うんですよね.. 必要に応じてバランスがとれているなら。

### 2020年のCSSのまとめ、FlexboxやCSS Gridの使用状況、よく使用するプロパティや単位、人気のフレームワークやツールなど

2020年のCSS界隈についてまとめられた記事です。

{{<summary "https://coliss.com/articles/build-websites/operation/css/the-state-of-css-2020.html">}}

本文も勉強になりますが、それぞれの項目でリンクされる過去記事が秀逸ですね。  
CSSにはあまり明るくないため、知らないことがたくさんありました。

その中でも特にカスタムプロパティが気になりました。  

{{<summary "https://coliss.com/articles/build-websites/operation/css/css-variables.html">}}

これのためにSass使ってたのですが、CSSでできるのなら..。


試したこと
----------

### Playwright

先ほどのPlaywrightを実際に試しました。

{{<summary "https://playwright.dev/#version=v1.6.2&path=docs%2Fintro.md&q=">}}

過去にSelenium、Cypress、Puppeteerを触ってきましたが、Playwrightイイ..!!  
特にDOMの準備を明示的に待たなくていいのが最高ですね😁

e2eテストはコストを改修するのが難しかったのもあり経験値が低いです。  
だから、年末年始にかけて集中スキルアップしようと思っています。

後ほど記事を公開します。

### QA Wolf

PlaywrightとJestを使ったe2eテストライブラリです。

{{<summary "https://www.qawolf.com/">}}

ボイラープレートやコマンドラッパーとしてのお膳立てをしてくれたり、GUI操作ベースでコード自動生成を手伝ってくれたりします。  
はじめはPlaywrightではなくQA Wolfを使おうと思っていました。  
しかし、以下の理由で方針を変えました。

* QA Wolfだからこそできる機能はない
* Playwrightを直接使った方がバージョンアップ対応は楽そう
* Playwrightの知識をつけた方が幅が広がりそう
* 自動生成されたコードはそのままでは使えない(調整が必須)
* Electronで使えない (2020/12/14現在)

Playwrightが出る前だったら使っていたと思います。


調べたこと
----------

なし


整備したこと
------------

### 【PowerShell】ffmpegを使った関数の整理

ffmpegを使った関数を整理しました。

```powershell
# サイズの小さいmp4を作る
function ffmp4red() { ffmpeg -i $args[0] -vcodec libx264 -crf 20 $args[1] }
# mp4をgifに変換
function ffgif() { ffmpeg -i $args[0] -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" $args[1] }
# mp4を幅360のgifに変換
function ffgif360() { ffmpeg -i $args[0] -filter_complex "[0:v]scale=360:-1 [s]; [s] split [a][b];[a] palettegen [p];[b][p] paletteuse" $args[1] }
# 画像を任意のサイズにリサイズ
function ffresize() { $width = $args[1]; ffmpeg -i $args[0] -vf scale=$width":-1" $args[2] }
# faviconに変換
function fffavicon() { ffmpeg -i $args[0] -vf "scale=256:-1" $args[1] }
```

### 【Confluence】子孫ページをすべて削除するbashスクリプト

`REST_API_BASE`をお使いのドメインに変えれば使えます。  
雑ですが動作確認済みです。

削除前にページ名一覧を表示し、確認プロンプトを出します。  
`y`か`Y`を押さなければ中断するので安心設計。

`jq`を使っていますので、無い場合はインストールが必要です。

```bash
#!/bin/bash

# -------------------------------------
# REQUIRED:
#   BASIC: Use for basic authentication
#   args1: Parent page id
# -------------------------------------

parent_page_id=$1

REST_API_BASE="https://your.atlassian.net/wiki/rest/api"

function fetch_descendant_pages() {
  curl -s "${REST_API_BASE}/content/${parent_page_id}/descendant/page?limit=100" \
    --header "Authorization: Basic ${BASIC}"
}

# $1: page_id
function delete_page() {
  echo Delete a page by "${REST_API_BASE}/content/$1";
  curl --request DELETE "${REST_API_BASE}/content/$1" \
    --header "Authorization: Basic ${BASIC}";
}

function main() {
  # Pre check
  echo "I will delete below pages."
  echo "--------------------------"
  fetch_descendant_pages | jq -r '.results[].title'
  echo "--------------------------"
  read -p "Can I continue to delete pages? (y/n)" yn
  case "$yn" in
    [yY]) ;;
    *) exit 1 ;;
  esac
  echo "--------------------------"
  # Delete
  fetch_descendant_pages | jq -r '.results[].id' | while read id; do delete_page $id; done
}

main
```


今週のリリース
--------------

### Owlelia v0.17.0

4ヶ月ぶりにDDDライブラリOwleliaをリリースしました。

{{<summary "https://github.com/tadashi-aikawa/owlelia">}}

#### 平日、土曜、日曜、祝日に関する機能の強化

まずは`DateTime.setHolidays`で土日以外の祝日が設定できるようになりました。

```typescript
DateTime.setHolidays("2020-01-01", "2020-01-02", "2020-01-03")
```

これによって、平日、土曜、日曜、祝日の判定ができるようになりました。  
他にもtsdocを強化しています。

##### 平日の判定

`DateTime.isWeekday`を使います。

```typescript
DateTime.setHolidays("2020-12-02");

DateTime.of("2020-12-01 00:00:00").isWeekday
// -> true
DateTime.of("2020-12-02 03:00:00").isWeekday
// -> false
DateTime.of("2020-12-03 06:00:00").isWeekday
// -> true
DateTime.of("2020-12-04 09:00:00").isWeekday
// -> true
DateTime.of("2020-12-05 12:00:00").isWeekday
// -> false
DateTime.of("2020-12-06 15:00:00").isWeekday
// -> false
DateTime.of("2020-12-07 18:00:00").isWeekday
// -> true
```

##### 土曜の判定

`DateTime.isSaturday`を使います。

```typescript
DateTime.of("2020-12-04 00:00:00").isSunday
// -> false
DateTime.of("2020-12-05 10:00:00").isSunday
// -> true
DateTime.of("2020-12-06 23:59:59").isSunday
// -> false
```

##### 日曜の判定

`DateTime.isSunday`を使います。

```typescript
DateTime.of("2020-12-04 00:00:00").isSunday
// -> false
DateTime.of("2020-12-05 10:00:00").isSunday
// -> false
DateTime.of("2020-12-06 23:59:59").isSunday
// -> true
```

##### 祝日の判定

`DateTime.isHoliday`を使います。

```typescript
DateTime.setHolidays("2020-07-07", "2020-12-24")

DateTime.of("2020-01-01 00:00:00").isHoliday
// -> false
DateTime.of("2020-07-07 10:00:00").isHoliday
// -> true
DateTime.of("2020-12-24 23:59:59").isHoliday
// -> true
```

##### 平日加算メソッドを追加

本当にやりたかったのは平日(≃営業日)の加算です。  
`DateTime.plusWeekdays`で実現しました。

```typescript
DateTime.setHolidays("2020-12-02");

DateTime.of("2020-12-01 00:00:00").plusWeekdays(2)
// -> 2020-12-04T00:00:00
DateTime.of("2020-12-03 00:00:00").plusWeekdays(3)
// -> 2020-12-08T00:00:00
```

### Togowl v2.22.3

タスク更新時にプロジェクト変更がないとき、セクションがクリアされる不具合を修正しました。


その他
------

### Quizletの単語数

本日時点での単語数は140(+17)です。  
コンスタントに増えてきており、単語帳の全件学習が厳しくなってきました..。

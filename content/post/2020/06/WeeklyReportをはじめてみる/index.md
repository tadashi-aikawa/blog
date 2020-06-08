---
title: Weekly Reportをはじめてみる
slug: start-weekly-report
date: 2020-06-08T09:47:07+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - idea
---

Weekly Reportをはじめることにしました。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


はじめに
--------

### Weekly Reportとは

私が1週間何をやってきたかの記録です。  
具体的には以下の内容を記載する予定です。

| 内容         | 説明                                        |
| ------------ | ------------------------------------------- |
| インプット   | 学んだ事こと。技術的スキル/気づき/閃き など |
| アウトプット | OSSプロダクトやブログ記事 など              |
| 変化         | 新しく始めたこと など                       |
| 所感         | 思ったこと/感じたこと など                  |

### なぜWeekly Reportを始めるのか

理由は3つあります。

❶ ブログを書くまでのフットワークを軽くしたい  
❷ 尊敬している人は1週間のふりかえりを文章にまとめている  
❸ 単一記事にするほどではないが、誰かの役に立ちそうなネタがありそう

少し時間をとられてしまうという懸念もあります。  
ただ、今も一週間に1時間ほどふりかえりをしています。

構成や品質に拘らなければ、1時間という時間内に執筆可能では..と思っています。

### いつWeekly Reportを書くのか

基本的に日曜日です。  
事情によって前後することもありますが、±1日の範囲内で公開を目指します。

### 注意事項

Weekly Reportの内容は、他の記事と比べて記載内容の信憑性は落ちます。  
これはクオリティよりもスピードを重視するためです。

クオリティを重視すると、単一記事と変わらなくなってしまうのでそこは線引きします。  
日記のような感覚で見ていただけると幸いです🙇

### Weekly Reportのサンプル

今回ははじめてなので、次のセクションから試しに書いてみます。  
次回からは`2020年6月2週 Weekly Report`みたいなタイトルにする予定です。


インプット
----------


アウトプット(ドキュメント)
--------------------

### Windows Terminal + PowerShellの記事を公開

個人的にかなりの力作です☺️  
ターミナル/Windows好きの方は是非！

{{<summary "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}

### TypeScript v2.6のリリースノート

TypeScriptの理解を深めるため、過去のリリースノートを要約する作業をしています。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/">}}

今週でv2.6の内容が終わりました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/2.6/">}}


アウトプット(OSS)
-----------------

### Jumeaux v2.4.0～v2.4.1リリース

JumeauxはAPI差分確認ツールです。

{{<summary "https://blog.mamansoft.net/2019/04/15/api-diff-check-tool-jumeaux-1.0/">}}

今回こちらのv2.4.0～v2.4.1をリリースしました。

Slack通知設定に条件を指定できるようになりました。  
詳しくはリリースノートを参照してください。

{{<summary "https://tadashi-aikawa.github.io/jumeaux/ja/releases/v2/#241">}}


### Markowl v0.5.0リリース

MarkowlはJetBrains製IDEで利用可能な、Markdownプラグインです。

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

今はちょっとしたフォーマッターの機能しかありません。  
必要を感じたら、都度機能追加していく予定です😄

今回、こちらの軽微な修正をしました。

### Togowl v1.5.0～v1.7.0リリース

Togowlは1日のタスクを効率的にこなすためのツール(PWA)です。  
Todoist/TogglのAPIを利用しており、Windows/Mac/Android/iOSなどマルチプラットフォームで動作します。

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

開発している主な目的は2つです。

* 日々のタスクを効率的にこなす
* キャッチアップした技術でプロダクト開発したときの知見を得る

今回こちらのバージョンアップをしました。

#### Schedule画面を追加

タスクの整理に特化した画面を追加しました。

{{<himg "resources/ceee6f29.jpeg">}}

表示がコンパクトなため、並び替えや整理をするのに役立ちます。

#### タスク/エントリのMarkdown表記に対応

Todoistのタスク名やTogglのエントリ名にMarkdown表記が含まれるとき、それを反映するようにしました。

{{<himg "resources/707f13b0.jpeg">}}

リンクに限りSlack通知でも変換されます。

{{<himg "resources/c358ae93.jpeg">}}

#### プロジェクトカテゴリのカラー設定に対応

プロジェクトカテゴリでColorを設定できるようになりました。

{{<himg "resources/e171bd01.jpeg">}}

ここで設定したカラーはカレンダーで反映されます。

{{<himg "resources/f8471b91.jpeg">}}


変化
----

所感
----

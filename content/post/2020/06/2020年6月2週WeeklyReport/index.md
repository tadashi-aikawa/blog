---
title: 2020年6月2週 Weekly Report
slug: 2020-06-2w-weekly-report
date: 2020-06-15T09:42:04+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - murai
  - rich
  - poetry
  - angular
  - togowl
  - wsl
  - ditto
  - todoist
---

今週の大きなトピックはWSL2..、使い方を間違えなければとても快適です。  
内容が膨大になるため、詳しい内容は単独の記事で紹介します。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


インプット
----------

### Murai

付箋系アクティビティに特化したMuraiを試してみました。

{{<summary "https://www.mural.co/">}}

手書き付箋対応で、大勢の人がリアルタイム作業できるのは魅力です。  
ただ、以下の理由から1人で使う私の用途にはあわなそうでした。

* ペンの反応が遅い
* 動作(読みこみ)が重い

オンラインサービス全般のデメリットだとは思っています。

### Rich

ターミナルでリッチなテキスト表現を提供するPythonライブラリです。

{{<summary "https://github.com/willmcgugan/rich">}}

TableとProgress barがオススメですね😄

{{<summary "https://note.com/navitime_tech/n/n6d8cd7327466">}}

### PoetryでaddするとAssetionError

プロジェクト名と依存関係のパッケージ名が同一だと起こるエラーです。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/python/poetry/faq/#assertionerror">}}

たまにハマる。。

### Angularプロジェクトでnpm auditしたらエラー

Angular8使ってたのに、しれっと9のビルド環境にアップデートされていたのが原因らしいです。

{{<summary "https://blog.officekoma.co.jp/2020/02/angular78an-unhandled-exception.html">}}



アウトプット(ドキュメント)
--------------------

今週はありません。


アウトプット(OSS)
-----------------

### Togowl v1.8.0～v1.10.0リリース

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### Time Divider

`⏲` からはじまるタスクをdividerとして認識させるようにしました。

{{<vimg "resources/4d826894.jpeg">}}

1日の予定を見通すときに便利です。

#### ラベル表示

Todoistのラベルを表示できるようにしました。

{{<vimg "resources/fdc45042.jpeg">}}

Scheduler画面のレイアウトでは1行表示を強制し、被せるように表示します。

{{<himg "resources/7ee26202.jpeg">}}


変化
----

### WSL2

勢いでWSL2の導入と周辺環境の整備をしました。  
今のところ快適です👍

今度記事を書きますので、ここにはメモ程度の内容を載せておきます。

#### Windowsのアップデート

WSL2対応のアップデート通知が来ていない場合は、手動でアップデートします。

{{<summary "https://www.microsoft.com/ja-jp/software-download/windows10">}}

#### WSL2のインストール

{{<summary "https://docs.microsoft.com/ja-jp/windows/wsl/install-win10 ">}}

```
sudo dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
sudo dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

PCを再起動します。終了&起動では駄目なので要注意。  
続いて、ディストリビューションのデフォルトバージョンを2にします。

```
sudo wsl --set-default-version 2
```

それから好きなディストリビューションをインストールします。  
私はUbuntu20をインストールしました。

`/etc/wsl.conf`でWindows側のpathをオフにします。  

```
[interop]
appendWindowsPath = false
```

`wsl --terminate Ubuntu`しないとUbuntuが裏で動き続けているため、設定がリロードされないのにハマりました。  
あとはAnsibleで普段使っている環境をインストール！

{{<himg "resources/058733d6.jpeg">}}

他にも色々試行錯誤しましたが、それは別途記事で☺️

### Ditto

クリップボードマネージャーのDittoを導入しました。  
今まではCLCLとCliborの二刀流でしたが、Dittoに統合できました👍

{{<summary "https://ditto-cp.sourceforge.io/">}}

自分に必要な要件の比較です。  
CLCLとCliborはバージョンが古いかもしれないので、最新版では対応されているかもしれません。

| 要件                   | CLCL | Clibor | Ditto | 備考                                  |
| ---------------------- | ---- | ------ | ----- | ------------------------------------- |
| インクリメンタルサーチ | ▲   | 〇     | ◎    | 起動後そのまま検索できるのはDittoだけ |
| 画像の保持             | 〇   | ×     | 〇    |                                       |
| `Shift x 2` で起動     | 〇   | 〇     | ×    | `Alt + F` 代用で問題なし              |


### HHKB吸振マット

Happy Hacking Keyboard用の振動を吸収するマットです。

{{<summary "https://www.amazon.co.jp/HHKB%E5%90%B8%E6%8C%AF%E3%83%9E%E3%83%83%E3%83%88HG-HYBRID-Type-S-Classic%E7%94%A8/dp/B08344W1DY">}}

目立った違いは感じませんが、指の疲れが少しだけ和らいだ気がしています..。気のせいかもしれませんが..。


その他
------

Todoistのタスクを編集すると、今日の並び順が変わってしまう問題に遭遇したのでサポートに聞いてみました。

{{<summary "https://twitter.com/Tadashi_MAMAN/status/1271249571037904896">}}

Twitter+英語で聞くの初めてでちょっと緊張しましたが、丁寧に返信いただけた😄


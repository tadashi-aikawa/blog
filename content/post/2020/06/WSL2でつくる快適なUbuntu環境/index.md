---
title: WSL2でつくる快適なUbuntu環境
slug: efficient-wsl2-with-ubuntu
date: 2020-06-17T09:50:18+09:00
thumbnailImage: images/cover/2020-06-17.jpg
categories:
  - engineering
tags:
---

WindowsでWSL2を使ったUbuntu環境をつくってみました。

<!--more-->

{{<cimg "2020-06-17.jpg">}}

<!--toc-->


はじめに
--------

WindowsのMay 2020 Updateアップデートで、WSL2が正式版になりました。  
直近でLinux環境が必要だったので、この機会にインストール/環境構築をしてみました。

### 前提条件

本記事は、以下の記事における環境構築がされている前提で執筆されています。

{{<summary "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}

Windowsのバージョンは`2004 (OSビルド 19041.329)`です。  
19041より前のバージョンでは動きませんので、必要ならばMicrosoftのページから[手動アップデート]してください。

[手動アップデート]: https://www.microsoft.com/ja-jp/software-download/windows10

また、筆者の環境ではWSL1はインストールされていません。


WSL2のインストール
------------------

公式ページを参考にまずはWSLをインストールします。

{{<summary "https://docs.microsoft.com/ja-jp/windows/wsl/install-win10">}}

PowerShellにてコマンドを実行します。  
sudoコマンドが使えない場合は、管理者権限でPowerShellを立ち上げてください。

```powershell
# WSLを有効にする
sudo dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# VMを有効にする
sudo dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

PCを再起動すると、WSL2のインストールが完了します。

{{<warn "wslコマンドが使えない">}}
WSL2のインストールに失敗した可能性があります。

**PCの『シャットダウン』→『起動』ではインストールされません。**  
必ず **『再起動』** をしてください。
{{</warn>}}

最後にLinuxディストリビューションがWSL2をフェフォルトで使うように設定しましょう。

```
sudo wsl --set-default-version 2
```


Ubuntuのインストール
--------------------

WindowsストアからUbuntuをインストールします。  
バージョンは`20.04 LTS`にしました。

{{<summary "https://www.microsoft.com/ja-jp/p/ubuntu-2004-lts/9n6svws3rx71?rtc=1#activetab=pivot:overviewtab">}}

インストール完了に起動して初期設定をします。  
Ubuntuに対して、WSLのバージョンが2に設定されていることを確認しましょう。

```
$ wsl --list -v                                                                                                                                                                ⨯ 10:19:26
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

{{<info "ディストリビューションのWSL VERSIONを変更する方法">}}
以下のコマンドで切り替えできます。

```
wsl --set-version Ubuntu 2
```
{{</info>}}


Windows TerminalからUbuntuを起動する
------------------------------------

`profiles.list[]`に以下を追加します。  
`source`以外のパラメータは、各自最適な値を設定してください。

```json
  {
    "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "source": "Windows.Terminal.Wsl",
    "startingDirectory": "//wsl$/Ubuntu/home/tadashi-aikawa",
    "backgroundImage": "%USERPROFILE%\\git\\github.com\\tadashi-aikawa\\owl-playbook\\mnt\\windows\\wsl\\ubuntu.png",
    "backgroundImageAlignment": "bottomRight",
    "backgroundImageStretchMode": "none",
    "backgroundImageOpacity": 0.4
  }
```

WSL2ではWindowsからLinuxディストリビューションのファイルシステムにアクセスできます。  
Ubuntuの場合、rootパスは`//wsl$/Ubuntu`になります。

上記設定では、起動後のカレントディレクトリをUbuntuのホームディレクトリにしています。


PATHからWindowsの設定を除外する
-------------------------------

デフォルトではLinuxからWindowsのコマンドを利用できます。  
これはLinuxのPATHに、WindowsのPATHがデフォルトで設定されているためです。

このままでは、Windows/Linux どちらのコマンドを実行されているかが暗黙的になり、知らない間にWindows環境に依存するリスクを生じます。  
それを回避するため、Linuxの`/etc/wsl.conf`を作成してWindowsのPATHが追加されないようにします。

```
[interop]
appendWindowsPath = false
```

`/etc/wsl.conf`では他にも様々な設定ができます。

{{<summary "https://docs.microsoft.com/ja-jp/windows/wsl/wsl-config#configure-per-distro-launch-settings-with-wslconf">}}

{{<warn "wsl.confを変更しても設定が反映されない">}}
Linuxが再起動されていない可能性があります。

ターミナルソフトを終了しても、Linuxはバックグラウンドでしばらく起動し続けます。  
以下のコマンドで意図的に終了したあと、もう一度ターミナルを立ち上げてください。

```powershell
wsl --terminate Ubuntu
```

{{<github "https://github.com/microsoft/WSL/issues/3994#issuecomment-485977423">}}

{{</warn>}}

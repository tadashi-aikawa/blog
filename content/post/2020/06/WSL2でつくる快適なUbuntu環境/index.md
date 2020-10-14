---
title: WSL2でつくる快適なUbuntu環境
slug: efficient-wsl2-with-ubuntu
date: 2020-07-02T10:52:18+09:00
thumbnailImage: images/cover/2020-06-17.jpg
categories:
  - engineering
tags:
  - wsl
  - ubuntu
  - terminal
  - ansible
  - vim
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

最後にLinuxディストリビューションがWSL2をデフォルトで使うように設定しましょう。

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


秘密情報を含むドットファイルのコピー
------------------------------------

基本的にホストの設定をそのまま使いたいのでコピーします。  
以下のような`provision.ps1`を作りました。

```powershell
# .gitconfig
cp $home\.gitconfig \\wsl$\Ubuntu\tmp\
wsl -- mv /tmp/.gitconfig ~/

# .ssh
cp -r $home\.ssh \\wsl$\Ubuntu\tmp\
wsl -- rm -rf ~/.ssh
wsl -- mv /tmp/.ssh ~/
wsl -- chmod 600 ~/.ssh/*
```

本当は1行でコピーしたいのですが、ホストマシンからは`\\wsl$\Ubuntu\~`をホームディレクトリとみなすことができません。  
そのため、tmp配下に一度コピーしたあと、WSL内でそれをホームディレクトリへ移動させます。

`wsl -- <コマンド>`でWindowsからUbuntu内でコマンドを直接実行することができます。


クリップボードを同期する
------------------------

Windows X Serveを使います。

{{<summary "https://sourceforge.net/projects/vcxsrv/">}}

Scoopでインストールします。

```
scoop install vcxsrv
```

### 設定ファイルの作成

XLauncherを起動します。  
**vcxsrvではないので注意してください。**

`C:\Users\syoum\scoop\apps\vcxsrv\current\xlaunch.exe`

設定画面が立ち上げるので、以下の画面が出るまでそのまま進みます。

{{<himg "resources/e8efd136.jpeg">}} 

`Disable access control`にチェックをつけて進みます。

{{<himg "resources/96d6741f.jpeg">}}

`Save configuration`をクリックすると設定をファイルとして保存できます。  
ここでは`config.xlaunch`として保存しました。

ファイルの中身は以下のような感じです。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<XLaunch WindowMode="MultiWindow" ClientMode="NoClient" LocalClient="False" Display="-1" LocalProgram="xcalc"
         RemoteProgram="xterm" RemotePassword="" PrivateKey="" RemoteHost="" RemoteUser="" XDMCPHost=""
         XDMCPBroadcast="False" XDMCPIndirect="False" Clipboard="True" ClipboardPrimary="True" ExtraParams="" Wgl="True"
         DisableAC="True" XDMCPTerminate="False"/>
```


### Windows起動時に自動起動させる

スタートアップにショートカットを作成し、リンク先に以下を指定します。

```
C:\Users\syoum\scoop\apps\vcxsrv\current\xlaunch.exe -run <config.xlaunchのパス>
```

### 環境変数DISPLAYの設定

Ubuntu側の`.bashrc`などで環境変数DISPLAYの値をセットします。

```bash
# クリップボード連携 (For WSL2)
LOCAL_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export DISPLAY=$LOCAL_IP:0
```

これでWindowsとクリップボードが連携できるようになります😁

{{<info "Vimを使っている場合">}}
VimのyankとWindowsのクリップボードを同期したい場合は、Ubuntu側の`.vimrc`で以下の設定をしてください。

```
set clipboard=unnamedplus
```

{{</info>}}


Ansibleで環境構築
-----------------

Linux環境構築で使用しているAnsibleのPlaybookを実行します。  
その前にAnsibleをインストールします。

```
sudo apt-get update
sudo apt-get install python3-pip libffi-dev libssl-dev -y
pip install ansible pywinrm
```

なぜこのコマンドにしたのか記憶にないので.. 公式のインストールコマンドで問題なければそちらを使った方がいいです..😅

{{<summary "https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu">}}

実行したらハマリ所はなく成功しました🎉

{{<himg "resources/181782bd.jpeg">}}

なお、Playbookの設定は以下のリポジトリで管理しています。

{{<summary "https://github.com/tadashi-aikawa/owl-playbook/blob/master/linux/ansible/wsl-ubuntu.yml">}}


総括
----

ポイントとハマリ所さえ抑えれば、思ったより時間をかけずに環境構築できました。  
PowerShell環境やVagrantを使ったVMと比べると以下の点が良いと感じています。

* 仮想マシンを起動/終了させる必要がない (地味に面倒ですよね！)
* Gitコマンドなどの反応が速い
* Linuxで利用できる技術がほぼそのまま使える

一方、注意すべき点もいくつかあります。

* Windowsファイルシステム上ではファイルの読み書き速度が著しく落ちる
* WindowsとPATHを混同させるとカオスになる
* Intellij IDEAではDebug/Runなどに完全対応していない

『LinuxでWindowsを扱う』のではなく『Windowsの中にあるLinuxを使う』くらいがちょうどいい塩梅だと感じています。

Windowsシステム上での操作を快適にしたい方は下記の記事も是非どうぞ😄

{{<summary "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}


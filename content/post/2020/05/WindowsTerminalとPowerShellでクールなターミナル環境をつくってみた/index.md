---
title: Windows TerminalとPowerShellでクールなターミナル環境をつくってみた
slug: windows-terminal-and-power-shell-makes-beautiful
date: 2020-05-31T17:50:08+09:00
thumbnailImage: images/cover/2020-05-27.jpg
categories:
  - engineering
tags:
  - windows
  - linux
  - power-shell
  - powerline
  - terminal
  - git
---

[Windows Terminal]と[PowerShell]を使って、COOLなターミナル環境を構築してみました。

<!--more-->

{{<cimg "2020-05-27.jpg">}}

<!--toc-->


はじめに
--------

先日、[Windows Terminal]のバージョン1.0がリリースされました。

{{<summary "https://github.com/microsoft/terminal">}}

以前は状況に応じてターミナルソフトを使い分けていましたが、[Windows Terminal]を使うことで全てを統一することができました。

### 導入後のイメージ

本記事の設定を行うと、どのようになるのか...  
実際の動作イメージを動画に収めました。

{{<mp4 "resources/3.mp4">}}

興味がありましたら是非この先へお進みください😉

### Windows Terminal導入前の環境

| 以前使っていたターミナルソフト | 状況                                                 |
| ------------------------------ | ---------------------------------------------------- |
| [Cmder]                        | 一般的なターミナル操作(コマンドプロンプトを使うもの) |
| [git bash]                     | Linuxコマンドを使ってShell Scriptを実行するとき      |
| [wsl-terminal]                 | Linux(SSH含む)の操作                                 |


### 以前の記事

本記事では[Cmder]や[git bash]、[wsl-terminal]の説明はしません。  
なぜ、それらを利用していたかは過去の記事をご覧ください。

{{<info "過去の記事はこちら">}}

#### Cmder

{{<summary "https://blog.mamansoft.net/2018/11/18/use-cmd-elegant-on-cmder-phase1/">}}

{{<summary "https://blog.mamansoft.net/2018/11/26/use-cmd-elegant-on-cmder-phase2/">}}

#### git bash

{{<summary "https://blog.mamansoft.net/2018/06/04/make-git-bash-look-good/">}}

#### fish

{{<summary "https://blog.mamansoft.net/2017/10/15/enjoy-fish/">}}

{{</info>}}

### 想定する読者

以下のような方を想定しています。

* WindowsでLinuxのようにターミナルを快適に使いたい
* [wsl-terminal]や[git bash]、[Cmder]を使っているが満足できていない
* [Windows Terminal]を使いこなしたい
* [PowerShell]を使いこなしたい
* Windowsのコマンドプロンプトを哀れみの目で見てくるMac/Linuxユーザを見返したい


ターミナルに求める要件
----------------------

私がターミナルに求める要件はいくつかあります。  
今まで使っていたツールで要件を満たせていたかを列挙します。

※ [Cmder]はcmd.exeを、[git bash]と[wsl-terminal]はbashを起動する前提

| 要件                                      | [Cmder]  | [git bash] | [wsl-terminal] |
| ----------------------------------------- | -------- | ---------- | -------------- |
| Windowsのファイルシステムをそのまま使える | 〇       | ▲         | ▲(重い)       |
| Windowsで動作保証されているコマンドが動く | 〇       | ▲         | ▲             |
| Linuxコマンドが使える                     | 〇       | 〇         | ◎             |
| Linuxサーバで文字化けしない               | ▲       | 〇         | ◎             |
| GitをPowerLine表示できる                  | 〇(重い) | ▲(重い)   | 〇(重い)       |
| Unicode絵文字が表示できる                 | ▲       | 〇         | 〇             |
| 画面を分割できる                          | 〇       | ×         | ×             |
| 複数タブ表示できる                        | ◎       | ×         | ×             |
| 背景に画像を表示できる                    | ◎       | ×         | ×             |
| 履歴からcdできる                          | ▲       | ×         | 〇             |
| リポジトリにcdできる                      | 〇       | ×         | 〇             |


Windows Terminal
----------------

まずは[Windows Terminal]についてです。  
導入を決めた理由、インストールや設定の仕方を説明していきます。

### なぜWindows Terminalなのか

理由は2つあります。

❶ Microsoftが公式で開発している  
❷ 必要な要件をほぼ全て満たしている

#### ❶ Microsoftが公式で開発している

Windows OSを開発しているのはMicrosoftです。  
そのMicrosoftが開発しているため、将来性は抜群でしょう😁

別の言い方をすると、リスク回避とも言えます。  
数年後には、他のOSSターミナルは軒並み開発が停止している可能性がありますので。

#### ❷ 必要な要件をほぼ全て満たしている

今回試して分かったことでもありますが、私にとって必要な要件をほぼ全て満たしていました。  
先ほどの要件表に照らし合わせると、以下のようになります。

| 要件                                      | [Windows Terminal] + [PowerShell] |
| ----------------------------------------- | --------------------------------- |
| Windowsのファイルシステムをそのまま使える | ◎                                |
| Windowsで動作保証されているコマンドが動く | ◎                                |
| Linuxコマンドが使える                     | ▲                                |
| Linuxサーバで文字化けしない               | ◎                                |
| GitをPowerLine表示できる                  | 〇 (Linuxには負けるが実用的速さ)  |
| Unicode絵文字が表示できる                 | ◎                                |
| 画面を分割できる                          | ◎                                |
| 複数タブ表示できる                        | ◎                                |
| 背景に画像を表示できる                    | ◎                                |
| 履歴からcdできる                          | 〇                                |
| リポジトリにcdできる                      | 〇                                |

[PowerShell]を使う唯一?の弊害として、Linuxコマンドは使いにくくなります。  
しかし、それさえ許容出来れば全てが統一できるわけです..🆒!!

※ 他にも問題はありますが、それは後ほど紹介します


### インストール

公式が推奨しているので、Microsoft Storeからインストールしました。

{{<summary "https://github.com/microsoft/terminal#installing-and-running-windows-terminal">}}

### 設定

GUIのメニューから設定を選ぶと、VS Codeなどのエディタで設定ファイルが開きます。

{{<himg "resources/f00e0f49.jpeg">}}

私は以下のように設定しています。  
設定項目のドキュメントは、ファイル内 👀のURLをご覧下さい。

{{<file "settings.json">}}

```javascript
// 👀 https://docs.microsoft.com/ja-jp/windows/terminal/customize-settings/global-settings
{
  "$schema": "https://aka.ms/terminal-profiles-schema",
  "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",

  "theme": "dark",
  "copyOnSelect": false,
  "copyFormatting": false,

  // ダブルクリックでパスを丸ごと選択したいため
  "wordDelimiters": " ",

  // 👀 https://docs.microsoft.com/ja-jp/windows/terminal/customize-settings/profile-settings
  // Azureは使わないので無効化
  "disabledProfileSources": ["Windows.Terminal.Azure"],
  "profiles": {
    "defaults": {
      "startingDirectory": "%USERPROFILE%",
      "closeOnExit": "always",
      "colorScheme": "Tango Dark",

      // Nerd Fontを指定
      "fontFace": "SauceCodePro NF",
      "fontSize": 13
    },

    // 実行するシェルの一覧
    "list": [
      // PowerShell Coreがメイン
      {
        "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
        "source": "Windows.Terminal.PowershellCore",
        "backgroundImage": "%USERPROFILE%\\git\\github.com\\tadashi-aikawa\\owl-playbook\\mnt\\windows\\power-shell\\fukurou.jpg"
      },
      // WSLは絵文字を入力したいとき
      {
        "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
        "source": "Windows.Terminal.Wsl"
      },
      // 『Git Bash』はbashスクリプトの動作確認用に使うことがある
      {
        "guid": "{cbaea444-ca1f-4125-bb6f-5c3f1201b568}",
        "name": "git bash",
        "startingDirectory": "%USERPROFILE%",
        "commandline": "%GIT_INSTALL_ROOT%\\usr\\bin\\bash.exe",
        "icon": "%GIT_INSTALL_ROOT%\\mingw64\\share\\git\\git-for-windows.ico",
        "backgroundImage": "%GIT_INSTALL_ROOT%\\mingw64\\share\\git\\git-for-windows.ico",
        "backgroundImageAlignment": "bottomRight",
        "backgroundImageStretchMode": "none",
        "backgroundImageOpacity": 0.75
      }
    ]
  },

  // 👀 https://docs.microsoft.com/ja-jp/windows/terminal/customize-settings/color-schemes
  "schemes": [],

  // 👀 https://docs.microsoft.com/ja-jp/windows/terminal/customize-settings/key-bindings
  "keybindings": [
    // 基本操作
    { "command": { "action": "copy", "singleLine": false }, "keys": "ctrl+c" },
    { "command": "paste", "keys": "ctrl+v" },
    { "command": "find", "keys": "ctrl+alt+f" },

    // 画面スクロール
    { "command": "scrollUp", "keys": "shift+up" },
    { "command": "scrollDown", "keys": "shift+down" },
    { "command": "scrollUpPage", "keys": "shift+pgup" },
    { "command": "scrollDownPage", "keys": "shift+pgdn" },

    // タブ
    { "command": "newTab", "keys": "ctrl+t" },
    { "command": "closeTab", "keys": "ctrl+w" },
    { "command": "nextTab", "keys": "alt+l" },
    { "command": "prevTab", "keys": "alt+h" },

    // ペインの分割
    { "command": { "action": "splitPane", "split": "auto", "splitMode": "duplicate" }, "keys": "alt+shift+d" },
    // ペイン移動
    { "command": { "action": "moveFocus", "direction": "down" }, "keys": "alt+ctrl+j" },
    { "command": { "action": "moveFocus", "direction": "left" }, "keys": "alt+ctrl+h" },
    { "command": { "action": "moveFocus", "direction": "right" }, "keys": "alt+ctrl+l" },
    { "command": { "action": "moveFocus", "direction": "up" }, "keys": "alt+ctrl+k" },
    // ペインサイズ変更
    { "command": { "action": "resizePane", "direction": "down" }, "keys": "alt+shift+j" },
    { "command": { "action": "resizePane", "direction": "left" }, "keys": "alt+shift+h" },
    { "command": { "action": "resizePane", "direction": "right" }, "keys": "alt+shift+l" },
    { "command": { "action": "resizePane", "direction": "up" }, "keys": "alt+shift+k" }
  ]
}
```

{{</file>}}

{{<info "guidの生成方法について">}}

guidの生成方法は以下を参考にさせていただきました。  
この記事はCmderのexeをWindows Terminalで動かすことがメインです。

{{<summary "https://qiita.com/tawara_/items/7cb1c8a12db81ab43a4c">}}

当初はPowerShellを使わずに、Windows TerminalでCmderを動かすつもりでした。  
Power Shellに乗り換えた一番の理由は、コマンドの反応速度です。

{{</info>}}

画面イメージはこんな感じです。

{{<himg "resources/c03f93bd.jpeg">}}

GitHubでも設定を公開しています。よろしければご覧下さい。

{{<summary "https://github.com/tadashi-aikawa/owl-playbook/blob/master/mnt/windows/terminal/LocalState/settings.json">}}

{{<why "フォントが見つからないとエラーが出る..">}}
本記事で設定したフォントはデフォルトでインストールされていない特殊なフォントです。  
後ほどインストール方法を紹介しますので、そちらをご覧下さい。
{{</why>}}

{{<why "アイコンや背景画像が表示されない..">}}
筆者のLocalだけに存在する画像ファイルのパスを指定しているためです。  
`icon`と`backgroundImage`は自分で使用したい画像ファイルのパスへ置き換えて下さい。
{{</why>}}


PowerShellのセットアップ
------------------------

[PowerShell]のベース環境を作ります。  
振り返ってみるとこの記事のメインは[PowerShell]かもしれません..。


### なぜPowerShellなのか

まずは採用した理由について..理由は3つあります。

❶ Windows標準  
❷ 見た目をかなりカスタマイズできる  
❸ Cmder.exeよりコマンド実行速度が速い  

#### ❶ Windows標準 

[PowerShell]はWindowsに標準でインストールされています。  
しかも、最近の推奨シェルは[PowerShell]となっています。

※ 一昔前は`cmd.exe`が主流でした

Windowsとの相性を考えると、最もベストな選択肢と言えるでしょう。

#### ❷ 見た目をかなりカスタマイズできる

[oh-my-posh]というテーマエンジンを使うと、見た目をかなりカスタマイズできます。  
これは、コマンドプロンプトと比べて大きなメリットでしょう😄

{{<summary "https://github.com/JanDeDobbeleer/oh-my-posh">}}

以下が[oh-my-posh]を適応して、Gitリポジトリを操作したイメージ画像です。  
テーマは`Set-Theme Powerlevel10k-Lean`を使っています。

{{<himg "resources/b50309f7.jpeg">}}

絵文字は後ほど紹介する設定でカスタマイズしています。

#### ❸ Cmder.exeよりコマンド実行速度が速い

Windowsではコマンドプロンプト/PowerShell以外のシェルを使うと、exe呼び出しか通信のオーバーヘッドがかなりかかっている気がします。  
たとえば、現在のリポジトリ状況を示すPowerlineの表示速度を比較するとこれだけ差が出ます。

| ツール                          | 表示速度の目安 |
| ------------------------------- | -------------- |
| [Windows Terminal]+[PowerShell] | 0.2秒          |
| [Windows Terminal]+[git bash]   | 2秒            |
| [Windows Terminal]+[Cmder]      | 1秒            |

Enterを押してから情報が表示されるまでのラグを比べてみると一目瞭然です。

{{<himg "resources/2020-05-27_20h01_09.gif">}}

私が[PowerShell]を採用する決め手となったのが、この速度差というわけです👍

### PowerShell Coreのインストール

[PowerShell]という呼び名は、以下2つのエディションをしばしば包括しています。

| エディション         | 概要                               | Windows標準搭載 |
| -------------------- | ---------------------------------- | --------------- |
| Windows PowerShell   | v5まで. Windows専用                | されている      |
| PowerShell Core      | v6以降. クロスプラットフォーム対応 | されていない    |

今回の記事ではPowerShell Coreを使います。

{{<why "なぜPowerShell Coreを使うのか?">}}
大きな理由は以下2点です。

❶ Windows PowerShellは開発が事実上凍結している (将来性がない)  
❷ PowerShell Coreは標準エンコーディングがUTF-8 BOMなし (Windows PowerShellはUTF-16 BOMあり)

特に❷の問題は、Windows PowerShellで解決することができません。  
Encodingを指定しても、UTF-8 BOMありが限界です。
{{</why>}}

GitHubのリリースページから、最新の安定版をインストールします。

{{<summary "https://github.com/PowerShell/PowerShell/releases">}}

本記事執筆時は`PowerShell-7.0.1-win-x64.msi`を使いました。

インストールが完了したら起動してみましょう。  
**起動コマンドは`powershell`ではなく`pwsh`なので間違えないよう気をつけてください。**

### Powerlineのセットアップ

Microsoftの公式ページを参考にします。

{{<summary "https://docs.microsoft.com/ja-jp/windows/terminal/tutorials/powerline-setup">}}

[PowerShell]を起動して、以下のコマンドを実行します。

```powershell
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
```

### フォントのインストール

Powerlineの表示には、アイコンに対応した特殊なフォントが必要です。  
メジャーなアイコンほぼ全てに対応済みである[Nerd Fonts]を使います。

{{<summary "https://www.nerdfonts.com/#home">}}

`Download`をクリックしてダウンロードします。  
私は`Source Code Pro`が好きなので、`Sauce Code Pro Nerd Font`にしました。

解凍をしたら、インストールしたいフォントをダブルクリックします。  
私は`Windows Compatible`版をすべてインストールしました。

{{<info "Windows Terminalでフォントを指定する方法">}}

Windows Terminalの設定で`fontFace`に指定します。
先ほど紹介した`settings.json`の例では以下のようにしています。

```
"fontFace": "SauceCodePro NF"
```

{{</info>}}


### プロファイルの作成

[PowerShell]の設定はプロファイルで設定します。  

プロファイルの場所は`$PROFILE`で出力されるパスです。  
まずは空ファイルを作成しましょう。

```
notepad $PROFILE
```

先ほどインストールしたPowerline関連のModuleをインポートする設定を追加します。

```powershell
Import-Module posh-git
Import-Module oh-my-posh
```

私のprofileファイルは以下です。

{{<file "~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1">}}

```powershell
#-----------------------------------------------------
# General
#-----------------------------------------------------

# PowerShell Core7でもConsoleのデフォルトエンコーディングはsjisなので必要
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")

# git logなどのマルチバイト文字を表示させるため (絵文字含む)
$env:LESSCHARSET = "utf-8"

# 音を消す
Set-PSReadlineOption -BellStyle None

#-----------------------------------------------------
# Key binding
#-----------------------------------------------------

# Emacsベース
Set-PSReadLineOption -EditMode Emacs

#-----------------------------------------------------
# Powerline
#-----------------------------------------------------

Import-Module posh-git
Import-Module oh-my-posh
Import-Module z

Set-Theme Powerlevel10k-Lean

# Prompt
$ThemeSettings.Colors.DriveForegroundColor = "Blue"
# Git
$ThemeSettings.GitSymbols.LocalStagedStatusSymbol = ""
$ThemeSettings.GitSymbols.LocalWorkingStatusSymbol = ""
$ThemeSettings.GitSymbols.BeforeWorkingSymbol = [char]::ConvertFromUtf32(0xf040)+" "
$ThemeSettings.GitSymbols.DelimSymbol = [char]::ConvertFromUtf32(0xf040)
$ThemeSettings.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xf126)
$ThemeSettings.GitSymbols.BranchAheadStatusSymbol = [char]::ConvertFromUtf32(0xf0ee)+" "
$ThemeSettings.GitSymbols.BranchBehindStatusSymbol = [char]::ConvertFromUtf32(0xf0ed)+" "
$ThemeSettings.GitSymbols.BeforeIndexSymbol = [char]::ConvertFromUtf32(0xf6b7)+" "
$ThemeSettings.GitSymbols.BranchIdenticalStatusToSymbol = ""
$ThemeSettings.GitSymbols.BranchUntrackedSymbol = [char]::ConvertFromUtf32(0xf663)+" "

#-----------------------------------------------------
# fzf
#-----------------------------------------------------

# fzf
$env:FZF_DEFAULT_OPTS="--reverse --border --height 50%"
$env:FZF_DEFAULT_COMMAND='fd -HL --exclude ".git" .'
function _fzf_compgen_path() {
    fd -HL --exclude ".git" . "$1"
}
function _fzf_compgen_dir() {
    fd --type d -HL --exclude ".git" . "$1"
}

#-----------------------------------------------------
# Linux like commands
#-----------------------------------------------------

# Linuxコマンドを優先
$linuxBin = "$env:GIT_INSTALL_ROOT\usr\bin"
Remove-Item alias:rm
function rm() { Invoke-Expression "$linuxBin\rm $args"}
function mkdir() { Invoke-Expression "$linuxBin\mkdir $args"}

# 代替コマンドを使用
Set-Alias grep rg
function ll() { lsd -l --blocks permission --blocks size --blocks date --blocks name --blocks inode $args}
function tree() { lsd --tree $args}

#-----------------------------------------------------
# Useful commands
#-----------------------------------------------------

# cd
function cdg() { gowl list | fzf | cd }
function cdr() { fd -H -t d -E .git -E node_modules | fzf | cd }
function cdz() { z -l | oss | select -skip 3 | % { $_ -split " +" } | sls -raw '^[a-zA-Z].+' | fzf | cd }

# Copy current path
function cpwd() { Convert-Path . | Set-Clipboard }

# git flow
function gf()  { git fetch --all }
function gd()  { git diff $args }
function ga()  { git add $args }
function gaa() { git add --all }
function gco() { git commit -m $args[0] }

# git switch
function gb()  { git branch -l | rg -v '^\* ' | % { $_ -replace " ", "" } | fzf | % { git switch $_ } }
function gbr() { git branch -rl | rg -v "HEAD|master" | % { $_ -replace "  origin/", "" } | fzf | % { git switch $_ } }
function gbc() { git switch -c $args[0] }
function gbm()  { git branch -l | rg -v '^\* ' | % { $_ -replace " ", "" } | fzf | % { git merge --no-ff $_ } }

# git log
function gls()   { git log -3}
function gll()   { git log -10 --oneline --all --graph --decorate }
function glll()  { git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset\ %C(yellow)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' }
function glls()  { git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset\ %C(yellow)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10}

# git status
function gs()  { git status --short }
function gss() { git status -v }
```

{{</file>}}

GitHubでも設定を公開しています。よろしければご覧下さい。

{{<summary "https://github.com/tadashi-aikawa/owl-playbook/blob/master/mnt/windows/power-shell/Microsoft.PowerShell_profile.ps1">}}

プロファイルの中身は次章で詳しく説明します。


PowerShellのカスタマイズ
------------------------

プロファイルでカスタマイズした内容を詳しく説明します。

### 文字化けを解消する

PowerShell Coreは`$OutputEncoding`のデフォルトがUTF-8です。  
しかし、その他の設定はsjisのものが多数あります。

これらについて、すべてUTF-8を指定しなくてはなりません。

```powershell
# PowerShell Core7でもConsoleのデフォルトエンコーディングはsjisなので必要
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")

# git logなどのマルチバイト文字を表示させるため (絵文字含む)
$env:LESSCHARSET = "utf-8"
```

以下の回答に大変助けられました..🙇

{{<summary "https://teratail.com/questions/226487">}}

{{<info "git statusのファイル名が文字化けする場合..">}}

こちらの場合はgitの設定変更で解決できます。

```
git config --global core.quotepath false
```

{{</info>}}


### キーバインドをbashに寄せる

[PowerShell]はターミナルで使えるショートカットキーがbashと異なります。  
PSReadLineの設定をEmacsベースにすることで、bashのようなショートカットキーが使えるようになります。

```powershell
Set-PSReadLineOption -EditMode Emacs
```

### Powerlineをカスタマイズする

主にGitのステータス表示で使われるアイコンをカスタマイズします。

{{<himg "resources/71b0e776.jpeg">}}

profileの以下で設定しています。

```powershell
Set-Theme Powerlevel10k-Lean

# Prompt
$ThemeSettings.Colors.DriveForegroundColor = "Blue"

# Git
$ThemeSettings.GitSymbols.LocalStagedStatusSymbol = ""
$ThemeSettings.GitSymbols.LocalWorkingStatusSymbol = ""
$ThemeSettings.GitSymbols.BeforeWorkingSymbol = [char]::ConvertFromUtf32(0xf040)+" "
$ThemeSettings.GitSymbols.DelimSymbol = [char]::ConvertFromUtf32(0xf040)
$ThemeSettings.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xf126)
$ThemeSettings.GitSymbols.BranchAheadStatusSymbol = [char]::ConvertFromUtf32(0xf0ee)+" "
$ThemeSettings.GitSymbols.BranchBehindStatusSymbol = [char]::ConvertFromUtf32(0xf0ed)+" "
$ThemeSettings.GitSymbols.BeforeIndexSymbol = [char]::ConvertFromUtf32(0xf6b7)+" "
$ThemeSettings.GitSymbols.BranchIdenticalStatusToSymbol = ""
$ThemeSettings.GitSymbols.BranchUntrackedSymbol = [char]::ConvertFromUtf32(0xf663)+" "
```

`[char]::ConvertFromUtf32(...)`の引数に好きなアイコンを設定しましょう。  
アイコンのコードポイントは[Nerd Fonts]のCheat Sheetで確認できます。

{{<summary "https://www.nerdfonts.com/cheat-sheet">}}

`[char]::ConvertFromUtf32(...)`のあとに`+" "`しているのは、ターミナルが全角/半角を誤認してレイアウトが崩れるのを防ぐためです。

ステータスのアイコンは`$ThemeSettings.GitSymbols`で確認できます。

![](resources/cf64805f.jpeg)

### fzfとの連携

[Cmder]を使っていたときは、独自Luaスクリプトで[fzf]と連携するコマンドを使っていました。  
下記の`cdg`, `cdz`, `cdr`相当のことをできるようにします。

{{<summary "https://github.com/tadashi-aikawa/owl-cmder-tools">}}

[fzf]以外にも、コマンドによってツールのインストールが必要です。

| コマンド | 依存しているツール | インストール方法の一例                                              |
| -------- | ------------------ | ------------------------------------------------------------------- |
| cdr      | [fd]               | [Scoop]                                                             |
| cdz      | [z]                | [PowerShell Gallery](https://www.powershellgallery.com/packages/z/) |
| cdg      | [gowl]             | go get                                                              |

profileにワンライナーのfunctionを定義すればOKです。

```powershell
Import-Module z

# fzf
$env:FZF_DEFAULT_OPTS="--reverse --border --height 50%"
$env:FZF_DEFAULT_COMMAND='fd -HL --exclude ".git" .'
function _fzf_compgen_path() {
    fd -HL --exclude ".git" . "$1"
}
function _fzf_compgen_dir() {
    fd --type d -HL --exclude ".git" . "$1"
}

# Command
function cdg() { gowl list | fzf | cd }
function cdr() { fd -H -t d -E .git -E node_modules | fzf | cd }
function cdz() { z -l | oss | select -skip 3 | % { $_ -split " +" } | sls -raw '^[a-zA-Z].+' | fzf | cd }
```

実際にコマンドを実行している動画です。

{{<mp4 "resources/1.mp4">}}

pipeで`cd`すると移動できるのは非常に🆒ですね！

### Linuxコマンドをできるだけ使えるようにする

日本語の扱いやパイプ、ビルドコマンドの制約などあるため完璧な設定は難しいです。  
できるだけ違和感なくなるよう、頻出するコマンドだけカスタマイズしてみました。

以下はこれから設定するコマンドを組み合わせた動画です。

{{<mp4 "resources/2.mp4">}}

#### git bashに同梱されているコマンドを使用する

`rm`と`mkdir`を設定します。

```powershell
$linuxBin = "$env:GIT_INSTALL_ROOT\usr\bin"

# rm
Remove-Item alias:rm
function rm() { Invoke-Expression "$linuxBin\rm $args"}

# mkdir
function mkdir() { Invoke-Expression "$linuxBin\mkdir $args"}
```

`rm`は既にエイリアスが存在するため、エイリアス削除が必要です。

#### 代替コマンドを使う

パイプで繋ぐことが多いコマンドは、Windowsに対応している代替コマンドを使います。  
すべて[Scoop]でインストールできます。

| コマンド | 依存しているツール | インストール方法の一例 |
| -------- | ------------------ | ---------------------- |
| grep     | [ripgrep]          | [Scoop]                |
| ll       | [lsd]              | [Scoop]                |
| tree     | [lsd]              | [Scoop]                |

それらを使ってAliasやfunctionを設定します。

```powershell
# grep
Set-Alias grep rg

# ll
function ll() { lsd -l --blocks permission --blocks size --blocks date --blocks name --blocks inode $args}

# tree
function tree() { lsd --tree $args}
```

`lsd`は`ls`より見た目も格好良くて🆒ですね😄

{{<error "特定ファイル、ディレクトリ、ドライブがエラーで表示されない">}}

`lsd`は環境によって表示されない場合があるようです。  
同じく`ls`の代替ツールである`exa`は、その点を解消する動きがあります。

{{<summary "https://github.com/ogham/exa/issues/32">}}

完成された場合は`exa`に切り替えるかもしれません。

{{</error>}}


課題
----

見た目もパフォーマンスも素晴らしい[Windows Terminal] x [PowerShell]ですが課題もあります。

### Linuxコマンドを呼び出すと文字化けすることがある

文字コードやコマンド設計のズレから、文字化けして表示できないことがあります。  
先ほど紹介したように、パイプを利用するコマンドは代替コマンドを検討しましょう。

### 絵文字が入力できない

[PowerShell]の問題だと思います。

絵文字の表示はほぼ完璧ですが、入力は全くできません。  
絵文字の入力が必要な場合は[PowerShell]ではなくWSLを利用してみましょう。


トラブルシューティング
----------------------

### profileに記載された設定が部分的に反映されない

profileが **CRLF改行** になっていることを確認してください。  
LF改行の場合は正しく認識されないことがあります。

### sshすると posix_spawn: No such file or directory

`.ssh/config`で`ProxyCommand`を設定している場合、`ssh.exe`のパスを絶対パスにしてください。

`例`
```
ProxyCommand    C:\Windows\System32\OpenSSH\ssh.exe -W %h:%p server
```

参考: https://serverfault.com/questions/956613/windows-10-ssh-proxycommand-posix-spawn-no-such-file-or-directory


### Vimの文字コード/改行コードが推論されない

`.vimrc`に以下を記載してください。

```vim
" 文字コード自動判別
:set encoding=utf-8
:set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
" 改行コード自動判別
:set fileformats=unix,dos,mac
```

### VimのBEEP音を消したい

`.vimrc`に以下を記載してください。

```vim
" 音を鳴らさない
:set belloff=all
```

### Vimのクリップボードとyankが同期しない

`.vimrc`に以下を記載してください。

```vim
" Clipboard同期
set clipboard+=unnamed
```


総括
----

[Windows Terminal]と[PowerShell]を使ってCOOLなターミナル環境を構築する手順を説明しました。  
文字コード問題やLinuxにどこまで思考をあわせるか..という点でとても苦労しましたが、満足できるクオリティに仕上がったのでは..と感じています🤗

先日リリースされたWSL2をメインに考えている方も多いと思います。  
しかし、結局のところWSL2はLinuxであり、1つの技術に依存するのはリスクだと思います。

PowerShell Coreもクロスプラットフォームを意識することで、標準的な仕様が増えてきました。  
[Windows Terminal]の登場で、ターミナルソフト面でも優位性もあります。

この記事で1人でも多くの方が[PowerShell]を導入し、Windows環境での開発を楽しんでほしい..  
と 心から願っております😊

[Windows Terminal]: https://docs.microsoft.com/ja-jp/windows/terminal/
[PowerShell]: https://docs.microsoft.com/en-us/powershell/
[Cmder]: https://cmder.net/
[git bash]: https://gitforwindows.org/
[wsl-terminal]: https://github.com/mskyaxl/wsl-terminal
[oh-my-posh]: https://github.com/JanDeDobbeleer/oh-my-posh
[Nerd Fonts]: https://www.nerdfonts.com/#home
[Scoop]: https://scoop.sh/
[fzf]: https://github.com/junegunn/fzf
[fd]: https://github.com/sharkdp/fd
[gowl]: https://github.com/tadashi-aikawa/gowl
[z]: https://github.com/rupa/z
[ripgrep]: https://github.com/BurntSushi/ripgrep
[lsd]: https://github.com/Peltoche/lsd

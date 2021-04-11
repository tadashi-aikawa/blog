---
title: oh-my-poshをv2からv3へ移行してみた
slug: migrate-oh-my-posh-from-v2-to-v3
date: 2021-04-11T15:06:44+09:00
thumbnailImage: images/cover/2021-04-11.jpg
categories:
  - engineering
tags:
  - windows
  - power-shell
  - powerline
  - terminal
---

[oh-my-posh]をv2からv3へ移行する際、実施したことをまとめました。

<!--more-->

{{<cimg "2021-04-11.jpg">}}

<!--toc-->


はじめに
--------

以前に[Windows Terminal]と[PowerShell]の記事を書きました。

{{<summary "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/">}}

上記記事の中に[oh-my-posh]のインストールや設定の項目があります。ところが、現在インストールされる[oh-my-posh]はv3であり、執筆当時のv2と異なります。そのため、記事のとおりに設定してもエラーになります。

この記事は本ブログでTopのアクセス数を誇るため、できるだけ多くの方に正しい情報を伝えるためアップデートすることにしました。その参照先としてこの記事を執筆しました。

先の記事をご覧になっていなくても、以下の方にオススメです。

- [PowerShell]でプロンプトを格好よくしたい方
- [oh-my-posh]をv2からv3に移行しようとしている方


v3移行後のイメージ
------------------

以下の画像のようになります。

{{<himg "resources/493f0288.png">}}

表示するアイコンの種類、プロンプトのデザイン、文字や背景色、順番は自由にカスタマイズできます。

冒頭で紹介した記事(v2)では以下のようなデザインでした。これはv3になったからではなくベースデザインを変えたからです。v3でも同様のデザインを実現できます。

{{<himg "https://blog.mamansoft.net/2020/05/31/windows-terminal-and-power-shell-makes-beautiful/resources/b50309f7.jpeg">}}


oh-my-poshのv3インストール
--------------------------

インストールページを参考にします。

{{<summary "https://ohmyposh.dev/docs/installation">}}

[PowerShell]を起動して以下のコマンドを実行します。

```shell
Install-Module oh-my-posh -Scope CurrentUser -Force
```

{{<why "-Forceをつける理由">}}
v2が既にインストールされていると中断するからです。

```console
WARNING: Version '2.0.412' of module 'oh-my-posh' is already installed at 
  'C:\Users\syoum\Documents\WindowsPowerShell\Modules\oh-my-posh\2.0.412'. To install version '3.133.1', run 
  Install-Module and add the -Force parameter, this command will install version '3.133.1' side-by-side with version 
  '2.0.412'.
```
{{</why>}}


v2からMigrationする
-------------------

[PowerShell]を立ち上げると以下のメッセージが表示されます。

```console
Hi there!

It seems you're using an oh-my-posh V2 cmdlet while running V3.
To migrate your current setup to V3, have a look the documentation.

https://ohmyposh.dev/docs/upgrading
```

v2が使われていることを検知したため、ドキュメントを参考にしてMigrationするよう促されます。

{{<summary "https://ohmyposh.dev/docs/upgrading">}}

### v3の特徴

v2との大きな違いは以下2点です。

- Goで書かれているためクロスプラットフォーム対応している
- 設定が`$ThemeSettings`から`.json`になった

2つ目の変更点がMigrationで重要です。今まで`$PROFILE`に書いていた設定が不要になり、代わりにjsonファイルを作成する必要があります。

### デフォルトのテーマを使う場合

デフォルトのテーマを使う場合は`Set-PoshPromt -Theme`でテーマを指定するだけです。jsonファイルは必要ありません。`Get-PoshThemes`コマンドを実行すると名前とプレビュー一覧を確認できます。

{{<himg "resources/37931d01.png">}}

今回ベーステーマとして使うのは`slimfat`です。

### テーマからjsonファイルを作成する

ベーステーマを選んでカスタマイズする場合は、そのテーマのjsonファイルを作成します。テーマを設定した状態で`Sexport-PoshTheme`コマンドを実行します。

```powershell
Set-PoshPrompt -Theme slimfat
Export-PoshTheme -FilePath ~/.oh-my-posh.json
```

これで`~/.oh-my-posh.json`に`slimfat`テーマのjsonファイルが作成されました。

### PowerShellのプロファイルを修正

v3で唯一実行するコマンドは以下です。

```powershell
Set-PoshPrompt -Theme  ~/.oh-my-posh.json
```

そのため、v2で設定した`$PROFILE`を以下のように修正します。

```diff
  # Powerline
  #-----------------------------------------------------
  
- Import-Module posh-git
- Import-Module oh-my-posh
  Invoke-Expression (& {
      $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
      (zoxide init --hook $hook powershell) -join "`n"
  })
  
- Set-Theme Powerlevel10k-Lean
- 
- # Prompt
- $ThemeSettings.Colors.DriveForegroundColor = "Blue"
- # Git
- $ThemeSettings.GitSymbols.LocalStagedStatusSymbol = ""
- $ThemeSettings.GitSymbols.LocalWorkingStatusSymbol = ""
- $ThemeSettings.GitSymbols.BeforeWorkingSymbol = [char]::ConvertFromUtf32(0xf040)+" "
- $ThemeSettings.GitSymbols.DelimSymbol = [char]::ConvertFromUtf32(0xf040)
- $ThemeSettings.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xf126)
- $ThemeSettings.GitSymbols.BranchAheadStatusSymbol = [char]::ConvertFromUtf32(0xf0ee)+" "
- $ThemeSettings.GitSymbols.BranchBehindStatusSymbol = [char]::ConvertFromUtf32(0xf0ed)+" "
- $ThemeSettings.GitSymbols.BeforeIndexSymbol = [char]::ConvertFromUtf32(0xf6b7)+" "
- $ThemeSettings.GitSymbols.BranchIdenticalStatusToSymbol = ""
- $ThemeSettings.GitSymbols.BranchUntrackedSymbol = [char]::ConvertFromUtf32(0xf663)+" "
+ Set-PoshPrompt -Theme  ~/.oh-my-posh.json
  
  #-----------------------------------------------------
  # fzf
```

設定のカスタマイズ
------------------

独自の設定をするためjsonファイルをカスタマイズします。私の設定を先の載せておきます。

{{<file ".oh-my-posh.json">}}
```json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        {
          "background": "#2f2f2f",
          "foreground": "#fafafa",
          "properties": {
            "enable_hyperlink": false,
            "style": "full"
          },
          "style": "diamond",
          "type": "path"
        },
        {
          "background": "#2f2f2f",
          "foreground": "#96E072",
          "properties": {
            "ahead_color": "#c42ebd",
            "behind_color": "#8A4FFF",
            "branch_icon": "  ",
            "color_background": false,
            "display_stash_count": true,
            "display_status": true,
            "display_upstream_icon": true,
            "local_changes_color": "#ffeb3b",
            "prefix": "<#7a7a7a> </>",
            "staging_color": "#ffeb3b",
            "status_colors_enabled": true,
            "working_color": "#E84855",
            "local_staged_icon": " \uF6B9"
          },
          "style": "diamond",
          "type": "git"
        },
        {
          "background": "#2f2f2f",
          "foreground": "#6CA35E",
          "properties": {
            "postfix": "<#7a7a7a> </>",
            "prefix": "  "
          },
          "style": "diamond",
          "type": "node"
        },
        {
          "background": "#2f2f2f",
          "foreground": "#96E072",
          "properties": {
            "postfix": "<#7a7a7a> </>",
            "prefix": "  "
          },
          "style": "diamond",
          "type": "python"
        },
        {
          "background": "#2f2f2f",
          "foreground": "#3891A6",
          "properties": {
            "postfix": "<#7a7a7a> </>",
            "prefix": "  "
          },
          "style": "diamond",
          "type": "dotnet"
        },
        {
          "background": "#2f2f2f",
          "foreground": "#7FD5EA",
          "properties": {
            "postfix": "<#7a7a7a> </>",
            "prefix": " ﳑ"
          },
          "style": "diamond",
          "type": "go"
        },
        {
          "background": "#2f2f2f",
          "foreground": "#9FD356",
          "properties": {
            "always_numeric": true,
            "color_background": false,
            "display_exit_code": true,
            "error_color": "#E84855",
            "prefix": "  "
          },
          "style": "diamond",
          "type": "exit"
        },
        {
          "background": "#2f2f2f",
          "foreground": "#fafafa",
          "properties": {
            "postfix": "",
            "prefix": "",
            "text": ""
          },
          "style": "diamond",
          "trailing_diamond": "",
          "type": "text"
        }
      ],
      "type": "prompt"
    }
  ],
  "console_title": true,
  "console_title_style": "template",
  "console_title_template": "{{if .Root}}root :: {{end}}{{.Shell}} :: {{.Folder}}",
  "final_space": true
}
```
{{</file>}}

{{<warn "上記設定ファイルの一部が文字化けする場合">}}
ブラウザフォントに[Nerd Fonts]が設定されていないと設定内のアイコンが文字化けするかもしれません。READMEにインストール方法が多数紹介されているのでそちらを参考にしてください。

{{<summary "https://github.com/ryanoasis/nerd-fonts">}}

{{<summary "https://publish.obsidian.md/mamansoft/Notes/Nerd+Fonts%E3%82%92Windows%E3%81%ABInstall">}}

{{<summary "https://publish.obsidian.md/mamansoft/Notes/Nerd+Fonts%E3%82%92Google+Chrome%E3%81%A7%E4%BD%BF%E7%94%A8">}}

oh-my-poshの公式ドキュメントにも言及されています。

{{<summary "https://ohmyposh.dev/docs/fonts">}}

[Nerd Fonts]: https://www.nerdfonts.com/
{{</warn>}}

`segments`が一番大事です。以下のイメージを持っておきましょう。

{{<himg "resources/86939e48.png">}}

使える`segments`とプロパティは公式ドキュメントのサイドバーから確認できます。

{{<vimg "resources/bc839410.png">}}

Segmentは自作もできるようなのでGoが書ける方は是非😉


総括
----

[oh-my-posh]をv2からv3へ移行する際の作業、および設定のカスタマイズ方法について紹介しました。

Gitリポジトリでのプロンプト表示が0.2sくらい遅くなったのを除けば、全体的にオシャレでカスタマイズもしやすくなっています。是非v3に移行しましょう😆

### 🦉 執筆の元になったMinervaのNotes

- [oh-my-poshをv2からv3にmigrate](https://publish.obsidian.md/mamansoft/Articles/oh-my-posh%E3%82%92v2%E3%81%8B%E3%82%89v3%E3%81%ABmigrate)


[Windows Terminal]: https://github.com/microsoft/terminal
[oh-my-posh]: https://github.com/JanDeDobbeleer/oh-my-posh
[PowerShell]: https://docs.microsoft.com/ja-jp/powershell/?view=powershell-7.1
[Nerd Fonts]: https://www.nerdfonts.com/

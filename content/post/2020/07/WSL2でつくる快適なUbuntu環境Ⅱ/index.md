---
title: WSL2でつくる快適なUbuntu環境Ⅱ
slug: efficient-wsl2-with-ubuntu2
date: 2020-07-26T21:20:34+09:00
thumbnailImage: images/cover/2020-07-26.jpg
categories:
  - engineering
tags:
  - wsl
  - ubuntu
  - terminal
  - bash
  - fcitx
---

[WSL2でつくる快適なUbuntu環境]の続編です。  
Ubuntu DesktopなしでGUIアプリケーションを使う方法や、bashのテーマを自作した話など。

[WSL2でつくる快適なUbuntu環境]: https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/

<!--more-->

{{<cimg "2020-07-26.jpg">}}

<!--toc-->


前提条件
--------

本記事は続編です。  
前回記事までの準備ができている前提で説明します。

{{<summary "https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/">}}

なおUbuntuのバージョンは`20.04 LTS (Focal Fossa)`です。


GUIアプリケーションの日本語対応
-------------------------------

VcXsrv Windows X ServerをインストールするとGUIアプリケーションを使えます。  
前回記事のセクション [クリップボードを同期する] でインストールされていると思います。

[クリップボードを同期する]: https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/#%E3%82%AF%E3%83%AA%E3%83%83%E3%83%97%E3%83%9C%E3%83%BC%E3%83%89%E3%82%92%E5%90%8C%E6%9C%9F%E3%81%99%E3%82%8B

しかし、素の状態では3つ問題があります。

* 日本語が表示されない
* 日本語が入力できない
* 一部の絵文字が表示されない

これらをすべて解決する手順を紹介します。

環境構築にあたり、以下のサイトを参考にしています。  
GNOME(Ubuntu Desktop)は使っていませんが大変助かりました🙇‍♂️

{{<summary "https://neos21.hatenablog.com/entry/2020/03/10/080000">}}


{{<warn "本記事の内容を過信しないでください">}}
筆者の環境は色々試行錯誤した結果できたものです。  
本記事の内容は、その過程でメモしたものを整理しただけです。

**同じ手順を実行したから同じ環境ができるとは限りませんし、その確認は行っていません。**

時代と共に適切な手順は変わりますので、その意味でも過信はしないでください。
{{</warn>}}

### GUIアプリケーションのインストール

動作確認用に使ってみたいツールをインストールしましょう。  
筆者はIntelliJ IDEAをインストールして試しました。

```
umake ide idea-ultimate ~/.local/share/umake/ide/idea
```

Google Chromeがよければこちらをどうぞ😉

```
# https://www.sejuku.net/blog/82940
# https://qiita.com/pyon_kiti_jp/items/e6032eb6061a4774aece
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list’
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update
sudo apt-get install google-chrome-stable
```

### 日本語版の関連パッケージをインストール

日本語化に必要なパッケージをインストールします。

```
sudo apt install -y $(check-language-support -l ja) language-pack-ja
```

{{<info "check-language-supportについて">}}
各言語に対応するため、欠落している必要なパッケージを管理するツールです。

`check-language-support -l ja`は日本語に必要な欠落しているパッケージのリストを表示しています。  
`check-language-support --show-installed ja`ではインストール済みのそれを表示します。

筆者の環境では以下のようになりました。

```
$ check-language-support --show-installed ja
fcitx fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-mozc fcitx-ui-classic fonts-noto-cjk fonts-noto-cjk-extra gnome-user-docs-ja language-pack-ja mozc-utils-gui
```
{{</info>}}

{{<why "language-pack-jaを指定する必要はあるのか..?">}}
個人的には無い気がしています。  
なぜなら、`check-language-support`のリストに含まれているはずだからです。

再度入れ直して確認するのが手間だったため、今回は実際に実行したコマンドをそのまま掲載しました。
{{</why>}}


最後にロケールを変更しましょう。

```
sudo update-locale LANG=ja_JP.UTF-8
```

このあと一度Ubuntuを再起動します。  
ターミナルを閉じただけでは裏で動き続けているため、Windows側で以下を忘れずに..。

```
wsl --terminate Ubuntu
```

### 絵文字が文字化けしないフォントをインストールする

標準のフォントでは絵文字が文字化けします。

{{<himg "resources/3a42ebab.png">}}

Unicode絵文字と特殊絵文字、両方に対応できるよう2つのフォントをインストールします。

#### Noto Color Emoji

Notoの由来は**No** more **to**fuです。  
二度と豆腐のように文字化けさせないというだけあり、ほとんどの文字/絵文字に対応しています。

{{<summary "https://www.google.com/get/noto/help/emoji/">}}

```
sudo apt install fonts-noto-color-emoji
```

筆者は主にブラウザで使用しています。  
Standard fontにだけ設定すると、そこそこイイ感じになります👍

{{<himg "resources/0b36b6ba.png">}}

#### fonts-symbola

白黒や古いUnicode絵文字を表示するために必要です。  
というのもNoto Color Emojiは上記のようなUnicode絵文字に対応していないからです。

```
sudo apt install fonts-symbola
```

{{<info "ttf-ancient-fontsについて">}}
`fonts-symbola`は元々`ttf-ancient-fonts`という名前だったようです。

{{<summary "https://launchpad.net/ubuntu/bionic/+package/ttf-ancient-fonts-symbola">}}

少し古いサイトは`ttf-ancient-fonts`や`ttf-ancient-fonts-symbola`のインストールをするよう記載されているかもしれません。
{{</info>}}

#### Nerd Fonts

PowerShellの環境整備でもお世話になった開発者用最強フォントです！

{{<summary "https://www.nerdfonts.com/">}}

GitHubのREADMEを参考にインストールしましょう。

{{<summary "https://github.com/ryanoasis/nerd-fonts#option-3-install-script">}}

今回は`Option 3: Install Script`を使いました。

```
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
./install.sh SourceCodePro
```

筆者は主にIntelliJ IDEAなどのIDEやターミナルで使用しています。


### IMEをfcitxに変更する

ファイティクスと読みます。

{{<summary "https://ja.wikipedia.org/wiki/Fcitx">}}

以下のコマンドを使って変更します。

```
im-config -n fcitx
```

必要な環境変数を`.bash_profile`か`.bashrc`で設定します。

```
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
```

またUbuntuを再起動します。  
再びログインしたら以下のコマンドでfcitxを起動します。

```
fcitx-autostart
```

{{<warn "I/O warningとERROR-271が表示される..">}}
以下の警告とエラーが表示されるかもしれません。  
筆者の環境では無視してEnter押したら動きました。

```
I/O warning : failed to load external entity "/usr/share/X11/xkb/rules/xorg.extras.xml"
(ERROR-271 ime.c:432) fcitx-keyboard-in-tel-kagapa already exists
```

調べても原因が分からなかったのでご存知の方いらっしゃれば是非教えて下さい🙏
{{</warn>}}

### fcitxの設定

IMEの設定をするため以下のコマンドを実行します。

```
fcitx-configtool
```

各タブごとに設定していきましょう。

#### Input Method

Kana 86 -> Mozc の優先度に設定します。

{{<himg "resources/a371c322.png">}}

#### Global Config

HotKeyの`Show Advanced Options`を有効にして以下のように設定しました。

{{<himg "resources/e183fa13.png">}}

`Activate input method`と`Inactivate Input Method`をはじめ、設定は単なる好みです。

#### Appearance

IDEの変換候補で使うフォントをNoto Color Emojiにします。  
また、ステータスパネルは常に表示させました。

{{<himg "resources/b8a613c6.png">}}

### 動作確認

Google Chromeで動作確認してみます。

{{<himg "resources/20200726_1.gif">}}

しっかり日本語や絵文字が入力できていますね😄


bashのテーマカスタマイズ
------------------------

2つ目はbashターミナルのカスタマイズです。  
Bash-itを使います。

### Bash-itとは

Bash-itはBashコミュニティが提供するBashのコマンド/スクリプト群です。  
主にプロンプトの見た目/挙動を変更する目的でこちらを導入しました。

{{<summary "https://github.com/Bash-it/bash-it">}}

### Bash-itのインストール

READMEの手順に沿うようインストールします。

```
git clone --depth 1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
```

{{<warn "~/bash_it/install.shを実行すると.bashrcが上書きされるので注意">}}
インストールをすると既存の`.bashrc`が完全に上書きされます。  
追記ではありません。

上書き前のファイルは`~/.bashrc.bak`として保存されています。  
`/bashrc`をカスタマイズしている場合はインストール後に設定をマージしましょう。
{{</warn>}}

### 独自テーマの配置と設定

`~/.bash_it/themes`配下にディレクトリと、その中にbashファイルを作成します。  
テーマ名を`maman`にしたので`~/.bash_it/themes/maman/maman.theme.bash`を作りました。

{{<file "maman.theme.bash">}}
```bash
#!/usr/bin/env bash

# Use in scm_prompt_vars
SCM_GIT_STAGED_CHAR=" "
SCM_GIT_UNSTAGED_CHAR=" "
SCM_GIT_UNTRACKED_CHAR=" "
SCM_GIT_AHEAD_CHAR=" "
SCM_GIT_BEHIND_CHAR=" "
SCM_THEME_TAG_PREFIX=" "
SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_DIRTY=""

# Separator instead of /
SEP=""

##################################################
#
# | prompt > virtual_env > scm > cwd > status >
#
##################################################
PROMPT_THEME_BG=2

# Python virtualenv
VIRTUAL_ENV_FG=255
VIRTUAL_ENV_BG=4

VIRTUAL_ENV_SYMBOL=" "

# Source code management
SCM_CLEAN_FG=231
SCM_DIRTY_FG=196
SCM_STAGED_FG=220
SCM_UNSTAGED_FG=166
SCM_BEHIND_FG=2
SCM_AHEAD_FG=2

SCM_BG=16

SCM_NONE_CHAR=""
SCM_GIT_CHAR=" "
SCM_GIT_CHAR_REMOTE_DEFAULT=" "
SCM_GIT_CHAR_REMOTE_NO_DEFAULT=" "
SCM_GIT_CHAR_GITHUB=" "
SCM_GIT_CHAR_BITBUCKET=" "

# Current working directory
CWD_FG=159
CWD_BG=236

# Status
STATUS_FG=1
STATUS_BG=52

#######################################
# Arguments:
#   None
# Returns:
#   None
# Stdout:
#   Logo emoji (ex: )
#######################################
function git_remote_logo() {
  if [[ "$(_git-upstream)" == "" ]]; then
    echo "$SCM_GIT_CHAR_REMOTE_NO_DEFAULT"
    return
  fi

  local remote_domain
  remote_domain=$(git remote get-url origin | awk -F'[@:.]' '{print $2}')
  case ${remote_domain//\//} in
    github) echo "$SCM_GIT_CHAR_GITHUB" ;;
    bitbucket) echo "$SCM_GIT_CHAR_BITBUCKET" ;;
    *) echo "$SCM_GIT_CHAR_REMOTE_DEFAULT" ;;
  esac
}

##############################################
# Arguments:
#   None
# Returns:
#   None
# Stdout:
#   Short current work directory (ex: ~/hoge)
##############################################
function short_cwd() {
  echo "$(pwd) " |
    sed -r "s@${HOME}/git/github.com@${SCM_GIT_CHAR_GITHUB}@g" |
    sed -r "s@${HOME}@~@g" |
    sed -r "s/\//  /2g"
}

##############################################
# Arguments:
#   $1: Background color of separator
# Stdout:
#   Separator
##############################################
function separator() {
  echo "$(bg "${1}")${SEP}"
}

##############################################
# Arguments:
#   $1: foreground color (ex: 208)
# Returns:
#   None
# Stdout:
#   Color string
##############################################
function fg() {
  echo -e "\[\033[38;5;${1}m\]"
}

##############################################
# Arguments:
#   $1: background color (ex: 208)
# Returns:
#   None
# Stdout:
#   Color string
##############################################
function bg() {
  echo -e "\[\033[48;5;${1}m\]"
}

##############################################
# Arguments:
#   $1: foreground color (ex: 208)
#   $2: background color (ex: 208)
# Returns:
#   None
# Stdout:
#   Color string
##############################################
function fgbg() {
  echo -e "\[\033[38;5;${1};48;5;${2}m\]"
}

##############################################
# (1)
##############################################
function build_shell_prompt() {
  echo "$(bg ${PROMPT_THEME_BG}) $(fg ${PROMPT_THEME_BG})"
}

##############################################
# (2)
##############################################
function build_virtualenv_prompt() {
  local environ=""

  if [[ -n "$VIRTUAL_ENV" ]]; then
    environ=$(basename "$VIRTUAL_ENV")
  fi

  if [[ -n "$environ" ]]; then
    echo "$(separator ${VIRTUAL_ENV_BG}) $(fgbg ${VIRTUAL_ENV_FG} ${VIRTUAL_ENV_BG})${VIRTUAL_ENV_SYMBOL}$environ $(fg ${VIRTUAL_ENV_BG})"
  fi
}

##############################################
# (3)
##############################################
function build_scm_prompt() {
  scm_prompt_vars

  if [[ "${SCM_NONE_CHAR}" == "${SCM_CHAR}" ]]; then
    return
  fi
  if [[ "${SCM_GIT_CHAR}" != "${SCM_CHAR}" ]]; then
    return
  fi

  local fg_local
  if [[ "${SCM_DIRTY}" -eq 3 ]]; then
    fg_local=${SCM_STAGED_FG}
  elif [[ "${SCM_DIRTY}" -eq 2 ]]; then
    fg_local=${SCM_UNSTAGED_FG}
  elif [[ "${SCM_DIRTY}" -eq 1 ]]; then
    fg_local=${SCM_DIRTY_FG}
  else
    fg_local=${SCM_CLEAN_FG}
  fi

  ahead=$(sed -nr "s@.*( ${SCM_GIT_AHEAD_CHAR}[0-9]+).*@\\1@pg" <<<${SCM_BRANCH})
  behind=$(sed -nr "s@.*( ${SCM_GIT_BEHIND_CHAR}[0-9]+).*@\\1@pg" <<<${SCM_BRANCH})
  without_remote=$(
    sed -r "s@(.*)( ${SCM_GIT_BEHIND_CHAR}[0-9]+)(.*)@\\1\\3@g" <<<${SCM_BRANCH} |
      sed -r "s@(.*)( ${SCM_GIT_AHEAD_CHAR}[0-9]+)(.*)@\\1\\3@g"
  )

  local fg_behind=${SCM_CLEAN_FG}
  if [[ ${behind} != "" ]]; then
    fg_behind=${SCM_BEHIND_FG}
  fi

  local fg_ahead=${SCM_CLEAN_FG}
  if [[ ${ahead} != "" ]]; then
    fg_ahead=${SCM_AHEAD_FG}
  fi

  SCM_PREFIX="$(fgbg ${fg_behind} ${SCM_BG})$(git_remote_logo)${behind} $(fg 0)$(fg ${fg_ahead})${ahead} $(fgbg ${fg_local} ${SCM_BG})${SCM_CHAR}${without_remote}${SCM_STATE}"
  echo "$(separator ${SCM_BG}) ${bold_white}${SCM_PREFIX} $(fg ${SCM_BG})"
}

##############################################
# (4)
##############################################
function build_cwd_prompt() {
  echo "$(separator ${CWD_BG}) $(fgbg ${CWD_FG} ${CWD_BG})$(short_cwd)$(fg ${CWD_BG})"
}

##############################################
# (5)
# Arguments:
#   $1: last_status_code (ex: 127)
##############################################
function build_status_prompt() {
  if [[ "$1" -ne 0 ]]; then
    echo "$(separator ${STATUS_BG}) $(fgbg ${STATUS_FG} ${STATUS_BG})${1} $(fg ${STATUS_BG})"
  fi
}

##############################################
# Last
##############################################
function tail() {
  echo "$(separator 0)${normal} "
}

##############################################
# Main
##############################################
function main() {
  err_code="$?"
  PS1="$(build_shell_prompt)$(build_virtualenv_prompt)$(build_scm_prompt)$(build_cwd_prompt)$(build_status_prompt $err_code)$(tail)"
}

PROMPT_COMMAND=main
```
{{</file>}}

上記ファイルは本記事執筆時のものです。  
最新版はGitHubをご覧下さい。

{{<summary "https://github.com/tadashi-aikawa/owl-playbook/blob/master/mnt/linux/ubuntu/.bash_it/themes/maman/maman.theme.bash">}}

そして`.bashrc`のテーマ名を変更します。

```
export BASH_IT_THEME='maman'
```

再びターミナルにログインするとテーマが変わっています💪

### mamanテーマについて

ポイントだけ解説します。  
SSHやユーザ名などは除外していますが、今後必要に応じて追加する予定です。

#### ホームディレクトリ

`~`で表示されます。

{{<himg "resources/066aa76b.png">}}

#### エラーコード

最後に表示されます。

{{<himg "resources/3ae1ed45.png">}}

#### 仮想環境

現時点ではPythonの仮想環境のみ表示されます。

{{<himg "resources/50e6e6a5.png">}}

#### Git

Gitの表示情報は充実しています。  
そのために自作したと言っても過言ではありません。

左端のロゴはリモートの種類です。  
GitHubとBitbucketに対応しています。

{{<himg "resources/6e4920fe.png">}}

ローカルの新規/変更/staged数を把握し、状況に応じて色を変更します。  
コミット済み(未push)の数はGitロゴの左側に表示され、ローカルのカラーリングとは異なるルールで表現されます。

{{<himg "resources/caedb473.png">}}

リモートの状況はリモートロゴの右側に表示されます。  
左に行けば行くほどリモートを意味するデザインにしています。

{{<himg "resources/b0118967.png">}}

新しいブランチ作成後です。  
追跡されていない場合のリモートロゴはこんな感じ。

{{<himg "resources/91f70f21.png">}}

StashやConflictのデザインは現状カスタマイズしていません。


総括
----

Ubuntu Desktopを使わずにWSL2 x UbuntuでGUIアプリケーションを使う方法について、主に日本語/Unicode対応の部分を説明しました。  
また、Bashで使えるオリジナルテーマも紹介しました。

前回紹介したとおり、Windows側のIDEAからWSL2のプロジェクトを開発する場合はDebug/Runができませんでした。  
Ubuntuから直接IntelliJ IDEAを使うことで、この問題を解決できたのは大きな成果です。  

Windowsと同じ操作感で複数のアプリをウィンドウとして配置できるのも素晴らしいです。  
しかも、AutoHotKeyなどのカスタマイズソフトも普通に使えます！

Ubuntu Desktopは入れたくないけどIDEやブラウザは使いたい...  
という方は是非チャレンジしてみてください👍

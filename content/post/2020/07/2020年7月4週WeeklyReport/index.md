---
title: 2020年7月4週 Weekly Report
slug: 2020-07-4w-weekly-report
date: 2020-07-27T07:49:07+09:00
thumbnailImage: images/cover/weekly-report.jpg
categories:
  - weekly-report
tags:
  - wsl
  - typescript
  - java
  - python
  - scaledrone
  - hhkb
  - concept
  - vuetify
  - vue
  - ubuntu
  - togowl
---

📰 **Topics**

WSL2 x Ubuntuの環境構築記事 後編を公開しました。  
Togowlのメジャーバージョンも2に上がり、便利な機能がいくつか追加されています。

<!--more-->

{{<cimg "weekly-report.jpg">}}

<!--toc-->


書いたこと
----------

### 【WSL】WSL2でつくる快適なUbuntu環境Ⅱ

続編を書きました。

{{<summary "https://blog.mamansoft.net/2020/07/26/efficient-wsl2-with-ubuntu2/">}}

Ubuntu DesktopをインストールせずGUIアプリケーションを使いたい方や、WSLに限らずbashのプロンプトを格好良くしたい方は是非ご覧下さい😄


### 【TypeScript】リリースノート v2.9

TypeScript v2.9のリリースノートをまとめ終わりました。

{{<summary "https://mimizou.mamansoft.net/it_note/languages/typescript/releases/2.9/">}}

個人的には `--resoolveJsonModule`以外あまり響かなかったです。

### 【JavaScript】【Python】正規表現の名前付きキャプチャ

よく忘れるのでMimizou Roomにまとめました。

{{<summary "https://mimizou.mamansoft.net/it_note/concepts/regex/faq/#_1">}}


読んだこと/聴いたこと
---------------------

### Scaledrone

リアルタイムでメッセージをやりとりするSaaSのようです。

{{<summary "https://www.scaledrone.com/">}}

WebSocketをサーバ側で用意する必要がなく、クライアントの実装もそれより簡単な印象です。  
サーバレスだけどリアルタイム性が欲しい場合に利用できるのではと思いました。

外部との通信が発生するため、仕事だとサーバを立てるのが現実的なのかもしれませんが..😓

### HHKBのプロモ

ラインナップ一新のタイミングで作られたのでしょうか..ｶｯｺｲｲ!!

<iframe width="560" height="315" src="https://www.youtube.com/embed/W7LT3pIndLM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

試したこと
----------

### Concept

無限キャンバスを持つスケッチアプリです。  
各OSに対応していますが今回はiPad Proで使ってみました。

※ 必需ツール(1840円)に課金しています

{{<summary "https://concepts.app/ja/">}}

ドキュメントはコチラです。かなり丁寧☺️

{{<summary "https://concepts.app/ja/ios/manual/">}}


#### 経緯

最近ではiPad OS標準メモを愛用していましたが、先週のレポートに記載のとおり欠点もあります。

❶ 1画面に沢山の文字(ベクターデータ)を書くと突然重くなる  
❷ キャンバスの拡大/縮小、ベクターデータの拡大/縮小ができない  
❸ 図形描画などはできない  
❹ **横幅が固定**  
❺ 画像と手書きを共存させるのが難しい (画像データに書き込みはできる)  
❻ 共同編集ができない  

この中でも特に❹が気になっていました。  
また、❶❷❸❺も解決できるなら解決したいと思いました。

Conceptはそれらを解決できそうなポテンシャルがあったため試してみました。

用途はアイデアを可視化するメモです。  
エンジニアリングのホワイトボード的位置づけなので、デザインや絵を描くわけではありません。  
そういう観点で使用した感想です。

#### 使用感

❶～❻について、Conceptの対応状況は以下の通りでした。

| No  | 説明                                                       | Conceptの対応状況 |
| --- | ---------------------------------------------------------- | ----------------- |
| ❶  | 1画面に沢山の文字(ベクターデータ)を書くと突然重くなる      | ?                 |
| ❷  | キャンバスの拡大/縮小、ベクターデータの拡大/縮小ができない | ✅ **できる**     |
| ❸  | 図形描画などはできない                                     | ✅ **できる**     |
| ❹  | **横幅が固定**                                             | ✅ **無限**       |
| ❺  | 画像と手書きを共存させるのが難しい                         | ✅ **共存可能**   |
| ❻  | 共同編集ができない                                         | ✘ 多分できない   |

❻以外の点は解消されたのでよかったです😄  
一方、メモにあった『ロック画面でApple Pencilをダブルタッチするとすぐに使える』という最大のメリットが失われますので、これはトレードオフですね。

ペンではなく指で触ったときの挙動を変えられるのも気に入っています。  
スライス(消しゴム)という機能に割りあてています。  
私のペンの持ち方はApple Pencilのダブルタップと相性が悪いので..。

機能が多くて、操作や設定が少し難しいですが慣れの問題かなとも思っています。

#### 描いてみた

せっかくなので描いてみたメモをアップしておきます。  
メモ系のアプリは色々使ってきたので、記事にするのもアリかなと思ったりしています🤔

{{<himg "resources/ce1a62e7.jpeg">}}

お気に入りのブラシはソフト鉛筆です。  
デフォルトだと薄かったので、スタイラスの設定から筆圧感度を`25-100%`に設定しました。

以下はTogowl開発中のメモ書きに使っている画面イメージです。

{{<himg "resources/concept.jpeg">}}


調べたこと
----------

### 【Vuetify】v-formによってEnterでページリロードされることがある

Fromsに配置する入力要素によって事象が発生することがありました。

{{<summary "https://vuetifyjs.com/ja/components/forms/">}}

以下のサイトで丁寧に説明されていました。

{{<summary "https://riotz.works/articles/lopburny/2019/07/31/page-reload-issue-by-implicit-submission/">}}

type=submitの要素が存在せず、項目が1つしかない場合に発生するみたいでです。  
`implicit submission`というHTMLの仕様らしいです。

### 【Vuetify】 モバイル端末でダイアログを開いた状態から戻るボタンを押すとページが戻ってしまう

期待値はダイアログが閉じてほしいですが、historyを1つ前に遡ってしまいます。  
回避策はいくつか紹介されていますが、対応される気配はなさそう..。

{{<summary "https://github.com/vuetifyjs/vuetify/issues/1793">}}

Vue3にメジャーバージョンアップする時期でもあるため、一旦対応は見送りました。  
面倒事に巻き込まれるリスクは減らしたいので。

### 【Vue】v-modelを使用できるコンポーネントの作成

公式ドキュメントに書かれていました。

{{<summary "https://jp.vuejs.org/v2/guide/components.html#%E3%82%B3%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%8D%E3%83%B3%E3%83%88%E3%81%A7-v-model-%E3%82%92%E4%BD%BF%E3%81%86">}}

* プロパティに`value`を追加する
* 値に変更があったら`input`イベントをemitし`value`を送出する

`value`と`input`という名前が強制されてしまうのは気になりました。  
ただ、インターフェースは`v-model`であり実装の話なので大きな問題ではないと思っています。

### Ubuntuで一部の絵文字が文字化けする

WSL2/Ubuntuの環境にて、vcxsrvを使ってIntellij IDEAを起動すると一部絵文字が豆腐化していました。  
fonts-symbolaをインストールすることで解消しました。

```
sudo apt install fonts-symbola
```

詳細は[ブログの記事](#wslwsl2%E3%81%A7%E3%81%A4%E3%81%8F%E3%82%8B%E5%BF%AB%E9%81%A9%E3%81%AAubuntu%E7%92%B0%E5%A2%83)をご覧下さい。


整備したこと
------------

### 【Bash】Bash-itのオリジナルtheme作成

[Bash-it](https://github.com/Bash-it/bash-it)のオリジナルテーマを作成しました。  
詳細はブログの記事に書く予定です。

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

[Power-Turk](https://github.com/Bash-it/bash-it/blob/master/themes/powerturk/powerturk.theme.bash)の影響を受けています。


### 【WSL】Ubuntuの日本語入力対応

WSL2/Ubuntuで日本語入力できるようにしました。  
詳細は[ブログの記事](#wslwsl2%E3%81%A7%E3%81%A4%E3%81%8F%E3%82%8B%E5%BF%AB%E9%81%A9%E3%81%AAubuntu%E7%92%B0%E5%A2%83)をご覧下さい。

### 【WSL】UbuntuにGoogle Chromeをインストール

WSL2/Ubuntuの環境にて、vcxsrv経由でGoogle Chromeを使える環境を作りました。  
インストールのコマンドです。

```
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list’
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update
sudo apt-get install google-chrome-stable
```

{{<refer "https://www.sejuku.net/blog/82940">}}
{{<refer "https://qiita.com/pyon_kiti_jp/items/e6032eb6061a4774aece">}}

絵文字などをしっかり表示したいので、Noto Color Emojiをインストールしました。

{{<summary "https://www.google.com/get/noto/help/emoji/">}}

```
sudo apt install fonts-noto-color-emoji
```

Chromeのフォント設定は[ブログの記事](#wslwsl2%E3%81%A7%E3%81%A4%E3%81%8F%E3%82%8B%E5%BF%AB%E9%81%A9%E3%81%AAubuntu%E7%92%B0%E5%A2%83)をご覧下さい。


### GitHub ActionsでCodeCovの解析に失敗してもFailureにしない

CodeCovへのアクセスはしばしばタイムアウトになります。  
その度に確認は手間なので、CodeCovの解析失敗は無視するようにしました。

```diff
       - uses: codecov/codecov-action@v1
         if: matrix.python == 3.8 && matrix.os == 'ubuntu-latest' && success()
-        with:
-          fail_ci_if_error: true
```

実はデフォルトが無視する設定なのです。  
なんで..?? と思ってましたが腑に落ちました😅


今週のリリース
--------------

### Togowl v2.0.0 ～ v2.6.0

メジャーバージョンを2に上げました。  

{{<summary "https://github.com/tadashi-aikawa/togowl">}}

#### タスクの追加機能

Togowlからタスクを作成できるようになりました🥳  
Todoistにアクセスせず、頭に浮かんだタスクをすぐに登録できます！

{{<vimg "resources/togowl_add_dialog.gif">}}

4つあるボタンのどれを押すかによって、タスクがどこに追加されるかが決まります。

#### URLの埋め込まれたタスクを開始したらリンク先を表示

リンク先を開く手間を削減することで、脳の切り替えをスムーズにします。

{{<himg "resources/togowl_v2.3.0_1.gif">}}

Safariだと設定でポップアップを許可が必要です。


#### タスクを本日リストの最初/最後に移動

ドラッグ＆ドロップによる移動の手間を省きます。

{{<himg "resources/ae9cd924.png">}}

#### タスクメニューの追加

タスクをクリックしたらメニューを表示してアクションできるようにしました。

{{<himg "resources/togowl_v2.6.0.gif">}}

スワイプメニューにあったタスク編集ボタンはこちらに移動しています。  
グレーアウトしている項目は後ほど実装予定です。


その他
------

### 【TypeScript】サバイバルTypeScript

業務で[サバイバルTypeScript]を教育用に使わせていただいております。

{{<summary "https://book.yyts.org/">}}

typoを発見したのでプルリクエストを送ってみました。

{{<summary "https://github.com/yytypescript/book/pull/4">}}

[サバイバルTypeScript]: https://github.com/yytypescript/book

### 創の軌跡発売まで1ヶ月

遂にあと1ヶ月！  
8/27と8/28はもちろん休暇をとりました😜

{{<summary "https://www.falcom.co.jp/hajimari/">}}

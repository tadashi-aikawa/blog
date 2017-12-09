---
title: ターミナルが100倍楽しくなるfish
date: 2017-10-15
thumbnailImage: https://fishshell.com/assets/img/Terminal_Logo_CRT_Small.png
categories:
  - engineering
tags:
  - wsl
  - windows
  - fish
  - zsh
  - ansible
---

zshからfishに移行してみました。

<!--more-->

{{<summary "https://fishshell.com/">}}

<!--toc-->


前提
----

以下の環境で構築しました。

* Windows10 with WSL (Ubuntu 16.04.2 LTS (Xenial Xerus))
* [WSL Terminal]
* [Ansible] (2.3.2.0) (python 2.7.14)

構築手順は **全てAnsible Playbookの形** で紹介します。  
Playbookを使わない方法は他の素晴らしいブログで記載されておりますので、そちらをご覧下さい。


[WSL Terminal]: https://github.com/goreliu/wsl-terminal
[Ansible]: http://docs.ansible.com/


経緯
----

社内のLTでfishの発表があり、デモもイイ感じだったので入れてみようと思ったのがきっかけです。  
今までは **bash/zshと文法が結構違う** という理由で躊躇していました。

しかし、冷静に考えてみると問題なさそうだと思いました。

* デフォルトシェルをfishにしなければスクリプトには影響が無い
* 新しい文法は慣れの問題
* 社内サーバはbashが基本であり、コンテキストスイッチコストもzshの時から存在する

また、fishが比較的新しいモダンなシェルであり これ以上大人の事情で目を瞑るのは良くないと思ったからです。

しばらく使ってみて、強力な補完とプラグインの虜になってしまいました。  
本題に入る前に、2つほどfishの補完について紹介します。

{{<alert warning>}}
補完の名前は適当につけました。正式名称は調べて下さい。
{{</alert>}}


### シャドー補完

まるで漢字ドリルをなぞるように先回りした補完がデフォルトの状態で使用できます。

{{<himg "https://dl.dropboxusercontent.com/s/rj8qobwzptcbz5f/20171015_2.gif">}}


### 曖昧補完

`**` で配下のエントリ全てを補完することができます。

{{<himg "https://dl.dropboxusercontent.com/s/edmn5h1xmkw32rk/20171015_3.gif">}}


最後のは標準機能ではなくプラグインを使っています。


インストール
------------

PPAリポジトリからインストールします。

```yaml
- name: Add fish repository from PPA and install its signing key.
  become: yes
  apt_repository:
    repo: 'ppa:fish-shell/release-2'

- name: Install fish
  become: yes
  apt:
    name: fish
    update_cache: yes
    state: latest
```

バージョンは `version 2.6.0` です。


fzf
---

コマンドラインのfuzzy finderです。  
曖昧な入力を元にfindコマンドを駆使して様々な検索をすることができます。

fishとは直接関係ありませんが、後でインストールするプラグイン(`fisherman/fzf`)を使用するために必要なのでインストールしています。  
凄い便利なのでfishを使用しない場合でも是非インストールしてみてください。

{{<summary "https://github.com/junegunn/fzf">}}


### インストール

cloneしてインストールスクリプトを実行します。

```yaml
- name: Clone fzf
  git:
    repo: https://github.com/junegunn/fzf.git
    dest: ~/.fzf
    depth: 1

- name: Install fzf
  shell: ~/.fzf/install --all
```


fisherman
---------

fishには便利なプラグインが沢山あり、プラグインマネージャを使用する事で簡単に管理することができます。  
もう1つ有名なマネージャとして `oh-my-fish` もありますが、`fisherman` の方が後発で評判もいいためこちらを採用しています。

詳しくは公式のREADMEをご覧下さい。

{{<summary "https://github.com/fisherman/fisherman">}}


### インストール

curlでインストールです。

```yaml
- name: Install fisherman
  shell: curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
```

Ansibleで環境構築を完了させるため、コマンドの説明は省略します。


プラグイン
----------

インストール方法は最後にご紹介します。


### theme-bobthefish

fishのテーマです。  
oh-my-fish側のリポジトリで管理されているテーマ群の中で選びました。

以下から全てのテーマを閲覧することができます。

{{<summary "https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md">}}

周囲を見ると ほとんどの方が[agnoster]を使用されていますが、私は[bobthefish]派です。  
[agnoster]にしなかった理由は以下の通りです。

* Gitに関する情報量と表現力が好みにあわなかった
* 目立ちすぎに思える
* 皆使っているので面白くない

フォントは[Source Code Pro for Powerline]を使用しています。

[agnoster]: https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md#agnoster
[bobthefish]: https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md#bobthefish
[Source Code Pro for Powerline]: https://github.com/powerline/fonts/tree/master/SourceCodePro


### fish-bd

`bd`コマンドで`cd`コマンドと全く逆の動きをすることができます。  

{{<summary "https://github.com/0rax/fish-bd">}}

`<TAB>`で上位ディレクトリが階層を越えて補完され、ディレクトリ名だけを指定すればそこまで移動することができます。

例えばカレントディレクトリが `a/b/c/d/e/f/g` の場合、補完候補は

```
a b c d e f g
```

となり、`bd c` を実行すると `a/b/c` に移動することができます。  
もう `cd ../../../../` といった暗号のようなコマンドを実行する必要はありません。


### fzf

先ほど説明したfzfのfishプラグインバージョンです。  
fishにマッチする形でfzfと上手く連携してくれます。

{{<summary "https://github.com/fisherman/fzf">}}

以下は以前実行した`site.yml`を編集するコマンドを履歴から検索して実行するまでの流れです。

{{<himg "https://dl.dropboxusercontent.com/s/4q3vjhb7s2uk1gn/20171015_1.gif">}}

他にも色々機能がありますが、これが一番使いますね。


### z

曖昧な入力を元に、一度でも移動したことがあるディレクトリへ移動するコマンドです。  
メチャクチャ便利です。

{{<summary "https://github.com/fisherman/z">}}


### インストール

`with_items`でまとめてインストールします。  
Ansibleはbashで実行しているため、`fish`のコマンドとして指定する必要があります。

```yaml
- name: Install by fisher
  shell: fish -c "fisher {{ item }}"
  with_items:
    - omf/theme-bobthefish
    - 0rax/fish-bd
    - fisherman/fzf
    - fisherman/z
```


その他
------

### wsl-terminalの起動シェルをfishに変更

`wsl-terminal/etc/wsl-terminal.conf` に `shell=fish` を設定しましょう。  
これでfishを直接起動することができます。

### `config.fish`の設定

bashの`.bashrc`やzshの`.zshrc`にあたるものです。  
場所が`.config/fish/config.fish`と少し異なります。

fzfに関するデフォルトオプションだけ以下に記載します。

```
# 一覧の上を最新として、境目をボーダーに
set -x FZF_DEFAULT_OPTS "--reverse --border"
# ディレクトリ検索で選択した項目の配下の構成をプレビューに表示する
set -x FZF_ALT_C_OPTS   "--preview 'tree -C {} | head -200'"
# ファイル検索で選択した項目の中身をプレビューに表示する
set -x FZF_CTRL_T_OPTS  "--preview 'head -100 {}'"

# エラーコードは番号で表示する
set -g theme_show_exit_status yes
# Gitのahead情報を細かく表示する
set -g theme_display_git_ahead_verbose yes
```


トラブルシューティング
----------------------

WSLを使っていることもあり、色々なハマリポイントがありました。


### pecoが使用できない

fzfと双璧をなすpecoというツールもあるのですが、WSLのせいか(?)インストールできませんでした。

{{<summary "https://github.com/peco/peco">}}


### PATHが不正

環境変数をセットしたつもりでもPATHが不正と怒られる場合は、以下のように設定しているかを確認してみて下さい。  
※ 例では`$PYENV_ROOT/bin`をセットしています

```
set -x PATH "$PYENV_ROOT/bin" $PATH
```

以下はいずれも誤りです。

```
set -x PATH "$PYENV_ROOT/bin:$PATH" 
set -x PATH "$PYENV_ROOT/bin" "$PATH"
```

### fishからfzfプラグインの機能 最近のコマンドから検索 が実行できない

事象としては `fzf` と文字列が出力されてしまいます。

`/home/tadashi-aikawa/.config/fish/functions/fish_user_key_bindings.fish` の `fzf_key_bindings` 以外をコメントアウトすることで事象は解消されました。  
ただ、正確な原因は不明です。。

```
function fish_user_key_bindings
    fzf_key_bindings
#    ### fzf ###
#    set -q FZF_LEGACY_KEYBINDINGS
#    or set -l FZF_LEGACY_KEYBINDINGS 1
... 中略 ...
#    end
#    ### fzf ###
end
```

### `tcsetpgrp`のPermission deniedエラーが発生する

必ず発生するわけではありませんが、fzf使用中に度々発生しました。  
まだ解決方が分かっておりません。。

### `wcmd: OUTBASH_PORT environment variable not set, and...`エラーが発生する

`wcmd`を使用するとエラーになり実行できなくなりました。  
Windowsを再起動したら発生しなくなりました。


総括
----

WSLへfishを導入する手順について紹介しました。  
今のところ大きな不満はありませんので、引き続き環境を最適化してみようと思います。


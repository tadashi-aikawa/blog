---
title: "古のCLIコマンドを時代に合わせてみた"
slug: replace-ancient-cli-command
date: 2018-09-03T01:11:14+09:00
thumbnailImage: https://images.pexels.com/photos/462334/pexels-photo-462334.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940
categories:
  - engineering
tags:
  - linux
  - cli
---

もうすぐ年号も変わりますので、太古から存在するCLIコマンドを現代に沿ったものへ移行してみました。

<!--more-->

<img src="https://images.pexels.com/photos/462334/pexels-photo-462334.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"/>

<!--toc-->


はじめに
--------

### 経緯

きっかけは以下の記事です。

{{<summary "https://remysharp.com/2018/08/23/cli-improved">}}

既にいくつかのコマンド(batやexa)は導入済みでしたが、他のものも全て試してみることにしました。


### 導入方針

以下のいずれか条件を満たす場合に導入します。

* どの環境でも動作する
* 環境によっては動作しないがCLI IFが古コマンドと酷似している

環境によってコマンドを使い分けたくないというのが理由です。  
全ての環境で動作すればその心配はありません。

また、特定の環境で動作しなくてもCLI IFが似ていれば切り替えコストが最小限で済みます。


### インストール方法

公式サイトに記載されているためそちらをご覧下さい。

私はAnsibleで環境構築しているため、参考までにPlaybookの内容を共有します。  

{{<alert "warning">}}
あくまで一例です。微妙な書き方していましたらコッソリご指摘いただければと思います。
{{</alert>}}


bat
---

catの強化版です。Local環境には導入済みです。  
rustのmusl版が配布されていますのでどの環境でも動作します。

{{<summary "https://github.com/sharkdp/bat">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[bat] Install"
  become: yes
  block:
    - unarchive:
        src: https://github.com/sharkdp/bat/releases/download/v0.4.1/bat-v0.4.1-x86_64-unknown-linux-gnu.tar.gz
        dest: /tmp
        remote_src: yes
        creates: /usr/bin/bat
    - shell: mv bat-v0.4.1-x86_64-unknown-linux-gnu/bat /usr/bin/bat
      args:
        chdir: /tmp
        creates: /usr/bin/bat
```
{{</file>}}



fzf
---

強力な曖昧検索。Local環境には導入済みです。  
goなので全ての環境で動作するはず...と思いましたがCentOS7で思うように動きませんでした..。

{{<summary "https://github.com/junegunn/fzf">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[fzf] Clone"
  git:
    repo: https://github.com/junegunn/fzf.git
    dest: ~/.fzf
    depth: 1

- name: "[fzf] Install"
  shell: ~/.fzf/install --all
```
{{</file>}}


ファイル検索のプレビューに今までは[pygments]を使っていましたが、速度に難があったためbatを使う設定にしました。

`config.fish`
```fish
set -x FZF_CTRL_T_OPTS "--preview 'bat --color \"always\" {}' --height 90%"
```

また、cd検索の`Alt+c`は押しにくいので`Alt+d`に変更しています。

{{<file "fish_user_key_bindings.fish">}}
```fish
function fish_user_key_bindings
    fzf_key_bindings
    ### Remove fzf settings... ###
    bind \ed fzf-cd-widget
end
```
{{</file>}}


glances
-------

topの強化版です。  
Python製のため、Pythonがインストールされていれば動くと思います。

{{<summary "https://nicolargo.github.io/glances/">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[Glances] Install"
  become: yes
  pip:
    name: glances
    extra_args: "glances[docker,ip,web]"
```
{{</file>}}

私のCentOS7環境にインストールするときは、rootにインストールされたrequestsのバージョンを上げられなかった小細工が必要でした。

```
$ pip install --user --upgrade requests
$ pip install --user 'glances[docker,ip,web]'
```


diff-so-fancy
-------------

git diffの強化版です。  
shellなのでどの環境でも動作します。

{{<summary "https://github.com/so-fancy/diff-so-fancy">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[diff-so-fancy] Install"
  become: yes
  get_url:
    url: https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
    dest: /usr/bin/diff-so-fancy
    mode: u+x,g+x,o+x
```
{{</file>}}

`.gitconfig`には以下の設定を追加しました。ほぼREADME通りです。

{{<file ".gitconfig (adding)">}}
```
[color]
  ui = true

[color "diff-highlight"]
  oldNormal = red bold
  oldHighlight = red bold 52
  newNormal = green bold
  newHighlight = green bold 22

[color "diff"]
  meta = yellow
  frag = magenta bold
  commit = yellow bold
  old = red bold
  new = green bold
  whitespace = red reverse

[pager]
  diff = diff-so-fancy | less --tabs=1,5 -RFX
  show = diff-so-fancy | less --tabs=1,5 -RFX
```
{{</file>}}

`git diff`の結果は以前とは比較にならないくらい綺麗になりました :smile:  
私は`tig`を使うことが多く、`tig`に対応してくれれば言うこと無しです。

{{<icon "github">}} [Supporting diff-so-fancy in diff view #542](https://github.com/jonas/tig/issues/542)


fd
--

findの強化版です。  
rustのmusl版が配布されていますのでどの環境でも動作します。

{{<summary "https://github.com/sharkdp/fd/">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[fd] Install"
  become: yes
  block:
    - unarchive:
        src: https://github.com/sharkdp/fd/releases/download/v{{ version }}/fd-v{{ version }}-x86_64-unknown-linux-musl.tar.gz
        dest: /tmp
        mode: u+x,g+x,o+x
        remote_src: yes
        creates: /usr/bin/fd
    - shell: mv fd-v{{ version }}-x86_64-unknown-linux-musl/fd /usr/bin/fd
      args:
        chdir: /tmp
        creates: /usr/bin/fd
```
{{</file>}}


ripgrep
-------

grepの強化版です。  
rustのmusl版が配布されていますのでどの環境でも動作します。

{{<summary "https://github.com/BurntSushi/ripgrep">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[ripgrep] Install"
  become: yes
  block:
    - unarchive:
        src: https://github.com/BurntSushi/ripgrep/releases/download/{{ version }}/ripgrep-{{ version }}-x86_64-unknown-linux-musl.tar.gz
        dest: /tmp
        remote_src: yes
        creates: /usr/bin/rg
    - shell: mv ripgrep-{{ version }}-x86_64-unknown-linux-musl/rg /usr/bin/rg
      args:
        chdir: /tmp
        creates: /usr/bin/rg
```
{{</file>}}

以前は[The Platinum Searcher]を使用していましたが以下の理由で乗り換えました。

* musl版のためLinuxであればどこでも動作する
* パフォーマンスがptより上


ncdu
----

duの強化版です。正式名称はNCurses Disk Usageです。  
i486用のmusl版のバイナリが提供されているため様々な環境で動くと思います。

{{<summary "https://dev.yorhel.nl/ncdu">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[ncdu] Install"
  become: yes
  unarchive:
    src: https://dev.yorhel.nl/download/ncdu-linux-i486-{{ version }}.tar.gz
    dest: /usr/bin
    mode: u+x,g+x,o+x
    remote_src: yes
    creates: /usr/bin/ncdu
```
{{</file>}}

参考にしたサイトに書かれているようオプション付きのエイリアスを定義しました。  
ncduコマンドの上書きはしたくないので`dur (du recursivelly)`にしました。

`config.fish`
```fish
alias dur "ncdu --color dark -rr -x --exclude .git --exclude node_modules"
```


exa
---

lsの強化版です。Local環境には導入済みです。  
Rustのmusl版が配布されていないため実行環境のlib配下環境に依存します。

{{<summary "https://the.exa.website/">}}

{{<file "Ansible Playbook">}}
```yaml
- name: "[exa] Install"
  become: yes
  block:
    - unarchive:
        src: https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
        mode: u+x,g+x,o+x
        dest: /usr/bin
        remote_src: yes
        creates: /usr/bin/exa
    - shell: mv exa-linux-x86_64 exa
      args:
        chdir: /usr/bin
        creates: /usr/bin/exa
```
{{</file>}}

`ls -l`のaliasとして`ll`を使っているため、それをexaで設定しなおしました。

`config.fish`
```fish
alias ll "exa -l --git"
alias llt "exa -l --git -snew"
```

`-t`オプションは別の意味を持つため、苦肉の策で`llt`というエイリアスを割り当てています。


総括
----

古いCLIコマンドを新しくて高機能なものにリプレイスしてみました。  
fzfとexaは動作しない環境もありますが、今後の対応に期待しています。

CLIではなくshellの話になりますが、fishとそのプラグインも世界が変わるレベルの効率化を実現できます。  
是非チャレンジしてみてください。

{{<summary "https://blog.mamansoft.net/2017/10/15/enjoy-fish/">}}


[pygments]: http://pygments.org/
[The Platinum Searcher]: https://github.com/monochromegane/the_platinum_searcher


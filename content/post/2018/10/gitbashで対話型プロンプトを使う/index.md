---
title: gitbashで対話型プロンプトを使う
slug: use-interactive-prompt-in-gitbash
date: 2018-10-08T01:32:50+09:00
thumbnailImage: https://cdn.svgporn.com/logos/git-icon.svg
categories:
  - engineering
tags:
  - git
  - bash
---

Pythonやfzfなど、対話型プロンプトをgitbashから使う方法を紹介します。

<!--more-->

{{<cimg "https://cdn.svgporn.com/logos/git-icon.svg">}}

<!--toc-->


はじめに
--------

### 経緯

最近私はWindowsで開発することが多く、コマンドプロンプトを使う場面によく遭遇します。  
しかしコマンドプロンプトはお世辞にも使いやすいとは言えません。

代替案として思いつくのは以下の3つです。

* WSL(bash)を使う
* PowerShellを使う
* gitbashを使う

はじめはWSLを使用していましたが、細かいところでWindows独自の使用が動かずフラストレーションが溜まりました。  
VagrantとVirtualboxでUbuntuを使い始めた理由の1つでもあります。

{{<summary "https://blog.mamansoft.net/2017/12/03/create-ubuntu-desktop/">}}

次にPowerShellにもチャレンジしましたが..なんというか本能的に受けつけませんでした。  
そこでgitbashを使うことにしました。


### 筆者の環境

* Windows10 Home 10.0.17134
* git version 2.17.1.windows.2
* [pureline-inspired](https://github.com/tadashi-aikawa/pureline-inspired)を使用


gitbashの問題点
--------------

gitbashはほとんどのbashコマンドを使用する事ができ、かつWindowsコマンドも実行可能です。  
Vimもプラグインインストール含めてLinuxと同様のレベルで動作します。素晴らしい！

しかし、対話型シェルが必要な場合は上手く動作しませんでした。  
たとえばPythonを実行するとご覧のように固まってしまいます..。

{{<himg "resources/20181008_1.gif">}}


解決方法
-------

winptyを使うと上手くいきます。

{{<summary "https://github.com/rprichard/winpty">}}

winptyはLinuxのpty-masterにあたるもののWindows版のようです。  
詳しいことは分かりませんが端末上に擬似的に端末IFを用意するイメージなのでしょうか..。

{{<refer "pty - 約束事その他の説明 - Linux コマンド集 一覧表" "http://kazmax.zpp.jp/cmd/p/pty.7.html">}}

以下のようになります。

{{<himg "resources/20181008_2.gif">}}

都度実行するのは面倒なので、`.bashrc`に以下のようなaliasを設定しておきます。

```bash
alias python='winpty python.exe'
```

せっかくなのでgitbashで使用している`.bashrc`の設定も晒しておきます。

{{<file ".bashrc">}}
```bash
# for symlink in windows
export MSYS=winsymlinks:nativestrict

alias python='winpty python.exe'
alias gowl='winpty gowl'
alias fzf='winpty fzf'

# ???
alias acmd='powershell -command "Start-Process -Verb runas cmd"'

function to_win_path() {
  path=${*}
  echo "$(readlink -f ${path} | sed -e 's@/@\\@g' -e 's@\\c\\@c:\\@g' | tr '\n' ' ')"
}

function tree() {
  dst="$(to_win_path ${1:-$(pwd)})"
  cmd //c "chcp 437 & tree ${dst}" //a //f
}

function te() {
  dst="$(to_win_path ${1:-$(pwd)})"
  /c/tablacus/TE64 ${dst}
}

source ~/go/src/github.com/tadashi-aikawa/pureline-inspired/pureline ~/go/src/github.com/tadashi-aikawa/pureline-inspired/.pureline.conf

# Copyright (c) 2009 rupa deadwyler. Licensed under the WTFPL license, Version 2

# maintains a jump-list of the directories you actually use
#
# INSTALL:
#     * put something like this in your .bashrc/.zshrc:
#         . /path/to/z.sh
#     * cd around for a while to build up the db
#     * PROFIT!!
#     * optionally:
#         set $_Z_CMD in .bashrc/.zshrc to change the command (default z).
#         set $_Z_DATA in .bashrc/.zshrc to change the datafile (default ~/.z).
#         set $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
#         set $_Z_NO_PROMPT_COMMAND if you're handling PROMPT_COMMAND yourself.
#         set $_Z_EXCLUDE_DIRS to an array of directories to exclude.
#         set $_Z_OWNER to your username if you want use z while sudo with $HOME kept
#
# USE:
#     * z foo     # cd to most frecent dir matching foo
#     * z foo bar # cd to most frecent dir matching foo and bar
#     * z -r foo  # cd to highest ranked dir matching foo
#     * z -t foo  # cd to most recently accessed dir matching foo
#     * z -l foo  # list matches instead of cd
#     * z -e foo  # echo the best match, don't cd
#     * z -c foo  # restrict matches to subdirs of $PWD

[ -d "${_Z_DATA:-$HOME/.z}" ] && {
    echo "ERROR: z.sh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
}

_z() {

    local datafile="${_Z_DATA:-$HOME/.z}"

    # if symlink, dereference
    [ -h "$datafile" ] && datafile=$(readlink "$datafile")

    # bail if we don't own ~/.z and $_Z_OWNER not set
    [ -z "$_Z_OWNER" -a -f "$datafile" -a ! -O "$datafile" ] && return

    _z_dirs () {
        local line
        while read line; do
            # only count directories
            [ -d "${line%%\|*}" ] && echo "$line"
        done < "$datafile"
        return 0
    }

    # add entries
    if [ "$1" = "--add" ]; then
        shift

        # $HOME isn't worth matching
        [ "$*" = "$HOME" ] && return

        # don't track excluded directory trees
        local exclude
        for exclude in "${_Z_EXCLUDE_DIRS[@]}"; do
            case "$*" in "$exclude*") return;; esac
        done

        # maintain the data file
        local tempfile="$datafile.$RANDOM"
        _z_dirs | awk -v path="$*" -v now="$(date +%s)" -F"|" '
            BEGIN {
                rank[path] = 1
                time[path] = now
            }
            $2 >= 1 {
                # drop ranks below 1
                if( $1 == path ) {
                    rank[$1] = $2 + 1
                    time[$1] = now
                } else {
                    rank[$1] = $2
                    time[$1] = $3
                }
                count += $2
            }
            END {
                if( count > 9000 ) {
                    # aging
                    for( x in rank ) print x "|" 0.99*rank[x] "|" time[x]
                } else for( x in rank ) print x "|" rank[x] "|" time[x]
            }
        ' 2>/dev/null >| "$tempfile"
        # do our best to avoid clobbering the datafile in a race condition.
        if [ $? -ne 0 -a -f "$datafile" ]; then
            env rm -f "$tempfile"
        else
            [ "$_Z_OWNER" ] && chown $_Z_OWNER:"$(id -ng $_Z_OWNER)" "$tempfile"
            env mv -f "$tempfile" "$datafile" || env rm -f "$tempfile"
        fi

    # tab completion
    elif [ "$1" = "--complete" -a -s "$datafile" ]; then
        _z_dirs | awk -v q="$2" -F"|" '
            BEGIN {
                q = substr(q, 3)
                if( q == tolower(q) ) imatch = 1
                gsub(/ /, ".*", q)
            }
            {
                if( imatch ) {
                    if( tolower($1) ~ q ) print $1
                } else if( $1 ~ q ) print $1
            }
        ' 2>/dev/null

    else
        # list/go
        local echo fnd last list opt typ
        while [ "$1" ]; do case "$1" in
            --) while [ "$1" ]; do shift; fnd="$fnd${fnd:+ }$1";done;;
            -*) opt=${1:1}; while [ "$opt" ]; do case ${opt:0:1} in
                    c) fnd="^$PWD $fnd";;
                    e) echo=1;;
                    h) echo "${_Z_CMD:-z} [-cehlrtx] args" >&2; return;;
                    l) list=1;;
                    r) typ="rank";;
                    t) typ="recent";;
                    x) sed -i -e "\:^${PWD}|.*:d" "$datafile";;
                esac; opt=${opt:1}; done;;
             *) fnd="$fnd${fnd:+ }$1";;
        esac; last=$1; [ "$#" -gt 0 ] && shift; done
        [ "$fnd" -a "$fnd" != "^$PWD " ] || list=1

        # if we hit enter on a completion just go there
        case "$last" in
            # completions will always start with /
            /*) [ -z "$list" -a -d "$last" ] && builtin cd "$last" && return;;
        esac

        # no file yet
        [ -f "$datafile" ] || return

        local cd
        cd="$( < <( _z_dirs ) awk -v t="$(date +%s)" -v list="$list" -v typ="$typ" -v q="$fnd" -F"|" '
            function frecent(rank, time) {
                # relate frequency and time
                dx = t - time
                if( dx < 3600 ) return rank * 4
                if( dx < 86400 ) return rank * 2
                if( dx < 604800 ) return rank / 2
                return rank / 4
            }
            function output(matches, best_match, common) {
                # list or return the desired directory
                if( list ) {
                    cmd = "sort -n >&2"
                    for( x in matches ) {
                        if( matches[x] ) {
                            printf "%-10s %s\n", matches[x], x | cmd
                        }
                    }
                    if( common ) {
                        printf "%-10s %s\n", "common:", common > "/dev/stderr"
                    }
                } else {
                    if( common ) best_match = common
                    print best_match
                }
            }
            function common(matches) {
                # find the common root of a list of matches, if it exists
                for( x in matches ) {
                    if( matches[x] && (!short || length(x) < length(short)) ) {
                        short = x
                    }
                }
                if( short == "/" ) return
                for( x in matches ) if( matches[x] && index(x, short) != 1 ) {
                    return
                }
                return short
            }
            BEGIN {
                gsub(" ", ".*", q)
                hi_rank = ihi_rank = -9999999999
            }
            {
                if( typ == "rank" ) {
                    rank = $2
                } else if( typ == "recent" ) {
                    rank = $3 - t
                } else rank = frecent($2, $3)
                if( $1 ~ q ) {
                    matches[$1] = rank
                } else if( tolower($1) ~ tolower(q) ) imatches[$1] = rank
                if( matches[$1] && matches[$1] > hi_rank ) {
                    best_match = $1
                    hi_rank = matches[$1]
                } else if( imatches[$1] && imatches[$1] > ihi_rank ) {
                    ibest_match = $1
                    ihi_rank = imatches[$1]
                }
            }
            END {
                # prefer case sensitive
                if( best_match ) {
                    output(matches, best_match, common(matches))
                } else if( ibest_match ) {
                    output(imatches, ibest_match, common(imatches))
                }
            }
        ')"

        [ $? -eq 0 ] && [ "$cd" ] && {
          if [ "$echo" ]; then echo "$cd"; else builtin cd "$cd"; fi
        }
    fi
}

alias ${_Z_CMD:-z}='_z 2>&1'

[ "$_Z_NO_RESOLVE_SYMLINKS" ] || _Z_RESOLVE_SYMLINKS="-P"

if type compctl >/dev/null 2>&1; then
    # zsh
    [ "$_Z_NO_PROMPT_COMMAND" ] || {
        # populate directory list, avoid clobbering any other precmds.
        if [ "$_Z_NO_RESOLVE_SYMLINKS" ]; then
            _z_precmd() {
                (_z --add "${PWD:a}" &)
            }
        else
            _z_precmd() {
                (_z --add "${PWD:A}" &)
            }
        fi
        [[ -n "${precmd_functions[(r)_z_precmd]}" ]] || {
            precmd_functions[$(($#precmd_functions+1))]=_z_precmd
        }
    }
    _z_zsh_tab_completion() {
        # tab completion
        local compl
        read -l compl
        reply=(${(f)"$(_z --complete "$compl")"})
    }
    compctl -U -K _z_zsh_tab_completion _z
elif type complete >/dev/null 2>&1; then
    # bash
    # tab completion
    complete -o filenames -C '_z --complete "$COMP_LINE"' ${_Z_CMD:-z}
    [ "$_Z_NO_PROMPT_COMMAND" ] || {
        # populate directory list. avoid clobbering other PROMPT_COMMANDs.
        grep "_z --add" <<< "$PROMPT_COMMAND" >/dev/null || {
            PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''(_z --add "$(command pwd '$_Z_RESOLVE_SYMLINKS' 2>/dev/null)" 2>/dev/null &);'
        }
    }
fi
```
{{</file>}}

gowlは最近私が開発しているリポジトリ管理ツールです。  
gitbashでは動作しませんでしたがwinptyのおかげで動くようになりました。

{{<summary "https://blog.mamansoft.net/2018/09/24/go-git-structual-cli-create/">}}

zは知らないと人生を損するツールなのでこちらも是非！

{{<summary "https://github.com/rupa/z">}}


総括
----

gitbashで対話型プロンプトが上手く動作しない問題の解決方法を紹介しました。

いつかWindowsとLinuxのターミナルが統一される...  
そんな時代を夢見てしばらくの間は頑張りたいと思います :relaxed:

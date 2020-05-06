---
title: Cmderでオシャレにcmd.exeを使う -前編-
slug: use-cmd-elegant-on-cmder-phase1
date: 2018-11-18T18:35:22+09:00
thumbnailImage: images/cover/2018-11-18.jpg
categories:
  - engineering
tags:
  - windows
  - terminal
  - cmd
  - cmder
  - powerline
---

Cmderを使ってWindowsの`cmd.exe`を快適にカッコよく使えるようにしてみました。

<!--more-->

{{<cimg "2018-11-18.jpg">}}

この写真で実行しているのは`cmd.exe`です。  
`cmd.exe`でもCmder上で実行すると、ここまでオシャレになります。

<!--toc-->


はじめに
--------

### 経緯

今仕事ではWindows中心の開発をしています。  
しかしWindowsはターミナルがイケていません... コマンドプロンプトを開くのは辛い。

Ubuntuではターミナル中心の快適な生活をしていました。  
Windowsでも同様のことがしたい... それを目標に色々試しもしていました。


### 過去にチャレンジしたもの

『無理して`cmd.exe`を使う必要はあるのか?』と思われるかもしれません。  
`cmd.exe`を脱却するために過去試したものを紹介します。

簡素な説明ですが、一度でも利用したことのある方なら伝わると思っています。

#### WSL

最近有名な[Windows Subsystem for Linux]です。

Linux環境が提供されているのはありがたいことですが、Windows上のシステムと連携すると複雑になります。  
今どちらのOSに対して作業をしているのか..を意識する必要があるため好きになれませんでした。

[Windows Subsystem for Linux]: https://ja.wikipedia.org/wiki/Windows_Subsystem_for_Linux

#### PowerShell

Windows公式で`cmd.exe`とも互換性ある...らしいですが色々思うように動かなかったのでやめました。  
そこまで色々試していないので、単に私の勉強不足かもしれませんが..。

#### git bash

Gitをインストールすると標準で搭載されているアレです。  
以前にgit bashを快適に使うための記事を書きました。

{{<summary "https://blog.mamansoft.net/2018/06/04/make-git-bash-look-good/">}}

WSLよりはWindowsシステム寄りではありますが、動いているのはbashであるのでどちらつかずな部分があります。  
例えば`cd $(fzf)`みたいなコマンドを実行できません。


### Cmderとの出会い

Cmderについては次章で説明します。  
試してみようと思ったのは以下の記事を目にしたからです。

{{<qiita "Windows + Cmderでカッコよくて見やすいターミナル、コンソール環境を作る(めんどくさがり屋な人向け)" "https://qiita.com/thrzn41/items/7dd3b1ec5e50bae9f03b">}}

決めては以下の2点です。

* 記事の文書に共感を覚えた (勝手ながらシンパシーを感じました :smile:)
* 更新日時が最近

特に以下の点が心に刺さりました。

* Powerlineも使える環境にする
* カッコよくて見やすいターミナル、コンソールを目指す


### 前提条件

以下を知っている前提で進めます。

* [Powerline]
* [Chocolatey]
* [Scoop]

[Powerline]: https://github.com/powerline/powerline
[Chocolatey]: https://chocolatey.org/
[Scoop]: https://scoop.sh/


Cmderのインストール
-------------------

公式サイトは以下です。

{{<summary "http://cmder.net/">}}

[Chocolatey]でインストールする場合は、`C:\tools\Cmder`にインストールされます。

```
$ choco install cmder
```


Powerlineの導入
---------------

デフォルトもそこそこオシャレですが、情報を増やしたいのでPowerlineを導入します。

{{<himg "resources/20181118_2.png">}}


### Powerline対応フォントのインストール

Powerline対応フォントをインストールします。  
私は[Source Code Pro for Powerline]を使用しています。

[Source Code Pro for Powerline]: https://github.com/powerline/fonts/tree/master/SourceCodePro

{{<warn "フォントのインストール方法が分からない...">}}
otfファイルをダウンロードして以下手順を参考にしてください。  
[フォントのインストール（Windows 10/8/7/Vista）](https://helpx.adobe.com/jp/x-productkb/global/233291.html)
{{</warn>}}


### Cmder-powerline-promptの導入

CmderでPowerlineを有効にできるプロジェクトをCloneしてきます。

{{<summary "https://github.com/AmrEldib/cmder-powerline-prompt">}}

プロジェクトディレクトリ内のLuaファイルをCmderのconfigディレクトリ配下に移動します。

```
$ cp *.lua %cmder_root%\config\
```

### 設定をPowerline対応フォントに変更

フォントをPowerline対応フォントにします。

{{<himg "resources/20181118_3.png">}}

Boldは個人的な好みです。  
Monospaceは日本語によるレイアウト崩れを防ぐために外しています。


コマンドの強化
--------------

`cmd.exe`やCmderに内包される`git-for-windows`のコマンドでは不十分のため色々インストールします。  
[Scoop]で以下をインストールしました。

* [sudo](https://github.com/lukesampson/psutils)
* [bat](https://github.com/sharkdp/bat)
* [fd](https://github.com/sharkdp/fd)
* [7zip](https://www.7-zip.org)
* [fzf](https://github.com/junegunn/fzf)
* [less](http://www.greenwoodsoftware.com/less/)
* [ripgrep](https://github.com/BurntSushi/ripgrep)
* [make](https://www.gnu.org/software/make/)

{{<file "インストールコマンド">}}
```
$ scoop install ^
    sudo ^
    bat ^
    fd ^
    7zip ^
    fzf ^
    less ^
    ripgrep ^
    make
```
{{</file>}}

{{<info "インストールしたけど消してしまったもの">}}
以下のツールは見送りました。  
Windows上ではexeファイル実行時のラグが大きく、我慢できなかったからです。

* diff-so-fancy

{{</info>}}


Cmderの設定変更
---------------

代表的な設定をいくつか晒します。

### 背景の設定

記事の冒頭にあるスクリーンショットで移っていたフクロウの画像を背景に設定しています。

{{<himg "resources/20181118_4.png">}}

フクロウの画像は[WallpaperCaveのもの](https://wallpapercave.com/wp/R5aosPq.jpg)を使わせて頂きました。


### cmd.exe直後のディレクトリをホームディレクトリに

起動直後は`%USERPROFILE%`にいるのが便利だと思うので変更します。

{{<himg "resources/20181118_5.png">}}

赤枠下の部分にある`Startup dir...`ボタンを押してホームディレクトリを選ぶと、自動で入力されます。

なお、`Cmder`では`%home%`もホームディレクトリとして認識されます。


プロンプトの改善
----------------

デフォルトのMonokaiテーマ + Powerlineだけでもオシャレですが更に格好良くしましょう。

{{<warn "本節で紹介されているソースコードについて">}}
**ここから紹介のあるコードおよびdiffは、2018/11/18時点のものです。**  
**Cmder-powerline-promptプロジェクトが更新された場合、正常に動作することを保証しません。**
{{</warn>}}


### プロンプトのλを$にする

λだとLinuxユーザには馴染みが無く、半角文字でないことが仇となることがあるため変更します。

`%cmder_root%\config\powerline_core.lua`を以下のように変更しましょう。

```diff
  if not plc_prompt_lambSymbol then
-     plc_prompt_lambSymbol = "λ"
+     plc_prompt_lambSymbol = "$"
  end
```

本記事執筆時は115行目でした。

{{<why "\vendor\clink.lua は変更しなくてもいいの...?">}}
変更の必要はありません。  
Google検索で調べると`clink.lua`を変更せよという記事が沢山出てきますが、それらはPowerlineを導入していない場合です。

`Cmder-powerline-prompt`を導入している場合、プロンプトの設定は`powerline_core.lua`で上書きされるため`clink.lua`を変更しても何も変わりません。
{{</why>}}


### コマンドをプロンプト1行目に入力する

デフォルトだとコマンド入力はプロンプトに情報が表示された次の行(2行目)になります。  
これをLinuxやコマンドプロンプトのように1行目で入力できるようにします。

`%cmder_root%\config\powerline_core.lua`を以下のように変更しましょう。

```diff
  -- Symbols
- newLineSymbol = "\n"
+ newLineSymbol = ""
```

本記事執筆時は100行目付近でした。

`newLineSymbol`を空にするのは違和感ありますが、挙動は意図したとおりになったため目を瞑ります。


### Gitリポジトリの情報を更に詳しく表示する

{{<warn "2018/11/27: より新しく優れた情報が展開されています">}}
[Cmderでオシャレにcmd.exeを使う -後編-](/2018/11/26/use-cmd-elegant-on-cmder-phase2/#powerline%E3%81%AE%E6%9B%B4%E3%81%AA%E3%82%8B%E5%BC%B7%E5%8C%96)をご覧下さい
{{</warn>}}

デフォルトだとブランチ名、変更や競合の有無が表示されます。  
追加で以下の情報も表示できるようにしてみました。

* 追加/削除/変更の件数
* リモートリポジトリとの差 (ahead/behind)

改修後のイメージです。

{{<himg "resources/20181118_6.png">}}

`%cmder_root%\config\powerline_git.lua`にいくつか改修を加えます。

#### 色設定の追加/変更

aheadとbehindを追加して、全体の色設定を微調整します。

{{<file "powerline_git.luaのsegmentColors">}}
```lua
local segmentColors = {
    clean = {
        fill = colorGreen,
        text = colorWhite
    },
    dirty = {
        fill = colorRed,
        text = colorWhite
    },
    conflict = {
        fill = colorYellow,
        text = colorWhite
    },
    ahead = {
        fill = colorBlue,
        text = colorWhite
    },
    behind = {
        fill = colorMagenta,
        text = colorWhite
    }
}
```
{{</file>}}

#### ステータス取得関数の変更

追加、編集、削除、管理対象外のファイル数を取得できるように変更します。

{{<file "powerline_git.luaのget_git_status()">}}
```lua
function get_git_status()
    local file = io.popen("git --no-optional-locks status --porcelain | awk '{print $1\"\\n\"}' | sort | uniq -c 2>nul")
    local add, modify, delete, unknown = 0, 0, 0, 0
    for line in file:lines() do
        num, kind = string.match(line, ".+(%d+) (.+)")
        if kind == "A" then
          add = num
        elseif kind == "M" then
          modify = num
        elseif kind == "D" then
          delete = num
        elseif kind == "??" then
          unknown = num
        end
    end
    file:close()

    return add, modify, delete, unknown
end
```
{{</file>}}

{{<info "Stagingエリアに追加済かの判定について">}}
今は実装していませんが、必要であれば近い内に対応を検討しています。
{{</info>}}


#### リモートリポジトリとの差分を取得する関数の作成

新しく`git_ahead_behind_module`関数を作成します。

{{<file "powerline_git.luaのgit_ahead_behind_module()">}}
```lua
function git_ahead_behind_module()
    local file = io.popen("git rev-list --count --left-right @{upstream}...HEAD 2>nul")

    for line in file:lines() do
        ahead, behind = string.match(line, "(%d+).+(%d+)")
    end
    file:close()

    return ahead, behind
end
```
{{</file>}}


#### 各種情報をプロンプトに表示する

上記を利用して`init`関数を編集します。

{{<file "powerline_git.luaのinit()">}}
```lua
local function init()
    segment.isNeeded = get_git_dir()
    if segment.isNeeded then
        -- if we're inside of git repo then try to detect current branch
        local branch = get_git_branch(git_dir)
        if branch then
            -- Has branch => therefore it is a git folder, now figure out status
            -- local gitStatus = get_git_status()

            local add, modify, delete, unknown = get_git_status()
            local ahead, behind = git_ahead_behind_module()
            local gitConflict = get_git_conflict()
            segment.text = " "..plc_git_branchSymbol.." "..branch.." "

            segment.textColor = segmentColors.clean.text
            segment.fillColor = segmentColors.clean.fill

            if gitConflict then
                segment.textColor = segmentColors.conflict.text
                segment.fillColor = segmentColors.conflict.fill
                if plc_git_conflictSymbol then
                    segment.text = segment.text..plc_git_conflictSymbol
                end 
                return
            end 

            if add ~= 0 then
                segment.textColor = segmentColors.dirty.text
                segment.fillColor = segmentColors.dirty.fill
                segment.text = segment.text.."+"..add.." "
            end
            if modify ~= 0 then
                segment.textColor = segmentColors.dirty.text
                segment.fillColor = segmentColors.dirty.fill
                segment.text = segment.text.."*"..modify.." "
            end
            if delete ~= 0 then
                segment.textColor = segmentColors.dirty.text
                segment.fillColor = segmentColors.dirty.fill
                segment.text = segment.text.."-"..delete.." "
            end
            if unknown ~= 0 then
                segment.textColor = segmentColors.dirty.text
                segment.fillColor = segmentColors.dirty.fill
                segment.text = segment.text.."?"..unknown.." "
            end
            if ahead ~= "0" then
                segment.textColor = segmentColors.ahead.text
                segment.fillColor = segmentColors.ahead.fill
                segment.text = segment.text.."↓ "..ahead.." "
            end
            if behind ~= "0" then
                segment.textColor = segmentColors.behind.text
                segment.fillColor = segmentColors.behind.fill
                segment.text = segment.text.."↑ "..behind.." "
            end

        end
    end
end
```
{{</file>}}

コードが醜いですって?  Lua書いたのは初めてなので勘弁してください :bow:


### リポジトリディレクトリでのもっさり感を軽減する

普通のディレクトリではサクサクですが、Gitリポジトリ内ではプロンプトの表示がもっさりします。  
調べたところ、私には不要なコマンドが毎回実行されていました。

`%cmder_root%\vendor\clink.lua`の一部をコメントアウトします。

```diff
  clink.prompt.register_filter(set_prompt_filter, 1)
- clink.prompt.register_filter(hg_prompt_filter, 50)
- clink.prompt.register_filter(git_prompt_filter, 50)
- clink.prompt.register_filter(svn_prompt_filter, 50)
+ -- clink.prompt.register_filter(hg_prompt_filter, 50)
+ -- clink.prompt.register_filter(git_prompt_filter, 50)
+ -- clink.prompt.register_filter(svn_prompt_filter, 50)
  clink.prompt.register_filter(percent_prompt_filter, 51)
```

hgはMercurial、svnはSVNですがどちらも使用していません。

以下のIssueが参考になりました。

{{<github "Lag returning to prompt (especially) in git repo #447" "https://github.com/cmderdev/cmder/issues/447#issuecomment-379992066">}}


マシン間の同期
--------------

Cmderはポータビリティがあるため、以下のディレクトリをGitやDropboxなどで同期しておけばOKです。

* `Cmder/config`
* `Cmder/bin`

{{<warn "clink.luaについて">}}
`clink.lua`は`vendor`配下にあるため、上記2ディレクトリを設定しても同期されません。  
そもそも`vendor`配下を同期すべきかという話にもなりますので、同期せずに初回だけ対応としています。

コメントアウトだけですので。
{{</warn>}}


トラブルシューティング
----------------------

ハマった事例をいくつか紹介します。


### aliasしたコマンドに引数が渡らない場合

末尾に`$*`が付いていることを確認しましょう。  
Linuxとは違い、そのままでは引数は渡されません。

* :ng: `alias ll=ls -l`
* :ok: `alias ll=ls -l $*`


### aliasしたコマンドがPipeの先で上手く動かない

事象は把握しましたが関係する情報は見つけられていません。

* `alias sort="C:\tools\cmder\vendor\git-for-windows\usr\bin\sort.exe"`とした場合
  * :ng: `ll | sort`
  * :ok: `ll | C:\tools\cmder\vendor\git-for-windows\usr\bin\sort.exe`


### historyの結果をgrepできない

デフォルトで設定されているaliasが引数(Pipe)に対応していません。  
以下のようにaliasを設定しましょう。

* :ng: `history=cat "%CMDER_ROOT%\config\.history"`
* :ok: `history=cat "%CMDER_ROOT%\config\.history" $*`


### Vimに色が付かない

`set termguicolors` の設定を削除したら解消しました。  
正確な原因は分かっていません..。


### tigの表示がおかしい

マルチバイト文字の無いリポジトリなら `set LANG=ISO-8859-1` した後にtig実行で解決します。  
しかし、マルチバイト文字があると文字化けします..。

tig2.4.1で改修されていそうですが、git bashに同梱されているtigが2.4.0のため確認できていません。

{{<github "line-graphics don't behave too nice #527" "https://github.com/jonas/tig/issues/527">}}


### bat出力結果の色がおかしい

git bashのless(MSYSのless)が使用されている場合、色付けに対応していないのが原因です。  
[Scoop]でlessをインストールすると解消されます。

{{<github "Incorrect colours on Windows #260" "https://github.com/sharkdp/bat/issues/260">}}


### 一部のKey Bindingが変更できない

これも情報源を見つけることができていません。  
私はAutoHotKeyを使用しているので、変更できない設定はそちらで対応してしまいました。


### findやsortのオプションが指定できない

findやsortは`c:\Windows\System32\`配下のコマンドが優先されます。  
それらはLinuxのfindやsortとオプションが異なるため、指定できないように見えます。

aliasの設定もできなかったので、今のところスマートな解決方法は見つかっていません。


総括
----

Cmderを使ってWindowsの`cmd.exe`をオシャレに使う方法を紹介しました。

タイトルからも分かるように今回前編です。  
後ほど執筆予定の後編では、自作コマンドを駆使してイケてるLinux環境に負けないカスタマイズの仕方を紹介します。

{{<update "2018/11/17: 後編を追加しました">}}
[Cmderでオシャレにcmd.exeを使う -後編-](/2018/11/26/use-cmd-elegant-on-cmder-phase2/)を公開しました.
{{</update>}}

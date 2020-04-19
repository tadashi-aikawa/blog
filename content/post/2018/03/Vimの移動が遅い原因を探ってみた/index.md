---
title: "Vimの移動が遅い原因を探ってみた"
slug: investigate-why-vim-moves-slow
date: 2018-03-31T19:33:00+09:00
thumbnailImage: images/cover/2018-03-31.jpg
categories:
  - engineering
tags:
  - vim
---

年始からVimに入信して3ヶ月が経ちました。  
インストールしたプラグインの数も増えてきましたが、Vimの動きが遅くなってきたので原因を調べてみました。

<!--more-->

{{<cimg "2018-03-31.jpg">}}

<!--toc-->


経緯
----

久しぶりに素のVimを立ち上げて編集したとき、カーソル移動やスクロールのあまりの速さに愕然としました。  
Vimmerを目指した理由の1つに『Vimの軽快さ』がありましたので、そのままにはしておけません。

以下のページを参考にして、何がボトルネックになっているかを調べることにしました。

{{<summary "https://qiita.com/k2nakamura/items/013cf2c2b42d927203c6">}}

結論から先に言うと、powerlineが遅さの原因になっていたようです。


測定方法
--------

以下の手順でプロファイリング結果を取得します。

```
"ログ出力先とプロファイリング対象を決める
:profile start profile.log
:profile func *
:profile file *

･･･測定したい動作を実施する･･･

"測定を終了する
:profile pause
:noautocmd qall!
```

`profile.log`を確認して遅い箇所を特定します。


測定結果と対策
--------------

### 1回目

```
FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
  261   0.295624   0.028529  tagbar#currenttag()
  262   0.253999   0.230772  <SNR>135_GetNearbyTag()
    1   0.127169   0.000282  <SNR>44_CursorHoldUpdate()
   37   0.121422   0.094126  167()


FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
  262   0.253999   0.230772  <SNR>135_GetNearbyTag()
   37   0.121422   0.094126  167()
  352              0.047612  <SNR>87_Highlight_Matching_Pair()
  261   0.295624   0.028529  tagbar#currenttag()
  353   0.048011   0.028194  ale#cursor#EchoCursorWarningWithDelay()
```

`GetNearbyTag()`が遅いので、tagbarを削除しました。


### 2回目

```
FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
  260   0.035391   0.021073  ale#cursor#EchoCursorWarningWithDelay()
  260   0.031245             <SNR>84_Highlight_Matching_Pair()
  274   0.010907             ale#Var()
  260   0.003823             <SNR>116_StopCursorTimer()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
  260              0.031245  <SNR>84_Highlight_Matching_Pair()
  260   0.035391   0.021073  ale#cursor#EchoCursorWarningWithDelay()
  274              0.010907  ale#Var()
  260              0.003823  <SNR>116_StopCursorTimer()
```

ALEの処理に時間がかかっていたのでリアルタイムで動作しないようにしました。  
保存の後に確認できれば十分です。

`84_Highlight_Matching_Pair()`は時間がかかっていますがONのままにします。  
対応するカッコをハイライトする機能で、OFFにすると支障をきたすためです。


### 3回目

```
FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
  390   0.045282   0.026225  ale#cursor#EchoCursorWarningWithDelay()
  390   0.042464             <SNR>86_Highlight_Matching_Pair()
  398   0.013941             ale#Var()
  390   0.005362             <SNR>117_StopCursorTimer()
  390   0.004008   0.002293  <SNR>131_on_cursor_moved()


FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
  390              0.042464  <SNR>86_Highlight_Matching_Pair()
  390   0.045282   0.026225  ale#cursor#EchoCursorWarningWithDelay()
  398              0.013941  ale#Var()
  390              0.005362  <SNR>117_StopCursorTimer()
  390   0.004008   0.002293  <SNR>131_on_cursor_moved()
```

結果が変わりませんでした。。  
ALEをリアルタイム実行しても移動に害はなさそうです。

試しにALEをOFFにしてみます。


### 4回目

```
FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
  256   0.033793             <SNR>80_Highlight_Matching_Pair()
  256   0.003458   0.001725  <SNR>114_on_cursor_moved()
  256   0.001733             lsp#ui#vim#diagnostics#echo#cursor_moved()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
  256              0.033793  <SNR>80_Highlight_Matching_Pair()
  256              0.001733  lsp#ui#vim#diagnostics#echo#cursor_moved()
  256   0.003458   0.001725  <SNR>114_on_cursor_moved()
```

Highlight_Matching_Pair以外はボトルネックが無くなりました。  
ただ体感速度はほとんど変わらなかったです。

次は`NERDTREE`をOFFにしてみます。


### 5回目

```
FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
  220   0.032893             <SNR>59_Highlight_Matching_Pair()
  220   0.002803   0.001520  <SNR>92_on_cursor_moved()
  220   0.001283             lsp#ui#vim#diagnostics#echo#cursor_moved()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
  220              0.032893  <SNR>59_Highlight_Matching_Pair()
  220   0.002803   0.001520  <SNR>92_on_cursor_moved()
  220              0.001283  lsp#ui#vim#diagnostics#echo#cursor_moved()
```

`NERDTREE`を無効にしたところ体感速度は上がりました。  
Highlight_Matching_Pairは未だに残っています。


### 6回目

```
FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
  295   0.007721   0.003956  <SNR>114_on_cursor_moved()
  295   0.003765             lsp#ui#vim#diagnostics#echo#cursor_moved()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
  295   0.007721   0.003956  <SNR>114_on_cursor_moved()
  295              0.003765  lsp#ui#vim#diagnostics#echo#cursor_moved()
```

`let loaded_matchparen = 1`でカッコのハイライト表示をやめました。  
プロファイル結果ではボトルネックが解消しました。


真犯人の存在!?
--------------

色々OFFにしてプロファイル結果は改善されましたが、マウント先のファイル(Windows)を開くと動作がもっさりしたままでした。  
マウント先ファイルでプロファイルした結果も問題ありませんでした。

色々弄ってみたところ他にも色々と発見がありました。  
移動によって描画処理が走る場合は体感速度にも違いがあるようです。

* 編集モードはもっさりだが、挿入モードの時は高速
* カーソル形状を変えても変わらない
* `osyo-manga/vim-brightest`をOFFにするとLinux版では少し早くなる 
* `set cursorline`をONにしないと少し早くなる

更に色々試してみたところ最大の原因が分かりました。


真犯人はPowerlineだ!!
---------------------

どうやらPowerlineが一番の原因だったようです。  
以下のように`.vimrc`で設定していたものを削除したら、速度は大幅に改善されました。

```
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
```

Powerlineなしではステータスラインが見にくいので以下サイトを参考にして自作してみました。

{{<summary "https://www.reddit.com/r/vim/comments/1dyun6/why_does_powerline_make_vim_significantly_slower/">}}


Powerlineの代わりに自作したもの
-------------------------------

作成したステータスラインは以下のような感じです。  
Powerlineより格好悪いですが実用で困ることはありません。何より軽いです。

{{<himg "resources/20180331_1.png">}}

`.vimrc`には以下を記載しました。

```
" Status bar
" ---------------------------------------------------
let g:last_mode = ""

function! Mode()
  let l:mode = mode()

  if l:mode !=# g:last_mode
    let g:last_mode = l:mode

    hi User2 guifg=#005f00 guibg=#dfff00 gui=BOLD ctermfg=22 ctermbg=190 cterm=BOLD
    hi User3 guifg=#FFFFFF guibg=#414243 ctermfg=255 ctermbg=241
    hi User4 guifg=#414234 guibg=#2B2B2B ctermfg=241 ctermbg=234
    hi User5 guifg=#4e4e4e guibg=#FFFFFF gui=bold ctermfg=239 ctermbg=255 cterm=bold
    hi User6 guifg=#FFFFFF guibg=#8a8a8a ctermfg=255 ctermbg=245
    hi User7 guifg=#ffff00 guibg=#8a8a8a gui=bold ctermfg=226 ctermbg=245 cterm=bold
    hi User8 guifg=#8a8a8a guibg=#414243 ctermfg=245 ctermbg=241

    if l:mode ==# 'n'
      hi User3 guifg=#dfff00 ctermfg=190
    elseif l:mode ==# "i"
      hi User2 guifg=#005fff guibg=#FFFFFF ctermfg=27 ctermbg=255
      hi User3 guifg=#FFFFFF ctermfg=255
    elseif l:mode ==# "R"
      hi User2 guifg=#FFFFFF guibg=#df0000 ctermfg=255 ctermbg=160
      hi User3 guifg=#df0000 ctermfg=160
    elseif l:mode ==? "v" || l:mode ==# ""
      hi User2 guifg=#4e4e4e guibg=#ffaf00 ctermfg=239 ctermbg=214
      hi User3 guifg=#ffaf00 ctermfg=214
    endif
  endif 

  if l:mode ==# "n"
    return "  NORMAL "
  elseif l:mode ==# "i"
    return "  INSERT "
  elseif l:mode ==# "R"
    return "  REPLACE "
  elseif l:mode ==# "v"
    return "  VISUAL "
  elseif l:mode ==# "V"
    return "  V·LINE "
  elseif l:mode ==# ""
    return "  V·BLOCK "
  else
    return l:mode
  endif
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'OK' : printf(
    \   '☠ %d ⚠ %d ⬥ ok',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%2*%{Mode()}%3*⮀%1*
set statusline+=%#StatusLine#
set statusline+=%{strlen(fugitive#statusline())>0?'\ ⭠\ ':''}
set statusline+=%{matchstr(fugitive#statusline(),'(\\zs.*\\ze)')}
set statusline+=%{strlen(fugitive#statusline())>0?'\ \ ⮁\ ':'\ '}
set statusline+=%f\ %{&ro?'⭤':''}%{&mod?'+':''}%<
set statusline+=%3*\ 
set statusline+=%{LinterStatus()}
set statusline+=\ %4*⮀
set statusline+=%#warningmsg#
set statusline+=%=
set statusline+=%4*⮂
set statusline+=%#StatusLine#
set statusline+=\ %{strlen(&fileformat)>0?&fileformat.'\ ⮃\ ':''}
set statusline+=%{strlen(&fileencoding)>0?&fileencoding.'\ ⮃\ ':''}
set statusline+=%{strlen(&filetype)>0?&filetype:''}
set statusline+=\ %8*⮂
set statusline+=%7*\ %p%%\ 
set statusline+=%6*⮂%5*⭡\ \ %l:%c\ 
```


総括
----

Vimの動きが遅くなってきたのでプロファイリングを行い原因を調べてみました。  
プロファイル結果に傾向は現れませんでしたが、一番のネックはPowerlineだったようです。

色々ググっても対策が見つからなかった場合、Powerlineをやめてステータスバーの自作を検討してみてください。

また以下の設定変更も体感速度に効果がありました。

* `NERDTREE`を必要ないときは非表示にする(プラグインはON)
* `osyo-manga/vim-brightest`を使わない
* `set cursorline`をONにしない


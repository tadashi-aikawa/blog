---
draft: true
---

tmuxのインストール
------------------

環境構築にAnsibleを使っているため、Playbookを作成しました。

```yml
```

tmuxの設定
----------


トラブルシューティング
----------------------

### tmuxを起動すると色がおかしい

環境変数 `TERM` に `xterm-256color` を設定すれば直ります。

### ネットのコマンドがうまくいかん

どっかで書き方が変わったpoi..

TODO: 調査

旧: bind-key -t vi-copy Escape clear-selection
新: bind-key -T copy-mode-vi Escape send -X clear-selection

### emuxのデフォルトシェルをfishに変更したい

`tmux.conf`で設定しましょう。

```
set-option -g default-shell /usr/bin/fish
```

`wsl-terminal.conf`起動時にtmuxを起動するには以下の様にします。  
ただし、tmuxのセッションが共有されてしまうためオススメしません。

* `shell=bash`
* `use_tmux=1`
* `attach_tmux_locally=0`


### 新しいウィンドウやペインが毎回ホームディレクトリで開かれてしまう

https://qiita.com/bomcat/items/73de1105f7ffa0f93863

### 起動後のディレクトリがホームディレクトリにならない

`.config/fish/config.fish`の最後に`cd ~`を追加することで解決しました。

### ステータスバーが更新されない



### Powerline

#### .tmux.confに

run-shell "powerline-daemon -q"
source "/usr/local/lib/python2.7/dist-packages/powerline/bindings/tmux/powerline.conf"

#### .vimrcに



参考

https://unskilled.site/powerline%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%99%E3%82%8B/

vim
https://qiita.com/qurage/items/4edda8559cc4c98758ee
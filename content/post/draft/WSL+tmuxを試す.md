
tmuxのインストール
------------------

環境構築にAnsibleを使っているため、Playbookを作成しました。

```yml
```


トラブルシューティング
----------------------

### tmuxを起動すると色がおかしい

環境変数 `TERM` に `xterm-256color` を設定すれば直ります。

### コピーモードで行の先頭/末尾に移動したい


### ネットのコマンドがうまくいかん

どっかで書き方が変わったpoi..

TODO: 調査

旧: bind-key -t vi-copy Escape clear-selection
新: bind-key -T copy-mode-vi Escape send -X clear-selection

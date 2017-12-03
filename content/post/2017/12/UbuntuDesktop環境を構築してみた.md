---
title: "Ubuntu Desktop環境を構築してみた"
date: 2017-12-03
thumbnailImage: https://s3-us-west-2.amazonaws.com/svgporn.com/logos/ubuntu.svg
categories:
  - engineering
tags:
  - ubuntu
  - docker
  - vagrant
  - virtualbox
  - ansible
  - vscode
  - autohotkey
  - powerline
---

Windows環境での開発が苦痛に感じてきたので、仮想マシンのUbuntuで開発できないかを試してみました。  

<!--more-->

<!--toc-->


はじめに
--------

### ホストマシンの環境

* Windows10 Home 10.0.16299
* Vagrant 1.9.5
* VirtualBox 5.1.30 r118389

### ゲストマシン(Ubuntu)の環境

* Ubuntu16.04
* 日本語対応版


Ubuntu Desktopの作成
--------------------

VagrantとVirtualBoxを使ってUbuntu Desktopを作成します。

### Vagrantfile

必須の箇所は必ず記載が必要です。  
任意設定は必要であれば記載してください。

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # ************************************
  # 必須！
  # ************************************
  config.vm.box = "bento/ubuntu-16.04"

  # ************************************
  # 任意設定
  # ************************************
  # port forward
  # ホストマシンからアクセスしたいポート番号を +10000 でフォワードする
  # ex. Windowsの10080 => Ubuntuの80
  ([80, 1313, 3000, 6006, 8000] + (8080..8090).to_a).each do |port|
    config.vm.network "forwarded_port", guest: port, host: port + 10000, host_ip: "127.0.0.1"
  end
  config.vm.network "private_network", ip: "192.168.33.10"

  # ************************************
  # 必須！
  # ************************************
  # VirtualBox VM options
  config.vm.provider "virtualbox" do |vb|
    # 好きな名前とスペックを設定
    vb.name = "ubuntu-gui"
    vb.cpus = "2"
    vb.memory = "4096"
    # GUI settings
    vb.gui = true
    vb.customize [
      "modifyvm", :id,
      # ビデオメモリの割り当て
      "--vram", "256",
      # 3DアクセラレータをONにしないと画面がカクカクになる
      "--accelerate3d", "on",
      "--hwvirtex", "on",
      "--nestedpaging", "on",
      "--largepages", "on",
      "--ioapic", "on",
      "--pae", "on",
      "--paravirtprovider", "kvm",
      # クリップボードやドラッグ&ドロップをWindowsと共有
      "--clipboard", "bidirectional",
      "--draganddrop", "bidirectional",
      # 仮想マシンのモニタ数。2にしたら描画がもっさりしたので泣く泣く1に....
      "--monitorcount", "1",
    ]
  end

  # ************************************
  # 任意設定
  # ************************************
  # sync
  # Windowsとマウントしたい場合は設定する
  config.vm.synced_folder "../../", "/vagrant"
  config.vm.synced_folder "../../../../", "/whome"

  # ************************************
  # 必須！
  # ************************************
  # Provision OS
  # Desktop環境 + 日本語環境 + timezoneとlocaleの設定
  # OSをバージョンアップするまでは二度と実行しない
  config.vm.provision "shell", inline: <<-SHELL
    # Install ubuntu-desktop
    sudo apt -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo apt-get -y install ubuntu-desktop

    # Install for japanese
    wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | sudo apt-key add -
    wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | sudo apt-key add -
    sudo wget https://www.ubuntulinux.jp/sources.list.d/xenial.list -O /etc/apt/sources.list.d/ubuntu-ja.list
    sudo apt -y update
    sudo apt-get -y upgrade
    sudo apt-get -y install ubuntu-defaults-ja

    # Set timezone and locale
    sudo timedatectl set-timezone Asia/Tokyo
    sudo localectl set-locale LANG=ja_JP.utf8
  SHELL

  # ************************************
  # 任意設定
  # ************************************
  # Install docker
  # DockerをVagrantのprovision機能でインストールする
  config.vm.provision "docker"

  # ************************************
  # 任意設定
  # ************************************
  # Install ansible and provisioning
  # AnsibleをVagrantのprovision機能でインストールする
  # 設定内容はtadashi-aikawaのものであり、各自設定する必要がある
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/site.yml"
    ansible.inventory_path = "ansible/local"
    ansible.limit = "localhost"
    ansible.raw_arguments = ["-K"]
    ansible.extra_vars = {
      env: 'vm-gui'
    }
  end

  # ************************************
  # 任意設定
  # ************************************
  # Install jenkins
  # 個人的にJenkinsをインストールしたいので追加
  # Ansibleでインストールしても良い。(面倒だったのでVagrant provisioningに記載した)
  config.vm.provision "shell", inline: <<-SHELL
    wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get -y update
    sudo apt-get -y install jenkins
  SHELL
  
end
```

{{<alert info>}}
上記設定ファイルで使用しているAnsibleのPlaybookは以下になります。  
本記事執筆時とは内容が変わっている可能性がありますのでご了承下さい。

<blockquote class="embedly-card"><h4><a href="https://github.com/tadashi-aikawa/owl-playbook">tadashi-aikawa/owl-playbook</a></h4><p>owl-playbook - Ansible playbook for Linux</p></blockquote>
{{</alert>}}

### 実行

上記のVagrantfileを実行します。  

```
$ vagrant up --provision
```

かなり時間がかかりますので、その間にVagrantfile内の解説をご覧下さい。  
処理が終わったらvagrantから再起動します。

```
$ vagrant halt && vagrant up
```

{{<alert warning>}}
Ubuntuから再起動するとボリュームマウントが上手くいきませんでした。
{{</alert>}}

ログインパスワードは `vagrant` です。


日本語キーボードにを使用する
----------------------------

デフォルトでは英語版のキーボードになっています。  
それが良い場合は問題ありませんが、日本語版が使いたい場合は以下の設定をします。

{{<mp4 "eeg31zu2kjnfuwm/20171203_2.mp4">}}


AutoHotKeyを自然に使えるようにする
----------------------------------

私の場合はAutoHotKeyをバリバリ使っておりますので以下の設定が必要でした。  
ホストOSでキーフックを設定していない場合は設定不要だと思います。

### キーボードの自動キャプチャーをオフにする

キーボードのキャプチャーとはVirtualBoxの機能です。  
VirtualBoxのウィンドウがアクティブなとき、キーボードからの入力を直接ゲストに送る機能だと思います。

以下が点灯しているとき、キーボードのキャプチャーはONになっています。  
キャプチャーのON/OFFはホストキー(デフォルト: `右Ctrl`)で変更できます。

{{<himg "tww72u7amt4x2uu/20171203_1.png">}}

デフォルトでは、VirtualBoxにフォーカスが当たると自動でONになります。  
これを禁止することで、普段はAutoHotKeyが使えるようにします。

{{<mp4 "t5c7wuidtqrwy2y/20171203_1.mp4">}}


### 日本語入力のON/OFFショートカットキーを変更する

AutoHotKeyでは`setIME()`関数を使用して直接日本語入力モードを制御しています。  
しかし、ゲストマシンのGoogle日本語入力ではそうはいきません。

そこで、ゲストマシンがアクティブの場合は`setIME()`ではなく、日本語入力をON/OFFするキーを割り当てるようにしました。

キーボードの設定を開きます。

{{<himg "bby1trlvx2y6r04/20171203_2.png">}}

最も他のツールと競合しなかった `Ctrl+Shift+Pgup` と `Ctrl+Shift+Pgdn` を割り当てました。

{{<himg "x9bvuv2mso4utu3/20171203_3.png">}}


ターミナルの設定
----------------

私の場合は以下を設定します。不要の場合はスキップしてください。  
端末を開き、`ファイル` > `新しいプロファイル`からプロファイルを作成します。

{{<himg "noc5yr7a2xxh4my/20171203_4.png">}}

### デフォルトシェルをfishにする

コマンドタブの設定を以下の様にします。

{{<himg "blsfqllynwn6w4x/20171203_5.png">}}


### Powerline対応フォントに変更する

全般タブの設定を以下の様にします。

{{<himg "vrwnmpf02vqa6ku/20171203_6.png">}}

{{<alert info>}}
Powerlineフォントはインストールが必要なため、Ansibleのplaybookにtaskを記載しています。  
冪等性は考慮していません。

```yml
- name: "[Powerline] Clone font"
  git:
    repo: https://github.com/powerline/fonts.git
    dest: /tmp/fonts
    depth: 1

- name: "[Powerline] Install"
  command: ./install.sh
  args:
    chdir: /tmp/fonts
```
{{</alert>}}

### デフォルトプロファイルの変更

ターミナルを開いたときのプロファイルを今回作成したものにしましょう。  
`端末` > `設定`から設定できます。

{{<himg "om6wwtfoaahmy7k/20171203_7.png">}}


トラブルシューティング
----------------------

### ウィンドウの切り替えができない

`Hostキー`を押してから`Alt + TAB`で切り替えできます。  
上述したキーボードのキャプチャが有効になっているかを気にする必要があります。

### Vimやnano以外のエディタを使いたい

私はVisual Studio Codeを入れています。

<blockquote class="embedly-card"><h4><a href="https://code.visualstudio.com/">Visual Studio Code - Code Editing. Redefined</a></h4><p>Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications. Visual Studio Code is free and available on your favorite platform - Linux, Mac OSX, and Windows.</p></blockquote>

Windowsでも使っていますが、以下をコピーすれば使い勝手はほぼ同じでした。

* `settings.json` (ユーザ設定)
* `keybindings.json` (ユーザのキーショートカット)

### 画面の動きがもっさりする

`Vagrantfile`の設定が適切であるかを確認してください。  
特に以下のケースでは悪化が著しいです。

* 仮想マシンのモニタ数が2以上になっている (`"--monitorcount", "１"`でない)
* 3DアクセラレータをONになっていない (`"--accelerate3d", "on"`でない)

### VS Codeをコマンドから起動できない

`code`で起動できない場合、環境変数`DISPLAY`の値を確認してください。

* `DISPLAY`が`:0`と設定されていればOK
* `DISPLAY`が`localhost:0.0`だとNG

### Vimのヤンクとクリップボードを同期させたい

#### Ubuntu Desktop

{{<icon linux>}} `.vimrc`で`set clipboard=unnamedplus`を設定しましょう。  

{{<alert warning>}}
`set clipboard=unamed`では動作しません。
{{</alert>}}

#### Windows

 {{<icon windows>}} `.vimrc`で`set clipboard=unnamedplus`を設定した上で以下の準備が必要です。

* Windows Xサーバ([VcXsrv] など)のインストール/起動が完了している
* 環境変数`DISPLAY`の値が`:0`である
* vimで`:echo has('clipboard')`した結果が`1`でなければ`vim-gtk` をインストールしている

クリップボードと通信するためWindows Xサーバが必要なのが少し面倒ですね。

[VcXsrv]: https://sourceforge.net/projects/vcxsrv/

### tmuxのコピー領域とクリップボードを同期させたい

`.tmux.conf`でバインドを設定しましょう。  

#### Ubuntu Desktop

{{<icon linux>}} デフォルトでインストールされている`xsel`を使ってクリップボードを操作させます。

```
$ bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xsel -ip && xsel -op | xsel -ib"
```

#### Windows

 {{<icon windows>}} Windowsコマンドの`wcmd clip`を使用します。    

```
$ bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "wcmd clip"
```

{{<alert warning>}}
前提として、WSL terminalで`wcmd`コマンドを使える必要があります。
{{</alert>}}


使用感
------

### Ubuntu Desktopにして良かったこと

Desktop版ならではのメリットは3つです。

* 純粋なLinuxで動かしたいモノ(Docker等)について
    - 動作を直接ブラウザで確認できる
        - Vagrantのポートフォワーディングはなぜか上手くいかないことがある...
    - Vim以外のエディタで閲覧/編集できる
* WSL terminalからUbuntuにsshログインしてコマンドを打つと、ゲストの仮想モニタで起動できる
    - `firefox blog.mamansoft.net`とすればこのブログが立ち上がる
* クリップボードやyankを完全に同期できる
    - Ubuntuがクリップボードを持ち、かつWindowsと同期できるのが大きい

以下はDesktop版ではないUbuntu環境でも同じです。

* ターミナルの反応速度が速い
* Windows特有の落とし穴にハマるリスクを回避できる

### Ubuntu Desktopの期待外れだったこと

UbuntuというよりVirtualBoxを使うことによる弊害がほとんだと思いますが...

* 仮想スクリーンを2つ以上にすると描画が遅い
* ウィンドウの操作が思考の速度でできない
* ホストマシンとキーバインディングが競合して悩まされることがある


総括
----

Ubuntu Desktopで開発できる環境を整えてみました。  
現時点では1画面で多少のキー競合を許容できれば快適といったレベルです。

キーバインディングの競合は仮想マシンを使う以上、避けられない問題です。  
ウィンドウと複数仮想スクリーンでの挙動は、VirtualBoxに頑張っていただきたいと思いました。

1画面という制限付きでも、GUIが使えるUbuntuから受ける恩恵は大きいです。  
基本はWSLターミナルで操作し、画面が必要なときに限って1画面限定のVirtualBox上で操作する... という使い方をしばらく試してみます。


### 参考

<blockquote class="embedly-card"><h4><a href="http://kamatte.me/2017/08/16/vagrantvirtualboxubuntu16-04%E3%81%A7%E8%B6%85%E5%BF%AB%E9%81%A9%E3%81%AAgui%E4%BB%AE%E6%83%B3%E7%92%B0%E5%A2%83%E3%82%92%E6%A7%8B%E7%AF%89%E3%81%99%E3%82%8B/">Vagrant+VirtualBox+Ubuntu16.04で超快適なGUI仮想環境を構築する - かまって☆しんどろ～む</a></h4><p>開発環境としてのWindowsに痺れを切らしました。いい加減まともな開発環境を構築しようと思い一念発起。VagrantとVirtualBoxを使ってUbuntu16.04の 超快適な GUI仮想環境を構築していきます。 なお、この記事は私がWindows環境で構築したことを基に解していますが、手順は全てのホストOSで共通ですのでご参考ください。 GUIが物理環境と同程度に機敏に動作する。 ...</p></blockquote>

<blockquote class="embedly-card"><h4><a href="http://did2memo.net/2015/07/31/virtualbox-autohotkey-auto-keyboard-capture-off/">VirtualBoxのゲストOSに対してAutoHotkeyのキー変換を有効にする設定方法（重要）</a></h4><p>Windows利用時に当然のようにAutoHotkeyを使う普通の人であれば、Windows上で動かしているVirtualBox上の仮想マシンにもAutoHotkeyで変換したキーストロークを送信したい、と思うのもまた当然でしょう。 しかし、この当然できるべき華麗な連携を実際にVirtualBox最新版+Ubuntuで試してみると、 ...</p></blockquote>

<blockquote class="embedly-card"><h4><a href="https://qiita.com/kmsyn1111/items/ed724a617b2753d135d2">Ubuntu Desktop(16.04LTS)のBox作成 - Qiita</a></h4><p>Ubuntu Desktop(16.04LTS)のBox作成 はじめに ローカル開発環境として、Ubuntu Desktop(16.04LTS)環境を構築したので、その手順を残します。 前提 Vagrant2.0.0 + Virtualbox5.1.30 + Ubuntu16.04 LTS 使用boxはbento/ubuntu-16.04 手順 Ubuntuをダウンロード $ vagrant init bento/ubuntu-16.04...</p></blockquote>

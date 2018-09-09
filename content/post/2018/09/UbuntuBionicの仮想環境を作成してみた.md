---
title: "Ubuntu Bionicの仮想環境を作成してみた"
slug: ubuntu-bionic-virtual-machine
date: 2018-09-09T17:04:37+09:00
thumbnailImage: https://images.unsplash.com/photo-1485795046599-702122cd1267?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=1bfc98d64d81949c903c9135e7562eb5&auto=format&fit=crop&w=1050&q=80
categories:
  - engineering
tags:
  - ubuntu
  - lubuntu
  - vagrant
  - virtualbox
  - ansible
---

Ubuntu Bionic BeaverことUbuntu 18.04 LTSが2018年4月にリリースされました。

リリースから半年近く経ったのでUbuntu 16.04の仮想環境から移行してみました。

<!--more-->

<img src="https://images.unsplash.com/photo-1485795046599-702122cd1267?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=1bfc98d64d81949c903c9135e7562eb5&auto=format&fit=crop&w=1050&q=80"/>

<!--toc-->


はじめに
--------

### 読者の前提

以下の技術を理解している前提で進めます。

* Vagrant
* Ansible


### ホストマシンの環境

* Windows10 Home 10.0.17134
* Vagrant 2.1.2
* VirtualBox 5.2.18 r124319


### ゲストマシンの環境

* Lubuntu18.04 (Ubuntu18.04)
* 日本語対応版


Vagrantプラグインのインストール
-------------------------------

Vagrantのプラグインを2つインストールします。

```
$ vagrant plugin install vagrant-vbguest vagrant-disksize
```


### vagrant-vbguest

ホストOSとゲストOSで[VirtualBox Guest Additions]のバージョンが一致するようにゲストOSへインストールするプラグインです。

{{<summary "https://github.com/dotless-de/vagrant-vbguest">}}

このプラグインによって[VirtualBox Guest Additions]のバージョンの差異がなくなると、以下の様な不都合を防止できます。

* ウィンドウが自動でリサイズしない
* ホストとゲストでクリップボードを共有できない

[VirtualBox Guest Additions]: https://www.virtualbox.org/manual/ch04.html


### vagrant-disksize

VMのディスク容量を増やすことができるプラグインです。

{{<summary "https://github.com/sprotheroe/vagrant-disksize">}}

40GBで足りなかったため、今回から80GBに増やしてみました。  
色々な言語で開発する身としてはストレスが無くなって快適 :relaxed:


Lubuntu Desktopの作成
---------------------

VagrantとVirtualBoxを使ってLubuntu Desktopを作成します。


### Boxの追加

`ubuntu/bionic64`のイメージをローカルに追加します。 

```
$ vagrant box add ubuntu/bionic64
```

{{<alert "success">}}
手順としては`vagrant box add`を必ず実行する必要はありません。  
ここでは失敗した際に再度通信する手間を省くため、明示的に実行しています。
{{</alert>}}


### Vagrantfileの作成と実行

以下のファイルを作成して`vagrant up --provision`を実行します。

2回ほど権限の許可を求められますので画面からは離れないで下さい。

{{<file "Vagrantfile">}}
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.disksize.size = "80GB"
  # config.vm.box_version = "v20180823.0.0"

  # port forward
  ([80, 1313, 3000, 4200, 6006, 8000] + (8080..8090).to_a).each do |port|
    config.vm.network "forwarded_port", guest: port, host: port + 10000, host_ip: "127.0.0.1"
  end
  config.vm.network "forwarded_port", guest: 61208, host: 61208, host_ip: "127.0.0.1"
  config.vm.network "private_network", ip: "192.168.33.10"

  # VirtualBox VM options
  config.vm.provider "virtualbox" do |vb|
    vb.name = "ubuntu-gui"
    vb.cpus = "2"
    vb.memory = "4096"
    # GUI settings
    vb.gui = true
    vb.customize [
      "modifyvm", :id,
      "--vram", "256",
      "--accelerate3d", "on",
      "--hwvirtex", "on",
      "--nestedpaging", "on",
      "--largepages", "on",
      "--ioapic", "on",
      "--pae", "on",
      "--paravirtprovider", "kvm",
      "--clipboard", "bidirectional",
      "--draganddrop", "bidirectional",
      "--monitorcount", "1",
      "--nictype1", "virtio",
      "--nictype2", "virtio",
    ]
  end

  # sync
  config.vm.synced_folder "../../", "/vagrant"
  config.vm.synced_folder "../../../../", "/whome"

  # Provisioning with ansible
  config.vm.provision "shell", inline: <<-SHELL
    # Install ubuntu-desktop
    sudo apt -y update
    # See https://github.com/chef/bento/issues/661
    #sudo apt-get -y upgrade
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
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

  # Install docker
  config.vm.provision "docker"

  # Install ansible and provisioning
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/site.yml"
    ansible.inventory_path = "ansible/local"
    ansible.limit = "localhost"
    ansible.raw_arguments = ["-K"]
    ansible.extra_vars = {
      env: 'vm-gui'
    }
  end

end
```
{{</file>}}

私個人用に設定などをカスタマイズしています。あくまで参考程度に。

{{<error "Error: Could not resolve host: vagrantcloud.com">}}
以下エラーのようにログインを促される場合

```
The box 'ubuntu/bionic64' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Vagrant Cloud, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://vagrantcloud.com/ubuntu/bionic64"]
Error: Could not resolve host: vagrantcloud.com
```

以下のアクションが必要です。

* HashiCorpのアカウントを作成
* `vagrant login`
{{</error>}}


### Lubuntu Desktopのインストール

ここまでの手順でUbuntu Desktopが構築されています。  
ここでは更に、軽量なディストリビューションのLubuntu Desktopをインストールします。

{{<summary "https://lubuntu.net/">}}

作成された仮想環境のターミナルを開き、以下のコマンドを実行するだけです。

```
$ sudo apt-get install -y lubuntu-desktop
```

途中でディスプレイマネージャーの選択を求められます。  
私はGDMを選択しました。

{{<warn Vagrantfileでlubuntu-desktopをインストールする場合の注意>}}
VagrantfileのProvisioning処理でlubuntu-desktopをインストールすると、ディスプレイマネージャー選択画面の表示に問題が生じます。  
画面に変化はなくても処理は完了するかもしれませんが、視覚フィードバックが得られないためオススメしません。

Provisioning完了後にUbuntuへログインしてからインストールすることを強く推奨します。
{{</warn>}}

{{<why "なぜディスプレイマネージャーにGDMを選ぶのか?">}}
Ubuntu 17からデフォルトのディスプレイマネージャーがGDMに変更されたからです。  
以前はLightDMがデフォルトでしたが、今後を考えるとGDMにしておいた方が良さそうだと判断しました。
{{</why>}}

{{<why "なぜLubuntuを使用するのか?">}}

Ubuntuでは以下ツールを使用する際、画面描画に大きな遅延が生じるからです。

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
* [Visual Studio Code](https://code.visualstudio.com/) (こちらが深刻)

Lubuntuは軽量ディストリビューションのため、画面描画を実用的な速度まで引き上げてくれます。  
なんてクールなんだ！
{{</why>}}


Lubuntuでログイン
-----------------

ログイン画面でLubuntuを選択します。  
LightDMに慣れていると切り替えに戸惑いますが、以下画像のように変更できます。

{{<himg "https://dl.dropboxusercontent.com/s/v9u3g9cd2z8bisw/20180909_1.png">}}

ユーザーを選択してからでないと歯車マークは出ませんのでご注意。


日本語化
--------

言語設定とキーボードを日本語化します。


### 言語設定

まずは言語設定を日本語化しましょう。  
以下の画像のように`Language Support`から日本語を追加します。

{{<himg "https://dl.dropboxusercontent.com/s/atcvplu83gbnq9x/20180909_2.png">}}

{{<warn "ubuntuユーザのログインパスワードを求められて認証できない場合は...">}}
`sudo passwd ubuntu`コマンドでubuntuユーザのパスワードを変更しましょう。  
再び入力を求められたら、再設定したパスワードを入力すればOKです。

※ 初期パスワードが分かっていればこの工程は不要かもしれませんが`vagrant`では認証が通りませんでした..
{{</warn>}}

インストール成功したら`Language`と`Regional Formats`を日本語に設定します。  
`Apply System-Wide`をクリックしてシステム全体へ適応するのを忘れないようにしてください。

{{<himg "https://dl.dropboxusercontent.com/s/zqq59xookwl0res/20180909_3.png">}}
{{<himg "https://dl.dropboxusercontent.com/s/vu3110pzkeftydz/20180909_4.png">}}


### キーボード設定

次に日本語対応のキーボードを設定します。  
この設定をしなければ日本語入力することができません。

キーボードアイコンから設定を開きます。

{{<himg "https://dl.dropboxusercontent.com/s/w8b1dz8px472sxo/20180909_5.png">}}

{{<warn "キーボードアイコンが表示されない場合は...">}}
理由は分かりませんが表示されなくなることがあります。一度VMを再起動してみましょう。

`vagrant reload`では改善しない場合がありますので、`vagrant halt && vagrant up`を推奨します。
{{</warn>}}

ダイアログ下部のボタンを使って、入力メソッドのキーボードを以下のように配置します。

{{<himg "https://dl.dropboxusercontent.com/s/mycshb7eiajujfo/20180909_6.png">}}

後は好みに応じて設定を変更して下さい。  
私はAutoHotKeyでカスタマイズをしているため以下のような設定をしています。

{{<summary "https://blog.mamansoft.net/2017/12/03/create-ubuntu-desktop/#autohotkey%E3%82%92%E8%87%AA%E7%84%B6%E3%81%AB%E4%BD%BF%E3%81%88%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB%E3%81%99%E3%82%8B">}}


Ansibleで環境構築
-----------------

ベースはできましたのでAnsibleを使って開発環境その他を構築します。  
私の場合は以下で環境を管理しています。

{{<summary "https://github.com/tadashi-aikawa/owl-playbook">}}

自分だけのPlaybookを作成しておくと環境再構築が楽チンですのでオススメです。


### ハマッタところ

#### tmuxのpowerlineが表示されない

環境変数`LC_ALL`が設定されていなかったためでした。

{{<refer "tmux \+ Powerline が上手く動作しない場合の確認ポイント" "https://qiita.com/shiftky/items/92c9ceedd26f168c87dc">}}

#### WSL Terminal上のVimとClipboardの共有ができない

ホストとゲストの共有はできているケース。  
環境変数`DISPLAY`の設定を変更すると解決しました。

* 変更前: `set -x DISPLAY :0`
* 変更後: `set -x DISPLAY :1.0`

恐らくディスプレイマネージャーをLightDMからGDMに変更した影響だと思います。  
`xsel`コマンドでコケていました..。


総括
----

Ubuntu 18.04 LTSの仮想環境をVarant/Virtualboxで作成してみました。

LTS版ですのでしばらくの間は安心して開発することができそうです :smile:



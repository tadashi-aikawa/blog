---
title: Ubuntu作成環境を整備した
slug: clean-ubuntu-infra
date: 2019-01-25T23:58:59+09:00
thumbnailImage: images/cover/2019-01-25.jpg
categories:
  - engineering
tags:
  - ansible
  - lubuntu
  - ubuntu
  - vagrant
  - virtualbox
  - bash
  - fish
---

Ubuntu環境が少し散らかっていたので、綺麗にしてみました。

<!--more-->

{{<cimg "2019-01-25.jpg">}}

<!--toc-->


はじめに
--------

2年ほど前からVMでUbuntuを使用しています。  
整備は今までに3回ほど実施しており、一部ブログの記事にしています。

{{<summary "https://blog.mamansoft.net/2017/12/03/create-ubuntu-desktop/">}}

{{<summary "https://blog.mamansoft.net/2018/09/09/ubuntu-bionic-virtual-machine/">}}

頻度は半年～1年に1回... 常に環境は綺麗に保ちたいので継続的なメンテナンスが大切です。


### 筆者の環境

* Windows10 Home 10.0.17134
* Vagrant 2.2.0
* VirtualBox 5.2.20 r125813 (Qt5.6.2)


### 想定する読者

手順を重視するため、技術の説明はしません。  
以下の用語について、意味と利用方法を知っている読者を想定しています。

* Ansible
* Bash
* Fish
* Ubuntu
* Lubuntu
* Display Manager
* Vagrant
* Virtualbox


前回までとの違い
----------------

ツールの取捨選択は勿論のこと、今まで使っていた環境との大きな違いがあります。

### メインシェルをFishからBashに変更

以下の理由からFishをやめてBashにしました。

* FishはBashに比べて表示が微妙に遅い (普通の人は気にならないレベルだと思います..)
* FishにあってBashに無い便利機能はほとんどカバーできる
* Bashの方がREADMEに記載された構築手順でハマることが少ない
* サーバはBashしか入っていないことが多いため、頭の切り替えや設定管理のコストが高い

便利機能のカバーについては別の機会に記事を書くかもしれません。


### 仮想環境のイメージを作成

`ubuntu/bionic64`ではなく、日本語設定したLubuntu Desktop環境作成状態のイメージをBoxとして保存するようにしました。  
理由は以下2点です。

* 日本語設定とLubuntu Desktop作成にとても時間がかかるため、イメージを再構築にできない
* Display Managerがしばしば正常に動作しなくなるが、上記理由からイメージ再構築のコストが高い

`vagrant package`するだけだったので、これはもっと早くやっておけばよかったと思いました。


日本語版Lubuntu Desktopの作成
-----------------------------

まずはイメージをBoxとして保存するまでのフェーズです。


### Vagrantfile

以下のVagrantfileを作成します。

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  # port forward
  config.vm.network "private_network", ip: "192.168.33.10"

  # VirtualBox VM options
  config.vm.provider "virtualbox" do |vb|
    vb.name = "lubuntu-base"
    vb.cpus = "2"
    vb.memory = "2048"
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
      "--natdnshostresolver1", "on",
    ]
  end
end
```

起動します。

```
$ vagrant up
```


### Lubuntuインストール

立ち上がったマシンの中で以下コマンドを実行します。

```
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install lubuntu-desktop
```

マシンを再起動します。

```
$ vagrant halt && vagrant up
```

{{<why "vagrant provisionでインストールしないのは...">}}
Windows上で`sudo apt install lubuntu-desktop`を実行すると、ターミナルによっては画面がフリーズするためです。  
Boxを作り直す機会は多くないため、多少の手間をかけても問題ないと判断しています。
{{</why>}}


### 日本語設定

まず、ubuntuユーザのパスワードを変更して下さい。後で聞かれるためです。

```
$ sudo passwd ubuntu
```

以下を参考にして日本語対応してください。

{{<summary "https://blog.mamansoft.net/2018/09/09/ubuntu-bionic-virtual-machine/#wsl-terminal%E4%B8%8A%E3%81%AEvim%E3%81%A8clipboard%E3%81%AE%E5%85%B1%E6%9C%89%E3%81%8C%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%84">}}

最後にLocaleを日本語にします。

```
$ sudo update-locale LANG=ja_JP.UTF-8
```


Boxの作成と追加
---------------

### 作成

vagrantの`package`コマンドを使うだけです。

```
$ vagrant halt
$ vagrant package
```

### 追加

vagrantの`box add`コマンドを使います。  
`lubuntu-base\package.box`にBoxが作成された場合です。

```
$ vagrant box add "tadashi-aikawa/lubuntu-jp" lubuntu-base\package.box
```

{{<why "Vagrant Cloudに公開しないのか?">}}
公開はしません。  
自分用に最適化されており、今後メンテしていく保証ができないからです。

{{<refer "Vagrant Cloud" "https://app.vagrantup.com/boxes/search">}}
{{</why>}}



新しいUbuntu環境の作成
----------------------

最長でUbuntuの時期安定版が出るまでの間、新しいイメージ作成はここからスタートできます。  
わんだふる!!🐶

### Vagrantでイメージ作成

ここまでに作成したベースイメージから新しいイメージを作成します。

{{<file "Vagrantfile">}}
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "tadashi-aikawa/lubuntu-jp"
  config.disksize.size = "40GB"

  # port forward
  [3000, 3001, 5432, 8000, 8888].each do |port|
    config.vm.network "forwarded_port", guest: port, host: port, host_ip: "127.0.0.1"
  end
  config.vm.network "private_network", ip: "192.168.33.10"

  # VirtualBox VM options
  config.vm.provider "virtualbox" do |vb|
    vb.name = "lubuntu-jp"
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
      "--natdnshostresolver1", "on",
    ]
  end

  # sync
  config.vm.synced_folder "../../mnt", "/mnt"
  config.vm.synced_folder "../ansible", "/mnt-ansible"
  target_path = ENV['USERPROFILE'].gsub(/\\/,'/') + "/tmp"
  config.vm.synced_folder target_path, "/mnt-tmp"

  # Install docker
  config.vm.provision "docker"

  # Install others
  config.vm.provision :shell, :path => "provision.sh"

  # Secret
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  config.vm.provision "file", source: "~/.gowlconfig", destination: ".gowlconfig"
  config.vm.provision "file", source: "~/.ssh", destination: ".ssh"
end
```
{{</file>}}

ポート番号や同期ディレクトリは私の好みです。

`# Secret`の下に列挙されたファイルは秘密情報を含むものです。  
バージョン管理できないため、ホストに置かれた情報から`provision`時に転送しています。

`provision.sh`の中ではAnsibleのインストールと`.ssh`配下の権限設定をしています。

{{<file "provision.sh">}}
```sh
#!/bin/bash

set -eu

# Install ansible
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-18-04

apt -y update
apt -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt -y update
apt -y install ansible

chmod 600 .ssh/*
```
{{</file>}}


### Ansibleで環境構築

後はAnsibleを使って環境構築します。

筆者の環境構築は以下のリポジトリで管理しています。

{{<summary "https://github.com/tadashi-aikawa/owl-playbook">}}

`linux/ansible`に移動してmakeコマンドを実行します。

```
$ make lubuntu-jp
```

{{<refer "owl-playbook/linux/ansible" "https://github.com/tadashi-aikawa/owl-playbook/tree/master/linux/ansible">}}

Vimプラグインのインストールは別途、Vim立ち上げ後にやる必要ありますけどね😄


総括
----

久しぶりにUbuntu環境を綺麗にしてみました。

fishを手放せたこと、ベースBoxを作成できたことは大きな収穫だったと思っています。


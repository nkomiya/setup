# setup

**目次**

<!-- TOC -->

- [setup](#setup)
    - [CLI 環境](#cli-環境)
    - [Prerequisites](#prerequisites)
        - [Command Line Tools for Xcode](#command-line-tools-for-xcode)
        - [Homebrew](#homebrew)
        - [source highlight](#source-highlight)
        - [Git](#git)
        - [Python](#python)
        - [Font](#font)
    - [Installation](#installation)
        - [ターミナル テーマ反映](#ターミナル-テーマ反映)
        - [ファイルの配置](#ファイルの配置)
            - [Python 仮想環境作成](#python-仮想環境作成)
    - [Optional tools](#optional-tools)
        - [Java](#java)
        - [Google Cloud SDK](#google-cloud-sdk)

<!-- /TOC -->

## CLI 環境

bash

## Prerequisites

### Command Line Tools for Xcode

1. [ここ](https://developer.apple.com/xcode/whats-new/) から利用可能な Xcode のバージョンを調べる
2. [ここ](https://developer.apple.com/download/all/?q=Command%20Line%20Tools%20for%20Xcode) から CLT をインストール

### Homebrew

Package管理は [Homebrew](https://brew.sh/) で行う。

```bash
# インストールコマンド
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### source highlight

```bash
# インストールコマンド
$ brew update && brew install source-highlight
```

### Git

補完を効かせたりするため、Git のバージョンを上げておく。

```bash
# インストールコマンド
$ brew update && brew install git
```

### Python

Pythonのバージョン管理は [pyenv](https://github.com/pyenv/pyenv.git)、仮想環境の管理は [pipenv](https://pypi.org/project/pipenv/) を使う。

```bash
# pyenv のインストール
$ git clone https://github.com/pyenv/pyenv.git ~/pyenv

# 適当な Python runtime をインストール
$ VERSION=3.9.1
$ pyenv install ${VERSION}
```

### Font

プロンプトで特殊文字を使うため、[JetBrains Mono](https://www.jetbrains.com/lp/mono/) あたりを入れておく。ttf ファイルのダウンロード後、Font Book.app で有効化する。

## Installation

### ターミナル テーマ反映

helper/my_powerline.terminal を terminal.app にインポート

### ファイルの配置

上書きで更新する。

```bash
# 個人環境の設定でテンプレートを上書き
$ bash $(git rev-parse --show-toplevel)/helper/configure.sh

# bash_profile
$ cat $(git rev-parse --show-toplevel)/build/bash_profile >~/.bash_profile

# bashrc
$ cat $(git rev-parse --show-toplevel)/bashrc >~/.bashrc

# custom scripts
$ rsync -av $(git rev-parse --show-toplevel)/scripts/ ~/.scripts
```

#### Python 仮想環境作成

カスタムコマンド用に、Python の仮想環境を Pipenv で作成しておく。

```bash
# ~/.local/share/virtualenvs へ仮想環境が入る
$ PIPENV_PIPFILE=~/.scripts/lib/Pipfile pipenv install
```

## Optional tools

### Java

Javaのバージョン管理は、[jEnv](https://www.jenv.be/)

```bash
# jEnv のインストール
$ git clone https://github.com/gcuisinier/jenv.git ~/jenv
```

jEnv では JDK のインストールはできないので、JDKを別途インストールし、jEnv に JDK のパスを登録する。

```bash
# JDK 8 を jEnv に登録
$ jenv add $(/usr/libexec/java_home -v 1.8)
```

### Google Cloud SDK

[ここ](https://cloud.google.com/sdk/docs/downloads-versioned-archives#installation_instructions) から最新版の tgz をダウンロードし、下記コマンドを実行する。

```bash
# ホームパス直下へ展開
$ tar zxf /path/to/tar/gz/file -C ~

# SDK のインストール
$ ~/google-cloud-sdk/install.sh
```

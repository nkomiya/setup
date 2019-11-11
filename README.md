# Repository overview
Mac OS の開発環境構築についてメモ.

## CLI 環境
bash

## Prerequistes
+ Command Line Tools for Xcode  
下記リンクから「Command Line Tools for Xcode」をダウンロードし、インストール
[https://developer.apple.com/download/more](https://developer.apple.com/download/more)

+ Homebrew  
Package管理は [Homebrew](https://brew.sh/) で行う。インストールは下記コマンド。

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

+ source highlight

```bash
$ brew install source-highlight
```

+ Git  
補完を効かせたりするため、Homebrew 経由で git をインストールし、Git のバージョンを上げておく。

```bash
$ brew update && brew install git
```

+ Font  
プロンプトで特殊文字を使うため、[適当なフォント](https://github.com/powerline/fonts/blob/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf) を入れておく。ttf ファイルのダウンロード後、Font Book.app で有効化する。

## Installation
### ターミナルのテーマ反映
helper/my_powerline.terminal を terminal.app にインポート

### 設定反映
Git の設定更新と kubectl の補完ファイルを作成

```bash
$ bash $(git rev-parse --show-toplevel)/helper/configure.sh
```

### ファイルの配置

```bash
$ cat $(git rev-parse --show-toplevel)/bash_profile >> ~/.bash_profile
$ cat $(git rev-parse --show-toplevel)/bashrc >> ~/.bashrc
$ cp -r $(git rev-parse --show-toplevel)/scripts ~/.scripts
```

## Optional tools
### Python
Pythonのバージョン管理は、[pyenv](https://github.com/pyenv/pyenv.git) と [pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv.git)

```bash
$ git clone https://github.com/pyenv/pyenv.git ~/pyenv
$ git clone https://github.com/yyuu/pyenv-virtualenv.git ~/pyenv/plugins/pyenv-virtualenv
```

### Java
Javaのバージョン管理は、[jEnv](https://www.jenv.be/)

```bash
$ git clone https://github.com/gcuisinier/jenv.git ~/jenv
```

jEnv では JDK のインストールはできないので、JDKを別途インストールし、jEnv に JDK のパスを教える。

```bash
$ jenv add $(/usr/libexec/java_home 8)
```

### gcloud command line tools
+ tgz ファイルをダウンロード
[https://cloud.google.com/sdk/docs/downloads-versioned-archives#installation_instructions](https://cloud.google.com/sdk/docs/downloads-versioned-archives#installation_instructions)

+ tar ファイルの解凍、初期設定

```bash
$ cd ~
$ tar zxf /path/to/tar/gz/file
$ ./google-cloud-sdk/install.sh
```

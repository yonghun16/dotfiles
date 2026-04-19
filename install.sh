#!/usr/bin/env bash

set -eo pipefail

SOURCE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

DATA="${XDG_DATA_HOME:-${HOME}/.local/share}"
mkdir -p "$DATA"

CONFIG="${XDG_CONFIG_HOME:=$HOME/.config}"
mkdir -p "$CONFIG"

function link() {
    local SRC="$SOURCE_DIR/$1"
    local DEST="$2"

    echo -n "installing $1 ... "

    if ! test -e "$DEST"; then
        ln -sf "$SRC" "$DEST"
        echo "is done"
        echo "$SRC → $DEST"
    else
        echo "is skipped"
    fi
    echo
}

function install_or_update_homebrew() {
    if [[ ! -x "$(command -v brew)" ]]; then
        echo "installing Homebrew ..."
        curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" | bash
    fi

    # brew 명령어를 현재 쉘에서 즉시 쓰기 위한 설정
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    brew update
}

function install_or_update_zinit() {
    local ZINIT_HOME="$DATA/zinit/zinit.git"

    if [[ ! -d "$ZINIT_HOME" ]]; then
        echo "installing zinit to $ZINIT_HOME..."
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone "https://github.com/zdharma-continuum/zinit.git" "$ZINIT_HOME"
    else
        echo "updating zinit..."
        git -C "$ZINIT_HOME" pull
    fi
    echo
}

# --- 실행 로직 ---

# 1. Homebrew 설치 및 업데이트
install_or_update_homebrew

# 2. 패키지 설치 (Brewfile)
brew bundle --upgrade --file "$SOURCE_DIR/Brewfile"

# 3. Zinit 설치
install_or_update_zinit

# 4. 설정 파일 링크
## Home 폴더 내부 연결
link "zshrc" "$HOME/.zshrc"
link "tmux.conf" "$HOME/.tmux.conf"
link "clang-format" "$HOME/.clang-format"

## Config 폴더 내부 연결
link "config/ghostty" "$CONFIG/ghostty"
link "karabiner" "$CONFIG/karabiner"
link "config/nvim" "$CONFIG/nvim"

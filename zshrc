# ==========================================
# 환경 변수 (Export) - 가장 먼저 로드
# ==========================================
export LANG=ko_KR.UTF-8
export EDITOR="nvim"

# Homebrew & 기본 경로
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Node.js (PNPM & NVM)
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

# pnpm
export PNPM_HOME="/Users/song-yonghun/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Python
export PATH="$HOME/Library/Python/3.9/bin:$PATH" # site-packages보다 bin 폴더가 우선입니다.

# Java & Android
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# API Key
export GEMINI_API_KEY=""


# ==========================================
# Zinit 설치 및 초기화
# ==========================================
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    print -P "%F{33}Installing Zinit...%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# ==========================================
# 테마 및 플러그인 (Turbo Mode 적용)
# ==========================================

# [Theme] Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# [Snippets] Oh My Zsh 핵심 기능
zinit snippet OMZL::history.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZP::git # git 플러그인으로 가져오는 것이 더 효율적입니다.

# [Plugins] 자동완성 및 하이라이트 (속도 최적화)
zinit ice wait'0a' lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait'0a' lucid atinit"ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)"
zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait'0b' lucid; zinit light zsh-users/zsh-completions


# ==========================================
# 사용자 설정 (Options & Aliases)
# ==========================================
setopt promptsubst
setopt SHARE_HISTORY
HISTSIZE=10000
SAVEHIST=10000

# Aliases
alias vi="nvim"
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first --git"
alias tree="eza --tree --icons"
alias rm="trash"
alias cp="cp -i"
alias mv="mv -i"
alias swap="rm -rf ~/.local/state/nvim/swap/*"
alias t="tmux attach -t main || tmux new -s main"
alias update-dev='brew update; brew upgrade; brew cleanup; npm update -g; pnpm update -g; pipx upgrade-all'

# Tmux 특정 설정
if [ -n "$TMUX" ]; then
    alias exit="tmux detach"
    export IGNOREEOF=10
fi


# ==========================================
# Gemini CLI 편의성 래퍼
# ==========================================
# 1. 프로젝트 루트 탐색
_find_gemini_root() {
    local dir="$PWD"

    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]] ||
           [[ -f "$dir/package.json" ]] ||
           [[ -f "$dir/go.mod" ]] ||
           [[ -f "$dir/Cargo.toml" ]] ||
           [[ -f "$dir/Makefile" ]]; then
            echo "$dir"
            return
        fi

        dir=$(dirname "$dir")
    done

    echo "$PWD"
}

_print_gemini_root() {
    printf "\033[1;34m󰙅 Gemini Root: %s\033[0m\n" "$1"
}

# 2. Toggle & Resume Latest (최근 세션 이어서 하기)
g-resume() {
    local root=$(_find_gemini_root)
    (
        cd "$root" || exit
        _print_gemini_root "$root"
        gemini --resume latest
    )
}

# 2. New Session (새 세션 시작)
g-new() {
    local root=$(_find_gemini_root)
    (
        cd "$root" || exit
        _print_gemini_root "$root"
        gemini
    )
}


# ==========================================
# Claude Code CLI 편의성 래퍼
# ==========================================

# 1. 프로젝트 루트 탐색
_find_claude_root() {
    local dir="$PWD"

    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]] ||
           [[ -f "$dir/package.json" ]] ||
           [[ -f "$dir/go.mod" ]] ||
           [[ -f "$dir/Cargo.toml" ]] ||
           [[ -f "$dir/Makefile" ]]; then
            echo "$dir"
            return
        fi

        dir=$(dirname "$dir")
    done

    echo "$PWD"
}


_print_claude_root() {
    printf "\033[1;35m󰙅 Claude Root: %s\033[0m\n" "$1"
}


# 2. 최근 세션 이어서 하기
c-resume() {
    local root=$(_find_claude_root)

    (
        cd "$root" || exit
        _print_claude_root "$root"
        claude --resume
    )
}


# 3. 새 세션 시작
c-new() {
    local root=$(_find_claude_root)

    (
        cd "$root" || exit
        _print_claude_root "$root"
        claude
    )
}


# ==========================================
# Aider CLI 편의성 래퍼
# ==========================================

# 1. 프로젝트 루트 탐색
_find_aider_root() {
    local dir="$PWD"

    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]] ||
           [[ -f "$dir/package.json" ]] ||
           [[ -f "$dir/pyproject.toml" ]] ||
           [[ -f "$dir/go.mod" ]] ||
           [[ -f "$dir/Cargo.toml" ]] ||
           [[ -f "$dir/Makefile" ]]; then
            echo "$dir"
            return
        fi

        dir=$(dirname "$dir")
    done

    echo "$PWD"
}


_print_aider_root() {
    printf "\033[1;32m󰚩 Aider Root: %s\033[0m\n" "$1"
}


# 2. Ollama 서버 실행 확인
_start_ollama() {
    if ! curl -s http://localhost:11434/api/tags >/dev/null; then
        echo "󰒋 Starting Ollama server..."
        nohup ollama serve >/dev/null 2>&1 &
        # 서버 준비 대기
        sleep 3
    fi
}


# 3. 모델 메모리 해제
_stop_aider_model() {
    echo ""
    echo "󰚌 Unloading qwen3-coder:30b..."
    ollama stop qwen3-coder:30b >/dev/null 2>&1
    echo "✓ Model unloaded"
}


# 4. 새 Aider 세션
a-new() {
    local root=$(_find_aider_root)
    (
        cd "$root" || exit

        _print_aider_root "$root"

        _start_ollama

        # Aider 종료(Ctrl+C 포함) 시 모델 해제
        trap '_stop_aider_model' EXIT INT TERM

        aider \
          --dark-mode \
          --model ollama/qwen3-coder:30b
    )
}

# 5. 이전 대화 복원
a-resume() {
    local root=$(_find_aider_root)
    (
        cd "$root" || exit

        _print_aider_root "$root"

        _start_ollama

        # Aider 종료(Ctrl+C 포함) 시 모델 해제
        trap '_stop_aider_model' EXIT INT TERM

        aider \
          --dark-mode \
          --model ollama/qwen3-coder:30b \
          --restore-chat-history
    )
}

# 6. 수동 모델 종료
a-stop() {
    echo "󰚌 Stopping qwen3-coder:30b..."
    ollama stop qwen3-coder:30b
    echo "✓ Model unloaded"
}


# ==========================================
# 외부 도구 지연 로딩 (속도 향상의 핵심)
# ==========================================

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# iTerm2 Integration
[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# 마무리 정보 표시
clear && neofetch
export OLLAMA_API_BASE=http://localhost:11434


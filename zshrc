# ==========================================
# 1. 환경 변수 (Export) - 가장 먼저 로드
# ==========================================
export LANG=ko_KR.UTF-8
export EDITOR="nvim"

# Homebrew & 기본 경로
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Node.js (PNPM & NVM)
export PNPM_HOME="$HOME/Library/pnpm"
export NVM_DIR="$HOME/.nvm"
export PATH="$PNPM_HOME:$PATH"

# Python
export PATH="$HOME/Library/Python/3.9/bin:$PATH" # site-packages보다 bin 폴더가 우선입니다.

# Java & Android
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# ==========================================
# 2. Zinit 설치 및 초기화
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
# 3. 테마 및 플러그인 (Turbo Mode 적용)
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
# 4. 사용자 설정 (Options & Aliases)
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

# Tmux 특정 설정
if [ -n "$TMUX" ]; then
    alias exit="tmux detach"
    export IGNOREEOF=10
fi


# ==========================================
# Gemini CLI 편의성 래퍼
# ==========================================

# [Internal] 프로젝트 루트 탐색 (Lua의 GetProjectRoot 역할)
_find_gemini_root() {
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        # 루트를 식별할 마커 파일들 (.git, package.json 등)
        if [ -d "$dir/.git" ] || [ -f "$dir/go.mod" ] || [ -f "$dir/Cargo.toml" ] || [ -f "$dir/Makefile" ]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
    echo "$PWD" # 못 찾으면 현재 디렉토리 반환
}

# 1. Toggle & Resume Latest (최근 세션 이어서 하기)
g-resume() {
    local root=$(_find_gemini_root)
    cd "$root" || return
    echo -e "\033[1;34m󰙅 Gemini Root: $root\033[0m"
    gemini --resume latest
}

# 2. New Session (새 세션 시작)
g-new() {
    local root=$(_find_gemini_root)
    cd "$root" || return
    echo -e "\033[1;34m󰙅 Gemini Root: $root\033[0m"
    gemini
}

# 3. Select Session (세션 목록 보고 선택하기)
g-select() {
    local root=$(_find_gemini_root)
    cd "$root" || return
    echo -e "\033[1;34m󰙅 Gemini Root: $root\033[0m"

    # 공백이나 빈 줄을 제외한 모든 세션 목록을 가져옵니다.
    local sessions=$(gemini --list-sessions 2>/dev/null | grep -v '^$')

    if [ -z "$sessions" ]; then
        echo "Gemini: 저장된 세션이 없습니다."
        return
    fi

    if command -v fzf >/dev/null 2>&1; then
        # fzf로 세션 라인 전체를 선택합니다.
        local choice=$(echo "$sessions" | fzf --prompt="재개할 세션을 선택하세요: ")
        if [ -n "$choice" ]; then
            # 선택한 라인에서 UUID(형식: 8-4-4-4-12자리 무작위 문자열)를 추출합니다.
            local session_id=$(echo "$choice" | grep -oE '[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}')
            
            # 만약 UUID 형식이 아니라면 라인의 첫 번째 단어(공백 기준)를 ID로 사용합니다.
            if [ -z "$session_id" ]; then
                session_id=$(echo "$choice" | awk '{print $1}')
            fi
            
            gemini --resume "$session_id"
        fi
    else
        # fzf가 없을 때를 위한 단순 번호 선택 인터페이스
        echo "$sessions"
        read -p "재개할 세션 ID 또는 번호를 입력하세요: " session_id
        if [ -n "$session_id" ]; then
            gemini --resume "$session_id"
        fi
    fi
}

# ==========================================
# 5. 외부 도구 지연 로딩 (속도 향상의 핵심)
# ==========================================

# NVM (필요할 때 로드하여 터미널 시작 속도 개선)
zinit ice wait'0b' lucid trigger'nvm'
zinit snippet "$NVM_DIR/nvm.sh"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# iTerm2 Integration
[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# 마무리 정보 표시
clear && neofetch

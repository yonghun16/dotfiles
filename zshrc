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

#!/data/data/com.termux/files/usr/bin/bash
# Termux용 Python LSP 설치 스크립트 (pyright)
# 사용법: bash install_lsp.sh
# 실패한 항목이 있어도 끝까지 진행하고, 마지막에 설치 결과를 요약합니다.

set -u

# ───────────── 설치 목록 ─────────────
# pkg: Termux 저장소 패키지
PKG_PACKAGES=(
    python
    nodejs
    lua-language-server
    shellcheck
    shfmt
)

# npm: 전역 설치
NPM_PACKAGES=(
    pyright # Python LSP (pyright-langserver 포함)
    bash-language-server
)

# 설치 후 점검할 실행 파일
CHECK_BINS=(
    python
    pip
    node
    npm
    pyright
    pyright-langserver
    bash-language-server
    lua-language-server
    shellcheck
    shfmt
    ruff
)

FAILED=()

# ───────────── 환경 확인 ─────────────
if ! command -v pkg >/dev/null 2>&1; then
    echo "pkg 명령을 찾을 수 없습니다. Termux에서 실행하세요."
    exit 1
fi

# ───────────── 1. pkg 패키지 ─────────────
echo "==> [1/3] pkg 패키지 설치"
pkg update -y || echo "pkg update 실패 (계속 진행)"

for p in "${PKG_PACKAGES[@]}"; do
    echo "--- pkg install $p"
    if ! pkg install -y "$p"; then
        FAILED+=("pkg:$p")
    fi
done

# ruff (린터/포매터, LSP 내장): pkg 우선, 실패하면 pip로 재시도
# pip 설치는 소스 빌드라 Rust가 필요하고 오래 걸릴 수 있습니다.
echo "--- pkg install ruff"
if ! pkg install -y ruff; then
    echo "pkg ruff 실패, pip로 재시도 (rust 필요)"
    if pkg install -y rust && pip install ruff; then
        :
    else
        FAILED+=("ruff")
    fi
fi

# ───────────── 2. npm 패키지 ─────────────
echo
echo "==> [2/3] npm 전역 패키지 설치"
if ! command -v npm >/dev/null 2>&1; then
    echo "npm이 없어서 npm 패키지를 건너뜁니다."
    FAILED+=("npm 미설치")
else
    for p in "${NPM_PACKAGES[@]}"; do
        echo "--- npm install -g $p"
        if ! npm install -g "$p"; then
            FAILED+=("npm:$p")
        fi
    done
fi

# ───────────── 3. 설치 확인 ─────────────
echo
echo "==> [3/3] 설치 확인"
MISSING=()
for b in "${CHECK_BINS[@]}"; do
    if path=$(command -v "$b" 2>/dev/null); then
        printf "  OK    %-24s %s\n" "$b" "$path"
    else
        printf "  없음  %-24s\n" "$b"
        MISSING+=("$b")
    fi
done

echo
if [ ${#FAILED[@]} -eq 0 ] && [ ${#MISSING[@]} -eq 0 ]; then
    echo "Python LSP(pyright)가 설치되었습니다."
else
    [ ${#FAILED[@]} -gt 0 ] && echo "설치 실패: ${FAILED[*]}"
    [ ${#MISSING[@]} -gt 0 ] && echo "PATH에서 찾지 못함: ${MISSING[*]}"
    echo
    echo "참고:"
    echo "  - npm 전역 경로가 PATH에 없다면 셸 설정에 추가하세요:"
    echo "      export PATH=\"\$PATH:\$(npm prefix -g)/bin\""
fi

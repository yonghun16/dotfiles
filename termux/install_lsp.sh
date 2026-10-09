#!/data/data/com.termux/files/usr/bin/bash
# Termux용 LSP 일괄 설치 스크립트
# 사용법: bash install_lsp.sh
# 일부 패키지가 실패해도 계속 진행하고, 마지막에 설치 결과를 요약합니다.
# 대상 서버: pyright, ts_ls, html, cssls, eslint, tailwindcss, sqlls, bashls,
#            rust_analyzer, clangd, lua_ls, emmet_language_server

set -u

# ───────────── 설치 목록 ─────────────
# pkg: Termux 저장소 패키지 (안드로이드에서 실행되는 바이너리)
PKG_PACKAGES=(
    nodejs
    git
    rust          # rustc + cargo
    rust-analyzer # Rust LSP
    clang         # C/C++ 컴파일러 + clangd
    lua-language-server
    shellcheck # bash-language-server 진단용
)

# npm: 전역 설치 (Node 기반 서버)
NPM_PACKAGES=(
    typescript
    typescript-language-server     # ts_ls (TypeScript, JavaScript)
    pyright                        # Python
    bash-language-server           # bashls (sh, bash)
    vscode-langservers-extracted   # html, cssls, eslint, json
    "@tailwindcss/language-server" # tailwindcss
    sql-language-server            # sqlls (네이티브 모듈 때문에 실패할 수 있음)
    "@olrtg/emmet-language-server" # emmet
)

# 설치 후 점검할 실행 파일
CHECK_BINS=(
    tsc
    typescript-language-server
    pyright-langserver
    bash-language-server
    shellcheck
    vscode-html-language-server
    vscode-css-language-server
    vscode-eslint-language-server
    tailwindcss-language-server
    sql-language-server
    emmet-language-server
    rust-analyzer
    clangd
    lua-language-server
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
        printf "  OK    %-34s %s\n" "$b" "$path"
    else
        printf "  없음  %-34s\n" "$b"
        MISSING+=("$b")
    fi
done

echo
if [ ${#FAILED[@]} -eq 0 ] && [ ${#MISSING[@]} -eq 0 ]; then
    echo "모든 LSP가 설치되었습니다."
else
    [ ${#FAILED[@]} -gt 0 ] && echo "설치 실패: ${FAILED[*]}"
    [ ${#MISSING[@]} -gt 0 ] && echo "PATH에서 찾지 못함: ${MISSING[*]}"
    echo
    echo "참고:"
    echo "  - npm 전역 경로가 PATH에 없다면 셸 설정에 추가하세요:"
    echo "      export PATH=\"\$PATH:\$(npm prefix -g)/bin\""
    echo "  - sql-language-server는 실패해도 나머지에는 영향이 없습니다."
fi

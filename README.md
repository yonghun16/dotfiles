# dotfiles
<div align="center">
  <img src="https://raw.githubusercontent.com/yonghun16/yonghun16/refs/heads/main/images/nvim_preview.png" width=800px />
</div>


## 1. Neovim(Nvchad)
> Nvchad : https://nvchad.com

### 1) Install
#### 🟢 Install
```bash
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
```
  - Run `:MasonInstallAll` command after lazy.nvim finishes downloading plugins.
  - Delete the `.git` folder from nvim folder.
  - Learn customization of ui & base46 from `:h nvui`.

#### 🟢 Update
  - Run `:Lazy sync`

#### 🟢 Uninstall
```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

### 2) Basic setting
#### 🔵 Package install(Apps, Fonts, Etc)
```bash
git clone https://github.com/yonghun16/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

#### 🔵 Manual plugins install
- package (shell)
  ```bash
  pip3 install debugpy
  ```
  ```bash
  npm install -g eslint
  ```
- Mason (Command-line mode in vim)
  ```bash
  :MasonInstallAll
  ```
- Tree-sitter (Command-line Mode in vim)
  ```bash
  :TSUpdate
  ```
  
### 3) Input & Hangul setting
#### 🟡 Karabiner
> karabiner : https://karabiner-elements.pqrs.org/
  - preset file
    - `karabiner.json`
  - [Complex Modifications] → [Add your own rule]
  - [Devices] → 외장키보드 사용 시 추가

#### 🟡 Gureum
> Gureum : https://gureum.io/
  - Config
    - 로마자로만 바꾸기 단축키 : `^C` (ESC 단축키)
    - 오른쪽 키로 언어 전환 : `Command` (한/영 키 대체)
    - 한자 및 이모지 바꾸기 : `control + shift + spacebar`
    - 한글 입력기 설정 : 모아치기, MS윈도호환, JDK호환, vi모드 
  - Mac 입력 소스 설정
    - [설정] → [키보드] → [키보드 단축키] → [입력소스]
    - 이전 입력 소스 선택 : `contrl + shift + spacebar`
    - 입력 메뉴에서 다음 소스 선택 : 체크해제
  - Detail : [gureum_setting.png](https://github.com/yonghun16/dotfiles/blob/master/gureum/gureum_setting.png), [keyboard_inputsource_setting.png](https://github.com/yonghun16/dotfiles/blob/master/gureum/keyboard_inputsource_setting.png?raw=true)


## 2. Other App Settings
#### 🔴 Zinit
> oh-my-zsh : https://ohmyz.sh/
  - Neofetch
    ```bash
    source ~/.zshrc
    ```

#### 🔴 Ghostty
> Ghostty : https://ghostty.org/
  - install
    ```bash
    brew install --cask ghostty
    ```

#### 🔴 tmux 
> tmux : https://github.com/tmux/tmux/wiki
  - install
  ```bash
  brew install tmux
  ```
  - setting : `.tmux.conf`
    - ```bash
      cp .tmux.conf ~/.tmux.conf
      ```
  - 파일을 수정한 뒤 tmux 안에서:
    - ```bash
      tmux source-file ~/.tmux.conf
      ```


## 3. Neovim Plugins info
#### AI
  - windsurf.vim (AI 코드 자동완성)
  - gemini-cli (AI 코딩 어시스턴트)

#### Coding
  - LuaSnip (스니펫)
  - neogen (함수/클래스 주석 자동 생성)
  - nvim-cmp (코드 자동완성)
  - outline (코드 아웃라인)
  - nvim-ts-autotag (닫는 태그 자동완성)

#### Debugging
  - nvim-dap (Debug Adapter Protocol)
  - js-debug-adapter (JS/TS Debuger)
  - debugpy (Pythion Debuger)

#### Editor
  - fzf-lua (fzf 파일 탐색기 보기)
  - nvim-lastplace (커서 마지막 위치 저장)
  - vim-illuminate (단어 하이라이팅)
  - vim-visual-multi (멀티 커서)

#### LSP & Formatting & Linting & Treesitter
  - mason.nvim (LSP Server Management)
  - conform.nvim (포맷팅)
  - nvim-lint (린팅)
  - nvim-treesitter (문법 강조 및 구문 분석)

#### UI
  - neoscroll.nvim (부드러운 스크롤)

#### Util
  - toggleterm.nvim (플로팅 터미널)
  - which-key.nvim (키맵 도움말)

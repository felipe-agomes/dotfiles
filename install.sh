#!/bin/bash

# --- Testes de Arquivo ---
# -e  Existe? (Qualquer tipo)
# -f  Existe arquivo?
# -d  Existe diretório?
# -L  É link simbólico?
# -s  Tem conteúdo? (Tamanho > 0 bytes)
# -x  É executável?

# --- Testes de String ---
# -z  Está vazia? (Zero length)
# -n  Tem conteúdo? (Non-zero)

# --- Variáveis Especiais ---
# $0  Nome deste script
# $1  Primeiro argumento ($2, $3...)
# $#  Quantidade total de argumentos
# $?  Status do último comando (0 = Sucesso, Outro = Erro)

# --- Debug e Saída ---
# bash -x {SCRIPT} : Roda script exibindo comandos
# set -x           : Ativa debug (mostra o que está fazendo)
# set +x           : Desativa debug
# 2>/dev/null      : Silencia erros (envia para o lixo)

# --- Redirecionamento & Pipes ---
# >   Salva no arquivo (SOBRESCREVE tudo)
# >>  Salva no arquivo (ADICIONA ao final)
# |   Joga a saída de um comando para o próximo
# &>  Redireciona ERRO e SAÍDA juntos

# --- Lógica Curta (One-liners) ---
# &&  Roda SÓ se o anterior DEU CERTO (Sucesso)
# ||  Roda SÓ se o anterior DEU ERRO (Falha)
# Ex: mkdir pasta && cd pasta  (Só entra se criar)
# Ex: git pull || echo "Erro"  (Só avisa se falhar)

# --- Comparação (Cuidado!) ---
# Números: -eq (igual), -ne (diferente), -gt (maior), -lt (menor)
# Textos:  =   (igual), !=  (diferente)
# Ex: [ 1 -eq 1 ]  vs  [ "a" = "a" ]

# --- Captura de Comando ---
# $(comando)  Pega o resultado para usar numa variável
# Ex: HOJE=$(date +%F)

# --- Input & Controle ---
# read VAR        Lê o teclado e salva em $VAR
# read -p "Txt"   Mostra mensagem "Txt" antes de ler (Prompt)
# read -s         Esconde o que digita (Senha/Silent)
# read -r         Lê exatamente o que foi digitado (evita bugs com \)
#
# command         Executa o comando "real", ignorando aliases/funções
# command -v      Verifica se um programa existe (Substituto seguro do 'which')

# --- Redirecionamento de Entrada ---
# < arquivo       Joga o conteúdo do arquivo para dentro do comando
# done < arquivo  Alimenta um loop inteiro com o arquivo


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[AVISO]${RESET} $*"; }
error()   { echo -e "${RED}[ERRO]${RESET}  $*" >&2; }
die()     { error "$*"; exit 1; }

check_installed() {
    command -v "$1" &>/dev/null
}

detect_pkg_manager() {
    if check_installed pacman; then
        PKG_MANAGER="pacman"

        info "Sistema Arch detectado."
    elif check_installed apt; then
        PKG_MANAGER="apt"

        info "Sistema Debian/Ubuntu detectado."
    else
        die "Nenhum gerenciador de pacotes suportado encontrado."
    fi
}

yay_install_dependency() {
    info "Instalando dependências (git, base-devel)..."
    sudo pacman -S --needed --noconfirm git base-devel &>/dev/null
    success "Dependências instaladas."
}

yay_clone_and_install() {
    local tmp_dir
    tmp_dir=$(mktemp -d)

    info "Clonando YAY em ${tmp_dir}..."
    git clone "https://aur.archlinux.org/yay.git" "${tmp_dir}/YAY"
    success "Clonado com sucesso."

    info "Compilando e instalando YAY..."
    cd "${tmp_dir}/YAY"
    makepkg -si --noconfirm
    success "Compilado com sucesso."

    info "Limpando arquivos temporários..."
    cd ~
    rm -rf "${tmp_dir}"
}

yay_install() {
    if check_installed yay; then
        info "YAY já está instalado."
    else
        yay_install_dependency
        yay_clone_and_install
    fi
}

ask_sudo() {
    sudo -v
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

pkg_install() {
    if [[ "${PKG_MANAGER}" == "yay" ]]; then
        yay -S --needed --noconfirm "$@"
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        sudo apt install -y "$@"
    fi
}

pkg_update() {
    if [[ "${PKG_MANAGER}" == "yay" ]]; then
        yay -Syu --noconfirm
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        sudo apt update && sudo apt upgrade -y
    fi
}

install_packages() {
    info "Atualizando sistema..."
    # pkg_update

    info "Instalando pacotes essenciais..."

    # Pacotes com o mesmo nome em ambos os gerenciadores
    local -r COMMON_PACKAGES=(
        git
        curl
        wget
        unzip
        zip
        stow
        zsh
        ripgrep
        htop
        tree-sitter-cli
        wl-clipboard
        lazygit
    )
    pkg_install "${COMMON_PACKAGES[@]}"

    # Pacotes com nomes diferentes por distro
    if [[ "$PKG_MANAGER" == "yay" ]]; then
        pkg_install github-cli
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        pkg_install build-essential gh
    fi
}

# --- Linkando os Dotfiles com Stow ---
link_dotfiles() {
    local -r DOTFILES_DIR="$HOME/dotfiles"

    if [[ ! -d "$DOTFILES_DIR" ]]; then
        die "Diretório $DOTFILES_DIR não encontrado."
    fi

    info "Aplicando configurações com Stow..."
    cd "$DOTFILES_DIR" || die "Não foi possível acessar $DOTFILES_DIR."

    local -r STOW_DIRS=(nvim zsh)

    for dir in "${STOW_DIRS[@]}"; do
        if [[ ! -d "$dir" ]]; then
            warn "Diretório '$dir' não encontrado em dotfiles, pulando..."
            continue
        fi
        stow --restow "$dir" && success "Linkado: $dir" || error "Falha ao linkar: $dir"
    done
}

# --- Instalação de ferramentas de desenvolvimento ---
install_tools() {
    info "Instalando ferramentas de desenvolvimento..."

    # Neovim
    if check_installed nvim; then
        info "Neovim já instalado, pulando..."
    else
        info "Instalando Neovim..."
        if [[ "$PKG_MANAGER" == "yay" ]]; then
            pkg_install neovim
        else
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
                || die "Falha ao baixar Neovim."
            sudo rm -rf /opt/nvim-linux-x86_64
            sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
            [[ -L /usr/local/bin/nvim ]] && sudo rm /usr/local/bin/nvim
            sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
            rm -f nvim-linux-x86_64.tar.gz
        fi
        success "Neovim instalado."
    fi

    # SDKMAN
    if [[ -d "$HOME/.sdkman" ]]; then
        info "SDKMAN já instalado, pulando..."
    else
        info "Instalando SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
        success "SDKMAN instalado."
    fi

    # Oh My Zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        info "Oh My Zsh já instalado, pulando..."
    else
        info "Instalando Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
            || die "Falha ao instalar Oh My Zsh."
        success "Oh My Zsh instalado."
    fi

    # FZF
    if [[ -d "$HOME/.fzf" ]]; then
        info "FZF já instalado, pulando..."
    else
        info "Instalando FZF..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" \
            || die "Falha ao clonar FZF."
        "$HOME/.fzf/install" --all
        success "FZF instalado."
    fi

    # Powerlevel10k
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        info "Powerlevel10k já instalado, pulando..."
    else
        info "Instalando Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" \
            || die "Falha ao clonar Powerlevel10k."
        success "Powerlevel10k instalado."
    fi

    # zsh-autosuggestions
    if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        info "zsh-autosuggestions já instalado, pulando..."
    else
        info "Instalando zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
            || die "Falha ao clonar zsh-autosuggestions."
        success "zsh-autosuggestions instalado."
    fi

    # zsh-syntax-highlighting
    if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        info "zsh-syntax-highlighting já instalado, pulando..."
    else
        info "Instalando zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
            || die "Falha ao clonar zsh-syntax-highlighting."
        success "zsh-syntax-highlighting instalado."
    fi

    # NVM + Node 24
    local NVM_DIR="$HOME/.nvm"
    if [[ -d "$NVM_DIR" ]]; then
        info "NVM já instalado, pulando..."
    else
        info "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
        success "NVM instalado."
    fi

    # shellcheck disable=SC1091
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    if ! nvm ls 24 &>/dev/null; then
        info "Instalando Node 24..."
        nvm install 24 && nvm alias default 24
        success "Node 24 instalado."
    else
        info "Node 24 já instalado, pulando..."
    fi
    nvm use 24 &>/dev/null

    # FVM (Flutter)
    if [[ -d "$HOME/fvm" ]]; then
        info "FVM já instalado, pulando..."
    else
        info "Instalando FVM..."
        curl -fsSL https://fvm.app/install.sh | bash
        success "FVM instalado."
    fi
}

setup_shell() {
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        info "Alterando shell padrão para Zsh..."
        chsh -s "$(which zsh)" || warn "Não foi possível alterar o shell. Rode manualmente: chsh -s $(which zsh)"
        success "Shell alterado para Zsh."
    else
        info "Zsh já é o shell padrão."
    fi
}

main() {
    detect_pkg_manager
    ask_sudo

    if [[ "$PKG_MANAGER" == "pacman" ]]; then
        yay_install
        PKG_MANAGER="yay"
        success "Usando yay como gerenciador."
    fi

    install_packages
    install_tools
    link_dotfiles
    setup_shell

    success "Ambiente configurado com sucesso!"
}

main

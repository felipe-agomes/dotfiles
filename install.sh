#!/bin/bash

# --- Configurações Iniciais ---
DOTFILES_DIR="$HOME/dotfiles"
# Cores para logs bonitos
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Iniciando a configuração do ambiente...${NC}"

# Função para pedir senha sudo antecipadamente
ask_sudo() {
    sudo -v
    while true;
    do sudo -n true;
        sleep 60;
        kill -0 "$$" || exit;
    done 2>/dev/null &
}

# --- 1. Instalação de Pacotes Base (Debian/Ubuntu/WSL) ---
# Se usar Arch ou Fedora, ajuste os comandos (pacman/dnf)
install_packages() {
    echo -e "${GREEN}Instalando pacotes essenciais...${NC}"

    sudo apt update

    # Ferramentas básicas do sistema
    PACKAGES=(
        git
        curl
        wget
        unzip
        stow
        zsh
        build-essential # Necessário para compilar plugins do Neovim (Treesitter)
    )

    # Ferramentas modernas para o terminal (Melhora o Neovim/Fzf)
    PACKAGES+=(
        ripgrep   # Grep super rápido (essencial para Telescope no Nvim)
        fd-find   # Alternativa rápida ao 'find'
        jq        # Processador JSON (útil para scripts)
        htop
    )

    sudo apt install -y "${PACKAGES[@]}"
}

# --- 2. Linkando os Dotfiles com Stow ---
link_dotfiles() {
    echo -e "${GREEN}Aplicando configurações com Stow...${NC}"

    # Entra na pasta dos dotfiles para o stow funcionar corretamente
    cd "$DOTFILES_DIR" || exit

    # Lista de pastas para aplicar o stow
    # Adicione aqui conforme for criando pastas (ex: 'alacritty', 'tmux', 'kitty')
    STOW_DIRS=(
        nvim
    )

    for dir in "${STOW_DIRS[@]}"; do
        # --restow garante que links antigos sejam atualizados/corrigidos
        stow --restow "$dir"
        echo "Configuração linkada: $dir"
    done
}

# --- 3. Ferramentas de Dev (Neovim Oficial & SDKMAN) ---
install_toools() {
    echo -e "${GREEN}Instalando ferramentas de desenvolvimento...${NC}"

    # --- INSTALAÇÃO DO NEOVIM (Versão Github Release) ---
    # Verifica se já está instalado ou se queremos forçar atualização
    echo "Baixando Neovim (Latest Stable)..."

    # 1. Baixa o tarball
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

    # 2. Remove instalação anterior para evitar conflito
    sudo rm -rf /opt/nvim-linux-x86_64

    # 3. Extrai para /opt
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

    # 4. Cria o link simbólico para o comando 'nvim' funcionar globalmente
    # Se já existir um link antigo, remove primeiro
    if [ -L /usr/local/bin/nvim ]; then
        sudo rm /usr/local/bin/nvim
    fi
    sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

    # 5. Limpa o arquivo baixado
    rm nvim-linux-x86_64.tar.gz

    echo "Neovim instalado com sucesso!"

    # --- INSTALAÇÃO DO SDKMAN (Java) ---
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "Instalando SDKMAN!..."
        curl -s "https://get.sdkman.io" | bash
    else
        echo "SDKMAN! já instalado."
    fi

    # --- INSTALAÇÃO DO OH MY ZSH ---
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Instalando Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# --- 4. Configuração Final ---
setup_shell() {
    # Define o Zsh como shell padrão se já não for
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo -e "${BLUE}Alterando shell padrão para Zsh...${NC}"
        chsh -s "$(which zsh)"
    fi
}

# --- Execução ---
ask_sudo
install_packages
# install_tools
# link_dotfiles
# setup_shell

echo -e "${GREEN}Instalação concluída! Reinicie o terminal ou faça logout/login.${NC}"

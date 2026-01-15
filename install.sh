#!/bin/zsh

# Só para documentação de comandos
# -d Verifica se uma pasta existe
# -f Verifica se um arquivo existe
# -z Verifica se a string está vazia
# -s Verifica se existe o arquivo e se tem o tamanho > 0 bite
#
# $0 O nome do próprio script
# $1, $2, $3... Mostra os argumentos passado em ordem
# $# O número total de argumentos passado
# $? Retorno do ultimo comando executado 0 = true; 1 = false
#
# zsh -x {SCRIPT} executa com debug
# set -x ativa o debug dentro do script
# set +x desativa o debug dentro do script
#
# 2>/dev/null redireciona o STDERR para o limbo


# --- Configurações Iniciais ---
DOTFILES_DIR="$HOME/dotfiles"
# Cores para logs bonitos
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
export NVM_DIR="$HOME/.nvm"

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
        zsh
    )

    for dir in "${STOW_DIRS[@]}"; do
        # --restow garante que links antigos sejam atualizados/corrigidos
        stow --restow "$dir"
        echo "Configuração linkada: $dir"
    done
}

# --- 3. Ferramentas de Dev (Neovim Oficial & SDKMAN) ---
install_tools() {
    echo -e "${GREEN}Instalando ferramentas de desenvolvimento...${NC}"

    if ! command -v nvim >/dev/null; then
      echo "${BLUE}Instalando Neovim...${NC}"

      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

      sudo rm -rf /opt/nvim-linux-x86_64

      sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

      if [ -L /usr/local/bin/nvim ]; then
          sudo rm /usr/local/bin/nvim
      fi
      sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

      rm nvim-linux-x86_64.tar.gz
    else
      echo "${BLUE}Neovim já está instalado.${NC}"
    fi

    # --- INSTALAÇÃO DO SDKMAN (Java) ---
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "${BLUE}Instalando SDKMAN!...${NC}"
        curl -s "https://get.sdkman.io" | bash
    else
        echo "${BLUE}SDKMAN! já instalado."
    fi

    # --- INSTALAÇÃO DO OH MY ZSH ---
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "${BLUE}Instalando Oh My Zsh...${NC}"

        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "${BLUE}Oh My Zsh já está instalado.${NC}"
    fi

    if [ ! -d "$HOME/.fzf" ]; then
        echo "${BLUE}Instalando FZF...${NC}"

        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all
    else
        echo "${BLUE}FZF já está instalado.${NC}"
    fi

    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo "${BLUE}Baixando Powerlevel10k...${NC}"

        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    else
        echo "${BLUE}Powerlevel10k já está instalado.${NC}"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "${BLUE}Baixando zsh-autosuggestions...${NC}"

        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        echo "${BLUE}zsh-autosuggestions já está instalado.${NC}"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo "${BLUE}Baixando zsh-syntax-highlighting...${NC}"

        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        echo "${BLUE}zsh-syntax-highlighting já está instalado.${NC}"
    fi

    if [ ! -d "$NVM_DIR" ]; then
        echo "${BLUE}Instalando o NVM...${NC}"

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    else
        echo "${BLUE}NVM já está instalado.${NC}"
    fi


    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if ! nvm ls 24 >/dev/null; then
      echo "${BLUE}Instalando Node 24.${NC}"

      nvm install 24
      nvm use 24
      nvm alias default 24
    else
      echo "${BLUE}Node 24 já está instalado.${NC}"

      nvm use 24 >/dev/null
      nvm alias default 24 >/dev/null
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
# install_packages
install_tools
# link_dotfiles
# setup_shell

echo -e "${GREEN}Instalação concluída! Reinicie o terminal ou faça logout/login.${NC}"

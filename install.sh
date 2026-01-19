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


GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

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

install_packages() {
    echo -e "${GREEN}Instalando pacotes essenciais...${NC}"

    sudo apt update

    PACKAGES=(
        git
        gh
        curl
        wget
        unzip
        stow
        zsh
        ripgrep
        htop
        build-essential # Necessário para compilar plugins do Neovim (Treesitter)
    )

    sudo apt install -y "${PACKAGES[@]}"
}

# --- 2. Linkando os Dotfiles com Stow ---
link_dotfiles() {
    echo -e "${GREEN}Aplicando configurações com Stow...${NC}"

    DOTFILES_DIR="$HOME/dotfiles"
    cd "$DOTFILES_DIR" || exit

    STOW_DIRS=(
        nvim
        zsh
    )

    for dir in "${STOW_DIRS[@]}"; do
        stow --restow  "$dir"
        echo -e "${GREEN}Configuração linkada: ${dir}${NC}"
    done
}

install_tools() {
    echo -e "${GREEN}Instalando ferramentas de desenvolvimento...${NC}"

    if ! command -v nvim >/dev/null; then
        echo -e "${GREEN}Instalando Neovim...${NC}"

        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

        sudo rm -rf /opt/nvim-linux-x86_64

        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

        if [ -L /usr/local/bin/nvim ]; then
            sudo rm /usr/local/bin/nvim
        fi
        sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

        rm nvim-linux-x86_64.tar.gz
    else
        echo -e "${BLUE}Neovim já está instalado.${NC}"
    fi

    # --- INSTALAÇÃO DO SDKMAN (Java) ---
    if [ ! -d "$HOME/.sdkman" ]; then
        echo -e "${GREEN}Instalando SDKMAN!...${NC}"
        curl -s "https://get.sdkman.io" | bash
    else
        echo -e "${BLUE}SDKMAN! já instalado."
    fi

    # --- INSTALAÇÃO DO OH MY ZSH ---
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${GREEN}Instalando Oh My Zsh...${NC}"

        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo -e "${BLUE}Oh My Zsh já está instalado.${NC}"
    fi

    if [ ! -d "$HOME/.fzf" ]; then
        echo -e "${GREEN}Instalando FZF...${NC}"

        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all
    else
        echo -e "${BLUE}FZF já está instalado.${NC}"
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo -e "${GREEN}Baixando Powerlevel10k...${NC}"

        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    else
        echo -e "${BLUE}Powerlevel10k já está instalado.${NC}"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo -e "${GREEN}Baixando zsh-autosuggestions...${NC}"

        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        echo -e "${BLUE}zsh-autosuggestions já está instalado.${NC}"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo -e "${GREEN}Baixando zsh-syntax-highlighting...${NC}"

        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        echo -e "${BLUE}zsh-syntax-highlighting já está instalado.${NC}"
    fi

    NVM_DIR="$HOME/.nvm"
    if [ ! -d "$NVM_DIR" ]; then
        echo -e "${GREEN}Instalando o NVM...${NC}"

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    else
        echo -e "${BLUE}NVM já está instalado.${NC}"
    fi

    # shellcheck disable=SC1091
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    if ! nvm ls 24 >/dev/null; then
        echo -e "${GREEN}Instalando Node 24...${NC}"

        nvm install 24
        nvm alias default 24
    else
        echo -e "${BLUE}Node 24 já está instalado.${NC}"
    fi

    nvm use 24 >/dev/null

    FVM_DIR="$HOME/fvm"
    if [ ! -d "$FVM_DIR" ]; then
        echo -e "${GREEN}Instalando FVM...${NV}"

        curl -fsSL https://fvm.app/install.sh | bash
    else
        echo -e "${BLUE}FVM já está instalado."
    fi

    if ! command -v op >/dev/null; then
        echo -e "${GREEN}Instalando 1password..."

        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
            sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

        echo -e "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
            sudo tee /etc/apt/sources.list.d/1password.list

        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
            curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
            sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

        sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
            sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

        sudo apt update && sudo apt install 1password-cli
    else
        echo -e "${BLUE}1password já está instalado."
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
install_tools
link_dotfiles
setup_shell

echo -e "${GREEN}Instalação concluída! Reinicie o terminal ou faça logout/login.${NC}"

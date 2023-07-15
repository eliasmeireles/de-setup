#!/bin/sh

YELLOW='\e[33m'
RESET='\e[m'

print_msg() {
  printf "${YELLOW}%s${RESET}\n" "$*"
}

print_msg 'Installing o oh-my-zsh'
rm -rf ~/.oh-my-zsh/
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

print_msg 'Installing p10k'
git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-~/.oh-my-zsh}"/themes/powerlevel10k

print_msg 'Installing autocomplete plugin'

rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

cp ./.zshrc ~/

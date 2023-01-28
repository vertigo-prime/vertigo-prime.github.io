#!/usr/bin/env bash
main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  printf "Checking for zsh...\n"
  CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
  if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
    printf "${RED}Zsh is not installed!${NORMAL} Please install zsh first!\n"
    exit
  fi
  unset CHECK_ZSH_INSTALLED

  if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
  fi

  printf "${YELLOW}Checking for oh-my-zsh...${NORMAL}"

  if [ ! -d "$ZSH" ]; then
    printf "\n${RED}Oh My Zsh is not installed.${NORMAL}\n"
    printf "Running sh -c '\$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)'\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
    printf "${GREEN}OH MY ZSH!${NORMAL}\n"
  fi

  printf "${YELLOW}Checking for oh-my-zsh custom theme directory...${NORMAL}"
  if [ ! -d "$ZSH/custom/themes" ]; then
      printf "\n${YELLOW}Custom theme directory does not exist... Creating${NORMAL}\n"
      mkdir "$ZSH/custom/themes"
  else
    printf "${GREEN}Good!${NORMAL}\n"
  fi

  printf "${YELLOW}Checking for oh-my-zsh custom theme (bnvnsn)...${NORMAL}"
  if [ ! -e "$ZSH/custom/themes/bnvnsn.zsh-theme" ]; then
      printf "\n${RED}Custom theme not found... downloading${NORMAL}\n"
      curl -fsSL http://benvinsontech.herokuapp.com/static/profile/bnvnsn.theme > $ZSH/custom/themes/bnvnsn.zsh-theme
  else
      printf "${GREEN}it's there!${NORMAL}\n\n"
  fi

  CUSTOM_THEME_THERE=$(grep '^ZSH_THEME="bnvnsn"' ~/.zshrc | wc -l)
  CUSTOM_THEME_LINE_THERE=$(grep '^ZSH_THEME=' ~/.zshrc | wc -l)
  printf "${YELLOW}Checking for oh-my-zsh custom theme in .zshrc...${NORMAL}"
  if [ ! -e ~/.zshrc ]; then
      printf "\n${RED}.zshrc not found... Please make sure zsh is installed, then running 'touch ~/.zshrc'${NORMAL}\n"
      exit
  else
      if [ ! $CUSTOM_THEME_LINE_THERE -ge 1 ]; then
        echo 'ZSH_THEME="bnvnsn"' >> ~/.zshrc
      elif [ ! $CUSTOM_THEME_THERE -ge 1 ]; then
        sed -i'.old' 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="bnvnsn"/' ~/.zshrc
      else
          printf "${GREEN}it's there too!${NORMAL}\n\n"
      fi
  fi

  AUTO_UPDATE_THERE=$(grep '^DISABLE_UPDATE_PROMPT="true"' ~/.zshrc | wc -l)
  AUTO_UPDATE_LINE_THERE=$(grep '^DISABLE_UPDATE_PROMPT=' ~/.zshrc | wc -l)
  printf "${YELLOW}Checking for oh-my-zsh auto-update option in .zshrc...${NORMAL}"
  if [ ! -e ~/.zshrc ]; then
      printf "\n${RED}.zshrc not found... Please make sure zsh is installed, then running 'touch ~/.zshrc'${NORMAL}\n"
      exit
  else
      if [ ! $AUTO_UPDATE_LINE_THERE -ge 1 ]; then
        echo 'DISABLE_UPDATE_PROMPT="true"' >> ~/.zshrc
        printf "${GREEN}it's there now!${NORMAL}\n\n"
      elif [ ! $AUTO_UPDATE_THERE -ge 1 ]; then
        sed -i'.old' 's/^DISABLE_UPDATE_PROMPT/# DISABLE_UPDATE_PROMPT/' ~/.zshrc
        echo 'DISABLE_UPDATE_PROMPT="true"' >> ~/.zshrc
        printf "${GREEN}it's there now!${NORMAL}\n\n"
      else
          printf "${GREEN}it's there too!${NORMAL}\n\n"
      fi
  fi

  printf "${YELLOW}Setting up your .vimrc file (as in overwriting it)...${NORMAL}"
  curl -fsSL http://vertigo-prime.github.io/cli/vim.rc > ~/.vimrc
  printf " ${GREEN}done${NORMAL}\n"


  printf "${BLUE}All actions complete. \n\nIf you use Ubuntu, make sure you get the fill vim ('sudo apt-get install vim') \n\nFor the terminal, you should logout, then back in for everything to take effect.  -BV${NORMAL}\n\n"

}

main

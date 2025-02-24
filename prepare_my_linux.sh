#! /bin/bash

#================DECLARATION DES VARIABLES=============
CYAN="\e[36m"
GREEN="\e[32m"
YELLOW="\e[33m"
DEFAULT_COLOR="\e[0m"
LAST_LTS_JAVA_VERSION="21.0.2-open"

#================DECLARATION DES FONCTIONS=============
print_installation_of(){
  echo -e "${CYAN}Installation de $1...\n${DEFAULT_COLOR}"
  sleep 1
  cd
}

upgrade(){
  echo -e "${CYAN}Actualisation des packages existants...\n${DEFAULT_COLOR}"
  sleep 1
  sudo apt update
  sudo apt upgrade
}

install_git () {
  print_installation_of "git"

  if ! command -v "git" >/dev/null 2>&1; then
      sudo apt install git
  else
      echo -e "${YELLOW}git est déjà installé vers : $(command -v "git") \n${DEFAULT_COLOR}"
  fi
}

install_oh_my_zsh () {
  print_installation_of "oh-my-zsh"

  if ! command -v "zsh" >/dev/null 2>&1; then
      sudo apt install zsh
      sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  else
      echo -e "${YELLOW}oh-my-zsh est déjà installé vers : $(command -v "zsh") \n${DEFAULT_COLOR}"
    fi
}

install_sdkman () {
  print_installation_of "sdkman"

  chemin_fichier=$(find .sdkman/ -type f -name "sdkman-main.sh" 2>/dev/null)
  if [ -z "$chemin_fichier" ]; then
      curl -s "https://get.sdkman.io" | bash
      sudo chmod +x .sdkman/bin/sdkman-init.sh
      ./.sdkman/bin/sdkman-init.sh
      # Installation et configuration de Java
      gnome-terminal -- bash -c "echo -e '${CYAN}Installation et configuration de Java ${LAST_LTS_JAVA_VERSION}...\n${DEFAULT_COLOR}'; source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java ${LAST_LTS_JAVA_VERSION}"
  else
      echo -e "${YELLOW}SDKMAN est déjà installé vers : $chemin_fichier \n${DEFAULT_COLOR}"
  fi
}

install_jetbrains_toolbox () {
  print_installation_of "jetbrains-toolbox"

  chemin_fichier=$(find .local/share/JetBrains/ -type f -name "jetbrains-toolbox" 2>/dev/null)
  if [ -z "$chemin_fichier" ]; then
      #Installation des dependencies
      sudo apt install libfuse2
      sudo apt install jq

      # Récupérer l'URL de la dernière version de Toolbox
      url=$(echo $(curl -s https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release) | jq -r '.TBA[0].downloads.linux.link')
      wget "$url"
      filename=$(basename "$url")
      tar -xzf "$filename" && rm "$filename" && cd $(basename "$filename" .tar.gz) && ./jetbrains-toolbox
  else
      echo -e "${YELLOW}Jetbrains Toolbox est déjà installé vers : $chemin_fichier \n${DEFAULT_COLOR}"
  fi
}

install_spotify(){
  print_installation_of "spotify"

  if ! command -v "spotify" >/dev/null 2>&1; then
      curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
      echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
      sudo apt update && sudo apt install spotify-client
  else
      echo -e "${YELLOW}Spotify est déjà installé vers : $(command -v "spotify") \n${DEFAULT_COLOR}"
  fi
}

create_workspace(){
  echo -e "${CYAN}Création du dossier Workspaces...\n${DEFAULT_COLOR}"
  sleep 1
  cd
  mkdir -p Workspaces
}

install_postman(){
  print_installation_of "postman"

  if ! command -v "postman" >/dev/null 2>&1; then
      wget "https://dl.pstmn.io/download/latest/linux_64?deviceId=52025c10-7deb-444d-82fa-83f6424f34bb" -O postman-linux-x64.tar.gz
      sudo tar -xzf postman-linux-x64.tar.gz -C /opt && rm postman-linux-x64.tar.gz
      sudo ln -s /opt/Postman/Postman /usr/bin/postman
      cd /usr/share/applications/
      sudo bash -c 'cat <<EOF > postman.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF'
  else
      echo -e "${YELLOW}Postman est déjà installé vers : $(command -v "postman") \n${DEFAULT_COLOR}"
  fi
}

install_snapd(){
  print_installation_of "snapd"

  if ! command -v "snap" >/dev/null 2>&1; then
      sudo mv /etc/apt/preferences.d/nosnap.pref nosnap.pref.backup
      sudo apt update
      sudo apt install snapd
  else
      echo -e "${YELLOW}snapd est déjà installé vers : $(command -v "snap") \n${DEFAULT_COLOR}"
  fi
}

install_flutter(){
  print_installation_of "flutter"

  if ! command -v "flutter" >/dev/null 2>&1; then
      sudo snap install flutter --classic
  else
      echo -e "${YELLOW}flutter est déjà installé vers : $(command -v "flutter") \n${DEFAULT_COLOR}"
  fi
}

#================EXECUTION=============
upgrade
install_git
install_snapd
install_oh_my_zsh
install_sdkman
install_jetbrains_toolbox
install_postman
install_spotify
install_flutter
create_workspace

echo -e "${GREEN}Ton Linux à bien été configuré et est prêt à être utilisé${DEFAULT_COLOR}"

#! /bin/bash

#================README=============
#Ce script permet d'installer les outils de base pour un environnement de development Java sur Linux. Je l'ai monté et
# testé sur un Linux Mint 22.1 Cinnamon. En théorie il doit fonctionner dans d'autres versions de Mint et autres
# distributions sans modifications. Mais si nécessaire, je ferais les modifs pour supporter autres distributions.

#En gros, ce script permet d'installer certains outils avec leurs dependence et voici la liste:
#* git
#* oh-my-zsh
#   * Celui-ci, il te permet d'avoir un terminal customized avec plusieurs options des thèmes disponibles
#* sdkman
#   * Par lui tu pourras gérer facilement les versions des outils comme Java, Kotlin, Maven, Quarkus...
#* jetbrains-toolbox
#   * À partir de lui tu pourras installer tout produit de JetBrains comme IntelliJ, DataGrip, PyCharm...
#* spotify
#* java
#   * La version default de Java est 21.0.2-open
#   * Pour choisir une version différente, il suffit de modifier la variable LAST_LTS_JAVA_VERSION en utilisant une des
#   versions supportée par sdkMan
#* Postman

#Au cas où il y aurais des outils que tu n'aimerais pas installer, il suffit de commenté la ligne qui execute la
#fonction d'installation de l'outil. Pas besoin de commenter toute la fonction

#Le script est divisé en trois parties pour faciliter la compréhension et la modification:
#* La déclaration des variables (Pour changer la version de Java par exemple)
#* La déclaration des fonctions (Elles doivent être quelque part quand-même)
#* L'exécution des fonctions (Ici, tu peux ignorer l'installation de certains outils)


#================DECLARATION DES VARIABLES=============
CYAN="\e[36m"
GREEN="\e[32m"
YELLOW="\e[33m"
DEFAULT_COLOR="\e[0m"
LAST_LTS_JAVA_VERSION="21.0.2-open"

#================DECLARATION DES FONCTIONS=============
upgrade(){
  echo -e "${CYAN}Actualisation des packages...\n${DEFAULT_COLOR}"
  sleep 1
  sudo apt update
  sudo apt upgrade
}

install_git () {
  echo -e "${CYAN}Installation de git...\n${DEFAULT_COLOR}"
  sleep 1
  if ! command -v "git" >/dev/null 2>&1; then
      sudo apt install git
  else
      echo -e "${YELLOW}git est déjà installé vers : $(command -v "git") \n${DEFAULT_COLOR}"
  fi
}

install_oh_my_zsh () {
    echo -e "${CYAN}Installation de oh-my-zsh...\n${DEFAULT_COLOR}"
    sleep 1
    if ! command -v "zsh" >/dev/null 2>&1; then
        sudo apt install zsh
        sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    else
        echo -e "${YELLOW}oh-my-zsh est déjà installé vers : $(command -v "zsh") \n${DEFAULT_COLOR}"
    fi
}

install_sdkman () {
    echo -e "${CYAN}Installation de SDKMAN...\n${DEFAULT_COLOR}"
    sleep 1
    cd
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
    echo -e "${CYAN}Installation de Jetbrains Toolbox...\n${DEFAULT_COLOR}"
    sleep 1
    cd
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
  echo -e "${CYAN}Installation de Spotify...\n${DEFAULT_COLOR}"
  sleep 1
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
  echo -e "${CYAN}Installation de Postman...\n${DEFAULT_COLOR}"
  sleep 1
  cd
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
#================EXECUTION=============

# Positionnement au dossier initial du SO
cd

upgrade
install_git
install_oh_my_zsh
install_sdkman
install_jetbrains_toolbox
install_postman
install_spotify
create_workspace

echo -e "${GREEN}Ton Linux à bien été configuré et est prêt à être utilisé${DEFAULT_COLOR}"

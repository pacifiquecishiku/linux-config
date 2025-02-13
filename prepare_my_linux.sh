#! /bin/bash

CYAN="\e[36m"
GREEN="\e[32m"
DEFAULT_COLOR="\e[0m"
LAST_LTS_JAVA_VERSION="21.0.2-open"


# Positionnement au dossier initial du SO
cd

echo -e "${CYAN}Actualisation des packages...\n${DEFAULT_COLOR}"
sleep 1
sudo apt update
sudo apt upgrade

echo -e "${CYAN}Installation de git...\n${DEFAULT_COLOR}"
sleep 1
sudo apt install git

echo -e "${CYAN}Installation de oh-my-zsh...\n${DEFAULT_COLOR}"
sleep 1
sudo apt install zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo -e "${CYAN}Installation de SDKMAN...\n${DEFAULT_COLOR}"
sleep 1
curl -s "https://get.sdkman.io" | bash
sudo chmod +x .sdkman/bin/sdkman-init.sh
./.sdkman/bin/sdkman-init.sh

# Installation et configuration de Java
gnome-terminal -- bash -c "echo -e '${CYAN}Installation et configuration de Java ${LAST_LTS_JAVA_VERSION}...\n${DEFAULT_COLOR}'; source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java ${LAST_LTS_JAVA_VERSION}"

echo -e "${CYAN}Installation de Jetbrains Toolbox...\n${DEFAULT_COLOR}"
sleep 1
sudo apt install libfuse2
sudo apt install jq

# Récupérer l'URL de la dernière version de Toolbox
url=$(echo $(curl -s https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release) | jq -r '.TBA[0].downloads.linux.link')

# Télécharger le fichier avec wget
wget $url

# Récupérer le nom du fichier téléchargé. (Cela peut changer pour chaque version)
filename=$(basename $url)

tar -xzf $filename && rm $filename && cd $(basename $filename .tar.gz) && ./jetbrains-toolbox

echo -e "${CYAN}Installation de Spotify...\n${DEFAULT_COLOR}"
sleep 1
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install spotify-client

echo -e "${CYAN}Création du dossier Workspaces...\n${DEFAULT_COLOR}"
sleep 1
mkdir -p Workspaces

echo -e "${GREEN}Ton Linux à bien été configuré et est prêt à être utilisé${DEFAULT_COLOR}"

#! /bin/bash

CYAN="\e[36m"
GREEN="\e[32m"
DEFAULT_COLOR="\e[0m"
LAST_LTS_JAVA_VERSION="21.0.2-open"


# Positionnement au dossier inicial du SO
cd

echo -e "${CYAN}Actualisation des packages...\n${DEFAULT_COLOR}"
sudo apt update
sudo apt upgrade

echo -e "${CYAN}Instalation de git...\n${DEFAULT_COLOR}"
sudo apt install git

echo -e "${CYAN}Instalation de oh-my-zsh...\n${DEFAULT_COLOR}"
sudo apt install zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo -e "${CYAN}Instalation de SDKMAN...\n${DEFAULT_COLOR}"
curl -s "https://get.sdkman.io" | bash
sudo chmod +x .sdkman/bin/sdkman-init.sh
./.sdkman/bin/sdkman-init.sh

# Instalation et configuration de Java
gnome-terminal -- bash -c "echo -e '${CYAN}Instalation et configuration de Java ${LAST_LTS_JAVA_VERSION}...\n${DEFAULT_COLOR}'; source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java ${LAST_LTS_JAVA_VERSION}"

echo -e "${CYAN}Création du dossier Workspaces...\n${DEFAULT_COLOR}"
mkdir -p Workspaces

echo -e "${CYAN}Instalation de Jetbrains Toolbox...\n${DEFAULT_COLOR}"
sudo apt install libfuse2
sudo apt install jq

# Récuperer l'url de la dernière version de Tollbox
url=$(echo $(curl -s https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release) | jq -r '.TBA[0].downloads.linux.link')

# Télécharger le fichier avec wget
wget $url

# Récuperer le nom du fichier téléchargé. (Cela peut changer pour chaque version)
filename=$(basename $url)

tar -xzf $filename && rm $filename && cd $(basename $filename .tar.gz) && ./jetbrains-toolbox

echo -e "${GREEN}Ton Linux à bien été configuré et est prêt à être utilisé${DEFAULT_COLOR}"

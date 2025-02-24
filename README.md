# linux-config

## 1. [prepare_my_linux.sh](prepare_my_linux.sh)

[Ce script](prepare_my_linux.sh) permet d'installer les outils de base pour un environnement de development Java sur Linux. Je l'ai monté et
testé sur un Linux Mint 22.1 Cinnamon. En théorie, il doit fonctionner dans d'autres versions de Mint et autres
distributions sans modifications. Mais si nécessaire, je ferais les modifs pour supporter autres distributions.

En gros, ce script permet d'installer certains outils avec leurs dependence et voici la liste :

* git
* oh-my-zsh
    * Celui-ci, il te permet d'avoir un terminal customized avec plusieurs options des thèmes disponibles
* sdkman
    * Par lui, tu pourras gérer facilement les versions des outils comme Java, Kotlin, Maven, Quarkus...
* jetbrains-toolbox
    * À partir de lui, tu pourras installer tout produit de JetBrains comme IntelliJ, DataGrip, PyCharm...
* spotify
* java
    * La version default de Java est 21.0.2-open
    * Pour choisir une version différente, il suffit de modifier la variable LAST_LTS_JAVA_VERSION en utilisant une des
      versions supportée par sdkMan (https://sdkman.io/jdks)
* Postman
* Flutter
* Snap

Au cas où il y aurait des outils que tu n'aimerais pas installer, il suffit de commenté la ligne qui execute la
fonction d'installation de l'outil. Pas besoin de commenter toute la fonction

Le script est divisé en trois parties pour faciliter la compréhension et la modification :

* La déclaration des variables (Pour changer la version de Java par exemple)
* La déclaration des fonctions (Elles doivent être quelque part quand-même).
* L'exécution des fonctions (Ici, tu peux ignorer l'installation de certains outils).
#!/bin/bash

# Vérifie que le script est exécuté en tant que root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root (sudo)."
    exit 1
fi

# Mise à jour des paquets
echo "Mise à jour des paquets..."
apt update

# Installation des dépendances
echo "Installation des dépendances..."
apt install -y ca-certificates curl

# Configuration du dépôt Docker
echo "Configuration du dépôt Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Ajout du dépôt Docker aux sources APT
echo "Ajout du dépôt Docker..."
echo \
  "Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc" | \
  tee /etc/apt/sources.list.d/docker.sources > /dev/null

# Mise à jour des paquets après ajout du dépôt
apt update

# Installation de Docker
echo "Installation de Docker..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Vérification de l'installation
echo "Vérification de l'installation de Docker..."
docker --version
docker compose version

echo "Docker a été installé avec succès !"

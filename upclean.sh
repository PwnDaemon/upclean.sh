#!/bin/bash

## -------------------------------------------------------------------
## SCRIPT DE MANTENIMIENTO COMPLETO (v1.0)
## Descripción: Actualiza, limpia y optimiza sistemas basados en Debian/Ubuntu.
## Autor: PwndDaemon
## Fecha: 2025-11-26
## -------------------------------------------------------------------

export LANG='es_ES.UTF-8'

set -e          
set -u          
set -o pipefail 

# Guarda el tiempo de inicio en segundos
START_TIME=$SECONDS

# Códigos de color ANSI
CYAN='\033[36m'
RESET='\033[0m'
RED='\033[31m'
GREEN='\033[32m'
BOLD='\033[1m'
YELLOW='\033[33m'


handle_error() {
    # $LINENO contiene el número de línea donde ocurrió el error
    echo -e "${BOLD}${RED}[ERROR] El script falló en la línea $1.${RESET} [ERROR]"
    echo -e "${BOLD}${RED}[ERROR] Revise el mensaje de error anterior de APT y resuélvalo.${RESET} [ERROR]\n"
 }

trap 'handle_error $LINENO' ERR

# Limpiar la pantalla de la terminal
clear

echo -e "${BOLD}${YELLOW}[!] Iniciando mantenimiento completo del sistema [!]${RESET}"
echo "Inicio: $(date)"
echo

# 1. Actualización de paquetes
echo -e "${BOLD}${CYAN}[*] Actualización de la lista de pquetes [*]${RESET}"
echo
sudo apt update || { echo "Error en apt update. Terminando."; exit 1; }
echo

echo -e "${BOLD}${CYAN}[*] Actualizando paquetes instalados [*]${RESET}"
echo
sudo apt upgrade -y || { echo "Error en apt upgrade. Continuando con la limpieza."; }
echo

echo -e "${BOLD}${CYAN}[*] Actualización completa [*]${RESET}"
echo
sudo apt full-upgrade -y || { echo "Error en apt full-upgrade. Continuando con la limpieza."; }
echo

echo -e "${BOLD}${CYAN}[*] Actualización de la distribución [*]${RESET}"
echo
sudo apt dist-upgrade -y || { echo "Error en apt dist-upgrade. Continuando con la limpieza."; }
echo

# 2. Limpieza del sistema
echo -e "${BOLD}${CYAN}[*] Borrando archivos .deb desactualizados [*]${RESET}"
echo
sudo apt clean
echo

echo -e "${BOLD}${CYAN}[*] Borrando dependencias huerfanas [*]${RESET}"
echo
sudo apt autoremove -y
echo

echo -e "${BOLD}${CYAN}[*] Limpieza de caché de paquetes desactualizados [*]${RESET}"
echo
sudo apt autoclean
echo

# --- Cálculo del tiempo transcurrido ---
END_TIME=$SECONDS
DURATION=$((END_TIME - START_TIME))
HOURS=$((DURATION / 3600))
MINUTES=$(( (DURATION % 3600) / 60 ))
SECONDS_FINAL=$((DURATION % 60))

echo -e "\n${BOLD}${YELLOW}[!] Mantenimiento finalizado [!]${RESET}"
echo "Fin: $(date)"
echo -e "\n${BOLD}Tiempo total transcurrido: ${HOURS} horas, ${MINUTES} minutos y ${SECONDS_FINAL} segundos.${RESET}"
echo -e ""
echo -e "\n${BOLD}${GREEN}[*] Hasta la vista baby! [*]${RESET}\n"
echo -e""


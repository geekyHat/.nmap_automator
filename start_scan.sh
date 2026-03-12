#!/bin/bash

# --- CONFIGURAZIONE COLORI ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- DEFINIZIONE PERCORSI ---
REAL_USER=$(logname)
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
BASE_DIR="$REAL_HOME/.nmap_automator"
MODULES_DIR="$BASE_DIR/modules"
CORE_DIR="$BASE_DIR/core"

# --- IMPORT MODULI CORE ---
source "$CORE_DIR/config_mgr.sh"
source "$CORE_DIR/menu_mgr.sh"
source "$CORE_DIR/executor.sh"

# --- CONTROLLO ROOT ---
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] Errore: Esegui con sudo.${NC}"
   exit 1
fi

# --- AVVIO SESSIONE ---
clear
echo -e "${BLUE}=== NMAP AUTOMATOR FRAMEWORK v2.0 ===${NC}"

# Carica l'IP precedente o mostra la cronologia
show_history 

# Se TARGET è stato impostato correttamente, salviamo e mostriamo il menu
if [[ ! -z "$TARGET" ]]; then
    save_session "$TARGET"
    show_categories
else
    echo -e "${RED}[!] Nessun target selezionato. Uscita.${NC}"
    exit 1
fi

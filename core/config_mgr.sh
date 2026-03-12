#!/bin/bash

# --- CONFIGURAZIONE FILE DI SESSIONE ---
SESSION_FILE="$BASE_DIR/.session"
HISTORY_FILE="$BASE_DIR/.history"

# Funzione per caricare l'ultimo IP utilizzato
load_session() {
    if [[ -f "$SESSION_FILE" ]]; then
        LAST_IP=$(cat "$SESSION_FILE")
    else
        LAST_IP=""
    fi
}

# Funzione per salvare l'IP attuale come sessione attiva
save_session() {
    local ip=$1
    echo "$ip" > "$SESSION_FILE"
    update_history "$ip"
}

# Gestione della cronologia (mantiene gli ultimi 5 target unici)
update_history() {
    local ip=$1
    if [[ -f "$HISTORY_FILE" ]]; then
        # Rimuove l'IP se già presente, aggiunge in testa e tiene solo 5 righe
        (echo "$ip"; grep -v "^$ip$" "$HISTORY_FILE") | head -n 5 > "$HISTORY_FILE.tmp"
        mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    else
        echo "$ip" > "$HISTORY_FILE"
    fi
}

# Funzione per mostrare e scegliere dalla cronologia
show_history() {
    if [[ -f "$HISTORY_FILE" ]]; then
        echo -e "\n${BLUE}[*] Target recenti:${NC}"
        local i=1
        mapfile -t history_ips < "$HISTORY_FILE"
        for ip in "${history_ips[@]}"; do
            echo -e "${YELLOW}$i)${NC} $ip"
            ((i++))
        done
        echo -e "${YELLOW}n)${NC} Inserisci un nuovo IP"
        read -p "Scelta: " HIST_CHOICE

        if [[ "$HIST_CHOICE" =~ ^[1-5]$ ]]; then
            TARGET="${history_ips[$((HIST_CHOICE-1))]}"
        else
            read -p "Nuovo IP Target: " TARGET
        fi
    else
        read -p "Inserisci l'IP del Target: " TARGET
    fi
}

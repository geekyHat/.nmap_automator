#!/bin/bash

# Funzione per gestire l'esecuzione effettiva
run_execution() {
    local module_path=$1

    # Estrazione dati dallo YAML (usando head -n 1 per sicurezza)
    local mod_name=$(grep "name:" "$module_path" | head -n 1 | cut -d'"' -f2)
    local raw_cmd=$(grep "command:" "$module_path" | head -n 1 | cut -d'"' -f2)

    # Verifica se il comando è stato estratto correttamente
    if [[ -z "$raw_cmd" ]]; then
        echo -e "${RED}[!] Errore: Impossibile estrarre il comando da $module_path${NC}"
        return 1
    fi

    # Configurazione directory di output
    local workdir="Target_$TARGET"
    local logdir="$workdir/log"
    local log_file="$logdir/${TARGET}-${mod_name}.txt"

    # Creazione cartelle
    mkdir -p "$logdir"

    echo -e "\n${BLUE}==================================================${NC}"
    echo -e "${GREEN}[+] ESECUZIONE MODULO:${NC} $mod_name"
    echo -e "${GREEN}[+] TARGET:${NC} $TARGET"
    echo -e "${GREEN}[+] LOG:${NC} $log_file"
    echo -e "${BLUE}--------------------------------------------------${NC}"
    echo -e "${YELLOW}[*] Comando in esecuzione:${NC}"
    echo -e "    $raw_cmd $TARGET -oN $log_file"
    echo -e "${BLUE}==================================================${NC}\n"

    # Esecuzione effettiva
    # Utilizziamo 'eval' per gestire correttamente stringhe complesse con flag e spazi
    eval "$raw_cmd $TARGET -oN $log_file"

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}[✓] Scansione completata con successo.${NC}"
    else
        echo -e "\n${RED}[X] Errore durante l'esecuzione di Nmap.${NC}"
    fi

    echo -e "${BLUE}[i] Premi Invio per tornare al menu...${NC}"
    read
    show_categories # Ritorna al menu principale per nuove scansioni
}

#!/bin/bash

# Funzione per mostrare le categorie (sottocartelle di modules/)
show_categories() {
    echo -e "\n${BLUE}=== CATEGORIE DISPONIBILI ===${NC}"
    
    # Crea un array con le sottocartelle
    categories=($(find "$MODULES_DIR" -maxdepth 1 -type d | sed "1d"))
    
    if [ ${#categories[@]} -eq 0 ]; then
        echo -e "${RED}[!] Nessuna categoria trovata in $MODULES_DIR${NC}"
        exit 1
    fi

    for i in "${!categories[@]}"; do
        # Mostra solo il nome della cartella, non il percorso intero
        cat_name=$(basename "${categories[$i]}")
        echo -e "${YELLOW}$((i+1)))${NC} $cat_name"
    done
    echo -e "${YELLOW}q)${NC} Esci"

    read -p "Seleziona una categoria: " CAT_CHOICE
    if [[ "$CAT_CHOICE" == "q" ]]; then exit 0; fi

    SELECTED_CAT="${categories[$((CAT_CHOICE-1))]}"
    show_modules "$SELECTED_CAT"
}

# Funzione per mostrare i moduli YAML dentro la categoria scelta
show_modules() {
    local cat_path=$1
    echo -e "\n${BLUE}--- MODULI IN $(basename "$cat_path") ---${NC}"
    
    modules=("$cat_path"/*.yaml)
    
    if [ ! -e "${modules[0]}" ]; then
        echo -e "${RED}[!] Nessun modulo YAML trovato in questa categoria.${NC}"
        return
    fi

    for i in "${!modules[@]}"; do
        m_name=$(grep "name:" "${modules[$i]}" | cut -d'"' -f2)
        m_desc=$(grep "description:" "${modules[$i]}" | cut -d'"' -f2)
        echo -e "${YELLOW}$((i+1)))${NC} ${GREEN}$m_name${NC}"
        echo -e "   ${BLUE}↳${NC} $m_desc"
    done
    echo -e "${YELLOW}b)${NC} Torna alle categorie"

    read -p "Scegli un modulo: " MOD_CHOICE
    if [[ "$MOD_CHOICE" == "b" ]]; then show_categories; return; fi

    SELECTED_MODULE="${modules[$((MOD_CHOICE-1))]}"
    
    # Una volta selezionato, passiamo i dati all'executor
    run_execution "$SELECTED_MODULE"
}

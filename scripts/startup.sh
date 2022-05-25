#!/bin/bash
set -e
source /Log4Bash/log4bash.sh


function envCheck() {
    true;
}

function setConfig() {
    DEBUG "Changing dir to DICK"
    cd /home/undies/ass/dick/src
    INFO "Setting DICK config from .env"
    cp ./constants.ts.example ./constants.ts
    # Replace ASS_SECURE = false with ASS_SECURE = $DICK_SECURE
    DEBUG "Setting ASS_SECURE to $DICK_SECURE/" 
    sed -i "s/ASS_SECURE = false/ASS_SECURE = $DICK_SECURE/" ./constants.ts
    DEBUG "Setting PORT"
    sed -i "s/3000/$DICK_PORT/" ./constants.ts
    DEBUG "Setting staff IDs"
    # Skipping for now lmao
}


function takeOffUndies() {
    envCheck
    setConfig
    # Start dick frontend server
    cd /home/undies/ass/dick
    npm start
}

takeOffUndies
#!/usr/bin/env bash


set -e
source /Log4Bash/log4bash.sh


function envInstall() {
    # Start dick frontend server
    cd /home/undies/ass/dick
    INFO "Installing dependencies for DICK"
    npm i
    # Genereate files so that ass can start dick up itself
    npm run build
    # Start ass backend server
    cd /home/undies/ass
    INFO "Installing dependencies for ASS"
    npm i --save-dev
    npm run build

    # ---------------------------------
    # Check if ./auth.json is empty
    if [ ! -s auth.json ]; then
        # If it is empty, create it
        echo "{}" > ./auth.json
        npm run new-token ass
    fi

    # Check if ./data.json is empty
    if [ ! -s data.json ]; then
        echo "{}" > ./data.json
    fi
}

function envCheck() {
    true;
}

function envPrep() {
    INFO "Setting Dick as the frontend server"
    # Replace all the contents of /home/undies/ass/.gitmodules with
    #
    # [submodule "dick"]
	# path = dick
	# url = https://github.com/Facinorous-420/dick.git
    cd /home/undies/ass
    echo '[submodule "dick"]' > ./gitmodules
	echo "  path = dick" >> ./gitmodules
	echo "  url = https://github.com/Facinorous-420/dick.git" >> ./gitmodules
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
    
    # ---------------------------------
    cd /home/undies/ass
    NOTICE "Generating config.json"
    # Recreate the config.json file
    # Example data:
    # {
    #     "host": "0.0.0.0",
    #     "port": 40115,
    #     "domain": "upload.example.com",
    #     "maxUploadSize": 500,
    #     "isProxied": true,
    #     "useSsl": true,
    #     "resourceIdSize": 12,
    #     "resourceIdType": "random",
    #     "spaceReplace": "_",
    #     "gfyIdSize": 2,
    #     "mediaStrict": false,
    #     "viewDirect": false,
    #     "dataEngine": "@tycrek/papito",
    #     "frontendName": "dick",
    #     "indexFile": "",
    #     "useSia": false,
    #     "s3enabled": false,
    #     "s3endpoint": "sfo3.digitaloceanspaces.com",
    #     "s3bucket": "bucket-name",
    #     "s3usePathStyle": false,
    #     "s3accessKey": "accessKey",
    #     "s3secretKey": "secretKey",
    #     "__WARNING__": "The following configs are no longer used and are here for backwards compatibility. For optimal use, DO NOT edit them.",
    #     "diskFilePath": "uploads/",
    #     "saveWithDate": true,
    #     "saveAsOriginal": false
    # }
    host="$ASS_HOST"
    port="$ASS_PORT"
    domain="$ASS_DOMAIN"
    maxUploadSize="$ASS_MAX_UPLOAD_SIZE"
    isProxied="$ASS_IS_PROXIED"
    useSsl="$ASS_USE_SSL"
    resourceIdSize="$ASS_RESOURCE_ID_SIZE"
    resourceIdType="$ASS_RESOURCE_ID_TYPE"
    spaceReplace="$ASS_SPACE_REPLACE"
    gfyIdSize="$ASS_GFYID_SIZE"
    mediaStrict="$ASS_MEDIA_STRICT"
    viewDirect="$ASS_VIEW_DIRECT"
    dataEngine="$ASS_DATA_ENGINE"
    frontendName="$ASS_FRONTEND_NAME"
    indexFile="$ASS_INDEX_FILE"
    useSia="$ASS_USE_SIA"
    s3enabled="$ASS_S3ENABLED"
    s3endpoint="$ASS_S3ENDPOINT"
    s3bucket="$ASS_S3BUCKET"
    s3usePathStyle="$ASS_S3_USE_PATH_STYLE"
    s3accessKey="$ASS_S3ACCESSKEY"
    s3secretKey="$ASS_S3SECRETKEY"


    # Generate the config.json file
    {
        echo "{" > config.json
        echo "  \"host\": \"$host\"," 
        echo "  \"port\": $port," 
        echo "  \"domain\": \"$domain\"," 
        echo "  \"maxUploadSize\": $maxUploadSize," 
        echo "  \"isProxied\": $isProxied," 
        echo "  \"useSsl\": $useSsl," 
        echo "  \"resourceIdSize\": $resourceIdSize," 
        echo "  \"resourceIdType\": \"$resourceIdType\"," 
        echo "  \"spaceReplace\": \"$spaceReplace\"," 
        echo "  \"gfyIdSize\": $gfyIdSize," 
        echo "  \"mediaStrict\": $mediaStrict," 
        echo "  \"viewDirect\": $viewDirect," 
        echo "  \"dataEngine\": \"$dataEngine\"," 
        echo "  \"frontendName\": \"$frontendName\"," 
        echo "  \"indexFile\": \"$indexFile\"," 
        echo "  \"useSia\": $useSia," 
        echo "  \"s3enabled\": $s3enabled," 
        echo "  \"s3endpoint\": \"$s3endpoint\"," 
        echo "  \"s3bucket\": \"$s3bucket\"," 
        echo "  \"s3usePathStyle\": $s3usePathStyle," 
        echo "  \"s3accessKey\": \"$s3accessKey\"," 
        echo "  \"s3secretKey\": \"$s3secretKey\"," 
        echo "  \"__WARNING__\": \"The following configs are no longer used and are here for backwards compatibility. For optimal use, DO NOT edit them.\"," 
        echo "  \"diskFilePath\": \"uploads/\"," 
        echo "  \"saveWithDate\": true," 
        echo "  \"saveAsOriginal\": false" 
        echo "}" 
    } >> config.json
}


function takeOffUndies() {
    envCheck
    NOTICE "Preparing environment"
    envPrep
    NOTICE "Setting configuration"
    setConfig
    NOTICE "Beginning dependency installs"
    envInstall
    INFO "Starting up Dick frontend server"
    INFO "Starting ASS Backend server"
    bash -c "cd /home/undies/ass/; cat ./auth.json;npm start"
}

takeOffUndies
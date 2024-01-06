#!/bin/bash

banner=$'
   _____  ____   _____   ______   _____ __     __ _____ 
  / ____|/ __ \ |  __ \ |  ____| / ____|\ \   / // ____|
 | |    | |  | || |  | || |__   | (___   \ \_/ /| (___  
 | |    | |  | || |  | ||  __|   \___ \   \   /  \___ \ 
 | |____| |__| || |__| || |____  ____) |   | |   ____) |
  \_____|\____/ |_____/ |______||_____/    |_|  |_____/ 
                                                        
'

java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

if [[ "$java_version" == 17* ]]; then
    
    cat <<< "$banner"

    echo " > [CODESYS APK BUILDER] Building apk..."
    npm run ng build --configuration=production
    wait $!

    mv www/browser/* www/ && rm -r www/browser
    wait $!

    if [ ! -d "android" ]; then
        ionic capacitor add android
        wait $!
    fi

    echo sdk.dir = ../android-sdk > android/local.properties
    
    ionic capacitor copy android --no-build && cd android && ./gradlew assembleDebug && cd ..
    wait $!
    
    if [ ! -d "android-apk" ]; then
        mkdir android-apk 
        wait $!
    fi

    name=$(grep '"name":' package.json | awk -F'"' '{print $4}')
    version=$(grep '"version":' package.json | awk -F'"' '{print $4}')
    
    rm android-apk/*
    wait $!
    
    mv android/app/build/outputs/apk/debug/app-debug.apk "android-apk/${name}-${version}_latest.apk"
    wait $!

    rm -r android
    rm -r www

    echo "✔ APK build completed successfully."
else
    echo "Error: JDK version needs to be 17. Check your JAVA_HOME env and JRE"
fi




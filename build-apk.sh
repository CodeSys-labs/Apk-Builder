#!/bin/bash

banner=$'
   _____  ____   _____   ______   _____ __     __ _____ 
  / ____|/ __ \ |  __ \ |  ____| / ____|\ \   / // ____|
 | |    | |  | || |  | || |__   | (___   \ \_/ /| (___  
 | |    | |  | || |  | ||  __|   \___ \   \   /  \___ \ 
 | |____| |__| || |__| || |____  ____) |   | |   ____) |
  \_____|\____/ |_____/ |______||_____/    |_|  |_____/ 

               __         __          _ __    __         
  ____ _____  / /__      / /_  __  __(_) /___/ /__  _____
 / __ `/ __ \/ //_/_____/ __ \/ / / / / / __  / _ \/ ___/
/ /_/ / /_/ / ,< /_____/ /_/ / /_/ / / / /_/ /  __/ /    
\__,_/ .___/_/|_|     /_.___/\__,_/_/_/\__,_/\___/_/     
    /_/                                                                                                
                                                        
'

java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

cat <<< "$banner"

if grep -q '"@capacitor/cli":' package.json; then
    echo "✔ Ionic Capacitor installation verified."

    capacitor_version=$(grep -oP '"@capacitor/cli": "\K[^"]+' package.json)

    if [[ ! "$capacitor_version" == "5.6.0" ]]; then
        echo "Warning: Ionic Capacitor version is not 5.6.0 maybe this script isn't compatible"
    fi

else
    echo "Error: Ionic Capacitor is not present in package.json. Please add it as a dependency."
    exit 1
fi

if grep -q '"@angular/core":' package.json; then
    echo "✔ Angular installation verified."
    
    

    angular_version=$(grep -oP '"@angular/core": "\K[^"]+' package.json)


    if [[ ! "$angular_version" == "^17.0.2" ]]; then
        echo "Warning: Angular version is not 17.0.2 maybe this script isn't compatible"
    fi

else
    echo "Error: Angular is not present in package.json. Please add it as a development dependency."
    exit 1
fi

if [[ "$java_version" == 17* ]]; then
    
    echo 
    echo "> [CODESYS APK BUILDER] Building apk..."
    
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
    
    echo
    echo "✔ APK build completed successfully."
else
    echo "Error: JDK version needs to be 17. Check your JAVA_HOME env and JRE"
    exit 1

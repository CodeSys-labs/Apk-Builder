# CodeSys Apk-Builder
<br>
Shell script to build apk in angular-ionic projects. <br>
This script works with the 'android-sdk' folder, witch contains minimized popular libreries of the android-sdk to build your apk project. Then Ionic going to provide you an 'android' folder with Graddle 8.0 standalone implementation to finish the job.

#### Requirements:
To run this script you going to need the following:
   - Java 17
   - Angular ^17.0.2
   - Ionic CLI 7.1.6

#### How to use it
  - Put <strong>'android-sdk'</strong> directory and <strong>./build-apk</strong> script in the root folder of your Angular-Ionic project.
  - If you want to change the location of 'android-sdk' directory you can change the "echo sdk.dir = ../android-sdk > android/local.properties" line in the .sh script.
  - Then use the following command in a bash based therminal inside the root folder of your Angular-Ionic project:

```shell
./build-apk
```
  - You can find your new .apk file in <strong>android-apk</strong> generated directory, ready to deploy to dev/prod environments. 


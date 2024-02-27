### Understaing the Project Struture
We know the Android app with Gradle has follow some predifined strucure as such:
`:app` module must be under a parent Gradle direcotory,where the parent direcotory has:
a `build.gradle`,`setting.gradle`,`local.properites`,...etc.
if we want to build the app ,then we must need to navigate the project root directory and then need to run the gradle command such as: `gradlde assembleDebug` to build the debug.

if we take the advantages of Android or IntejIDEA auto suggestion and other help,then we have to open the root directory in the studio,otherwise the IDE unable to detect the root direcotory and it not able to provide us the feature or benefit.

This the concept.

The Flutter Root is not follow any Gradle strucuture,it root is followed it own structure,so we have to follow this structure.

The flutter  root is itself a package(same as Gradle module).so it need at least the following files:



`flutter create --no-pub my_app`



### Proje

_Let create the project manually:

Let create the package:
create a root dircory, with lib and pubspec.yaml as:

- my_app
    - lib
      - main.dart 
    - pubspec.yaml

define the dependecy and other in the pubspec.yaml,
then download the dependency(like gradle sync) using the command:

` flutter pub get`

after this command run the, the `.dart_tool` and `pubspec.lock` will be created in the root direcotry.

since those are automatically created so if you remove theme for some reason,then to generate them run the command again.


once the dependency is downloaded and the project is synced,

Run the following(optinal) command to perform a code analysis, checking for any issues or errors:
`flutter analyze`

till now we do not add any platform ,
let add the web platform by the command:

`flutter create --platforms=web .`
this will create a web platform in the root project.
with the:
test
web
.gitignore
.metadata
analysis_operations.yaml

you can remove the "test" direcotory since it is for unit test.
also if we do not using git then you can remove the "git igonre also"

then to run the web target use:
`flutter run -d chrome`

Note that the :
`.idea`,`.vs_code`,`yyy.iml`  these are IDE specfic file,if you removed them by mistake,and the IDE do not show the project structure,then clean the project using 
`flutter clean` and close the IDE and open again,that will be worked insha-allah.

adding android target
`flutter create --platforms=android .`
note the dot(.) represent the current directory so make sure 
you are in the root project

to run the android target `flutter run -d DeviceName`,from the 
direcory where the 'android` direcory is present,
or use `flutter run`

creating target under nested direcory,
if you want to create the target not in the root direcoty instead inside another direcotory then must create a separat package with:
packageName
pubspec.yaml
lib
 main.dart


then add this project dependency into the  root module `pubspec.yaml`
now synce the project using `flutter pub get` 

after that open the terminal and move to this direcotory and create your target.example as for creating android target use the command

`flutter create --platforms=android .`

Note that Though to be a `packge` the `lib` direcoty is optional,but since this package will contain the `platform` sub package so it must need a `lib/main.dart`,otherwise,it will not the apk or the target platform app will not build and run.





since we now the target is not under the root,so some IDE such as android studio or vs code may not able to run the app using the command `flutter run ` or `flutter run -d DeviceName` .
in that case,IDE may be behave differently.
in case of android studio, go to the package direcotory(not the flutter project root);where your `androd` direcotory is located,using `cd ...` ,then run the command such as  `flutter run ` or `flutter run -d DeviceName` . or if these not work use the `.\gradlew.bat assembleDebug` to make the debug build.

note that your target will run insha-allah,but depends on the IDE or terminal it might show error,so  try these command from the correct directory,it will work.

Since the Android Studio is follow the Gradle project strcuture,so open the   open the `android` direcotory only(ignoring the it parent directory) as android projec,it will work fine insha-allah._








### Creating own Package(Equivalent to JavaModule)
<details>
.dart_tool
it wil be auto generated,same as .gradle folder,if you delete it then no problem,
later when running app or command it will be generated automatically.
do not push it in the github repository.

then create a pub.yml file

```yaml
name: module_name
description: "A new Flutter plugin project."
version: 0.0.1
homepage:

environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: '>=3.3.0'

dependencies:
  flutter:
    sdk: flutter
  plugin_platform_interface: ^2.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:

  plugin:
    platforms:

      some_platform:
        pluginClass: somePluginClass


```
then sync the project ,then it will be turned into a package(kind of java module)

pubseclock.yaml, .dart_tool ,will generated upon sync.

to import a package we have use use the `package` ,keyword,that is not needed 
for relative or absolute paths (that are not package),
```dart
import 'package:flutter/material.dart';

```

then you should define the public api or sub module under the `lib` directory,but while importing and mentining the full path do not need to use the 'lib' as path example as:

I have the project structure as:
- applications
  - lib
    - hello.dart


,now while importing use 
```dart
import 'package:applications/hello.dart';

```
so here need not to explicitly mention 'lib' because of it semantically public by flutter tool(flutter build tool),it will cause errors if you mention explicitly.

 </details>

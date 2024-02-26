###

<details>

<summary> The Dart command-line tool </summary>

the **in/dart** or `dart tool(bin/dart)` is a command line tool that come with the dart sdk.

this tool includes the command for :

- creating
- running
- testing
- analyzing
  the dart file or program

For creating a dart console application use the command:

```
dart create -t console appName
```

For creating a dart new project:

```
dart create   projectName
```

For running a dart file that has main function:

```
dart run fileName.dart
```

Note since this is going to run in Dart Vm so do not need to compile before running.

Example let we have the file, `HelloWorld.dart`

```dart
void main() {
  print('Hello, World!');
}

```

since this has the main function,so we can run it using command line as:

```
dart run HelloWorld.dart
```

or

```
dart run .\HelloWorld.dart
```

so you can specify the full path when running it.

#### compiling to a target platform

if we want to compile the dart source files to
a target platform such as Windows(exe) then use the command:

```
dart compile exe .\HelloWorld.dart
```

it will compile the dart file to exe file,but you can not directly run it.

For more information visit the official [docs](https://dart.dev/tools/dart-tool)

</details>

<!-- <details>
<summary> <summary>
</details> -->

### Importing external files and dependencies

#### Java/Kotlin import vs Dart import

<details>
let we have the following project structure
###### Folder Structure

- MyApp
  - app
    - Main.dart
  - feature
    - calculator
      - Adder.dart

###### Codes

<details>

<summary> Main.dart </summary>

```dart
import '../feature/calculator/Adder.dart';
void main(){
  Adder myAdder = Adder();
  int sum = myAdder.add(5, 3);
  print('Sum: $sum');

}

```

</details>
<details>

<summary> Adder.dart </summary>

```dart
class Adder {
  int add(int a, int b) {
    return a + b;
  }
}
```

</details>

###### Conclusions

we can see that in dart we do not need to use `package ` keyword in each and every file ,that means in java/kotlin we have to use the

`package ` keyword to define in which package this file is belong to each and every file regardless of the directory name.

but in dart we do not have any `package ` keyword and we do not have to define the file in which package it belongs to,instead we have to use the direct full path of the file,in order to access it from another file.

but we should not do relative path imports that we do in this section because this might break code when we have folder strture or file name has changed or some other reason,to avoid this use the modularization concept known as `Package ( not java/kotlin package) ` in Packing section.
read more about,why avoid relative path [imports](https://dart.dev/tools/linter-rules/avoid_relative_lib_imports)

</details>

#### Modularization(Package(not package))

In java or kotlin we have modules,the same equivalent is here is the `package`,not that dart `Package` is not the same as java/kotlin `package` ,in dart there is no equivalent to java/kotlin `package` .

but there is equivalent to `module` of java/kotlin in dart,these module are called `Package` in dart world.

##### Package Layout or folder structure conventions

<details>

<summary> pubspec.yaml </summary>
we know  the Gradle declare a directory as a module if and only if that directory has  a `build.gradle` in it root.
if  a directory has no `build.gradle` then we can not say that directory is to be a module,
same in in dart world a directory will be declared as `Package` is it has a `pubspec.yaml` in the root.

so in order to declare a directory as `Package`, we have to create a `pubspec.yaml` file in the root that is equivalent to to the `build.gradle`.

</details>

<details>

<summary> .dart_tool/ * </summary>
we have the `.gradle` folder in a gradle module that do 
something for Gradle,we never touch it,because it contains something that are needed to run the gradle command,
same as in dart `Package` the `.dart_tool/` folder for running the 
several commands for this dart module,so we never going to touch it.
we we run the command `dart pub get` then this directory is created,we should not upload this git directory to the github,so we can git ignore it.

</details>

<details>

<summary> pubspec.lock </summary>

this a generated file,it generated if somehow `dart pub get` command it called,either by any internal command or external command,either by us or by dart sdk.
same as, Running `dart pub get`, `dart pub upgrade`, or `dart pub downgrade` on the package creates a lockfile, named `pubspec.lock`. If your package is an application package, check the lockfile into source control. Otherwise, don't.

</details>

<details>

<summary> lib </summary>

this sub directory is going to public to the other `Package(module)` that is going to import or implement this module.

In order to make a API/libraries(sub modules) public,we must have to put those APIs in this directory.

Note that only libraries should be in lib. Entrypoints—Dart scripts with a main() function—cannot go in lib. If you place a Dart script inside lib, you will discover that any package: imports it contains don't resolve. Instead, your entrypoints should go in the appropriate entrypoint directory.

</details>

<details>

<summary> lib/src </summary>

we we want to internal implementation or api that we don't expose as public,that should not put directly inside the 'lib' root,instead we can create sub directories such as `lib/src` or with any name,that directory will be used as internal directory,these are should not be import or accessible by other `modules(Package)`

</details>

<details>

<summary> bin </summary>

this sub directory is going to public to the other `Package(module)` that is going to import or implement this module.

but in this directory we never put any libraries,instead put the tools here that you want to make public.

Dart scripts placed inside of the bin directory are public. If you're inside the directory of a package, you can use dart run to run scripts from the bin directories of any other package the package depends on. From any directory, you can run scripts from packages that you have activated using dart pub global activate.

If you intend for your package to be depended on, and you want your scripts to be private to your package, place them in the top-level tool directory. If you don't intend for your package to be depended on, you can leave your scripts in bin.

</details>

for more information [visit](https://dart.dev/tools/pub/glossary#sidenav-5-6
)
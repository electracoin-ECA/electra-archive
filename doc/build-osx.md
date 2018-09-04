# Mac OS X Build Instructions

This guide will show you how to build the electra deamon (headless client).

#### Prepare the build environment

Let’s create the build environment:
1. From the Finder menu, click the Apple icon
2. Select App Store…
3. In the Search field type `xcode` and install the XCode Development environment. This may require a while.
4. Open a terminal window and execute the following command to enable XCode development license:
```
$ sudo xcodebuild -license
```
5. Install MacPorts to download wallet dependencies. To install MacPorts download and run https://github.com/macports/macports-base/releases/download/v2.4.2/MacPorts-2.4.2-10.12Sierra.pkg
* In the Welcome to MacPorts installer welcome click Continue
* In the Important Information window click Continue
* In the Software License Agreement click Continue
* Agree to License
* In the Standard Install window click Install to begin installation
6. Open a terminal window and execute the following commands:
```
$ sudo port install boost db48 openssl miniupnpc qrencode qt4-mac
```
7. Now we have dependencies installed, we must downgrade boost libraries to 1.5xxx (newer versions are not supported by current release of Electra wallet source code):
```
$ port installed boost
$ sudo port uninstall boost @1.65.1_1+no_single+no_static+python27
$ git clone --single-branch https://github.com/macports/macports-ports.git
$ cd macports-ports/
$ git checkout 694e99b5dc33aa45630dcac9475e54f98123b7cf
$ cd devel/boost/
$ sudo port install
```
The process above deactivates the current boost library (1.6.xxx) clone the 1.56 by using git hash and install it.

Prerequisites are now ready.

8. Compile the source code - Go to Electra source code

```
$ cd src/
$ make -f makefile.osx Electrad
```

Compilation can take up to 5 minutes, no more than 10 minutes.

#### The following are the available commands

1. Spawn the deamon

```
$ ./Electrad
```

2. Help

```
$ ./Electrad help
```

> **Note**<br>
> The output will be a list of available commands

3. Stop

```
$ ./Electrad stop
```

#### Notes

- The installation of boost version 1.56 can take up to 40-45 minutes, please be patient.

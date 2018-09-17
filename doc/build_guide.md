# Electra wallet build guide (By Francesco)

This document describes the complete process for building Electra-Qt wallet. The following platform are currently supported: Windows, Mac OSX, Linux. An additional section is specific for compiling the command line version of the wallet for Linux distributions where no GUI is available.

The build process follows three steps :

1. setup build environment
2. import and compile sources
3. package for distribution

Based on the target platform, steps may vary.

### Recommendations

It is recommended to use a virtual machine and snapshots to facilitate the build process.

It is recommended to take virtual machine snapshots each time you make Operating System's configuration changes to easily rollback in case of issues.
The build process requires some outdated dependencies like BOOST 1.5xxx and the Qt Development Environment version 4.8. *DO use this specific version*.
The Electra wallet source code we have is not developed to be compatible with newer versions for now. If you use updated versions the build process described here will fail.

## Windows

#### Required packages
*MinGW MSYS
*shell
*Perl
*Python
*MinGW toolchain
*QT Development environment

#### Create the build environment
1. Setup a fresh Windows 7 x64 bit (Enterprise). Do not install ServicePack here. It is not needed to register your windows copy. This workstation must have internet access to facilitate download of software components.
2. [optional] you can install Chrome browser of Mozilla Firefox to access the web
3. Download and install 7Zip and Notepad++ useful for the build environment.
4. Install MinGW (MSYS) shell as follow:
* Download and install http://sourceforge.net/projects/mingw/files/Installer/mingw-getsetup.exe
* Execute MinGW Installation Manager
* From the Installation Manager make sure no package is pre-selected
* Select only the followings: All packages MSYS, msys-base (only the bin)
* Make sure the msys-gcc and msys-w32api packages are not selected for installation
* Click Installation menu and then Apply Changes to start installation of selected components
5. Install Perl with all default settings from http://downloads.activestate.com/ActivePerl/releases/5.22.3.2204/ActivePerl-5.22.3.2204MSWin32-x86-64int-401627.exe
6. Install Python with all default settings from http://www.python.org/ftp/python/3.3.3/python3.3.3.msi
7. Install MinGW toolchain:
* Download http://sourceforge.net/projects/mingww64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingwbuilds/4.8.2/threads-posix/dwarf/i686-4.8.2-release-posix-dwarf-rt_v3-rev3.7z
* Unpack with 7Zip under `C:\` (do not change this path)
From step 7 you should now have the following structure `C:\mingw32`. It’s time to check/set system environment variable.
8. Verify the following folders have been set in your SYSTEM environment PATH variable:
* `C:\MinGW\msys\1.0\bin`
* `C:\mingw32\bin`
* `C:\Python33`
* `C:\Perl\site\bin`
* `C:\Perl\bin`

If one or more folder is missing, add it manually and your PATH system variable should look like:
`C:\MinGW\msys\1.0\bin;C:\mingw32\bin;C:\Python33;C:\Perl\site\bin;C:\Perl\bin;%SystemRoot%\system32;%SystemRoot%;% SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\`

>Recommendation: if you are using a virtual machine, it’s time to shut down and take a snapshot now

9. Install and compile the Qt Environment from source:
* Download http://download.qt.io/official_releases/qt/4.8/4.8.6/qt-everywhereopensource-src-4.8.6.zip
* Unpack the content under `C:\Qt\4.8.6`. You should have `C:\Qt\4.8.6\bin` (and other folders)
* Open a command prompt window and compile the QT environment as follow (this may require a while):
```
C:\> cd C:\Qt\4.8.6
C:\Qt\4.8.6\> configure -release -opensource -confirm-license -static -no-sqlsqlite -no-qt3support -no-opengl -qt-zlib -no-gif -qt-libpng -qt-libmng -no-libtiff -qt-libjpeg -no-dsp -no-vcproj -no-openssl -no-dbus -no-phonon -no-phonon-backend no-multimedia -no-audio-backend -no-webkit -no-script -no-scripttools -nodeclarative -no-declarative-debug -no-style-plastique -no-style-cleanlooks -nostyle-motif -no-style-cde -nomake demos -nomake examples
C:\Qt\4.8.6\> mingw32-make
```
11. Add `C:\qt\4.8.6\bin` to system PATH variable
12. Close the command prompt window

**You build environment for Electra wallet is ready.**

>Recommendation: if you are using a virtual machine, it’s time to shut down and take a snapshot now

#### Import and compile wallet from source

Now we will use the build environment from section above to compile wallet from source.
First, we need all dependencies compiled from source. The following dependencies is used:
* OpenSSL
* Oracle Barkley DB
* BOOST C++ libraries
* UPNPC support library
* LIBPNG
* QREncode library

Let’s start:
1. Create `C:\deps` directory
2. Download and save under `C:\deps` the package https://www.openssl.org/source/openssl1.0.1g.tar.gz . Open MinGW MSYS shell by running C:\MinGW\msys\1.0\msys.bat
* From MSYS shell execute the following commands:
```
$ cd /c/deps
$ tar zxvf openssl-1.0.1g.tar.gz
$ cd openssl-1.0.1g/
$ ./configure mingw
$ make
```
3. Download and save under `C:\deps` the package http://download.oracle.com/berkeley-db/db4.8.30.NC.tar.gz
* Open MinGW MSYS shell by running `C:\MinGW\msys\1.0\msys.bat`
* From MSYS shell execute the following commands:
```
$ cd /c/deps
$ tar zxvf db-4.8.30.NC.tar.gz
$ cd db-4.8.30.NC/build_unix/
$ ../dist/configure --disable-replication --enable-mingw --enable-cxx
$ make
```
4. Download and save under `C:\deps the package boost_1_55_0.zip` from http://sourceforge.net/projects/boost/files/boost/1.55.0/
5. Extract zip content under `C:\deps`. You should have `C:\deps\boost_1_55_0` with files and folders inside
6. Open a command prompt window and execute the following commands:
```
C:\> cd C:\deps\boost_155_0
C:\deps\boost_1_55_0\> boostrap.bat mingw
C:\deps\boost_1_55_0\> b2 --build-type=complete --with-chrono --with-filesystem -with-program_options --with-system --with-thread toolset=gcc stage
```
7. Download and save under `C:\deps the package miniupnpc-1.9.tar.gz` from http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.9.tar.gz
8. Extract tar.gz content under miniupnpc-1.9 with 7Zip. You should have `C:\deps\miniupnpc-1.9` with files and folders inside
9. Open a command prompt window and execute the following commands:
```
C:\> cd C:\deps\miniupnpc-1.9
C:\deps\miniupnpc-1.9\> mingw32-make -f Makefile.mingw init upnpc-static
C:\deps\miniupnpc-1.9\> mkdir C:\deps\miniupnpc-1.9\miniupnpc
C:\deps\miniupnpc-1.9\> copy C:\deps\miniupnpc-1.9\*.h C:\deps\miniupnpc1.9\miniupnpc
```
10. Download and save under `C:\deps` the package http://prdownloads.sourceforge.net/libpng/libpng-1.6.9.tar.gz
* Open MinGW MSYS shell by running `C:\MinGW\msys\1.0\msys.bat`
* From MSYS shell execute the following commands:
```
$ cd /c/deps
$ tar zxvf libpng-1.6.9.tar.gz
$ cd libpng-1.6.9/ $ ./configure
$ make
```
11. Download and save under `C:\deps` the package http://fukuchi.org/works/qrencode/qrencode3.4.3.tar.gz
* Open MinGW MSYS shell by running `C:\MinGW\msys\1.0\msys.bat`
* From MSYS shell execute the following commands:
```
$ cd /c/deps
$ tar zxvf qrencode-3.4.3.tar.gz

$ cd qrencode-3.4.3/ $ LIBS="../libpng-1.6.9/.libs/libpng16.a ../../mingw32/i686-w64-mingw32/lib/libz.a" png_CFLAGS="-I../libpng-1.6.9" png_LIBS="-L../libpng-1.6.9/.libs" configure -enable-static --disable-shared
$ make
```
**Prerequisites are now ready.**
>Recommendation: if you are using a virtual machine, it’s time to shut down and take a snapshot now

#### Now let’s compile the wallet:
1. Download and unzip under `C:\` the package https://github.com/electra01/Electra/archive/master.zip. You should have `C:\Electra-master` with files and folders inside.
2. Open C:\Electra-master\electra-qt.pro with a text editor.
3. Verify or set the following variables as below:
```
BOOST_LIB_SUFFIX=-mgw48-mt-s-1_55 BOOST_INCLUDE_PATH=C:/deps/boost_1_55_0 BOOST_LIB_PATH=C:/deps/boost_1_55_0/stage/lib BDB_INCLUDE_PATH=C:/deps/db-4.8.30.NC/build_unix BDB_LIB_PATH=C:/deps/db-4.8.30.NC/build_unix OPENSSL_INCLUDE_PATH=C:/deps/openssl-1.0.1g/include OPENSSL_LIB_PATH=C:/deps/openssl-1.0.1g MINIUPNPC_INCLUDE_PATH=C:/deps/miniupnpc-1.9 MINIUPNPC_LIB_PATH=C:/deps/miniupnpc-1.9 QRENCODE_INCLUDE_PATH=C:/deps/qrencode-3.4.3 QRENCODE_LIB_PATH=C:/deps/qrencode-3.4.3/.libs
```
4. Now set flags for static build. Open C:\Electra-master\electra-qt.pro with a text editor and add the following line at the very beginning of the file:
```
CONFIG += static
```
5. Compile LEVELDB first:
* Open MinGW MSYS shell by running `C:\MinGW\msys\1.0\msys.bat`
* From MSYS shell execute the following commands:
```
$ cd /c/Electra-master/src/leveldb
$ TARGET_OS=NATIVE_WINDOWS make libleveldb.a libmemenv.a
```
6. Compile the wallet
7. Open a command prompt window and execute the following commands:
```
C:\> cd C:\Electra-master\
C:\Electra-master\> qmake "USE_UPNP=-" electra-qt.pro
C:\Electra-master\> mingw32-make -f Makefile.Release
```
Now you should have Electra-Qt.exe file in C:\Electra-master.

#### Package for distribution

TODO

## OSX

This section details the build process for Mac OSx platforms. It is recommended to work on a fresh copy of OSX without any other software installed.  
This build process is based on OSX Sierra 10.12 running as virtual machine on Oracle Virtual box 5.1 and Windows 7 64 bit as host operating system.
The build environment requires the following packages:
* MacPorts
* QT Development environment
* XCode

Before setting up the build environment we will document steps to install OSX Sierra 10.12 as virtual machine. If you already have OSX ready, jump to **Prepare the build environment** section.

>NOTE: Your host operating system must have virtualization feature enabled in the machine BIOS. Consult hardware vendor documentation to enable this feature at BIOS level.

Install OSX Sierra on Virtual Box You must download MAC OSX sierra prebuilt disk (VMDK) before. Download is available here https://drive.google.com/drive/folders/1YneaDNMhveiByjo5iE3jNKLPHNYG6s0a.
Once you have the the ZIP file, extract the vmdk in a preferred location (e.g. `C:\disks`) and open Oracle Virtual Box:
1. Create a new virtual machine
2. In the Name and operating system pane:
* type your preferred VM name (e.g. OSX)
* Select Mac OS X as Type
* Select Mac OS x 10.11 El Capitan (64 bit) as Version
3. Set 4 GB of Memory size
4. Select Use an existing virtual disk file and point to the VMDK file downloaded above
5. Click Create
Now you need some customization on the new VM:
6. Right click on the virtual machine and select Settings…
7. In the Settings window select System on the left pane.
On the Motherboard tab:
* remove Floppy under Boot Order
* Set Chipset as ICH9
* Make sure all the extended properties are checked (I/O APIC, Enable EFI, Hardware clock)
On the Processor tab:
* Set Processor(s) to 2
* Check Feature Enable PAE/NX
8. In the Settings window select Display on the left pane
* On the Screen tab set video memory at 128MB
9. In the Settings window select Network on the left pane. On the Adapter 1 tab:
* Check Enable Network Adapter
* Select Attached to NAT or Bridge according to you network layout

>NOTE: This VM must have access to internet to facilitate software download. Make sure your network settings permit this VM to access internet

10. In the Setting window click OK to save virtual machine setting
11. Close Virtual Box Manager interface
12. Open a command prompt window with Run As Administrator and execute the following commands (replace “Your VM Name” quotes included with the name of your virtual machine):
```
C:\> cd "C:\Program Files\Oracle\VirtualBox\" C:\Program Files\Oracle\VirtualBox\> VBoxManage modifyvm "Your VM Name" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff C:\Program Files\Oracle\VirtualBox\> VBoxManage setextradata "Your VM Name"
 "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3" C:\Program Files\Oracle\VirtualBox\> VBoxManage setextradata "Your VM Name"
 "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0" C:\Program Files\Oracle\VirtualBox\> VBoxManage setextradata "Your VM Name"
 "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple" C:\Program Files\Oracle\VirtualBox\> VBoxManage setextradata "Your VM Name"
 "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" C:\Program Files\Oracle\VirtualBox\> VBoxManage setextradata "Your V M Name"
 "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
```
Your OSx Sierra is now ready. Power on the virtual machine and complete the OSx installation by following the wizard.

> Recommendation: Once OSx installation is completed shut down the VM and take a snapshot

Power on your OSx Sierra to execute system update. This system update is required to install XCode build environment. You must upgrade your OSx Sierra to 10.12.6. To upgrade your VM execute:
1. From the Finder menu, click the Apple icon
2. Select App Store…
3. From the App Store window select Updates on the top bar and install update for OSX Sierra 10.12.6. This process may require a while.

>Recommendation: Once OSx is updated, shut down the VM and take a snapshot

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
$ port installed boost // get the current installed version here
$ sudo port uninstall boost @1.65.1_1+no_single+no_static+python27
$ git clone --single-branch https://github.com/macports/macports-ports.git
$ cd macports-ports/
$ git checkout 694e99b5dc33aa45630dcac9475e54f98123b7cf
$ cd devel/boost/
$ sudo port install
```

The process above deactivates the current boost library (1.6.xxx) clone the 1.56 by using git hash and install it.
Prerequisites are now ready.

>Recommendation: if you are using a virtual machine, it’s time to shut down and take a snapshot Now

#### Import and compile wallet from source
TODO

#### Package for distribution
TODO

## References
* https://techsviewer.com/install-macos-sierra-virtualbox-windows/
* https://www.macports.org/install.php
* https://trac.macports.org/wiki/howto/InstallingOlderPort
* https://github.com/peercoin/peercoin/wiki/Mac-OSX-Wallet-Build-Instructions

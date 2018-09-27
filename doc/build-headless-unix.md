# Debian Based Build Instructions (Debian, Ubuntu, Mint, Kali)

This guide will show you how to build the electra deamon (headless client).

#### Prepare the build environment

Let’s create the build environment:
1. Add the bitcoin repository
```
$ sudo add-apt-repository ppa:bitcoin/bitcoin
```
2. Update the package list
```
$ sudo apt-get update
```
3. Install the required dependencies
```
$ sudo apt-get install build-essential libssl-dev libdb4.8-dev libdb4.8++-dev libminiupnpc-dev qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev git
```
4. Clone the Electra Github repository
```
$ git clone https://github.com/Electra-project/Electra ~/src/Electra
```
5. Compile electra
```
$ cd ~/src/Electra/src
$ make -f makefile.unix Electrad
```
6. Before starting the daemon, you can copy the config file into the correct folder, as well as the daemon.
```
$ cp ~/src/Electra/Electra.conf ~/.Electra
$ cp ~/src/Electra/src/Electrad ~/.Electra
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

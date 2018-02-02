TEMPLATE = lib
INCLUDEPATH += json
DEFINES += BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE HAVE_CXX_STDHEADERS MINIUPNP_STATICLIB
CONFIG += thread staticlib

QMAKE_CXXFLAGS = -fpermissive

win32 {
    BOOST_LIB_SUFFIX=-mgw49-mt-s-1_55
    BOOST_INCLUDE_PATH=C:/deps/boost_1_55_0
    BOOST_LIB_PATH=C:/deps/boost_1_55_0/stage/lib
    BDB_INCLUDE_PATH=C:/deps/db-4.8.30.NC/build_unix
    BDB_LIB_PATH=C:/deps/db-4.8.30.NC/build_unix
    OPENSSL_INCLUDE_PATH=C:/deps/openssl-1.0.1j/include
    OPENSSL_LIB_PATH=C:/deps/openssl-1.0.1j
    MINIUPNPC_INCLUDE_PATH=C:/deps/
    MINIUPNPC_LIB_PATH=C:/deps/miniupnpc
    QRENCODE_INCLUDE_PATH=C:/deps/qrencode-3.4.4
    QRENCODE_LIB_PATH=C:/deps/qrencode-3.4.4/.libs
}


# for boost 1.37, add -mt to the boost libraries
# use: qmake BOOST_LIB_SUFFIX=-mt
# for boost thread win32 with _win32 sufix
# use: BOOST_THREAD_LIB_SUFFIX=_win32-...
# or when linking against a specific BerkelyDB version: BDB_LIB_SUFFIX=-4.8

# Dependency library locations can be customized with:
#    BOOST_INCLUDE_PATH, BOOST_LIB_PATH, BDB_INCLUDE_PATH,
#    BDB_LIB_PATH, OPENSSL_INCLUDE_PATH and OPENSSL_LIB_PATH respectively

OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build

# use: qmake "RELEASE=1"
contains(RELEASE, 1) {
    # Mac: compile for maximum compatibility (10.5, 32-bit)
    macx:QMAKE_CXXFLAGS += -mmacosx-version-min=10.5 -arch x86_64 -isysroot /Developer/SDKs/MacOSX10.5.sdk

    !windows:!macx {
        # Linux: static link
        LIBS += -Wl,-Bstatic
    }
}

!win32 {
    # for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
    QMAKE_CXXFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
    QMAKE_LFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
    # We need to exclude this for Windows cross compile with MinGW 4.2.x, as it will result in a non-working executable!
    # This can be enabled for Windows, when we switch to MinGW >= 4.4.x.
}
# for extra security on Windows: enable ASLR and DEP via GCC linker flags
win32:QMAKE_LFLAGS *= -Wl,--large-address-aware -static
win32:QMAKE_LFLAGS += -static-libgcc -static-libstdc++

# use: qmake "USE_UPNP=1" ( enabled by default; default)
#  or: qmake "USE_UPNP=0" (disabled by default)
#  or: qmake "USE_UPNP=-" (not supported)
# miniupnpc (http://miniupnp.free.fr/files/) must be installed for support
contains(USE_UPNP, -) {
    message(Building without UPNP support)
} else {
    message(Building with UPNP support)
    count(USE_UPNP, 0) {
        USE_UPNP=1
    }
    DEFINES += USE_UPNP=$$USE_UPNP STATICLIB
    INCLUDEPATH += $$MINIUPNPC_INCLUDE_PATH
}

# use: qmake "USE_IPV6=1" ( enabled by default; default)
#  or: qmake "USE_IPV6=0" (disabled by default)
#  or: qmake "USE_IPV6=-" (not supported)
contains(USE_IPV6, -) {
    message(Building without IPv6 support)
} else {
    count(USE_IPV6, 0) {
        USE_IPV6=1
    }
    DEFINES += USE_IPV6=$$USE_IPV6
}

include(leveldb.pri)

# regenerate build.h
!windows|contains(USE_BUILD_INFO, 1) {
    genbuild.depends = FORCE
    genbuild.commands = cd $$PWD; /bin/sh ../share/genbuild.sh $$OUT_PWD/build/build.h
    genbuild.target = $$OUT_PWD/build/build.h
    PRE_TARGETDEPS += $$OUT_PWD/build/build.h
    QMAKE_EXTRA_TARGETS += genbuild
    DEFINES += HAVE_BUILD_INFO
}

contains(USE_O3, 1) {
    message(Building O3 optimization flag)
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS += -O3
    QMAKE_CFLAGS += -O3
}

*-g++-32 {
    message("32 platform, adding -msse2 flag")

    QMAKE_CXXFLAGS += -msse2
    QMAKE_CFLAGS += -msse2
}

QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wno-ignored-qualifiers -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector


# Input
DEPENDPATH += src json
HEADERS += alert.h \
    addrman.h \
    base58.h \
    bignum.h \
    checkpoints.h \
    compat.h \
    coincontrol.h \
    sync.h \
    util.h \
    uint256.h \
    kernel.h \
    scrypt.h \
    pbkdf2.h \
    zerocoin/Accumulator.h \
    zerocoin/AccumulatorProofOfKnowledge.h \
    zerocoin/Coin.h \
    zerocoin/CoinSpend.h \
    zerocoin/Commitment.h \
    zerocoin/ParamGeneration.h \
    zerocoin/Params.h \
    zerocoin/SerialNumberSignatureOfKnowledge.h \
    zerocoin/SpendMetaData.h \
    zerocoin/ZeroTest.h \
    zerocoin/Zerocoin.h \
    serialize.h \
    strlcpy.h \
    main.h \
    miner.h \
    net.h \
    key.h \
    db.h \
    txdb.h \
    walletdb.h \
    script.h \
    init.h \
    irc.h \
    mruset.h \
    json/json_spirit_writer_template.h \
    json/json_spirit_writer.h \
    json/json_spirit_value.h \
    json/json_spirit_utils.h \
    json/json_spirit_stream_reader.h \
    json/json_spirit_reader_template.h \
    json/json_spirit_reader.h \
    json/json_spirit_error_position.h \
    json/json_spirit.h \
    wallet.h \
    keystore.h \
    Electrarpc.h \
    crypter.h \
    protocol.h \
    allocators.h \
    ui_interface.h \
    version.h \
    netbase.h \
    clientversion.h \
    bloom.h \
    checkqueue.h \
    hash.h \
    hashblock.h \
    limitedmap.h \
    sph_blake.h \
    sph_groestl.h \
    sph_jh.h \
    sph_keccak.h \
    sph_skein.h \
    sph_types.h \
    threadsafety.h \
    txdb-leveldb.h

SOURCES += alert.cpp \
    version.cpp \
    sync.cpp \
    util.cpp \
    netbase.cpp \
    key.cpp \
    script.cpp \
    main.cpp \
    miner.cpp \
    # init.cpp \
    net.cpp \
    irc.cpp \
    checkpoints.cpp \
    addrman.cpp \
    db.cpp \
    walletdb.cpp \
    wallet.cpp \
    keystore.cpp \
    Electrarpc.cpp \
    rpcdump.cpp \
    rpcnet.cpp \
    rpcmining.cpp \
    rpcwallet.cpp \
    rpcblockchain.cpp \
    rpcrawtransaction.cpp \
    crypter.cpp \
    protocol.cpp \
    noui.cpp \
    kernel.cpp \
    scrypt-arm.S \
    scrypt-x86.S \
    scrypt-x86_64.S \
    scrypt.cpp \
    pbkdf2.cpp \
    zerocoin/Accumulator.cpp \
    zerocoin/AccumulatorProofOfKnowledge.cpp \
    zerocoin/Coin.cpp \
    zerocoin/CoinSpend.cpp \
    zerocoin/Commitment.cpp \
    zerocoin/ParamGeneration.cpp \
    zerocoin/Params.cpp \
    zerocoin/SerialNumberSignatureOfKnowledge.cpp \
    zerocoin/SpendMetaData.cpp \
    zerocoin/ZeroTest.cpp

CODECFORTR = UTF-8

isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}

# platform specific defaults, if not overridden on command line
isEmpty(BDB_INCLUDE_PATH) {
    macx:BDB_INCLUDE_PATH = /opt/local/include/db48
}

include(./boost.pri)

windows:DEFINES += WIN32

windows:!contains(MINGW_THREAD_BUGFIX, 0) {
    # At least qmake's win32-g++-cross profile is missing the -lmingwthrd
    # thread-safety flag. GCC has -mthreads to enable this, but it doesn't
    # work with static linking. -lmingwthrd must come BEFORE -lmingw, so
    # it is prepended to QMAKE_LIBS_QT_ENTRY.
    # It can be turned off with MINGW_THREAD_BUGFIX=0, just in case it causes
    # any problems on some untested qmake profile now or in the future.
    DEFINES += _MT BOOST_THREAD_PROVIDES_GENERIC_SHARED_MUTEX_ON_WIN
}

!windows:!macx {
    DEFINES += LINUX
}

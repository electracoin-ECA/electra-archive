TEMPLATE = app
TARGET = Electra-qt
macx:TARGET = "Electra-qt"
VERSION = 1.2.0
INCLUDEPATH += json qt $$PWD
DEFINES += QT_GUI BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE HAVE_CXX_STDHEADERS MINIUPNP_STATICLIB
CONFIG += thread
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
lessThan(QT_MAJOR_VERSION, 5): CONFIG += static
QMAKE_CXXFLAGS = -fpermissive

greaterThan(QT_MAJOR_VERSION, 4) {
    QT += widgets
    DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
}

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

LIBS += -L$$PWD -lcore

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
lessThan(QT_MAJOR_VERSION, 5): win32: QMAKE_LFLAGS *= -static

# use: qmake "USE_QRCODE=1"
# libqrencode (http://fukuchi.org/works/qrencode/index.en.html) must be installed for support
contains(USE_QRCODE, 1) {
    message(Building with QRCode support)
    DEFINES += USE_QRCODE
    LIBS += -lqrencode
}

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
    LIBS += $$join(MINIUPNPC_LIB_PATH,,-L,) -lminiupnpc
    win32:LIBS += -liphlpapi
}

# use: qmake "USE_DBUS=1"
contains(USE_DBUS, 1) {
    message(Building with DBUS (Freedesktop notifications) support)
    DEFINES += USE_DBUS
    QT += dbus
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

contains(ELECTRA_NEED_QT_PLUGINS, 1) {
    DEFINES += ELECTRA_NEED_QT_PLUGINS
    QTPLUGIN += qcncodecs qjpcodecs qtwcodecs qkrcodecs qtaccessiblewidgets
}

include(leveldb.pri)

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
DEPENDPATH += src qt
HEADERS += qt/Electragui.h \
    qt/transactiontablemodel.h \
    qt/addresstablemodel.h \
    qt/optionsdialog.h \
    qt/coincontroldialog.h \
    qt/coincontroltreewidget.h \
    qt/sendcoinsdialog.h \
    qt/addressbookpage.h \
    qt/signverifymessagedialog.h \
    qt/aboutdialog.h \
    qt/editaddressdialog.h \
    qt/Electraaddressvalidator.h \
    qt/clientmodel.h \
    qt/guiutil.h \
    qt/transactionrecord.h \
    qt/guiconstants.h \
    qt/optionsmodel.h \
    qt/monitoreddatamapper.h \
    qt/transactiondesc.h \
    qt/transactiondescdialog.h \
    qt/Electraamountfield.h \
    qt/transactionfilterproxy.h \
    qt/transactionview.h \
    qt/walletmodel.h \
    qt/overviewpage.h \
    qt/csvmodelwriter.h \
    qt/sendcoinsentry.h \
    qt/qvalidatedlineedit.h \
    qt/Electraunits.h \
    qt/qvaluecombobox.h \
    qt/askpassphrasedialog.h \
    qt/notificator.h \
    qt/qtipcserver.h \
    qt/rpcconsole.h 

SOURCES += qt/Electra.cpp qt/Electragui.cpp \
    qt/transactiontablemodel.cpp \
    qt/addresstablemodel.cpp \
    qt/optionsdialog.cpp \
    qt/sendcoinsdialog.cpp \
    qt/coincontroldialog.cpp \
    qt/coincontroltreewidget.cpp \
    qt/addressbookpage.cpp \
    qt/signverifymessagedialog.cpp \
    qt/aboutdialog.cpp \
    qt/editaddressdialog.cpp \
    qt/Electraaddressvalidator.cpp \
    qt/clientmodel.cpp \
    qt/guiutil.cpp \
    qt/transactionrecord.cpp \
    qt/optionsmodel.cpp \
    qt/monitoreddatamapper.cpp \
    qt/transactiondesc.cpp \
    qt/transactiondescdialog.cpp \
    qt/Electrastrings.cpp \
    qt/Electraamountfield.cpp \
    qt/transactionfilterproxy.cpp \
    qt/transactionview.cpp \
    qt/walletmodel.cpp \
    qt/overviewpage.cpp \
    qt/csvmodelwriter.cpp \
    qt/sendcoinsentry.cpp \
    qt/qvalidatedlineedit.cpp \
    qt/Electraunits.cpp \
    qt/qvaluecombobox.cpp \
    qt/askpassphrasedialog.cpp \
    qt/notificator.cpp \
    qt/qtipcserver.cpp \
    qt/rpcconsole.cpp \

# init.cpp contains the running code for the
# program and is not included inside libcore by default
SOURCES += \
    init.cpp

RESOURCES += \
    qt/Electra.qrc

FORMS += \
    qt/forms/coincontroldialog.ui \
    qt/forms/sendcoinsdialog.ui \
    qt/forms/addressbookpage.ui \
    qt/forms/signverifymessagedialog.ui \
    qt/forms/aboutdialog.ui \
    qt/forms/editaddressdialog.ui \
    qt/forms/transactiondescdialog.ui \
    qt/forms/overviewpage.ui \
    qt/forms/sendcoinsentry.ui \
    qt/forms/askpassphrasedialog.ui \
    qt/forms/rpcconsole.ui \
    qt/forms/optionsdialog.ui

contains(USE_QRCODE, 1) {
    HEADERS += qt/qrcodedialog.h
    SOURCES += qt/qrcodedialog.cpp
    FORMS += qt/forms/qrcodedialog.ui
}

CODECFORTR = UTF-8

# for lrelease/lupdate
# also add new translations to qt/Electra.qrc under translations/
TRANSLATIONS = $$files(qt/locale/Electra_*.ts)

isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
isEmpty(QM_DIR):QM_DIR = $$PWD/qt/locale
# automatically build translations, so they can be included in resource file
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$QM_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM

# "Other files" to show in Qt Creator
OTHER_FILES += \
    doc/*.rst doc/*.txt doc/README README.md res/Electra-qt.rc

windows:DEFINES += WIN32
windows:RC_FILE = qt/res/Electra-qt.rc

windows:!contains(MINGW_THREAD_BUGFIX, 0) {
    # At least qmake's win32-g++-cross profile is missing the -lmingwthrd
    # thread-safety flag. GCC has -mthreads to enable this, but it doesn't
    # work with static linking. -lmingwthrd must come BEFORE -lmingw, so
    # it is prepended to QMAKE_LIBS_QT_ENTRY.
    # It can be turned off with MINGW_THREAD_BUGFIX=0, just in case it causes
    # any problems on some untested qmake profile now or in the future.
    DEFINES += _MT BOOST_THREAD_PROVIDES_GENERIC_SHARED_MUTEX_ON_WIN
    QMAKE_LIBS_QT_ENTRY = -lmingwthrd $$QMAKE_LIBS_QT_ENTRY
}

!windows:!macx {
    DEFINES += LINUX
    LIBS += -lrt
}

macx:HEADERS += qt/macdockiconhandler.h \
                qt/macnotificationhandler.h
macx:OBJECTIVE_SOURCES += qt/macdockiconhandler.mm \
                          qt/macnotificationhandler.mm
macx:LIBS += -framework Foundation -framework ApplicationServices -framework AppKit
macx:DEFINES += MAC_OSX MSG_NOSIGNAL=0
macx:ICON = qt/res/icons/Electra.icns
macx:TARGET = "Electra-Qt"
macx:QMAKE_CFLAGS_THREAD += -pthread
macx:QMAKE_LFLAGS_THREAD += -pthread
macx:QMAKE_CXXFLAGS_THREAD += -pthread

# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH
LIBS += $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,)
LIBS += -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX
# -lgdi32 has to happen after -lcrypto (see  #681)
windows:LIBS += -lws2_32 -lshlwapi -lmswsock -lole32 -loleaut32 -luuid -lgdi32
LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX
windows:LIBS += -lboost_chrono$$BOOST_LIB_SUFFIX

contains(RELEASE, 1) {
    !windows:!macx {
        # Linux: turn dynamic linking back on for c/c++ runtime libraries
        LIBS += -Wl,-Bdynamic
    }
}

# system($$QMAKE_LRELEASE -silent $$_PRO_FILE_)

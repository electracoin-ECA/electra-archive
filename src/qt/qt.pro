TEMPLATE = app
TARGET = Electra-qt
macx:TARGET = "Electra-qt"
VERSION = 1.2.0
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

QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wno-ignored-qualifiers -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector


# Input
DEPENDPATH += src json qt
HEADERS += Electragui.h \
    transactiontablemodel.h \
    addresstablemodel.h \
    optionsdialog.h \
    coincontroldialog.h \
    coincontroltreewidget.h \
    sendcoinsdialog.h \
    addressbookpage.h \
    signverifymessagedialog.h \
    aboutdialog.h \
    editaddressdialog.h \
    Electraaddressvalidator.h \
    clientmodel.h \
    guiutil.h \
    transactionrecord.h \
    guiconstants.h \
    optionsmodel.h \
    monitoreddatamapper.h \
    transactiondesc.h \
    transactiondescdialog.h \
    Electraamountfield.h \
    transactionfilterproxy.h \
    transactionview.h \
    walletmodel.h \
    overviewpage.h \
    csvmodelwriter.h \
    sendcoinsentry.h \
    qvalidatedlineedit.h \
    Electraunits.h \
    qvaluecombobox.h \
    askpassphrasedialog.h \
    notificator.h \
    qtipcserver.h \
    rpcconsole.h \

SOURCES += Electra.cpp \
    Electragui.cpp \
    transactiontablemodel.cpp \
    addresstablemodel.cpp \
    optionsdialog.cpp \
    sendcoinsdialog.cpp \
    coincontroldialog.cpp \
    coincontroltreewidget.cpp \
    addressbookpage.cpp \
    signverifymessagedialog.cpp \
    aboutdialog.cpp \
    editaddressdialog.cpp \
    Electraaddressvalidator.cpp \
    clientmodel.cpp \
    guiutil.cpp \
    transactionrecord.cpp \
    optionsmodel.cpp \
    monitoreddatamapper.cpp \
    transactiondesc.cpp \
    transactiondescdialog.cpp \
    Electrastrings.cpp \
    Electraamountfield.cpp \
    transactionfilterproxy.cpp \
    transactionview.cpp \
    walletmodel.cpp \
    overviewpage.cpp \
    csvmodelwriter.cpp \
    sendcoinsentry.cpp \
    qvalidatedlineedit.cpp \
    Electraunits.cpp \
    qvaluecombobox.cpp \
    askpassphrasedialog.cpp \
    notificator.cpp \
    qtipcserver.cpp \
    rpcconsole.cpp 

RESOURCES += \
    Electra.qrc

FORMS += \
    forms/coincontroldialog.ui \
    forms/sendcoinsdialog.ui \
    forms/addressbookpage.ui \
    forms/signverifymessagedialog.ui \
    forms/aboutdialog.ui \
    forms/editaddressdialog.ui \
    forms/transactiondescdialog.ui \
    forms/overviewpage.ui \
    forms/sendcoinsentry.ui \
    forms/askpassphrasedialog.ui \
    forms/rpcconsole.ui \
    forms/optionsdialog.ui

contains(USE_QRCODE, 1) {
HEADERS += qrcodedialog.h
SOURCES += qrcodedialog.cpp
FORMS += forms/qrcodedialog.ui
}

CODECFORTR = UTF-8

# for lrelease/lupdate
# also add new translations to Electra.qrc under translations/
TRANSLATIONS = $$files(locale/Electra_*.ts)

isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
isEmpty(QM_DIR):QM_DIR = $$PWD/locale
# automatically build translations, so they can be included in resource file
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$QM_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM

include(./boost.pri)

windows:DEFINES += WIN32
windows:RC_FILE = res/Electra-qt.rc

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

macx:HEADERS += macdockiconhandler.h \
                macnotificationhandler.h
macx:OBJECTIVE_SOURCES += macdockiconhandler.mm \
                          macnotificationhandler.mm
macx:LIBS += -framework Foundation -framework ApplicationServices -framework AppKit
macx:DEFINES += MAC_OSX MSG_NOSIGNAL=0
macx:ICON = res/icons/Electra.icns
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

system($$QMAKE_LRELEASE -silent $$_PRO_FILE_)

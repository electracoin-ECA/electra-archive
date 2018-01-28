# This .pri file adds support for leveldb by adding
# the following sources to the current build and additionally
# builds the leveldb dependency as a static library that will be linked
# against the current target.

INCLUDEPATH += $$PWD/leveldb/include $$PWD/leveldb/helpers
LIBS += $$PWD/leveldb/libleveldb.a $$PWD/leveldb/libmemenv.a
SOURCES += $$PWD/txdb-leveldb.cpp \
    $$PWD/bloom.cpp \
    $$PWD/hash.cpp \
    $$PWD/blake.c \
    $$PWD/groestl.c \
    $$PWD/jh.c \
    $$PWD/keccak.c \
    $$PWD/skein.c
!win32 {
    # we use QMAKE_CXXFLAGS_RELEASE even without RELEASE=1 because we use RELEASE to indicate linking preferences not -O preferences
    genleveldb.commands = cd $$PWD/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a
} else {
    # make an educated guess about what the ranlib command is called
    isEmpty(QMAKE_RANLIB) {
        QMAKE_RANLIB = $$replace(QMAKE_STRIP, strip, ranlib)
    }
    LIBS += -lshlwapi
    #genleveldb.commands = cd $$PWD/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX TARGET_OS=OS_WINDOWS_CROSSCOMPILE $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a && $$QMAKE_RANLIB $$PWD/leveldb/libleveldb.a && $$QMAKE_RANLIB $$PWD/leveldb/libmemenv.a
}
genleveldb.target = $$PWD/leveldb/libleveldb.a
genleveldb.depends = FORCE
PRE_TARGETDEPS += $$PWD/leveldb/libleveldb.a
QMAKE_EXTRA_TARGETS += genleveldb
# Gross ugly hack that depends on qmake internals, unfortunately there is no other way to do it.
QMAKE_CLEAN += $$PWD/leveldb/libleveldb.a; cd $$PWD/leveldb ; $(MAKE) clean
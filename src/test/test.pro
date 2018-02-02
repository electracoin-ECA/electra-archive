CONFIG+=testcase

INCLUDEPATH += $$PWD/..

QMAKE_CXXFLAGS = -fpermissive

include(../boost.pri)
 
SOURCES += util_tests.cpp \
    sigopcount_tests.cpp \
    test_electra.cpp \
    Checkpoints_tests.cpp \
    netbase_tests.cpp \
    transaction_tests.cpp \
    script_tests.cpp \
    base58_tests.cpp \
    miner_tests.cpp \
    mruset_tests.cpp \
    rpc_tests.cpp \
    base64_tests.cpp \
    uint160_tests.cpp \
    multisig_tests.cpp \
    uint256_tests.cpp \
    base32_tests.cpp \
    script_P2SH_tests.cpp \
    wallet_tests.cpp \
    accounting_tests.cpp \
    bignum_tests.cpp \
    allocator_tests.cpp \
    getarg_tests.cpp \
    key_tests.cpp \
    DoS_tests.cpp

include(../core.pri)
include(../leveldb.pri)

# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$BOOST_INCLUDE_PATH 
LIBS += $$join(BOOST_LIB_PATH,,-L,)

LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX -lboost_unit_test_framework$$BOOST_UNIT_TEST_FRAMEWORK_LIB_SUFFIX
windows:LIBS += -lboost_chrono$$BOOST_LIB_SUFFIX
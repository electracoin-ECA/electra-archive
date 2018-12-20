// Copyright (c) 2014 The Bitcoin Core developers
// Copyright (c) 2014-2015 The Dash developers
// Copyright (c) 2015-2017 The PIVX developers
// Copyright (c) 2018 The Electra developers
// Distributed under the MIT/X11 software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "primitives/transaction.h"
#include "main.h"

#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_SUITE(main_tests)

CAmount nMoneySupplyPoSStart = 20000000000 * COIN;

BOOST_AUTO_TEST_CASE(subsidy_limit_test)
{
    CAmount nSum = 0;
    for (int nHeight = 0; nHeight < 2; nHeight += 1) {
        /* genesis block is empty */
        CAmount nSubsidy = GetBlockValue(nHeight, false, uint64_t(0));
        BOOST_CHECK(nSubsidy <= 0 * COIN);
        nSum += nSubsidy;
    }

    for (int nHeight = 2; nHeight < 3; nHeight += 1) {
        /* premine in block 2 */
        CAmount nSubsidy = GetBlockValue(nHeight, false, uint64_t(0));
        BOOST_CHECK(nSubsidy <= 1000000019 * COIN);
        nSum += nSubsidy;
    }

    for (int nHeight = 3; nHeight <= 11522; nHeight += 1) {
        /* PoW Phase One */
        CAmount nSubsidy = GetBlockValue(nHeight, false, uint64_t(0));
        BOOST_CHECK(nSubsidy <= 0.00390625 * COIN);
        nSum += nSubsidy;
    }

    for (int nHeight = 11523; nHeight < 11811; nHeight += 1) {
        /* PoW Phase Two */
        CAmount nSubsidy = GetBlockValue(nHeight, false, uint64_t(0));
        BOOST_CHECK(nSubsidy <= 65972222 * COIN);
        BOOST_CHECK(MoneyRange(nSubsidy));
        nSum += nSubsidy;
        BOOST_CHECK(nSum > 0 && nSum <= nMoneySupplyPoSStart);
    }
    //BOOST_CHECK(nSum == 4109975100000000ULL);
}

BOOST_AUTO_TEST_SUITE_END()

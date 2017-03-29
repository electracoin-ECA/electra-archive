#ifndef HASHBLOCK_H
#define HASHBLOCK_H

#include "uint256.h"
#include "sph_blake.h"
#include "sph_groestl.h"
#include "sph_jh.h"
#include "sph_keccak.h"
#include "sph_skein.h"

template<typename T1>
inline uint256 Nist5(const T1 pbegin, const T1 pend)
{
    sph_blake512_context     ctx_blake;
    sph_groestl512_context   ctx_groestl;
    sph_jh512_context        ctx_jh;
    sph_keccak512_context    ctx_keccak;
    sph_skein512_context     ctx_skein;

    static unsigned char pblank[1];
    uint512 hash;

    // Blake512
    sph_blake512_init(&ctx_blake);
    sph_blake512(&ctx_blake, (pbegin == pend ? pblank : (unsigned char*)&pbegin[0]), (pend - pbegin) * sizeof(pbegin[0]));
    sph_blake512_close(&ctx_blake, (unsigned char*)&hash);
    // Groestl512
    sph_groestl512_init(&ctx_groestl);
    sph_groestl512(&ctx_groestl, (unsigned char*)&hash, sizeof(hash));
    sph_groestl512_close(&ctx_groestl, (unsigned char*)&hash);
    // Jh512
    sph_jh512_init(&ctx_jh);
    sph_jh512(&ctx_jh, (unsigned char*)&hash, sizeof(hash));
    sph_jh512_close(&ctx_jh, (unsigned char*)&hash);
    // Keccak512
    sph_keccak512_init(&ctx_keccak);
    sph_keccak512(&ctx_keccak, (unsigned char*)&hash, sizeof(hash));
    sph_keccak512_close(&ctx_keccak, (unsigned char*)&hash);
    // Skein512
    sph_skein512_init(&ctx_skein);
    sph_skein512(&ctx_skein, (unsigned char*)&hash, sizeof(hash));
    sph_skein512_close(&ctx_skein, (unsigned char*)&hash);

    //printf("\nhash: %s\n", hash.ToString().c_str());

    return hash.trim256();
}

#endif // HASHBLOCK_H

# Electra Test Net

When Bitcoin was born, developers introduced [Bitcoin TestNet](https://en.bitcoin.it/wiki/Testnet): a blockchain functionally
identical to the official [MainNet](https://bitcoin.org/en/glossary/mainnet) that could be used as a way of testing
changes to the Bitcoin protocol and ensure compatibility and security of the blockchain.

It is of paramount importance to have at least one running and reliable TestNet where running Research and Development (R&D) tasks
in order to continuously release new Electra features or enhancements to users, without compromising the official blockchain.

For the reasons above, the Electra Team has implemented and released Electra TestNet.

## How to connect to TestNet

Connecting to Electra TestNet is very simple. You will need to update you `Electra.conf` with a list of testnet nodes, and 
launch your Electra wallet with the option `-testnet`.

Some testnet nodes are:

```properties
addnode=34.234.94.42:15817
addnode=54.172.176.159:15817
```

And the wallet should be launched with:
```bash
./Electra-qt -testnet
```

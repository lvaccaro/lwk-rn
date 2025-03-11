# Liquid Wallet Kit - react native

**LWK-rn** is a React Native module for [Liquid Wallet Kit](https://github.com/Blockstream/lwk). Its goal is to provide all the necessary building blocks for mobile development of a liquid wallet.

** NOTE: LWK and LWK-rn is in public beta and still undergoing significant development. Use it at your own risk. **

_Please consider reviewing, experimenting and contributing_

_Thanks for taking a look!_

## Installation

Using npm:

```sh
npm install lwk-rn
```

Using yarn:

```sh
yarn add lwk-rn
```

[iOS Only] Install pods:

```bash
npx pod-install
or
cd ios && pod install
```

Note: Use android sdk version >= 23 and iOS >= v13 .

### Examples

You could run the example in iOS or android by the following
```sh
$ yarn example ios
...
$ yarn example android
```

Create a Wallet and sync with Electrum client

```js
import { Wollet, Client, Signer, Network } from 'lwk-rn';

const mnemonic =
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';
const network = Network.Testnet;
const signer = await new Signer().create(mnemonic, network);
const descriptor = await signer.wpkhSlip77Descriptor();
console.log(await descriptor.asString());

const wollet = await new Wollet().create(network, descriptor, null);
const client = await new Client().defaultElectrumClient(network);
const update = await client.fullScan(wollet);
await wollet.applyUpdate(update);
```

Get a new address:
```js
const address = await wollet.getAddress();
console.log(address);
```

Get a transaction list:
```js
const transactions = await wollet.getTransactions();
console.log(transactions);
```

Get balance as `[AssetId : UInt64]`:
```js
const balance = await wollet.getBalance();
console.log(balance);
```

Build, sign and broadcast a Transaction:
```js
    const out_address = await wollet.getAddress().description;
    const satoshis = 900;
    const fee_rate = 280; // this is the sat/vB * 100 fee rate. Example 280 would equal a fee rate of .28 sat/vB. 100 would equal .1 sat/vB
    const builder = await new TxBuilder().create(network);
    await builder.addLbtcRecipient(out_address, satoshis);
    await builder.feeRate(fee_rate);
    let pset = await builder.finish(wollet);
    let signed_pset = await signer.sign(pset);
    let finalized_pset = await wollet.finalize(signed_pset);
    const tx = await finalized_pset.extractTx();
    await client.broadcast(tx);
    console.log("BROADCASTED TX!\nTXID: {:?}", (await tx.txId.toString()));
```
## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## HOWTO

See the [how-to](HOW-TO.md) to learn how works lwk-rn react native module and the repo code.

## Greetings

Thanks to all Blockstream LWK team for the amazing library.

A special thanks to @rcasatta to help me about packaging library for iOS and Android.

A big thanks to @BlakeKaufman because give me the opportunity to build this library with a [Bounty](https://github.com/BlakeKaufman/BlitzWallet/issues/4) and made contributions by itself.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

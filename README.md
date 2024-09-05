# lwk-rn

Liquid Wallet Kit react native module

_Note: Caution this is an Alpha at this stage
Please consider reviewing, experimenting and contributing ⚡️_

Thanks for taking a look!

## Installation

Using npm:

```sh
npm install lwk-rn
```

Using yarn:

```sh
yarn add lwk-rn
```

[IOS Only] Install pods:

```bash
npx pod-install
or
cd ios && pod install
```

### Examples

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
const address = await wollet.getTransactions();
console.log(address);
```

Get balance as `[AssetId : UInt64]`:
```js
const balance = await wollet.getBalance();
console.log(balance);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## HOWTO

See the [how-to](HOW-TO.md) to learn how works lwk-rn react native module and the repo code.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

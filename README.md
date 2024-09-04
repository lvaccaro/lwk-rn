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


### Examples

### Create a Wallet & sync the txs of a descriptor


```js
const mnemonic = 'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';
const network = Network.Testnet;
const descriptor = await new Descriptor().createDescriptorSecret(network, mnemonic);
const descriptorString = await descriptor.asString();
console.log('Your descriptor ' + descriptorString);
const wollet = await new Wollet().create(network, descriptor, '');
const client = await new Client().defaultElectrumClient(network);
const update = await client.fullScan(wollet);
await wollet.applyUpdate(update);
onst txs = await wollet.getTransactions();
console.log('Your have ' + txs + ' txs');
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## HOWTO

See the [howto](HOWTO.md) to learn how works lwk-rn react native module and the repo code.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

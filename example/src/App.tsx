import { useState, useEffect } from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { Wollet, Client, Signer, Network } from 'lwk-rn';

export default function App() {
  const [result, setResult] = useState<string | undefined>();

  useEffect(() => {
    async function setup() {
      const mnemonic =
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';
      const network = Network.Testnet;
      const signer = await new Signer().create(mnemonic, network);
      const descriptor = await signer.wpkhSlip77Descriptor();
      const wollet = await new Wollet().create(network, descriptor, null);
      const client = await new Client().defaultElectrumClient(network);
      const update = await client.fullScan(wollet);
      await wollet.applyUpdate(update);

      const txs = await wollet.getTransactions();
      console.log('Get transactions');
      console.log(txs.length.toString());

      const address = await wollet.getAddress();
      console.log('Get address');
      console.log(address);

      const balance = await wollet.getBalance();
      console.log('Get balance');
      console.log(balance);

      setResult(txs.length.toString());
    }

    setup();
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});

import { useState, useEffect } from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { Descriptor, Wollet, Client } from 'lwk-rn';
import { Network } from 'lwk-rn';

export default function App() {
  const [result, setResult] = useState<string | undefined>();

  useEffect(() => {
    async function setup() {
      const mnemonic =
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';
      const network = Network.Testnet;
      const descriptor = await new Descriptor().createDescriptorSecret(
        network,
        mnemonic
      );
      //const txt = await descriptor.asString();
      const wollet = await new Wollet().create(network, descriptor, '');
      const client = await new Client().defaultElectrumClient(network);
      const update = await client.fullScan(wollet);
      await wollet.applyUpdate(update);
      const txs = await wollet.getTransactions();

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

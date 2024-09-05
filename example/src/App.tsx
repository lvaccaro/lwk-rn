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
      console.log(await descriptor.asString());

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
      /*
      const out_address = address.description;
      const satoshis = 900;
      const fee_rate = 280; // this seems like absolute fees
      const builder = await new TxBuilder().create(network);
      await builder.addLbtcRecipient(out_address, satoshis);
      await builder.feeRate(fee_rate);
      let pset = await builder.finish(wollet);
      let signed_pset = await signer.sign(pset);
      let finalized_pset = await wollet.finalize(signed_pset);
      const tx = await finalized_pset.extractTx();
      await client.broadcast(tx);
      console.log('BROADCASTED TX!\nTXID: {:?}', tx.txId.toString());
*/
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

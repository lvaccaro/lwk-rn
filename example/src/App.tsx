import { Text, View, StyleSheet } from 'react-native';
import { Mnemonic, Network, Signer, Wollet } from 'lwk-rn';

let network = Network.testnet();
console.log("network:", network.toString());
console.log("policyAsset:", network.policyAsset().toString());

let mnemonic = new Mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"); 
let signer = new Signer(mnemonic, network);
console.log("mnemonic:", mnemonic.toString());

let singlesigDesc = signer.wpkhSlip77Descriptor();
let wollet = new Wollet(network, singlesigDesc, undefined);

// update wallet
let client = network.defaultElectrumClient();
let update = client.fullScan(wollet);
if (update) { 
  wollet.applyUpdate(update);
}

// show balance
let balance = wollet.balance();
console.log("balance");
for (var b of balance.entries()) {
  console.log("asset: ", b[0], ", value: ", b[1]);
}

// show transactions
let txs = wollet.transactions();
console.log(txs);
for (var tx of txs) {
  console.log("tx: ",tx.txid().toString());
  for (var output of tx.outputs()) {
    let script_pubkey = output?.scriptPubkey().toString();
    let value = output?.unblinded().value().toString();
    console.log(" -> script_pubkey: ", script_pubkey, ", value: ", value);
  }
}
const result = balance.get(network.policyAsset())?.toString();

// generate last unused address
let latest_address = wollet.address(undefined); 
let out_address = latest_address.address();
console.log("address:", out_address.toString());

// Build, sign, finalize and broadcast a transaction of policy asset
let satoshis = 900n;
let fee_rate = 280; // this seems like absolute fees

let builder = network.txBuilder();
builder.addLbtcRecipient(out_address, satoshis);
builder.feeRate(fee_rate);
let pset = builder.finish(wollet);

let signed_pset = signer.sign(pset);
let finalized_pset = wollet.finalize(signed_pset);
let txid = client
    .broadcast(finalized_pset.extractTx());
console.log("BROADCASTED TX!\nTXID: ", txid.toString());

export default function App() {
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
});


import { Network } from './enums';
import { WolletTx } from './bindings';

/** Get Network Enum */
export const getNetwork = (networkName: string): Network => {
    let networkEnum = Network.Testnet;
    switch (networkName) {
      case 'testnet':
        networkEnum = Network.Testnet;
        break;
      case 'regtest':
        networkEnum = Network.Regtest;
        break;
      case 'bitcoin':
        networkEnum = Network.Mainnet;
        break;
    }
    return networkEnum;
  };


type Props = {
  txid: string;
  balance: any;
  type: string;
  fee?: number;
  height?: number;
  timestamp?: number;
};

export const createWolletTxObject = (item: Props): WolletTx => {
  return new WolletTx(
    item.txid,
    item.balance,
    item.type,
    item?.fee,
    item?.height,
    item?.timestamp
  );
};
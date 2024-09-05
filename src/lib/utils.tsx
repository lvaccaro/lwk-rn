import { Network } from './enums';

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

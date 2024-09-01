
export enum Network {
    Testnet = 'testnet',
    Regtest = 'regtest',
    Mainnet = 'mainnet',
    Signet = 'signet',
  }
  
export enum ClientNames {
  Electrum = 'Electrum',
  Esplora = 'Esplora',
  Rpc = 'Rpc',
}

export interface ElectrumClientConfig {
  url: string;
  tls: boolean;
  validateDomain: boolean;
}
export interface EsploraClientConfig {
  url: string;
}
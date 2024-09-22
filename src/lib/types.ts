import { Chain } from "./enums";

export type Balance = {
    [index: string]: number;
}

export type Outpoint = {
  txid: string;
  vout: number;
}
export type Unblinded = {
  asset: string;
  assetBf: string;
  value: number;
  valueBf: string;
}

export type WolletTxOut = {
  ext_int: Chain,
  height: number | undefined;
  outpoint: Outpoint;
  script_pubkey: string;
  wildcard_index: number | undefined;
  unblinded: Unblinded;
}

export type WolletTx = {
    txid: string;
    balance: Balance;
    type: string;
    fee?: number | undefined;
    height?: number | undefined;
    timestamp?: number | undefined;
    inputs?: Array<WolletTxOut>;
    output?: Array<WolletTxOut>;
}

export type Update  = string;

export type Address = {
  description: string;
  is_blinded: string;
  qr_code_text: string;
  script_pubkey: string;
}

export type Contract = {
  domain: string;
  issuerPubkey: string;
  name: string;
  precision: number;
  ticker: string;
  version: number;  
}
export type Balance = {
    [index: string]: number;
}

export type WolletTx = {
    txid: string;
    balance: Balance;
    type: string;
    fee?: number | undefined;
    height?: number | undefined;
    timestamp?: number | undefined;
  }


export type Update  = string;

export class Transaction {
  id: string;
  constructor(id: string) {
    this.id = id
  }
}

export type Address = {
  description: string;
  is_blinded: string;
  qr_code_text: string;
  script_pubkey: string;
}
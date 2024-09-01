
export class Balance {
    [index: string]: number;
}

export class WolletTx {
    txid: string;
    balance: Balance;
    type: string;
    fee?: number | undefined;
    height?: number | undefined;
    timestamp?: number | undefined;
  
    constructor(
      txid: string,
      balance: Balance,
      type: string,
      fee?: number | undefined,
      height?: number | 0,
      timestamp?: number | 0
    ) {
      this.txid = txid;
      this.balance = balance;
      this.type = type;
      this.fee = fee;
      this.height = height;
      this.timestamp = timestamp;
    }
  }
  export type Update  = string;
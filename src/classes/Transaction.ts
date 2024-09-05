import { NativeLoader } from './NativeLoader';

export class Transaction extends NativeLoader {
  id: string = '';

  async from(id: string): Promise<Transaction> {
    this.id = id;
    return this;
  }

  async create(hex: string): Promise<Transaction> {
    this.id = await this._lwk.createTransaction(hex);
    return this;
  }

  async txId(): Promise<string> {
    return await this._lwk.txId(this.id);
  }

  async fee(policyAsset: string): Promise<number> {
    return this._lwk.txFee(this.id, policyAsset);
  }

  async asString(): Promise<string> {
    return this._lwk.txAsString(this.id);
  }
}

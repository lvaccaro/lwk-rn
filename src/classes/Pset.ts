import { NativeLoader } from './NativeLoader';
import { Transaction } from './Transaction';

export class Pset extends NativeLoader {
  id: string = '';

  async from(id: string): Promise<Pset> {
    this.id = id;
    return this;
  }

  async extractTx(): Promise<Transaction> {
    let id = this._lwk.psetExtractTx(this.id);
    return new Transaction().from(id);
  }

  async asString(): Promise<string> {
    return this._lwk.psetAsString(this.id);
  }
}

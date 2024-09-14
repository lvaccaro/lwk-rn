import { Network } from '../lib/enums';
import { type Update, type Address, type Balance } from '../lib/types';
import { type WolletTx } from '../lib/types';
import { NativeLoader } from './NativeLoader';
import { Descriptor } from './Descriptor';
import { Pset } from './Pset';

export class Wollet extends NativeLoader {
  id: string = '';
  updates: Array<string> = [];

  async create(
    network: Network,
    descriptor: Descriptor,
    datadir: string | null
  ): Promise<Wollet> {
    if (!Object.values(Network).includes(network)) {
      throw `Invalid network passed. Allowed values are ${Object.values(Network)}`;
    }
    this.id = await this._lwk.createWollet(network, descriptor.id, datadir);
    return this;
  }

  async applyUpdate(update: Update): Promise<any> {
    await this._lwk.applyUpdate(this.id, update);
    return null;
  }

  async getTransactions(): Promise<Array<WolletTx>> {
    return await this._lwk.getTransactions(this.id);
  }

  async getAddress(addressNum: number = 0): Promise<Address> {
    return await this._lwk.getAddress(this.id, addressNum);
  }

  async getBalance(): Promise<Balance> {
    return await this._lwk.getBalance(this.id);
  }

  async finalize(pset: Pset): Promise<Pset> {
    let newPsetId = await this._lwk.finalize(this.id, pset.id);
    return new Pset().from(newPsetId);
  }
}

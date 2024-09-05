import { NativeLoader } from './NativeLoader';
import { Wollet } from './Wollet';
import { Pset } from './Pset';

export class TxBuilder extends NativeLoader {
  id: string = '';

  async from(id: string): Promise<TxBuilder> {
    this.id = id;
    return this;
  }

  async create(network: string): Promise<TxBuilder> {
    this.id = await this._lwk.createTxBuilder(network);
    return this;
  }

  async addBurn(satoshi: number, asset: string): Promise<null> {
    return await this._lwk.txBuilderAddBurn(this.id, satoshi, asset);
  }
  async addLbtcRecipient(address: string, satoshi: number): Promise<null> {
    return await this._lwk.txBuilderAddLbtcRecipient(this.id, address, satoshi);
  }
  async addRecipient(
    address: string,
    satoshi: number,
    asset: string
  ): Promise<null> {
    return await this._lwk.txBuilderAddRecipient(
      this.id,
      address,
      satoshi,
      asset
    );
  }
  async drainLbtcTo(address: string): Promise<null> {
    return await this._lwk.txBuilderDrainLbtcTo(this.id, address);
  }
  async drainLbtcWallet(): Promise<null> {
    return await this._lwk.txBuilderDrainLbtcWallet(this.id);
  }
  async feeRate(rate: number | null): Promise<null> {
    return await this._lwk.txBuilderFeeRate(this.id, rate);
  }

  async finish(wollet: Wollet): Promise<Pset> {
    let psetId = await this._lwk.txBuilderFinish(this.id, wollet.id);
    return new Pset().from(psetId);
  }
}

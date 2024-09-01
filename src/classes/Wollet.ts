import { Network } from '../lib/enums';
import { type Update } from '../lib/bindings';
import { createWolletTxObject } from '../lib/utils';
import { WolletTx,  } from '../lib/bindings';
import { NativeLoader } from './NativeLoader';
import { Descriptor } from './Descriptor';

export class Wollet extends NativeLoader {
    id: string = '';
    updates: Array<string> = [];
  
    async create(
        network: Network,
        descriptor: Descriptor,
        datadir: string
      ): Promise<Wollet> {
        if (!Object.values(Network).includes(network)) {
            throw `Invalid network passed. Allowed values are ${Object.values(Network)}`
          }
        this.id = await this._lwk.createWollet(network, descriptor.id, datadir)        
        return this
      }


      async applyUpdate(update: Update): Promise<any> {
        await this._lwk.applyUpdate(this.id, update)        
        return null
      }

      async getTransactions(): Promise<Array<WolletTx>> {
        let list = await this._lwk.getTransactions(this.id)        
        let transactions: Array<WolletTx> = [];
        list.map((item) => {
            let localObj = createWolletTxObject(item);
            transactions.push(localObj);
        });
        return transactions;
      }

    }
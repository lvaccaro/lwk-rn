import {
  type ElectrumClientConfig,
  type EsploraClientConfig,
} from '../lib/interfaces';
import { ClientNames, Network } from '../lib/enums';
import { type Update } from '../lib/types';
import { NativeLoader } from './NativeLoader';
import type { Wollet } from './Wollet';
import type { Transaction } from './Transaction';

export class Client extends NativeLoader {
  id: string = '';

  async create(
    config: ElectrumClientConfig | EsploraClientConfig,
    clientName: ClientNames = ClientNames.Electrum
  ): Promise<Client> {
    if (ClientNames.Electrum === clientName) {
      const { url, tls, validateDomain } = config as ElectrumClientConfig;
      this.id = await this._lwk.initElectrumClient(url, tls, validateDomain);
    } else if (ClientNames.Esplora === clientName) {
      //const { url } = config as EsploraClientConfig;
      //this.id = await this._lwk.initEsploraBlockchain(url);
    } else {
      throw `Invalid client name passed. Allowed values are ${Object.values(clientName)}`;
    }
    return this;
  }

  async defaultElectrumClient(network: Network): Promise<Client> {
    if (!Object.values(Network).includes(network)) {
      throw `Invalid network passed. Allowed values are ${Object.values(Network)}`;
    }
    this.id = await this._lwk.defaultElectrumClient(network);
    return this;
  }

  async fullScan(wollet: Wollet): Promise<Update> {
    return await this._lwk.fullScan(wollet.id, this.id);
  }

  async broadcast(tx: Transaction): Promise<string> {
    return await this._lwk.broadcast(this.id, tx.id);
  }
}

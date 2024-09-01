import { Network } from '../lib/enums';
import { NativeLoader } from './NativeLoader';


export class Descriptor extends NativeLoader {
    id: string = '';
  
    /**
     * Constructor
     * @param descriptor
     * @param networ
     * @returns {Promise<Descriptor>}
     */
    async create(descriptor: string): Promise<Descriptor> {
      this.id = await this._lwk.createDescriptor(descriptor);
      return this;
    }
  
    /**
     * Constructor
     * @param network
     * @param mnemonic
     * @returns {Promise<Descriptor>}
     */
    async createDescriptorSecret(network: Network, mnemonic: string): Promise<Descriptor> {
        if (!Object.values(Network).includes(network)) {
          throw `Invalid network passed. Allowed values are ${Object.values(Network)}`;
        }
        this.id = await this._lwk.createDescriptorSecret(network, mnemonic);
        return this;
      }
    /**
     * Return the public version of the output descriptor.
     * @returns {Promise<string>}
     */
    async asString(): Promise<string> {
      return this._lwk.descriptorAsString(this.id);
    }
    async multiply(a: number, b: number): Promise<number> {
        return this._lwk.multiply(a, b)
    }
}
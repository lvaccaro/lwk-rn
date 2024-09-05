import { NativeLoader } from './NativeLoader';

export class Descriptor extends NativeLoader {
  id: string = '';

  async from(id: string): Promise<Descriptor> {
    this.id = id;
    return this;
  }

  async create(descriptor: string): Promise<Descriptor> {
    this.id = await this._lwk.createDescriptor(descriptor);
    return this;
  }

  async asString(): Promise<string> {
    return this._lwk.descriptorAsString(this.id);
  }
}

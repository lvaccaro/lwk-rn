import { NativeLoader } from './NativeLoader';

export class Pset extends NativeLoader {
  id: string = '';

  async from(id: string): Promise<Pset> {
    this.id = id;
    return this;
  }

  async asString(): Promise<string> {
    return this._lwk.psetAsString(this.id);
  }
}

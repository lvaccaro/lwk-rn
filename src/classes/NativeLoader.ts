import type { WolletTx } from '../lib/bindings';
import { Network } from '../lib/enums';
import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-lwk-module' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export interface NativeLwk {
  multiply(a: number, b: number): number;

  createDescriptorSecret(network: Network, mnemonic: string): string;
  createDescriptor(descriptor: string): string;
  descriptorAsString(id: string): string;

  initElectrumClient(
    electrumUrl: string,
    tls: boolean,
    validateDomain: boolean
  ): string;
  defaultElectrumClient(network: Network): string;

  createWollet(network: Network, descriptorId: string, datadir: string): string;
  fullScan(wolletId: string, clientId: string): string;
  applyUpdate(wolletId: string, updateId: string): string;
  getTransactions(wolletId: string): Array<WolletTx>;
}

export class NativeLoader {
  protected _lwk: NativeLwk;

  constructor() {
    this._lwk = NativeModules.LwkRnModule
      ? NativeModules.LwkRnModule
      : new Proxy(
          {},
          {
            get() {
              throw new Error(LINKING_ERROR);
            },
          }
        );
  }
}

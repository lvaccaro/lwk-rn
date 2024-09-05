import type { Address, Balance, WolletTx } from '../lib/types';
import { Network } from '../lib/enums';
import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-lwk-module' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export interface NativeLwk {
  // Descriptor
  createDescriptor(descriptor: string): string;
  descriptorAsString(id: string): string;

  // Electrum Client
  initElectrumClient(
    electrumUrl: string,
    tls: boolean,
    validateDomain: boolean
  ): string;
  defaultElectrumClient(network: Network): string;
  broadcast(clientId: string, txId: string): string;

  // Signer
  createSigner(mnemonic: string, network: Network): string;
  sign(signerId: string, psetId: string): string;
  wpkhSlip77Descriptor(signerId: string): string;

  // Wollet
  createWollet(
    network: Network,
    descriptorId: string,
    datadir: string | null
  ): string;
  fullScan(wolletId: string, clientId: string): string;
  applyUpdate(wolletId: string, updateId: string): string;
  getTransactions(wolletId: string): Array<WolletTx>;
  getDescriptor(wolletId: string): string;
  getBalance(wolletId: string): Balance;
  getAddress(wolletId: string, index: number | null): Address;
  finalize(wolletId: string, psetId: string): string;

  // Pset
  psetAsString(psetId: string): string;
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

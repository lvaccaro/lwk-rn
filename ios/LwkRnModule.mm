#import <React/RCTBridgeModule.h>


@interface RCT_EXTERN_MODULE(LwkRnModule, NSObject)

    /** Signers Methods */
    RCT_EXTERN_METHOD(
                      createSigner: (nonnull NSString)mnemonic
                      network: (nonnull NSString)network
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject: (RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      sign: (nonnull NSString)signerId
                      psetId: (nonnull NSString)psetId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject: (RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      wpkhSlip77Descriptor: (nonnull NSString)signerId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject: (RCTPromiseRejectBlock)reject
                      )
    
    /** Descriptors Methods */
    
    RCT_EXTERN_METHOD(
                      createDescriptor: (nonnull NSString)descriptor
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      descriptorAsString: (nonnull NSString)keyId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    /** Electrum client Methods */
    RCT_EXTERN_METHOD(
                      initElectrumClient: (nonnull NSString)electrumUrl
                      tls:(bool)tls
                      validateDomain:(bool)validateDomain
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      defaultElectrumClient: (nonnull NSString)network
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      broadcast: (nonnull NSString)clientId
                      txId: (nonnull NSString)txId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    /** Wollet Methods */
    
    RCT_EXTERN_METHOD(
                      createWollet: (nonnull NSString)network
                      descriptorId:(nonnull NSString)descriptorId
                      datadir:(NSString)datadir
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      fullScan: (nonnull NSString)wolletId
                      clientId:(nonnull NSString)clientId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      applyUpdate: (nonnull NSString)wolletId
                      updateId:(nonnull NSString)updateId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      getTransactions: (nonnull NSString)wolletId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      getDescriptor: (nonnull NSString)wolletId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      getAddress: (nonnull NSString)wolletId
                      index: (int)index
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      getBalance: (nonnull NSString)wolletId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    /** Transactions Methods */
    RCT_EXTERN_METHOD(
                      createTransaction: (nonnull NSString)string
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txId: (nonnull NSString)string
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txFee: (nonnull NSString)string
                      policyAsset: (nonnull NSString)string
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txAsString: (nonnull NSString)string
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    /** Pset Methods */
    RCT_EXTERN_METHOD(
                      psetAsString: (nonnull NSString)psetId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      psetExtractTx: (nonnull NSString)psetId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    /** TxBuilder Methods */
    RCT_EXTERN_METHOD(
                      createTxBuilder: (nonnull NSString)network
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txBuilderAddBurn: (nonnull NSString)id
                      satoshi: (nonnull NSNumber)satoshi
                      asset: (nonnull NSString)asset
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txBuilderAddLbtcRecipient: (nonnull NSString)id
                      address: (nonnull NSString)address
                      satoshi: (nonnull NSNumber)satoshi
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txBuilderAddRecipient: (nonnull NSString)id
                      address: (nonnull NSString)address
                      satoshi: (nonnull NSNumber)satoshi
                      asset: (nonnull NSString)asset
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txBuilderDrainLbtcTo: (nonnull NSString)id
                      address: (nonnull NSString)address
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txBuilderLbtcWallet: (nonnull NSString)id
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    RCT_EXTERN_METHOD(
                      txBuilderFeeRate: (nonnull NSString)id
                      rate: (nonnull NSNumber)rate
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    RCT_EXTERN_METHOD(
                      txBuilderFinish: (nonnull NSString)id
                      wolletId: (nonnull NSString)wolletId
                      resolve: (RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject
                      )
    
    + (BOOL)requiresMainQueueSetup
    {
        return NO;
    }
    
@end
    

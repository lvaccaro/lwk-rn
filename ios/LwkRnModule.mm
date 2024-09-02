#import <React/RCTBridgeModule.h>


@interface RCT_EXTERN_MODULE(LwkRnModule, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a b:(float)b
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)


/** Descriptors Methods */
RCT_EXTERN_METHOD(
    createDescriptorSecret: (nonnull NSString)network
    mnemonic:(nonnull NSString)mnemonic
    resolve: (RCTPromiseResolveBlock)resolve
    reject:(RCTPromiseRejectBlock)reject
)

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

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end


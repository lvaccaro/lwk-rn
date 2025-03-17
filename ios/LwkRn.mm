// Generated by uniffi-bindgen-react-native
#import "LwkRn.h"

namespace uniffi_generated {
    using namespace facebook::react;
    /**
    * ObjC++ class for module 'NativeLwkRn'
    */
    class JSI_EXPORT NativeLwkRnSpecJSI : public ObjCTurboModule {
    public:
        NativeLwkRnSpecJSI(const ObjCTurboModule::InitParams &params);
        std::shared_ptr<CallInvoker> callInvoker;
    };

    static facebook::jsi::Value __hostFunction_LwkRn_installRustCrate(facebook::jsi::Runtime& rt, TurboModule &turboModule, const facebook::jsi::Value* args, size_t count) {
        auto& tm = static_cast<NativeLwkRnSpecJSI&>(turboModule);
        auto jsInvoker = tm.callInvoker;
        uint8_t result = lwkrn::installRustCrate(rt, jsInvoker);
        return facebook::jsi::Value(rt, result);
    }
    static facebook::jsi::Value __hostFunction_LwkRn_cleanupRustCrate(facebook::jsi::Runtime& rt, TurboModule &turboModule, const facebook::jsi::Value* args, size_t count) {
        uint8_t result = lwkrn::cleanupRustCrate(rt);
        return facebook::jsi::Value(rt, result);
    }

    NativeLwkRnSpecJSI::NativeLwkRnSpecJSI(const ObjCTurboModule::InitParams &params)
        : ObjCTurboModule(params), callInvoker(params.jsInvoker) {
            this->methodMap_["installRustCrate"] = MethodMetadata {1, __hostFunction_LwkRn_installRustCrate};
            this->methodMap_["cleanupRustCrate"] = MethodMetadata {1, __hostFunction_LwkRn_cleanupRustCrate};
    }
} // namespace uniffi_generated

@implementation LwkRn
RCT_EXPORT_MODULE()

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED

// Automated testing checks lwkrn
// by comparing the whole line here.
/*
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(lwkrn::multiply(a, b));
}
*/

- (NSNumber *)installRustCrate {
    @throw [NSException exceptionWithName:@"UnreachableException"
                        reason:@"This method should never be called."
                        userInfo:nil];
}

- (NSNumber *)cleanupRustCrate {
    @throw [NSException exceptionWithName:@"UnreachableException"
                        reason:@"This method should never be called."
                        userInfo:nil];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<uniffi_generated::NativeLwkRnSpecJSI>(params);
}
#endif

@end
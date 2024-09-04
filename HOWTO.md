# HOWTO lwk-rn

LWK-RN is a react module for Liquid Wallet Kit library  
Liquid Wallet Kit react native module help

## Build skeleton

Start a template project and selet native module:
```sh
$ npx create-react-native-library@latest lwk-rn
...
 What type of library do you want to develop? › - Use arrow-keys. Return to submit.
    JavaScript library
❯   Native module
```

The creator create a folder with all the main components as the follow:
```sh
$ cd ln-rn
- ios/     # swift wrapper for react
- android/ # kotlin wrapper for react
- example/ # examples for all the platforms
- src/     # js classes to siomplify the raw interface
- package.json # node package definition
```
NOTE: Change path or rename files could broke all the stuff.

The template contains a demo code to wrap a `multiply` function from swift/kotlin definition to react native. The examples allow to run the `multiply` in ios and android simulator.

```sh
$ npx run ios
...
$ npx run android
...
```

## iOS Swift module

### Module specification
The iOS module needs to be archived in cocoapods with the `lwk-rn.podspec` file in order to be included in the react native for iOS. When the exmple iOS app will be build, the command `pod install` takes care of all the dependencies. 
The podspec cointains the module definition and all the iOS dependency which are required.
 ```sh
$ cat lwk-rn.podspec
...
Pod::Spec.new do |s|
  s.name         = "lwk-rn"
  ...
  s.dependency 'lwkFFI', '0.0.1'
  s.dependency 'LiquidWalletKit', '0.0.1'
```
NOTE: react native use cocoapods instead SPM, so also all your dependencies should be availabe in cocoapods package system.

### Module raw interface
Lwk-rn uses the SWIFT interface of LWK library, available at https://github.com/blockstream/lwk-swift. So the raw interface is defined in Swift and only the bridge is in Object-C.
Checking the folder `ios`:
```sh
- LWKRnModule-Bridging-Header.h # standard bridge interface for react, don't edit
- LWKRnModule.mm # the module interface in Object-C with the list of all exported functions
- LWKRnModule.swift # our swift code which use LiquidWalletKit library whith the definition of the functions
```

### LWKRnModule.swift
The `LWKRnModule.swift` import and use the `LiquidWalletKit` library to export a set of functions used by react native; the library dependency is defined in `lwk-rn.podspec` file.

The react template create the class module with a simple `multiply` function for demo. All the class and functions needs the `@objc` annotation. The function takes 2 inputs params and 2 output parameters, which they are used to set the returned value into `resolve` or an error in `reject`. The function output is provided by promise block instead returned value.

NOTE: in case of exported functions, all the params needs to be convertible in Object-C, so avoid to use custom types.

```swift
import LiquidWalletKit 

@objc(LwkRnModule)
class LwkRnModule: NSObject {

  @objc
  func multiply(_ a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }
}
```

LWK library use custom types as WalletDescriptor, Wollet, ElectrumClient and so on, which they are not convertible. The lwk-rn interface stores locally the instantiated object in an hashmap and provide to the react interface the key pointer, so when react needs to access to an object, the interface will be pass the key id to manipulate the object.
In the followning code, `createDescriptor()` create a `WalletDescriptor` object from a string, store it locally and return the id. `descriptorAsString()` takes the keyId and return the string descriptor of the pointed  `WalletDescriptor` object.

```swift
  var _descriptors: [String: WolletDescriptor] = [:]

  @objc 
  func createDescriptor(_
    descriptor: String,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let id = randomId()
      _descriptors[id] = try WolletDescriptor(descriptor: descriptor)
      resolve(id)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

    @objc
    func descriptorAsString(_
        keyId: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        resolve(_descriptors[keyId]!.description)
    }
```

### LWKRnModule.mm
The `LWKRnModule.mm` is the interface file for the binding of swift code. It has a own macro system to define the interface and object and a set of H library file to import/use specific bridging objects.

The template create an interface for the `multiply` function as the following.
```c
#import <React/RCTBridgeModule.h>


@interface RCT_EXTERN_MODULE(LwkRnModule, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a b:(float)b
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
```

Lwk-rn extends the interface with all the prototypes of functions which required to be exported, defined in `LWKRnModule.swift`.
For the preivos declarated function the interface is the following
```c

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
```
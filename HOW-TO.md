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
$ yarn example ios
...
$ yarn example android
...
```

## iOS Swift module
The `./ios/` folder contains all the bindings for the iOS platform to expose in react.

### Pods specification
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

### Pods import
In order to use the library previously linked in the podspec file, the `./ios/` folder contains the `Podfile` as the following :
```pod
ws_dir = Pathname.new(__dir__)
ws_dir = ws_dir.parent until
  File.exist?("#{ws_dir}/node_modules/react-native-test-app/test_app.rb") ||
  ws_dir.expand_path.to_s == '/'
require "#{ws_dir}/node_modules/react-native-test-app/test_app.rb"

workspace 'LwkRnExample.xcworkspace'

use_test_app!

config = use_native_modules!
```
Note: be sure to add the last line to use native module


### Module raw interface
Lwk-rn uses the SWIFT interface of LWK library, available at https://github.com/blockstream/lwk-swift.
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

```c++
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

## Typescript interface

LWK-RN module is written to export a library interface most similar to the LWK bindings interface. 
The `./src/` folder contains the typescript code to load the raw interface, expose classes and types to simplify user interaction and hide the complexity of all ids parameters.

The `NativeLoader.ts` is the script to load the raw module interface and expose all the functions defining the input parameters and the returned value, in this case we don't use any Promise. For example, the NativeLoader implement the descriptor functions as the follow:
```ts
import NativeModules from 'react-native';

export interface NativeLwk {
  createDescriptor(descriptor: string): string;
  descriptorAsString(id: string): string;
  ...
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
```

## Android Kotlin module
The `./android/` folder contains all the bindings for the Android platform to expose in react. The folder could be open by Android Studio as android project itself.

### Grandle import
The `./android/build.gradle` file contains the list of the dependency, as react framework for android and the lwk android library.
```kotlin
dependencies {
    implementation 'com.facebook.react:react-android:+'
    implementation files("/Users/luca/blockstream/lwk/lwk_bindings/android_bindings1/lib/build/outputs/aar/lib-debug.aar")
}
```

### Kotlin interface
The kotlin interface is defined in the subfolder `./android/src/main/java/io/lwkrn` folder.
The folder contains:
- `LwkRnPackage.kt`: define the module as ReactPackage to be exported, don't edit
- `LwkRnModule.kt`: define the list of all exported functions

The `LwkRnModule.kt` expose the functions in the same way as iOS does. 
All the functions needs the `@ReactMethod` annotation, takes input parameters and set the result into promise callback.

 The kotlin module with the descriptors functions is defined as the follow:

```kotlin
package io.lwkrn

import com.facebook.react.bridge.*
import lwk.WolletDescriptor

class LwkRnModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "LwkRnModule"
    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }

    private var _descriptors = mutableMapOf<String, WolletDescriptor>()

    @ReactMethod
    fun createDescriptor(
        descriptor: String, result: Promise
    ) {
        try {
        val id = randomId()
        _descriptors[id] = WolletDescriptor(descriptor)
        result.resolve(id)
        } catch (error: Throwable) {
        return result.reject("WolletDescriptor create error", error.localizedMessage, error)
        }
    }

    @ReactMethod
    fun descriptorAsString(
        keyId: String,
        result: Promise
    ) {
        result.resolve(_descriptors[keyId]!!.toString())
    }
}
```

## Example

The repository provide a working demo example written in typescript in `example` folder. All the react code is written in `src/App.tsx`. The example code uses the react interface previously defined with high level classes and types.

The Following code get a descriptor for liquid testnet from a mnemonic, connect to electrum and full scan to get the list of transactions.
```ts
      const mnemonic =
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';
      const network = Network.Testnet;
      const descriptor = await new Descriptor().createDescriptorSecret(
        network,
        mnemonic
      );
      const descriptorString = await descriptor.asString();
      console.log('Your descriptor ' + descriptorString);
      const wollet = await new Wollet().create(network, descriptor, '');
      const client = await new Client().defaultElectrumClient(network);
      const update = await client.fullScan(wollet);
      await wollet.applyUpdate(update);
      const txs = await wollet.getTransactions();
      console.log('Your have ' + txs + ' txs');
```

You could run the example in iOS or android by the following
```sh
$ yarn example ios
...
$ yarn example android
```
NOTE: most of the example code is autogenerated for both platform, so editing platform files in `./example/ios/` or `example/android/` subfolder could break stuff. Anyway a dev could open the subfolder in Xcode or Android Studio for developing and testing.
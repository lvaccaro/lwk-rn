import LiquidWalletKit 


@objc(LwkRnModule)
class LwkRnModule: NSObject {

  var _descriptors: [String: WolletDescriptor] = [:]
  var _electrumClients: [String: ElectrumClient] = [:]
  var _wollets: [String: Wollet] = [:]
  var _updates: [String: Update] = [:]
  var _transactions: [String: WalletTx] = [:]

  @objc
  func multiply(_ a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }

  @objc
  func createDescriptorSecret(_
    network: String,
    mnemonic: String,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let id = randomId()
      let mnemonic = try Mnemonic(s: mnemonic)
      let network = setNetwork(networkStr: network)
      let signer = try Signer(mnemonic: mnemonic, network: network)
      _descriptors[id] = try signer.wpkhSlip77Descriptor()
      resolve(id)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

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

  @objc
  func initElectrumClient(_
    electrumUrl: String,
    tls: Bool,
    validateDomain: Bool,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let client = try ElectrumClient(electrumUrl: electrumUrl, tls: tls, validateDomain: validateDomain)
      let id = randomId()
      _electrumClients[id] = client
      resolve(id)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

  @objc
  func defaultElectrumClient(_
    network: String,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let network = setNetwork(networkStr: network)
      let client = try network.defaultElectrumClient()
      let id = randomId()
      _electrumClients[id] = client
      resolve(id)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

  @objc 
  func createWollet(_
    network: String,
    descriptorId: String,
    datadir: String,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let network = setNetwork(networkStr: network)
      let descriptor = _descriptors[descriptorId]
      let wollet = try Wollet(network: network, descriptor: descriptor!, datadir: nil)
      let id = randomId()
      _wollets[id] = wollet
      resolve(id)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

  @objc 
  func fullScan(_
    wolletId: String,
    clientId: String,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let client = _electrumClients[clientId]
      let wollet = _wollets[wolletId]
      let update = try client!.fullScan(wollet: wollet!)
      let id = randomId()
      _updates[id] = update
      resolve(id)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

  @objc 
  func applyUpdate(_
    wolletId: String,
    updateId: String,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let wollet = _wollets[wolletId]
      let update = _updates[updateId]
      try wollet!.applyUpdate(update: update!)
      resolve(nil)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

  @objc 
  func getTransactions(_
    wolletId: String,
    resolve: RCTPromiseResolveBlock, 
    reject: RCTPromiseRejectBlock
  ) -> Void {
    do {
      let wollet = _wollets[wolletId]
      let txs = try wollet!.transactions()
      var responseObject: [Any] = []  
            for item in txs {
                var txObject = getTransactionObject(transaction: item)
                let randomId = randomId()
                _transactions[randomId] = item
                txObject["transaction"] = randomId
                responseObject.append(txObject)
            }
            resolve(responseObject)
     } catch {
       reject("Error", error.localizedDescription, error)
    }
  }

}

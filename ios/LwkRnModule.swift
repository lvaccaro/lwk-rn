import LiquidWalletKit 


@objc(LwkRnModule)
class LwkRnModule: NSObject {
    
    var _signers: [String: Signer] = [:]
    var _descriptors: [String: WolletDescriptor] = [:]
    var _electrumClients: [String: ElectrumClient] = [:]
    var _wollets: [String: Wollet] = [:]
    var _updates: [String: Update] = [:]
    var _wolletTxs: [String: WalletTx] = [:]
    var _transactions: [String: Transaction] = [:]
    var _addresses: [String: Address] = [:]
    var _psets: [String: Pset] = [:]
    var _txBuilders: [String: TxBuilder] = [:]
    
    
    /* WolletDescriptor */
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
            reject("Descriptor create error", error.localizedDescription, error)
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
    
    
    
    /* Signer */
    @objc
    func createSigner(
        _ mnemonic: String,
        network: String,
        resolve: RCTPromiseResolveBlock,
        reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let id = randomId()
            let mnemonic = try Mnemonic(s: mnemonic)
            let network = setNetwork(networkStr: network)
            _signers[id] = try Signer(mnemonic: mnemonic, network: network)
            resolve(id)
        } catch {
            reject("Signer create error", error.localizedDescription, error)
        }
    }
    
    @objc
    func sign(
        _ signerId: String,
        psetId: String,
        resolve: RCTPromiseResolveBlock,
        reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let id = randomId()
            let signer = _signers[signerId]
            let pset = _psets[psetId]
            _psets[id] = try signer!.sign(pset: pset!)
            resolve(id)
        } catch {
            reject("Signer sign error", error.localizedDescription, error)
        }
    }
    
    @objc
    func wpkhSlip77Descriptor(
        _ signerId: String,
        resolve: RCTPromiseResolveBlock,
        reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let id = randomId()
            let signer = _signers[signerId]
            _descriptors[id] = try signer?.wpkhSlip77Descriptor()
            resolve(id)
        } catch {
            reject("Signer wpkhSlip77Descriptor error", error.localizedDescription, error)
        }
    }
    
    /* Electrum client */
    
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
            reject("ElectrumClient init error", error.localizedDescription, error)
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
            reject("ElectrumClient default error", error.localizedDescription, error)
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
            reject("ElectrumClient fullScan error", error.localizedDescription, error)
        }
    }
    
    @objc
    func broadcast(_
                   clientId: String,
                   txId: String,
                   resolve: RCTPromiseResolveBlock,
                   reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let client = _electrumClients[clientId]
            let transaction = _transactions[txId]
            let txid = try client!.broadcast(tx: transaction!)
            resolve(txid.description)
        } catch {
            reject("ElectrumClient broadcast error", error.localizedDescription, error)
        }
    }
    
    /* Wollet */
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
            reject("Wollet create error", error.localizedDescription, error)
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
            reject("Wollet applyUpdate error", error.localizedDescription, error)
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
                _wolletTxs[randomId] = item
                txObject["transaction"] = randomId
                responseObject.append(txObject)
            }
            resolve(responseObject)
        } catch {
            reject("Wollet getTransactions error", error.localizedDescription, error)
        }
    }
    
    @objc
    func getDescriptor(_
                       wolletId: String,
                       resolve: RCTPromiseResolveBlock,
                       reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            resolve(try _wollets[wolletId]!.descriptor().description)
        } catch {
            reject("Wollet getDescriptor error", error.localizedDescription, error)
        }
    }
    
    @objc
    func getAddress(_
                    wolletId: String,
                    index: NSNumber? = nil,
                    resolve: RCTPromiseResolveBlock,
                    reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let wollet = _wollets[wolletId]
            let address = try wollet!.address(index: index?.uint32Value).address()
            resolve(getAddressObject(address: address))
        } catch {
            reject("Wollet getAddress error", error.localizedDescription, error)
        }
    }
    
    @objc
    func getBalance(_
                    wolletId: String,
                    resolve: RCTPromiseResolveBlock,
                    reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let wollet = _wollets[wolletId]
            let balance = try wollet!.balance()
            resolve(balance)
        } catch {
            reject("Wollet getBalance error", error.localizedDescription, error)
        }
    }
    
    @objc
    func finalize(_
                  wolletId: String,
                  psetId: String,
                  resolve: RCTPromiseResolveBlock,
                  reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let wollet = _wollets[wolletId]
            let pset = _psets[psetId]
            let id = randomId()
            _psets[id] = try wollet!.finalize(pset: pset!)
            resolve(id)
        } catch {
            reject("Wollet finalize error", error.localizedDescription, error)
        }
    }
    
    /* Transaction */
    @objc
    func createTransaction(_
                           hex: String,
                           resolve: RCTPromiseResolveBlock,
                           reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let id = randomId()
            _transactions[id] = try Transaction(hex: hex)
            resolve(id)
        } catch {
            reject("Transaction create error", error.localizedDescription, error)
        }
    }
    
    @objc
    func txId(_
              txId: String,
              resolve: RCTPromiseResolveBlock,
              reject: RCTPromiseRejectBlock
    ) -> Void {
        let tx = _transactions[txId]
        resolve(tx?.txid().description)
    }
    
    @objc
    func txFee(_
               txId: String,
               policyAsset: String,
               resolve: RCTPromiseResolveBlock,
               reject: RCTPromiseRejectBlock
    ) -> Void {
        let tx = _transactions[txId]
        resolve(tx?.fee(policyAsset: policyAsset))
    }
    @objc
    func txAsString(_
                    txId: String,
                    resolve: RCTPromiseResolveBlock,
                    reject: RCTPromiseRejectBlock
    ) -> Void {
        let tx = _transactions[txId]
        resolve(tx?.description)
    }    
    
    /* Pset */
    @objc
    func psetAsString(_
                      psetId: String,
                      resolve: RCTPromiseResolveBlock,
                      reject: RCTPromiseRejectBlock
    ) -> Void {
        resolve(_psets[psetId]!.description)
    }
    
    @objc
    func psetExtractTx(_
                       psetId: String,
                       resolve: RCTPromiseResolveBlock,
                       reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let id = randomId()
            let pset = _psets[psetId]
            _transactions[id] = try pset!.extractTx()
            resolve(id)
        } catch {
            reject("Pset extractTx error", error.localizedDescription, error)
        }
    }
    
    /* TxBuilder */
    
    @objc
    func createTxBuilder(_
                         network: String,
                         resolve: RCTPromiseResolveBlock,
                         reject: RCTPromiseRejectBlock
    ) -> Void {
        let id = randomId()
        let network = setNetwork(networkStr: network)
        _txBuilders[id] = network.txBuilder()
        resolve(id)
    }
    
    @objc
    func txBuilderAddBurn(_
                          id: String,
                          satoshi: NSNumber,
                          asset: String,
                          resolve: RCTPromiseResolveBlock,
                          reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            try _txBuilders[id]?.addBurn(satoshi: satoshi.uint64Value, asset: asset)
            resolve(nil)
        } catch {
            reject("TxBuilder addBurn error", error.localizedDescription, error)
        }
    }
    @objc
    func txBuilderAddLbtcRecipient(_
                                id: String,
                                address: String,
                                satoshi: NSNumber,
                                resolve: RCTPromiseResolveBlock,
                                reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            try _txBuilders[id]?.addLbtcRecipient(address: try Address(s: address), satoshi: satoshi.uint64Value)
            resolve(nil)
        } catch {
            reject("TxBuilder addLbtcRecipient error", error.localizedDescription, error)
        }
    }
    @objc
    func txBuilderAddRecipient(_
                               id: String,
                               address: String,
                               satoshi: NSNumber,
                               asset: String,
                               resolve: RCTPromiseResolveBlock,
                               reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            try _txBuilders[id]?.addRecipient(address: try Address(s: address), satoshi: satoshi.uint64Value, asset: asset)
            resolve(nil)
        } catch {
            reject("TxBuilder addRecipient error", error.localizedDescription, error)
        }
    }
    @objc
    func txBuilderDrainLbtcTo(_
                              id: String,
                              address: String,
                              resolve: RCTPromiseResolveBlock,
                              reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            try _txBuilders[id]?.drainLbtcTo(address: try Address(s: address))
            resolve(nil)
        } catch {
            reject("TxBuilder drainLbtcTo error", error.localizedDescription, error)
        }
    }
    @objc
    func txBuilderDrainLbtcWallet(_
                                  id: String,
                                  resolve: RCTPromiseResolveBlock,
                                  reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            try _txBuilders[id]?.drainLbtcWallet()
            resolve(nil)
        } catch {
            reject("TxBuilder drainLbtcWallet error", error.localizedDescription, error)
        }
    }
    @objc
    func txBuilderFeeRate(_
                          id: String,
                          rate: NSNumber,
                          resolve: RCTPromiseResolveBlock,
                          reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            try _txBuilders[id]?.feeRate(rate: rate.floatValue)
            resolve(nil)
        } catch {
            reject("TxBuilder feeRate error", error.localizedDescription, error)
        }
    }
    @objc
    func txBuilderFinish(_
                         id: String,
                         wolletId: String,
                         resolve: RCTPromiseResolveBlock,
                         reject: RCTPromiseRejectBlock
    ) -> Void {
        do {
            let txBuilder = _txBuilders[id]
            let wollet = _wollets[wolletId]
            let id = randomId()
            _psets[id] = try txBuilder!.finish(wollet: wollet!)
            resolve(id)
        } catch {
            reject("TxBuilder finish error", error.localizedDescription, error)
        }
    }
    
}

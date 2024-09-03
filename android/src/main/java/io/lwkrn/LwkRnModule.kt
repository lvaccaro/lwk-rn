package io.lwkrn

import com.facebook.react.bridge.*
import lwk.ElectrumClient
import lwk.Mnemonic
import lwk.Signer
import lwk.Update
import lwk.WalletTx
import lwk.Wollet
import lwk.WolletDescriptor

class LwkRnModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "LwkRnModule"
    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }

    private var _descriptors = mutableMapOf<String, WolletDescriptor>()
    private var _electrumClients = mutableMapOf<String, ElectrumClient>()
    private var _wollets = mutableMapOf<String, Wollet>()
    private var _updates = mutableMapOf<String, Update>()
    private var _transactions = mutableMapOf<String, WalletTx>()

    @ReactMethod
    fun createDescriptorSecret(
        network: String, mnemonic: String, result: Promise
    ) {
        try {
          val id = randomId()
          val mnemonic = Mnemonic(mnemonic)
          val network = setNetwork(network)
          val signer = Signer(mnemonic, network)
          _descriptors[id] = signer.wpkhSlip77Descriptor()
          result.resolve(id)
        } catch (error: Throwable) {
            return result.reject("WolletDescriptor create error", error.localizedMessage, error)
        }
    }

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

  @ReactMethod
  fun initElectrumClient(
    electrumUrl: String,
    tls: Boolean,
    validateDomain: Boolean,
    result: Promise
  ) {
    try {
      val id = randomId()
      _electrumClients[id] = ElectrumClient(electrumUrl, tls, validateDomain)
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("ElectrumClient create error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun defaultElectrumClient(
    network: String,
    result: Promise
  ) {
    try {
      val id = randomId()
      val network = setNetwork(network)
      _electrumClients[id] = network.defaultElectrumClient()
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("ElectrumClient defaultElectrumClient error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun createWollet(
    network: String,
    descriptorId: String,
    datadir: String,
    result: Promise
  ) {
    try {
      val id = randomId()
      val network = setNetwork(network)
      val descriptor = _descriptors[descriptorId]
      _wollets[id] = Wollet(network, descriptor!!, null)
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("Wollet create error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun fullScan(
    wolletId: String,
    clientId: String,
    result: Promise
  ) {
    try {
      val id = randomId()
      val client = _electrumClients[clientId]
      val wollet = _wollets[wolletId]
      _updates[id] = client!!.fullScan(wollet!!)!!
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("Client fullScan error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun applyUpdate(
    wolletId: String,
    updateId: String,
    result: Promise
  ) {
    try {
      val wollet = _wollets[wolletId]
      val update = _updates[updateId]
      wollet!!.applyUpdate(update!!)
      result.resolve(null)
    } catch (error: Throwable) {
      return result.reject("Client fullScan error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun getTransactions(wolletId: String, result: Promise) {
    try {
      val wollet = _wollets[wolletId]
      val list = wollet!!.transactions()
      val transactions: MutableList<Map<String, Any?>> = mutableListOf()
      for (item in list) {
        var txObject = getTransactionObject(item)
          val randomId = randomId()
          _transactions[randomId] = item
          txObject["transaction"] = randomId
        transactions.add(txObject)
      }
      result.resolve(Arguments.makeNativeArray(transactions))
    } catch (error: Throwable) {
      result.reject("List transactions error", error.localizedMessage, error)
    }
  }

}


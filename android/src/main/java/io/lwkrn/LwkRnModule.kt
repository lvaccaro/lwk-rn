package io.lwkrn

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import lwk.ElectrumClient
import lwk.Mnemonic
import lwk.Pset
import lwk.Signer
import lwk.Transaction
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
  private var _walletTxs = mutableMapOf<String, WalletTx>()
  private var _transactions = mutableMapOf<String, Transaction>()
  private var _psets = mutableMapOf<String, Pset>()
  private var _signers = mutableMapOf<String, Signer>()

  /* Descriptor */

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

  /* Signer */

  @ReactMethod
  fun createSigner(
    mnemonic: String,
    network: String,
    result: Promise
  ) {
    try {
      val id = randomId()
      val mnemonicObj = Mnemonic(mnemonic)
      val networkObj = setNetwork(network)
      _signers[id] = Signer(mnemonicObj, networkObj)
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("Signer create error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun sign(
    signerId: String,
    psetId: String,
    result: Promise
  ) {
    try {
      val id = randomId()
      val signer = _signers[signerId]
      val pset = _psets[psetId]
      _psets[id] = signer!!.sign(pset!!)
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("Signer sign error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun wpkhSlip77Descriptor(
    signerId: String,
    result: Promise
  ) {
    try {
      val id = randomId()
      val signer = _signers[signerId]
      _descriptors[id] = signer!!.wpkhSlip77Descriptor()
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("Signer wpkhSlip77Descriptor error", error.localizedMessage, error)
    }
  }

  /* Electrum client */

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
      val networkObj = setNetwork(network)
      _electrumClients[id] = networkObj.defaultElectrumClient()
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject(
        "ElectrumClient defaultElectrumClient error",
        error.localizedMessage,
        error
      )
    }
  }

  @ReactMethod
  fun broadcast(
    clientId: String,
    txId: String,
    result: Promise
  ) {
    try {
      val client = _electrumClients[clientId]
      val transaction = _transactions[txId]
      val txid = client!!.broadcast(transaction!!)
      result.resolve(txid.toString())
    } catch (error: Throwable) {
      return result.reject(
        "ElectrumClient broadcast error",
        error.localizedMessage,
        error
      )
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
      return result.reject("ElectrumClient fullScan error", error.localizedMessage, error)
    }
  }

  /* Wollet */

  @ReactMethod
  fun createWollet(
    network: String,
    descriptorId: String,
    datadir: String,
    result: Promise
  ) {
    try {
      val id = randomId()
      val networkObj = setNetwork(network)
      val descriptor = _descriptors[descriptorId]
      _wollets[id] = Wollet(networkObj, descriptor!!, datadir)
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("Wollet create error", error.localizedMessage, error)
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
      return result.reject("Wollet applyUpdate error", error.localizedMessage, error)
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
        _walletTxs[randomId] = item
        txObject["transaction"] = randomId
        transactions.add(txObject)
      }
      result.resolve(Arguments.makeNativeArray(transactions))
    } catch (error: Throwable) {
      result.reject("Wollet getTransactions error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun getDescriptor(wolletId: String, result: Promise) {
    try {
      val wollet = _wollets[wolletId]
      result.resolve(wollet!!.descriptor().toString())
    } catch (error: Throwable) {
      result.reject("Wollet getDescriptor error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun getAddress(wolletId: String, result: Promise) {
    try {
      val wollet = _wollets[wolletId]
      val address = wollet!!.address(null)
      result.resolve(getAddressObject(address))
    } catch (error: Throwable) {
      result.reject("Wollet getAddress error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun getBalance(wolletId: String, result: Promise) {
    try {
      val wollet = _wollets[wolletId]
      val balance = wollet!!.balance()
      result.resolve(balance)
    } catch (error: Throwable) {
      result.reject("Wollet getBalance error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun finalize(wolletId: String, psetId: String, result: Promise) {
    try {
      val wollet = _wollets[wolletId]
      val pset = _psets[psetId]
      val newPset = wollet!!.finalize(pset!!)
      result.resolve(newPset)
    } catch (error: Throwable) {
      result.reject("Wollet finalize error", error.localizedMessage, error)
    }
  }

  /* Transaction */

  @ReactMethod
  fun createTransaction(
    hex: String, result: Promise
  ) {
    try {
      val id = randomId()
      _transactions[id] = Transaction(hex)
      result.resolve(id)
    } catch (error: Throwable) {
      return result.reject("Transaction create error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun txId(txId: String, result: Promise) {
    try {
      val tx = _transactions[txId]
      result.resolve(tx!!.txid().toString())
    } catch (error: Throwable) {
      result.reject("Transaction toString error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun txFee(txId: String, policyAsset: String, result: Promise) {
    try {
      val tx = _transactions[txId]
      result.resolve(tx!!.fee(policyAsset).toString())
    } catch (error: Throwable) {
      result.reject("Transaction toString error", error.localizedMessage, error)
    }
  }

  @ReactMethod
  fun txAsString(txId: String, result: Promise) {
    try {
      val tx = _transactions[txId]
      result.resolve(tx.toString())
    } catch (error: Throwable) {
      result.reject("Transaction toString error", error.localizedMessage, error)
    }
  }

  /* Pset */

  @ReactMethod
  fun psetAsString(psetId: String, result: Promise) {
    try {
      val pset = _psets[psetId]
      result.resolve(pset.toString())
    } catch (error: Throwable) {
      result.reject("Pset toString error", error.localizedMessage, error)
    }
  }
  fun psetExtractTx(psetId: String, result: Promise) {
    try {
      val id = randomId()
      val pset = _psets[psetId]
      _transactions[id] = pset!!.extractTx()
      result.resolve(id)
    } catch (error: Throwable) {
      result.reject("Pset extractTx error", error.localizedMessage, error)
    }
  }
}

package io.lwkrn

import android.util.Log
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableNativeArray

import java.util.*
import lwk.Network
import lwk.WalletTx

fun setNetwork(networkStr: String? = "testnet"): Network {
    return when (networkStr) {
        "testnet" -> Network.testnet()
        "mainnet" -> Network.mainnet()
        "regtest" -> Network.regtestDefault()
        else -> Network.testnet()
    }
}

fun getNetworkString(network: Network): String {
  if (network.isMainnet()) {
    return "mainnet"
  } else {
    return "testnet"
  }
}

fun randomId() = UUID.randomUUID().toString()

fun getTransactionObject(transaction: WalletTx): MutableMap<String, Any> {
  return mutableMapOf<String, Any>(
    "fee" to transaction.fee().toInt(),
    "balance" to transaction.balance(),
    "type" to transaction.type(),
    "txid" to transaction.txid(),
    "height" to transaction.height()!!,
    "timestamp" to transaction.timestamp()!!
  )
}

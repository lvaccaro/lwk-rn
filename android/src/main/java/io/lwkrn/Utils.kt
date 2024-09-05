package io.lwkrn

import lwk.Network
import lwk.WalletTx
import java.util.*

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

fun getAddressObject(address: Address): MutableMap<String, Any> {
  return mutableMapOf<String, Any>(
    "description" to address.description,
    "is_blinded" to address.isBlinded(),
    "qr_code_text" to address.qrCodeText(),
    "script_pubkey" to address.scriptPubkey().description
  )
}

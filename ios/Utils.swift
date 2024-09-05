
import Foundation
import LiquidWalletKit

func setNetwork(networkStr: String?) -> Network {
    switch (networkStr) {
    case "testnet": return Network.testnet()
    case "mainnet": return Network.mainnet()
    case "regtest": return Network.regtestDefault()
    default: return Network.testnet()
    }
}

func getNetworkString(network: Network) -> String {
    if network.isMainnet() { 
        return "mainnet"
    } else { 
        return "testnet"
    }
}

func randomId() -> String {
    return UUID().uuidString
}

func getTransactionObject(transaction: WalletTx?) -> [String: Any] {
    return [
        "fee": transaction?.fee() as Any,
        "balance": transaction?.balance() as Any,
        "type": transaction?.type() as Any,
        "txid": transaction?.txid().description as Any,
        "tx": transaction?.tx().bytes() as Any,
        "height": transaction?.height() as Any,
        "timestamp": transaction?.timestamp() as Any
    ] as [String: Any]
}

func getAddressObject(address: Address?) -> [String: Any?] {
    return [
        "description": address?.description as Any,
        "is_blinded": address?.isBlinded() as Any,
        "qr_code_text": try? address?.qrCodeText() as? Any,
        "script_pubkey": address?.scriptPubkey().description as Any,
    ] as [String: Any?]
}

func setChain(chain: String? = "external") -> Chain {
    switch (chain) {
    case "external": return Chain.external
    case "internal": return Chain.internal
    default: return Chain.external
    }
}

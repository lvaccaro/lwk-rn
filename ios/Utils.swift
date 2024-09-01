
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

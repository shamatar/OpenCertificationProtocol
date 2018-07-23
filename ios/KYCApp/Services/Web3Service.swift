//
//  Web3Swrvice.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 23/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
import web3swift

class Web3Service {
    
    let contractABI = """
[{"constant":true,"inputs":[],"name":"getStatus","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newStatus","type":"bool"}],"name":"setStatus","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]
"""
    let ethContractAddress = EthereumAddress("0xe562e2562c142eee458b3cdee66e721c3c639acf")!
    func testIt() {
        guard let data = UserDefaults.standard.data(forKey: "keyData") else { return }
        guard let address = UserDefaults.standard.object(forKey: "address") as? String else { return }
        guard let keystore = EthereumKeystoreV3(data) else { return }
        let ethAddressFrom = EthereumAddress(address)
        
        let web3 = Web3.InfuraRinkebyWeb3()
        
        web3.addKeystoreManager(KeystoreManager([keystore]))
        var options = Web3Options.defaultOptions()
        options.from = ethAddressFrom
        options.value = 0
        guard let contract = web3.contract(contractABI, at: ethContractAddress, abiVersion: 2) else { return }
        guard let gasPrice = web3.eth.getGasPrice().value else { return }
        options.gasPrice = gasPrice
        guard let transaction = contract.method("setStatus", parameters: [false] as [AnyObject], options: options) else { return }
        let result = transaction.call(options: options)
        switch result {
        case .success(let r):
            print(r)
        case .failure(let error):
            print(error)
        }
        guard case .success(let estimate) = transaction.estimateGas(options: options) else {return}
        print("estimated cost: \(estimate)")
        
        let result1 = transaction.send()
        switch result1 {
        case .success(let res):
            print(res.transaction)
        case .failure(let error):
            print(error)
        }
    }
    
//    DispatchQueue.global().async {
//    let wallet = self.keyservice.selectedWallet()
//    guard let address = wallet?.address else { return }
//    let ethAddressFrom = EthereumAddress(address)
//
//    let web3 = Web3.InfuraMainnetWeb3()
//    web3.addKeystoreManager(self.keyservice.keystoreManager())
//
//    var options = Web3Options.defaultOptions()
//    options.from = ethAddressFrom
//    options.value = 0
//    guard let contract = web3.contract(peepEthABI, at: ethContractAddress, abiVersion: 2) else { return }
//    guard let gasPrice = web3.eth.getGasPrice().value else { return }
//    options.gasPrice = gasPrice
//    options.gasLimit = gasLimit
//    guard let transaction = contract.method("share", parameters: [peepDataHash] as [AnyObject], options: options) else { return }
//    guard case .success(let estimate) = transaction.estimateGas(options: options) else {return}
//    print("estimated cost: \(estimate)")
//    DispatchQueue.main.async {
//    completion(Result.Success(transaction))
//    }
//    }
}

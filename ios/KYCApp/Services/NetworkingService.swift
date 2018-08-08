//
//  NetworkingService.swift
//  KYCApp
//

import Foundation
import web3swift


//TODO: - ....
class NetworkInteractionService {
    //This is a method for getting data from the link and than delete that data in the server
    func retrieveData(model: QRCodeGetDataModel, completion: @escaping(Result<[UserDataModel]>) -> Void) {
        guard let url = URL(string: model.path) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let initialData = GetDataPOSTBody(sessionId: model.sessionId, signature: "sign")
        do {
            request.httpBody = try JSONEncoder().encode(initialData)
        } catch{
            completion(Result.error(error))
        }
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.error(error))
                }
                return
            }
            do {
                if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:String] {
                    var res = [UserDataModel]()
                    
                    for (key, value) in json {
                        res.append(
                            UserDataModel(typeID: key, detail: value)
                        )
                    }
                    DispatchQueue.main.async {
                        completion(Result.success(res))
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion(Result.error(NetworkErrors.wrongFromatOfData))
                    }
                    
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.error(error))
                }
                
            }
            
        }
        dataTask.resume()
        
    }
    //Method for sending proofs + data + signature, requested by the bank
    func sendData(toUrl urlString: String,data: [UserDataModel], fullData: [UserDataModel], randomNumber: Int,completion: @escaping(Bool) -> Void) {
        let tree = PaddabbleTree(fullData, UserDataModel(typeID: "", detail: ""))
        var proofs = [Data]()
        for el in data {
            guard let index = fullData.index(where: { (model) -> Bool in
                return model.typeID == el.typeID && model.detail == el.detail
            }) else { return }
            guard let proof = tree.makeBinaryProof(index) else { return }
            proofs.append(proof)
        }
        
        //You have a structure of the data to send written on some A4 paper on your table
        guard let data = UserDefaults.standard.data(forKey: "keyData") else { return }
        guard let address = UserDefaults.standard.object(forKey: "address") as? String else { return }
        guard let keystore = EthereumKeystoreV3(data) else { return }
        guard let privateKey = try? keystore.UNSAFE_getPrivateKeyData(password: "BANKEXFOUNDATION", account: EthereumAddress(address)!) else { return }
        let signature = SECP256K1.signForRecovery(hash: (fullData.first?.data)!, privateKey: privateKey)
        // Here should be sending of data, proofs and signature to somebody (Data, Proofs)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            completion(true)
        })
    }
    
    //DONE.
    func sendPublicKey(key: Data, model: QRCodeSendKeyModel, completion: @escaping(Bool) -> Void) {
        guard let url = URL(string: model.address) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let initialData = InitialData(publicKey: "0x" + key.toHexString(), sessionId: model.sessionId, mainURL: model.mainURL, signature: "sign")
        do {
            request.httpBody = try JSONEncoder().encode(initialData)
        } catch{
            completion(false)
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data1, response, error) in
            print(error)
            if error != nil {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
        dataTask.resume()
    }
    
    func signData(data: Data) -> Data? {
        guard let data = UserDefaults.standard.data(forKey: "keyData") else { return nil }
        guard let address = UserDefaults.standard.object(forKey: "address") as? String else { return nil }
        guard let keystore = EthereumKeystoreV3(data) else { return nil }
        guard let privateKey = try? keystore.UNSAFE_getPrivateKeyData(password: "BANKEXFOUNDATION", account: EthereumAddress(address)!) else { return nil }
        let signature = SECP256K1.signForRecovery(hash: data.sha256(), privateKey: privateKey)
        return signature.serializedSignature
    }
}

enum Result<T> {
    case success(T)
    case error(Error)
}

enum NetworkErrors: Error {
    case wrongFromatOfData
}

struct InitialData: Codable {
    var publicKey: String
    let sessionId: String
    let mainURL: String
    let signature: String
}

struct GetDataPOSTBody: Codable {
    let sessionId: String
    let signature: String
}


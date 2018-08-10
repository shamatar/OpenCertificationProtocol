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
        let initialData = GetDataPOSTBody(sessionId: model.sessionId, signature: "qwe")
        do {
            request.httpBody = try JSONEncoder().encode(initialData)
        } catch {
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
                if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    var res = [UserDataModel]()
                    
                    for (key, value) in json {
                        guard let userData = value as? [String: String] else { return }
                        guard let value = userData["value"],
                            let name = userData["name"],
                            let type = userData["type"] else { return }
                        let uintType: UInt16 = key.hexToUInt()!
                        res.append(
                            UserDataModel(typeID: uintType, value: value, name: name, type: type)
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
    func sendData(withQRCodeModel model: QRCodeDataModel, data: [UserDataModel], fullData: [UserDataModel], randomNumber: Int,completion: @escaping(Bool) -> Void) {
        let tree = PaddabbleTree(fullData, SimpleContent(UserDataModel.emptyData))
        guard let rootHash = tree.merkleRoot?.toHexString() else { return }
        var proofs = [Data]()
        for el in data {
            guard let index = fullData.index(where: { (model) -> Bool in
                return model.typeID == el.typeID && model.name == el.name && model.type == el.type && model.value == el.value
            }) else { return }
            guard let proof = tree.makeBinaryProof(index) else { return }
            print(proof.toHexString())
            proofs.append(proof)
        }

        //You have a structure of the data to send written on some A4 paper on your table
//        guard let data = UserDefaults.standard.data(forKey: "keyData") else { return }
//        guard let address = UserDefaults.standard.object(forKey: "address") as? String else { return }
//        guard let keystore = EthereumKeystoreV3(data) else { return }
//        guard let privateKey = try? keystore.UNSAFE_getPrivateKeyData(password: "BANKEXFOUNDATION", account: EthereumAddress(address)!) else { return }
//        let signature = SECP256K1.signForRecovery(hash: (fullData.first?.data)!, privateKey: privateKey)
        var dataForPost = [String: DataWithProof]()
        for (position, key) in model.fields.enumerated() {
            let user = data.first { (user) -> Bool in
                let uint: UInt16 = key.hexToUInt()!
                return user.typeID == uint
            }
            guard let value = user?.value else { return }
            print(proofs[position].toHexString())
            dataForPost[key] = DataWithProof(value: value, proof: proofs[position].toHexString())
        }
        
        let post = DataToBankPOSTBody(id: model.id, key: model.key, rootHash: rootHash, data: dataForPost)
        let url = URL(string: model.address)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONEncoder().encode(post)
        } catch {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
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
        task.resume()
        
    }
    
    //DONE.
    func sendPublicKey(key: Data, model: QRCodeSendKeyModel, completion: @escaping(Bool) -> Void) {
        guard let url = URL(string: model.address) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //TODO: - Send Address of the wallet
        guard let address = UserDefaults.standard.object(forKey: "address") as? String else { return }
        let initialData = InitialData(publicKey: address, sessionId: model.sessionId, mainURL: model.mainURL, signature: "qwe")
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

struct DataToBankPOSTBody: Codable {
    let id: Int
    let key: Int
    let rootHash: String
    let data: [String: DataWithProof]
}

struct DataWithProof: Codable {
    let value: String
    let proof: String
}


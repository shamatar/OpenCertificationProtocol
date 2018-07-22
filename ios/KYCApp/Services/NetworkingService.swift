//
//  NetworkingService.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation


//TODO: - ....
class NetworkInteractionService {
    
    //This is a method for getting data from the link and than delete that data in the server
    func retrieveData(fromUrl urlString: String, completion: @escaping(Result<[UserDataModel]>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(Result.error(error))
                return
            }
            do {
                print(String(data: data!, encoding: .utf8))
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
    
    func sendData(toUrl urlString: String,data: [UserDataModel], completion: @escaping(Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            completion(true)
        })
    }
    
    func deleteDataOnTheServer(completion: @escaping (Bool) -> Void) {
        
    }
}

enum Result<T> {
    case success(T)
    case error(Error)
}

enum NetworkErrors: Error {
    case wrongFromatOfData
}

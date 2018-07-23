//
//  UserDataModel.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation


struct UserDataModel: ContentProtocol {
    var data: Data {
        guard let d = (typeID + ", " + detail).data(using: .utf8) else { return Data() }
        return d
    }
    
    func getHash(_ hasher: TreeHasher) -> Data {
        return hasher.hash(self.data)
    }
    
    func isEqualTo(_ other: ContentProtocol) -> Bool {
        return self.data == other.data
    }
    
    let typeID: String
    let detail: String
}

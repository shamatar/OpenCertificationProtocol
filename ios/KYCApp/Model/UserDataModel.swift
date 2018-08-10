//
//  UserDataModel.swift
//  KYCApp
//

import Foundation
import web3swift


struct UserDataModel: ContentProtocol {
    static var emptyData: Data {
        return RLP.encode([Data(repeating: 0, count: 2) as AnyObject, [Data(repeating: 0, count: 32)] as AnyObject])!
    }
    
    var data: Data {
        let beUint = self.typeID
        let bytes : Array<UInt8> = [(UInt8((beUint >> 8) & 0xff)), UInt8(beUint & 0xff)]
        let type = Data(bytes)
        guard let data = value.data(using: .utf8) else { return Data() }
        return RLP.encode([type as AnyObject, [data] as AnyObject])!
    }
    
    func getHash(_ hasher: TreeHasher) -> Data {
        return hasher.hash(self.data)
    }
    
    func isEqualTo(_ other: ContentProtocol) -> Bool {
        return self.data == other.data
    }
    
    let typeID: UInt16
    let value: String
    let name: String
    let type: String
}



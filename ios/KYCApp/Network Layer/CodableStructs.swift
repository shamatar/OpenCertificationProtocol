//
//  SendPublicKeyStruct.swift
//  KYCApp
//


import Foundation

//MARK: - Codable structs for use in httpBodies
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

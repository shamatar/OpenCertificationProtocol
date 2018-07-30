//
//  QRCodeDataModel.swift
//  KYCApp
//
import Foundation

struct QRCodeDataModel: Codable {
    let url: String
    let typeIDs: [String]
}

struct QRCodeForSendingPublicKeyModel: Codable {
    let address: String
    let mainURL: String
    let sessionId: String
}

//
//  QRCodeDataModel.swift
//  KYCApp
//
import Foundation

//TODO: - This is a wrong model, write a right one.

//{"id":13,"key":585087,"fields":["0x0001","0x0004"]}
struct QRCodeDataModel: Codable {
    let id: Int
    let key: Int
    let fields: [String]
    let address: String
}

struct QRCodeSendKeyModel: Codable {
    let mainURL: String
    let sessionId: String
    let address: String
}

struct QRCodeGetDataModel: Codable {
    let sessionId: String
    let path: String
}

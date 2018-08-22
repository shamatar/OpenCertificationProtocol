//
//  CommonEnums.swift
//  KYCApp
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

enum NetworkErrors: Error {
    case wrongFromatOfData
    case wrongCheckSum
}

//
//  ParsersService.swift
//  KYCApp
//

import Foundation


class ParserService {
    //TODO: - write a parser for ImportFromTextViewController
    func parseRawSertificate(data: String) -> [UserDataModel]? {
        return nil
    }
    
    func parseQRCodeData(data: String) -> QRCodeDataModel? {
        print(data)
        guard let data = data.data(using: .utf8) else { return nil }
        do {
            let normalData = try JSONDecoder().decode(QRCodeDataModel.self, from: data)
            return normalData
            
        } catch {
            print(error)
            return nil
        }
    }
    
    //TODO: - this is not working correctly
    func parseQRBeforeSetConnection(data: String) -> QRCodeForSendingPublicKeyModel? {
        guard let dataBinary = data.data(using: .utf8) else { return nil }
        do {
            let normalData = try JSONDecoder().decode(QRCodeForSendingPublicKeyModel.self, from: dataBinary)
            return normalData
        } catch {
            print(error)
            return nil
        }
    }
}



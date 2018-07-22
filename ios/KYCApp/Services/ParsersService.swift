//
//  ParsersService.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
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
        return nil
    }
}

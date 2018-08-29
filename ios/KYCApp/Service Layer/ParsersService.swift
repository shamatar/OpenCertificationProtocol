//
//  ParsersService.swift
//  KYCApp
//

import Foundation


class ParserService {
    func parseQRCode<T: Codable>(data: String) -> T? {
        guard let data = data.data(using: .utf8) else { return nil }
        do {
            let normalData = try JSONDecoder().decode(T.self, from: data)
            return normalData
        } catch {
            print(error)
            return nil
        }
    }
}



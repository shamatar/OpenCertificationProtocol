//
//  QRCodeDataModel.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct QRCodeDataModel: Codable {
    let url: String
    let typeIDs: [String]
}

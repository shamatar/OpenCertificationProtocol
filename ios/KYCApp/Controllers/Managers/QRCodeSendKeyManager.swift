//
//  QRCodeSendKeyManager.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 24/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
import QRCodeReader


class QRCodeSendKeyManager: QRCodeReaderViewControllerDelegate {
    
    weak var delegate: QRCodeSendKeyDelegate?
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        
    }
    
}

protocol QRCodeSendKeyDelegate: class {
    
}

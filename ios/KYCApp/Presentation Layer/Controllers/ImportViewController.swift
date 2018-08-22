//
//  ViewController.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import QRCodeReader

class ImportViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var importCertificateButton: UIButton!
    @IBOutlet weak var sendPublicKeyButton: RoundedButton!
    
    
    var urlString: String?
    let networkService = NetworkInteractionService()
    let localStorageService = LocalStorageService()
    let parser = ParserService()
    var qrType: QRType = .importQR
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //This is a way to let that controller know whether it was loaded from deeplink or not
//        if let urlString = urlString {
//            dataRetrieving(model: )
//
//        } else {
//            importCertificateButton.isHidden = false
//            descriptionLabel.isHidden = false
//        }
    }
    
    
    
    @IBAction func importCertificateButtonTapped(_ sender: Any) {
        qrType = .importQR
        readerVC.delegate = self
        present(readerVC, animated: true, completion: nil)
        
    }
    @IBAction func sendPublicKeyButtonTapped(_ sender: UIButton) {
        qrType = .sendKey
        readerVC.delegate = self
        present(readerVC, animated: true, completion: nil)
        
    }
    
    private func showAllert(data: [UserDataModel]) {
        let alertController = UIAlertController(title: "Profile override", message: "After override you'll no longer be able to restore previous profile. Are you sure you want to override your profile data?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.localStorageService.save(data: data, completion: { (success) in
                if success {
                    self.performSegue(withIdentifier: "showProfile", sender: nil)
                }
            })
        }
        
        let actionNo = UIAlertAction(title: "No", style: .default) {_ in
            self.importCertificateButton.isHidden = false
            self.descriptionLabel.isHidden = false
            self.performSegue(withIdentifier: "showProfile", sender: nil)
        }
        
        alertController.addAction(actionNo)
        alertController.addAction(actionYes)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func dataRetrieving(model: QRCodeGetDataModel) {
        startSpinner()
        var base = model.path.split(separator: "/")
        base.removeLast()
        let baseUrlString = base.joined(separator: "/")
        networkService.retrieveData(model: model) { (result) in
            self.stopSpinner()
            self.urlString = nil
            switch result {
            case .error(let error):
                print(error)
            case .success(let data):
                if self.localStorageService.isThereAnyData() {
                    self.showAllert(data: data)
                } else {
                    self.localStorageService.save(data: data, completion: { (success) in
                        if success {
                            self.networkService.dataRetrievedSuccessfully(urlString: baseUrlString + "/dataLoaded", sessionId: model.sessionId, completion: { (success) in
                                if success {
                                    self.performSegue(withIdentifier: "showProfile", sender: nil)
                                } else {
                                    print("Something went wrong!")
                                }
                            })
                            
                        }
                    })
                }
                
            }
        }
    }
    
    private func startSpinner() {
        importCertificateButton.isHidden = true
        descriptionLabel.isHidden = true
        sendPublicKeyButton.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    private func stopSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
        descriptionLabel.isHidden = false
        importCertificateButton.isHidden = false
        sendPublicKeyButton.isHidden = false
    }
    
}

extension ImportViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        startSpinner()
        dismiss(animated: true, completion: nil)
        switch qrType {
        //MARK: - Retrieving data by sessionId?
        case .importQR:
            guard let model: QRCodeGetDataModel = parser.parseQRCode(data: result.value) else { return }
            dataRetrieving(model: model)
        //MARK: - scan QR and send data(pubKey + sign) to received url
        case .sendKey:
            guard let model: QRCodeSendKeyModel = parser.parseQRCode(data: result.value) else { return }
            guard let key = UserDefaults.standard.data(forKey: "publicKey") else { return }
            networkService.sendPublicKey(key: key, model: model) { (success) in
                self.stopSpinner()
                if success {
                    self.showAllert(message: "Your public key was successfully sent.")
                } else {
                    self.showAllert(message: "There is a trouble. Please, try again.")
                }
            }
        }
    }
    
    func showAllert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(actionYes)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    
}

enum QRType {
    case importQR
    case sendKey
}


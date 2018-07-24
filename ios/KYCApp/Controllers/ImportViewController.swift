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
    
    var urlString: String?
    let networkService = NetworkInteractionService()
    let localStorageService = LocalStorageService()
    var qrType: QRType = .importQR
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.isHidden = true
        importCertificateButton.isHidden = false
        descriptionLabel.isHidden = false
        
        //This is a way to let that controller know whether it was loaded from deeplink or not
        if let urlString = urlString {
            dataRetrieving(withUrl: urlString)
            
        } else {
            importCertificateButton.isHidden = false
            descriptionLabel.isHidden = false
        }
    }
    
    func showAllert(data: [UserDataModel]) {
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
    
    func dataRetrieving(withUrl urlString: String) {
        importCertificateButton.isHidden = true
        descriptionLabel.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        networkService.retrieveData(fromUrl: urlString) { (result) in
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.descriptionLabel.isHidden = false
            self.importCertificateButton.isHidden = false
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
                            self.performSegue(withIdentifier: "showProfile", sender: nil)
                        }
                    })
                }
                
            }
        }
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
    
}

extension ImportViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        importCertificateButton.isHidden = true
        descriptionLabel.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        dismiss(animated: true, completion: nil)
        switch qrType {
        //MARK: - QRCodeScanner appears and getting the url which will give user the data
        case .importQR:
            let urlString = result.value
            dataRetrieving(withUrl: urlString)

        //MARK: - scan QR and send data(pubKey + sign) to received url
        case .sendKey:
            let urlString = result.value
            guard let key = UserDefaults.standard.data(forKey: "publicKey") else { return }
            networkService.sendPublicKey(key: key, toUrl: urlString) { (success) in
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.descriptionLabel.isHidden = false
                self.importCertificateButton.isHidden = false
                if success {
                    //TODO: - probably some alert
                } else {
                    //TODO: - and here too
                }
            }
        }
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


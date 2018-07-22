//
//  ViewController.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var importCertificateButton: UIButton!
    
    var urlString: String? = "hello"
    let networkService = NetworkInteractionService()
    let localStorageService = LocalStorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.isHidden = true
        importCertificateButton.isHidden = false
        descriptionLabel.isHidden = false
        
        //This is a way to let that controller know whether it was loaded from deeplink or not
        if let urlString = urlString {
            importCertificateButton.isHidden = true
            descriptionLabel.isHidden = true
            spinner.isHidden = false
            spinner.startAnimating()
            networkService.retrieveData(fromUrl: urlString) { (result) in
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.urlString = nil
                switch result {
                case .error(let error):
                    print(error)
                    self.performSegue(withIdentifier: "showImportFromText", sender: nil)
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
    
    @IBAction func importCertificateButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showImportFromText", sender: nil)
    }
    
}


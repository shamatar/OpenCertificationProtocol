//
//  SettingsViewController.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let localStorage = LocalStorageService()
    
    @IBAction func deleteProfileButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Are you sure that you want to delete profile?", preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.localStorage.deleteProfile()
            UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "first")
        }
        alertController.addAction(actionNo)
        alertController.addAction(actionYes)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

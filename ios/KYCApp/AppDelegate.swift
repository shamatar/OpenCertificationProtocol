//
//  AppDelegate.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var localStorage = LocalStorageService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //If app launched from deeplink we catch that url and load data from the network
        if let launchOptions = launchOptions {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "first") as! ImportViewController
            if let url = launchOptions[UIApplicationLaunchOptionsKey.url] as? URL {
                guard let index = url.absoluteString.index(of: "/") else { return true}
                let i = url.absoluteString.index(index, offsetBy: 2)
                vc.urlString = "https://" + String(url.absoluteString[i...])
                window?.rootViewController = vc
                return true
            }
        }
        
        //If we already have some information in the app and there is no deeplinking in play, then we just show profile screen to the user.
        if isThereAnyDataOnThePhone() {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController")
            window?.rootViewController = vc
        }
        
        return true
    }
    
    //TODO: - Here should be a check of local dataStorage
    func isThereAnyDataOnThePhone() -> Bool {
        return localStorage.isThereAnyData()
    }
    
    
    //Not sure what is the difference between commented method and didFinishLaunchingWithOptions
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "first") as! ImportViewController
        guard let index = url.absoluteString.index(of: "/") else { return true}
        let i = url.absoluteString.index(index, offsetBy: 2)
        vc.urlString = "https://" + String(url.absoluteString[i...])
        window?.rootViewController = vc
        return true
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


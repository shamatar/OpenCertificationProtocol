//
//  AppDelegate.swift
//  KYCApp
//

import UIKit
import web3swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var localStorage = LocalStorageService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        putWalletIntoApp()
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
    
    private func isThereAnyDataOnThePhone() -> Bool {
        return localStorage.isThereAnyData()
    }
    
    //TODO: - Move it to coreData, let user to set multiple profiles(?).
    func putWalletIntoApp() {
        if UserDefaults.standard.value(forKey: "keyData") == nil {
            guard let newWallet = try? EthereumKeystoreV3() else {return}
            guard let wallet = newWallet, wallet.addresses?.count == 1 else {return}
            guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {return}
            guard let address = newWallet?.addresses?.first?.address else {return}
            guard let pk = try? newWallet?.UNSAFE_getPrivateKeyData(password: "BANKEXFOUNDATION", account: EthereumAddress(address)!), let privateKey = pk else { return }
            guard let publicKey = Web3.Utils.privateToPublic(privateKey) else { return }
            UserDefaults.standard.set(keyData, forKey: "keyData")
            UserDefaults.standard.set(address, forKey: "address")
            UserDefaults.standard.set(publicKey, forKey: "publicKey")
        }
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "first") as! ImportViewController
        guard let index = url.absoluteString.index(of: "/") else { return true}
        let i = url.absoluteString.index(index, offsetBy: 2)
        vc.urlString = "https://" + String(url.absoluteString[i...])
        window?.rootViewController = vc
        return true
    }
}

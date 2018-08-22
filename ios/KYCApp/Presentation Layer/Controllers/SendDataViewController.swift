//
//  SendDataViewController.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class SendDataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var networkService = NetworkInteractionService()
    let localStorage = LocalStorageService()
    
    var data = [UserDataModel]()
    var siteUrlString: String?
    var model: QRCodeDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        siteLabel.text = siteUrlString
        addGestureRecognizer()
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        let allData = localStorage.getAllData()
        guard let model = model else { return }
        networkService.sendData(withQRCodeModel: model, data: data, fullData: allData, randomNumber: 1) { (success) in
            if success {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.showAlert()
            } else {

            }
        }
        
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "", message: "Your data was successfully sent", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLink))
        siteLabel.isUserInteractionEnabled = true
        siteLabel.addGestureRecognizer(tap)
    }
    
    @objc func didTapLink() {
        guard let urlString = siteLabel.text, urlString != "", let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func rejectButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SendDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as? InformationCell else { return UITableViewCell() }
        cell.configureCell(withData: data[indexPath.row])
        return cell
    }
}

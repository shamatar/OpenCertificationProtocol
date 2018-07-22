//
//  ImportFromTextViewController.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit

class ImportFromTextViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    let parser = ParserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func importButtonTapped(_ sender: Any) {
        guard let text = textView.text, text != "" else { return }
        if let parsedData = parser.parseRawSertificate(data: text) {
            self.performSegue(withIdentifier: "showProfile", sender: parsedData)
        } else {
            errorLabel.isHidden = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProfileViewController, let parsedData = sender as? [UserDataModel] {
            vc.info = parsedData
        }
    }
}

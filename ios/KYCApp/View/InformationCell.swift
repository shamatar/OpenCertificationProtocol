//
//  InformationCell.swift
//  KYCApp
//

import UIKit

class InformationCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configureCell(withData data: UserDataModel) {
        nameLabel.text = data.typeID
        detailLabel.text = data.detail
    }
}

class InformationCell2: UITableViewCell {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configureCell(withData data: UserDataModel) {
        nameLabel.text = data.typeID
        detailLabel.text = data.detail
    }
}

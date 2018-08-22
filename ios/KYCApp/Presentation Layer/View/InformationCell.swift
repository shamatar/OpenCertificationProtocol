//
//  InformationCell.swift
//  KYCApp
//

import UIKit

class InformationCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configureCell(withData data: UserDataModel) {
        nameLabel.text = data.name
        detailLabel.text = data.value
    }
}

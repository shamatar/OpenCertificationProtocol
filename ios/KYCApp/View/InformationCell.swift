//
//  InformationCell.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
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

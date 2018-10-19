//
//  SelectFood2VCTableViewCell.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 18.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import  Parse

class SelectFood2VCTableViewCell: UITableViewCell {

    var priceArray = [String]()
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

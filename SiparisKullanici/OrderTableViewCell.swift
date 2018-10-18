//
//  OrderTableViewCell.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 18.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

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

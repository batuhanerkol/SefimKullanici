//
//  OrderTableViewCell.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 18.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit
import Parse

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNoteLabel: UILabel!
    @IBOutlet weak var tlIsaretilabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

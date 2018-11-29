//
//  RestaurantsTVC.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 24.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit

class RestaurantsTVC: UITableViewCell {

    @IBOutlet weak var testePointLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  favoritesCell.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 21.11.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit

class favoritesCell: UITableViewCell {

    @IBOutlet weak var lezzetPuanLabel: UILabel!
    @IBOutlet weak var favBusinessNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

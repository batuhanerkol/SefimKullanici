//
//  Cell1.swift
//  SiparisKullanici
//
//  Created by Batuhan Erkol on 28.10.2018.
//  Copyright © 2018 Batuhan Erkol. All rights reserved.
//

import UIKit

class Cell1: UITableViewCell {

    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

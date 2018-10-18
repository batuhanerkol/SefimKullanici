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
    
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getPriceData(){
        
        let query = PFQuery(className: "Siparisler")
        query.whereKey("SiparisSahibi", equalTo: (PFUser.current()?.username)!)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "HATA", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
               
            }
            else{
                self.priceArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.priceArray.append(object.object(forKey: "SiparisFiyati") as! String)
                    self.priceLabel.text = "\(self.priceArray.last!)"
                    
                }
                
            }
        }
    }
}

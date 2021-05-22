//
//  ShopCell.swift
//  NestedTableviewTask
//
//  Created by Amshuhu  on 20/05/21.
//

import UIKit

class ShopCell: UITableViewCell {
    
    @IBOutlet weak var lblShopName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

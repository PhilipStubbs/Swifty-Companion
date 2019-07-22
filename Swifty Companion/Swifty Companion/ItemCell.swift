//
//  ItemCell.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/19.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var itemName: UILabel!
    @IBOutlet var mark: UILabel!
    @IBOutlet var progress: UIProgressView!
    @IBOutlet var itemType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

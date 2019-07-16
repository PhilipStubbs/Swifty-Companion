//
//  TableCell.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var intraProfilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var campus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MenuCell.swift
//  TwitterClient
//
//  Created by Olya Sorokina on 11/3/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

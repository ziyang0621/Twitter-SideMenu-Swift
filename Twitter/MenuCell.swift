//
//  MenuCell.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/15/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var sectionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionName.textColor = kThemeColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

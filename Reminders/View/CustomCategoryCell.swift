//
//  CustomCategoryCell.swift
//  Reminders
//
//  Created by Dennis M on 2019-05-27.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class CustomCategoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var cellColourString = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame =  newFrame
//            frame.origin.y += 10
//            frame.origin.x += 10
//            frame.size.height -= 10
//            frame.size.width -= 20
//            super.frame = frame
//        }
//    }
    
}

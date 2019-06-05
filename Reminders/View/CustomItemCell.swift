//
//  CustomCell.swift
//  Reminders
//
//  Created by Dennis M on 2019-05-26.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class CustomItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
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
//            frame.origin.y += 5
//            frame.origin.x += 5
//            frame.size.height -= 7
//            frame.size.width -= 10
//            super.frame = frame
//        }
//    }
    
}

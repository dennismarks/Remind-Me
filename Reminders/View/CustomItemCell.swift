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
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var separationLine: UIView!
    
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    @IBAction func doneButtonPressed(_ sender: UIButton) {
//        print(self.delegate)
//        guard let cell = sender.superview?.superview as? CustomItemCell else { return }
//        self.delegate?.donePressed(cell: cell)
//    }
    
    
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

//
//  ExpandedViewController.swift
//  Expanding Table Animation
//
//  Created by Dennis M on 2019-05-30.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class ExpandedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

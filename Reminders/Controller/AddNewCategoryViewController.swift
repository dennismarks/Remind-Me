//
//  AddNewCategoryViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-09.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

protocol UpdateMainViewDelegate {
    func addNewCategory()
}

class AddNewCategoryViewController: UIViewController {
    
    var num = 0
    var delegate : UpdateMainViewDelegate?
    @IBOutlet weak var colourPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIView.animate(withDuration: 0.5) {
            self.preferredContentSize = CGSize(width: self.view.frame.width - 7, height: self.view.frame.height - 7)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.delegate?.addNewCategory()
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
//        self.delegate?.addNewCategory()
        self.dismiss(animated: true, completion: nil)
    }
}


extension AddNewCategoryViewController: UIPickerViewDelegate, UIPickerViewDelegate {
    
    
    
}

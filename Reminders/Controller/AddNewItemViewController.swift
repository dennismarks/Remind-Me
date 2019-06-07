//
//  AddNewItemViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-05-29.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

protocol AddNewItemDelegate {
    func addNewItem(name: String)
    func dismissView()
}

class AddNewItemViewController: UIViewController {
    
    var active = false
    var delegate: AddNewItemDelegate?
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var addReminderButton: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.delegate?.dismissView()
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.delegate?.dismissView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewCategoryPressed(_ sender: UIButton) {
        if let name = itemNameTextField.text {
            self.delegate?.addNewItem(name: name)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReminderPressed(_ sender: UIButton) {
        if (active == false) {
            print(active)
            active = !active
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Dismiss", for: .normal)
                self.datePickerView.layer.opacity = 1.0
            }
        } else {
            active = !active
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
                self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200)
            })
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Add Reminder", for: .normal)
                self.datePickerView.layer.opacity = 0.0
            }
        }
        
    }
    
}

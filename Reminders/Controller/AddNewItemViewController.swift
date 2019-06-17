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
    func addNewItem(name: String, reminder: UIDatePicker)
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
//        Date().localizedDescription
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            self.itemNameTextField.becomeFirstResponder()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(260), execute: {
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200)

        })
        
//        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        itemNameTextField.resignFirstResponder()
        self.delegate?.dismissView()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700), execute: {
//            self.delegate?.dismissView()
//        })
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
//        itemNameTextField.resignFirstResponder()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750), execute: {
//            self.delegate?.dismissView()
//            self.dismiss(animated: true, completion: nil)
//        })
        itemNameTextField.resignFirstResponder()
        self.delegate?.dismissView()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addNewCategoryPressed(_ sender: UIButton) {
        itemNameTextField.resignFirstResponder()

        guard let name = itemNameTextField.text else {
            print("Name is empty")
            return
        }
        if name == "" {
            print("Name is empty")
        } else if (active == false) {
            self.delegate?.addNewItem(name: name)
        } else if (active == true) {
            self.delegate?.addNewItem(name: name, reminder: datePickerView)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200)
            })
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Add Reminder", for: .normal)
                self.datePickerView.layer.opacity = 0.0
            }
        }
        
    }
    
}

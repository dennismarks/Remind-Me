//
//  EditItemViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-24.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

protocol UpdateUIAfterEditItemDelegate {
    func editNewItem(name: String)
    func editNewItem(name: String, reminder: UIDatePicker)
}

class EditItemViewController: UIViewController {

    
    
    var itemName = ""
    var reminderDate: Date?
    var active = false
    var delegate: UpdateUIAfterEditItemDelegate?
    
    @IBOutlet weak var newItemName: UITextField!
    @IBOutlet weak var addReminderButton: UIButton!
    @IBOutlet weak var newReminderDate: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newItemName.text = itemName
        if let reminder = reminderDate {
            newReminderDate.date = reminder
            newReminderDate.layer.opacity = 1.0
            newReminderDate.reloadInputViews()
            addReminderButton.setTitle("Dismiss", for: .normal)
            active = true
            print("Been here")
        }
        self.newItemName.becomeFirstResponder()
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let name = newItemName.text else {
            print("Name is empty")
            return
        }
        if name == "" {
            print("Name is empty")
        } else if (active == false) {
            self.delegate?.editNewItem(name: name)
        } else if (active == true) {
            self.delegate?.editNewItem(name: name, reminder: newReminderDate)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReminderPressed(_ sender: UIButton) {
        if (active == false) {
            print(active)
            active = !active
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Dismiss", for: .normal)
                self.newReminderDate.layer.opacity = 1.0
            }
        } else {
            active = !active
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200)
            })
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Add Reminder", for: .normal)
                self.newReminderDate.layer.opacity = 0.0
            }
        }
        
    }
    
    

}

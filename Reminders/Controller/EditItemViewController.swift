//
//  EditItemViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-24.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

protocol UpdateUIAfterEditItemDelegate {
    func editItem(name: String)
    func editItem(name: String, reminder: UIDatePicker)
}

class EditItemViewController: UIViewController {

    
    
    var itemName = ""
    var reminderDate: Date?
    var active = false
    var delegate: UpdateUIAfterEditItemDelegate?
    
    @IBOutlet weak var newItemName: UITextField!
    @IBOutlet weak var addReminderButton: UIButton!
    @IBOutlet weak var newReminderDate: UIDatePicker!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        print("---> \(self.view.frame.height)")
        if self.view.frame.height < 175 {
            stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            newItemName.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
            newItemName.font = newItemName.font?.withSize(23)
            //            buttonsStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            //            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6).isActive = true
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let name = newItemName.text else {
            print("Name is empty")
            return
        }
        if name == "" {
            print("Name is empty")
        } else if (active == false) {
            self.delegate?.editItem(name: name)
        } else if (active == true) {
            self.delegate?.editItem(name: name, reminder: newReminderDate)
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
            print("---> \(self.view.frame.height)")
            if self.view.frame.height < 250 {
                datePickerHeight.constant = 120
            }
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Dismiss", for: .normal)
                self.newReminderDate.layer.opacity = 1.0
            }
        } else {
            active = !active
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width * 0.5)
            })
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Add Reminder", for: .normal)
                self.newReminderDate.layer.opacity = 0.0
            }
        }
        
    }
    
    

}

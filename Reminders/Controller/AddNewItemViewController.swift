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
    @IBOutlet weak var stackView: UIStackView!
    
    var showArrow = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Date().localizedDescription
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            self.itemNameTextField.becomeFirstResponder()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(260), execute: {
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width * 0.5)

        })
//        self.preferredContentSize = CGSize(width: self.view.frame.width, height: 200)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("---> \(self.view.frame.height)")
        if self.view.frame.height < 340 {
            stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            itemNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
            itemNameTextField.font = itemNameTextField.font?.withSize(23)
//            buttonsStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6).isActive = true
        }
        if self.view.frame.height < 390 {
            stackView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            datePickerView.heightAnchor.constraint(equalToConstant: 135).isActive = true
            self.view.layoutIfNeeded()
        }
        itemNameTextField.font = UIFontMetrics.default.scaledFont(for: itemNameTextField.font!)
        addReminderButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: addReminderButton.titleLabel!.font)
//        if showArrow {
//        }
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
//            hideArrow = true
//            self.popoverPresentationController?.sourceView = self.view
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
//            self.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            
            UIView.animate(withDuration: 1) {
                
                self.addReminderButton.setTitle("Dismiss", for: .normal)
                self.datePickerView.layer.opacity = 1.0
            }
//            self.viewWillAppear(true)
        } else {
            active = !active
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width * 0.5)
            })
//            hideArrow = false
            UIView.animate(withDuration: 1) {
                self.addReminderButton.setTitle("Add Reminder", for: .normal)
                self.datePickerView.layer.opacity = 0.0
            }
//            self.viewWillAppear(true)
        }
        
    }
    
}

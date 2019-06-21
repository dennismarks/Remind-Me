//
//  AddNewCategoryViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-09.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

protocol UpdateMainViewDelegate {
    func addNewCategory(name: String, colour: String, tint: String)
    func dismissView()
}

class AddNewCategoryViewController: UIViewController {
    

    var colourArray = ["#324047", "#EFEFEF", "#00CECE", "#00A8A8", "#E3A6AE", "#EECECE", "#F7F7F7", "B7C8CB", "#8D8DAA", "#DFDFE2", "#F7F5F2", "F56D91"]
    var tintColourArray = ["#DADAD0", "#324148", "#016566", "#EFEFEF", "#FFFCF3", "C67E86", "#4485C8", "#6B8E94", "#F6F5F3", "#7A7AA0", "#F6678D", "#F6F5F1"]
    var colourNames = ["Big Stone", "Super Silver", "Turquoise Surf", "Jade Orchid", "Berry Riche", "Oyster Pink", "Lynx White", "Misty Surf", "Charcoal Dust", "Violet Echo", "White Chalk", "Rosy Pink"]

//    var colourArray = [UIColor]()
    var num = 0
    var delegate : UpdateMainViewDelegate?
    var chosenColour = ""
    var chosenTint = ""
    @IBOutlet weak var colourPickerView: UIPickerView!
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colourPickerView.showsSelectionIndicator = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.categoryNameTextField.becomeFirstResponder()
        })
        
//        let colour = hexStringToUIColor(hex: "E2C7C0")
//        colourArray.append(colour)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        categoryNameTextField.resignFirstResponder()
        chosenColour = colourArray[0]
        chosenTint = tintColourArray[0]
//        UIView.animate(withDuration: 0.5) {
//            self.preferredContentSize = CGSize(width: self.view.frame.width - 15, height: self.view.frame.height - 15)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        categoryNameTextField.resignFirstResponder()

        self.delegate?.dismissView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("Size \(self.view.frame.height)")
        if self.view.frame.height < 340 {
            categoryNameTextField.font = categoryNameTextField.font?.withSize(23)
            categoryNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            buttonsStackView.heightAnchor.constraint(equalToConstant: 45).isActive = true
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        }
        categoryNameTextField.font = UIFontMetrics.default.scaledFont(for: categoryNameTextField.font!)
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
//        categoryNameTextField.resignFirstResponder()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750), execute: {
//            self.delegate?.dismissView()
//            self.dismiss(animated: true, completion: nil)
//        })
        categoryNameTextField.resignFirstResponder()

        self.delegate?.dismissView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewCategoryPressed(_ sender: UIButton) {
        categoryNameTextField.resignFirstResponder()

        if let name = categoryNameTextField.text {
            self.delegate?.addNewCategory(name: name, colour: chosenColour, tint: chosenTint)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension AddNewCategoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
//        label.backgroundColor = hexStringToUIColor(hex: colourArray[row])
        label.layer.cornerRadius = 15.0
        label.layer.backgroundColor = hexStringToUIColor(hex: colourArray[row]).cgColor
        label.textAlignment = .center
        label.text = colourNames[row]
        label.textColor = hexStringToUIColor(hex: tintColourArray[row])
        label.font = UIFont(name: "SFProText-Regular", size: 19.0)
        label.font = UIFontMetrics.default.scaledFont(for: label.font)
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if self.view.frame.height < 250 {
            return CGFloat(integerLiteral: 30)
        } else {
            return CGFloat(integerLiteral: 40)
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return CGFloat(integerLiteral: 10)
//    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return colourArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenColour = colourArray[row]
        chosenTint = tintColourArray[row]
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

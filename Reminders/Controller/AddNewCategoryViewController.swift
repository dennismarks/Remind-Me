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
        chosenColour = colourArray[0]
        chosenTint = tintColourArray[0]
//        UIView.animate(withDuration: 0.5) {
//            self.preferredContentSize = CGSize(width: self.view.frame.width - 15, height: self.view.frame.height - 15)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.delegate?.dismissView()
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
//        categoryNameTextField.resignFirstResponder()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750), execute: {
//            self.delegate?.dismissView()
//            self.dismiss(animated: true, completion: nil)
//        })

        self.delegate?.dismissView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewCategoryPressed(_ sender: UIButton) {
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
        label.font = UIFont(name: "AvenirNext-Regular", size: 22.0)
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(integerLiteral: 40)
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

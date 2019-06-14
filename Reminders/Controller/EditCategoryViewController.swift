//
//  EditCategoryViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-23.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

protocol UpdateUIAfterClosingEditCategoryDelegate {
    func dismissEditView()
}

class EditCategoryViewController: UIViewController {
    
    var categoryName = ""
    var categoryColour = ""
    
    var chosenColour = ""
    var chosenTint = ""
    
    @IBOutlet weak var newCategoryName: UITextField!
    @IBOutlet weak var newCategoryColour: UIPickerView!
    
    var colourArray = ["#324047", "#EFEFEF", "#00CECE", "#00A8A8", "#E3A6AE", "#EECECE", "#F7F7F7", "B7C8CB", "#8D8DAA", "#DFDFE2", "#F7F5F2", "F56D91"]
    var tintColourArray = ["#DADAD0", "#324148", "#016566", "#EFEFEF", "#FFFCF3", "C67E86", "#4485C8", "#6B8E94", "#F6F5F3", "#7A7AA0", "#F6678D", "#F6F5F1"]
    var colourNames = ["Big Stone", "Super Silver", "Turquoise Surf", "Jade Orchid", "Berry Riche", "Oyster Pink", "Lynx White", "Misty Surf", "Charcoal Dust", "Violet Echo", "White Chalk", "Rosy Pink"]
    
    var delegate: UpdateUIAfterClosingEditCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        newCategoryColour.showsSelectionIndicator = false
        self.newCategoryName.becomeFirstResponder()
        self.newCategoryName.text = categoryName
        
        var index = 0
        for item in colourArray {
            if item == categoryColour {
                break
            }
            index += 1
        }
        print("Index is \(index)")
        self.newCategoryColour.selectRow(index, inComponent: 0, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.dismissEditView()
        dismiss(animated: true, completion: nil)
    }
    

}

extension EditCategoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

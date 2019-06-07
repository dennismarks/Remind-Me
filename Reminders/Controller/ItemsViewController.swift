//
//  ItemsViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-06.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateUIAfterGoBackDelegate {
    func updateUI()
}

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewItemDelegate, DoneButtonPressedDelegate {
    
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bottomSafeView: UIView!
    @IBOutlet weak var topSafeView: UIView!
    @IBOutlet weak var tableViewFooter: UIView!
    
    
    var selectedCategory : Category? {
        // what should happen when a variable gets set with a new value
        didSet {
            load()
            self.title = self.selectedCategory?.name
        }
    }
    var tableViewColour : String = ""
    var delegate : UpdateUIAfterGoBackDelegate?
    var array = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemTableView.backgroundColor = hexStringToUIColor(hex: tableViewColour)
        itemTableView.separatorStyle = .none
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
            UIView.animate(withDuration: 0.4, animations: {
                self.backButton.layer.opacity = 0.92
                self.addButton.layer.opacity = 0.92
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        bottomSafeView.translatesAutoresizingMaskIntoConstraints = false
        topSafeView.translatesAutoresizingMaskIntoConstraints = false
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        
        bottomSafeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomSafeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomSafeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bottomSafeView.heightAnchor.constraint(equalToConstant: window.frame.maxY - safeFrame.maxY).isActive = true
        bottomSafeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        topSafeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topSafeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topSafeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topSafeView.heightAnchor.constraint(equalToConstant: safeFrame.minY).isActive = true
        topSafeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bottomSafeView.backgroundColor = hexStringToUIColor(hex: (selectedCategory?.colour)!)
        topSafeView.backgroundColor = hexStringToUIColor(hex: (selectedCategory?.colour)!)
        tableViewFooter.backgroundColor = hexStringToUIColor(hex: (selectedCategory?.colour)!)
        
        itemTableView.estimatedRowHeight = 100
        itemTableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = array[indexPath.row] as Item
        let cell = Bundle.main.loadNibNamed("CustomItemCell", owner: self, options: nil)?.first as! CustomItemCell
        cell.titleLabel.text = data.title
        cell.reminderLabel.text = data.reminder
        if data.reminder == "" {
            cell.topSpace.isActive = false
            cell.bottomSpace.isActive = false
            cell.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.titleLabel.leadingAnchor.constraint(equalTo: cell.cellContentView.trailingAnchor, constant: 28).isActive = true
            cell.titleLabel.centerYAnchor.constraint(equalTo: cell.cellContentView.centerYAnchor).isActive = true
            print(cell.titleLabel.constraints)
        }
//        cell.accessoryType = data.done ? .checkmark : .none
        cell.backgroundColor = hexStringToUIColor(hex: (selectedCategory?.colour)!)
        cell.tintColor = .white
        let doneImage = UIImage(named: "done.png")?.withRenderingMode(.alwaysTemplate)
        let circleImage = UIImage(named: "circle.png")?.withRenderingMode(.alwaysTemplate)
        if (data.done) {
            cell.doneButton.setImage(doneImage, for: .normal)
        } else {
            cell.doneButton.setImage(circleImage, for: .normal)
        }
        cell.doneButton.tintColor = .black
        cell.delegate = self
//        cell.doneButton.layer.cornerRadius = 14.0
//        cell.doneButton.layer.shadowColor = UIColor.black.cgColor
//        cell.doneButton.layer.shadowRadius = 5.0
//        cell.doneButton.layer.shadowOpacity = 0.1
//        cell.doneButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
    

        
//        cell.backgroundColor = (cell.accessoryType == .checkmark) ? UIColor(rgb: 0xBDBDBD).withAlphaComponent(0.3) : UIColor.white
//        cell.titleLabel?.textColor = (cell.accessoryType == .checkmark) ? UIColor.red : UIColor.black
        
//        if cell.accessoryType == .checkmark {
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.titleLabel.text!)
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
//            cell.textLabel?.attributedText = attributeString
//        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        array[indexPath.row].done = !array[indexPath.row].done
//        save()
//        self.itemTableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func donePressed(cell: CustomItemCell) {
        let indexPath = itemTableView.indexPath(for: cell)
        array[indexPath!.row].done = !array[indexPath!.row].done
        save()
        self.itemTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.context.delete(self.array[indexPath.row])
            self.array.remove(at: indexPath.row)
            self.itemTableView.deleteRows(at: [indexPath], with: .automatic)
            self.save()
            completion(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            //            self.save()
            completion(true)
        }
        //        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = .black
        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("Back pressed")
        UIView.animate(withDuration: 0.065) {
            self.addButton.layer.opacity = 0.0
            self.backButton.layer.opacity = 0.0
        }
        self.delegate?.updateUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.8) {
            self.view.layer.opacity = 0.6
        }
        performSegue(withIdentifier: "goToAddItem", sender: self)
        
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Add new item", message: .none, preferredStyle: .alert)
//        let add = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
//            if let text = textField.text {
//                let item = Item(context: self.context)
//                item.title = text
//                item.done = false
//                item.parentCategory = self.selectedCategory
//                self.array.append(item)
//                self.save()
//                self.itemTableView.reloadData()
//                print("Saved")
//            }
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in }
//        alert.addTextField { (UITextField) in
//            UITextField.placeholder = "Create new item"
//            textField = UITextField
//        }
//        alert.addAction(add)
//        alert.addAction(cancel)
//        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddItem" {
            let destinationVC = segue.destination as! AddNewItemViewController
            destinationVC.delegate = self
            destinationVC.modalPresentationStyle = .popover
            let popOverVC = destinationVC.popoverPresentationController
            popOverVC?.delegate = self
            popOverVC?.sourceView = self.addButton
            popOverVC?.sourceRect = CGRect(x: self.addButton.bounds.midX, y: self.addButton.bounds.minY - 3, width: 0, height: 0)
            destinationVC.preferredContentSize = CGSize(width: self.view.frame.width, height: 200)
        }
    }
    
    func addNewItem(name: String) {
        let item = Item(context: self.context)
        item.title = name
        item.reminder = ""
        item.done = false
        item.parentCategory = self.selectedCategory
        self.array.append(item)
        self.save()
        self.itemTableView.reloadData()
        print("Saved")
    }
    
    func addNewItem(name: String, reminder: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEE, MMM d hh:mm aaa")
        let time = formatter.string(from: reminder.date)
        print(time)
        let item = Item(context: self.context)
        item.title = name
        item.reminder = time
        item.done = false
        item.parentCategory = self.selectedCategory
        self.array.append(item)
        self.save()
        self.itemTableView.reloadData()
    }
    
    func dismissView() {
        UIView.animate(withDuration: 0.5) {
            self.view.layer.opacity = 1.0
        }
    }
    
    func save() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func load(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let searchPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            array = try context.fetch(request)
        } catch {
            print("Error fetchin data from context \(error)")
        }
    }

}


extension ItemsViewController {
    
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


// This is we need to make it looks as a popup window on iPhone
extension ItemsViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

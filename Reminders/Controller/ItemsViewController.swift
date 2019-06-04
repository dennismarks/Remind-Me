//
//  ItemsViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-06.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemTableView: UITableView!
    var selectedCategory : Category? {
        // what should happen when a variable gets set with a new value
        didSet {
            load()
            self.title = self.selectedCategory?.name
        }
    }
    var tableViewColour : String = ""
    
    var array = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemTableView.backgroundColor = hexStringToUIColor(hex: tableViewColour)
//        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = array[indexPath.row] as Item
        let cell = Bundle.main.loadNibNamed("CustomItemCell", owner: self, options: nil)?.first as! CustomItemCell
        cell.titleLabel.text = data.title
        cell.titleLabel.textColor = .red
        cell.accessoryType = data.done ? .checkmark : .none
        cell.backgroundColor = (cell.accessoryType == .checkmark) ? UIColor(rgb: 0xBDBDBD).withAlphaComponent(0.3) : UIColor.white
        cell.titleLabel?.textColor = (cell.accessoryType == .checkmark) ? UIColor.red : UIColor.black
        
        if cell.accessoryType == .checkmark {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.titleLabel.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        array[indexPath.row].done = !array[indexPath.row].done
        save()
        self.itemTableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
        //        deleteAction.backgroundColor = .white
        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        for item in selectedCategory!.items! {
            print(item)
        }
//        print(selectedCategory?.items)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let pvc = storyboard.instantiateViewController(withIdentifier: "AddNewItemViewController") as? AddNewItemViewController
//        //        pvc!.modalPresentationStyle = .overCurrentContext
//        self.present(pvc!, animated: true, completion: nil)
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: .none, preferredStyle: .alert)
        let add = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            if let text = textField.text {
                let item = Item(context: self.context)
                item.title = text
                item.done = false
                item.parentCategory = self.selectedCategory
                self.array.append(item)
                self.save()
                self.itemTableView.reloadData()
                print("Saved")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Create new item"
            textField = UITextField
        }
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true)
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

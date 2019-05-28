//
//  ViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-05-25.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCategory : Category? {
        // what should happen when a variable gets set with a new value
        didSet {
            load()
        }
    }
    var array = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSearchController()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.largeTitleDisplayMode = .never
        
        
        // set up add button
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = add
        
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = array[indexPath.row] as Item
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let cell = Bundle.main.loadNibNamed("CustomItemCell", owner: self, options: nil)?.first as! CustomItemCell
        print(cell.frame.height)
//        cell.view.backgroundColor = .red
//        cell.backgroundColor = UIColor.red
        cell.titleLabel.text = data.title
        cell.titleLabel.textColor = .red
//        cell.textLabel?.text = data.title
        cell.accessoryType = data.done ? .checkmark : .none
        cell.backgroundColor = (cell.accessoryType == .checkmark) ? UIColor(rgb: 0xBDBDBD).withAlphaComponent(0.3) : UIColor.white
        cell.titleLabel?.textColor = (cell.accessoryType == .checkmark) ? UIColor.red : UIColor.black
//        cell.layer.borderWidth = 0.3
//        cell.layer.borderColor = UIColor.darkGray.cgColor
//        cell.layer.cornerRadius = 10.0
        
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowRadius = 3.0
//        cell.layer.shadowOpacity = 0.5
//        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        if cell.accessoryType == .checkmark {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.titleLabel.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        array[indexPath.row].done = !array[indexPath.row].done
        save()
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func addButtonPressed() {
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
                self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.context.delete(self.array[indexPath.row])
            self.array.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
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


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension ItemTableViewController: UISearchResultsUpdating {
    
    func setUpSearchController() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController!.searchBar.delegate = self as? UISearchBarDelegate
        navigationItem.searchController!.searchResultsUpdater = self
        navigationItem.searchController!.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {
        if searchText == "" {
            load()
            tableView.reloadData()
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.predicate = predicate
            load(with: request, with: predicate)
            tableView.reloadData()
        }
    }
    
}

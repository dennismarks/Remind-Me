//
//  ItemsTableViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-05-27.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    @IBOutlet var tabelView: UITableView!
    var array = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSearchController()
        self.title = "Reminders"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = add
        
        tableView.separatorStyle = .none
        
        load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemTableViewController
        if let indexPath = tabelView.indexPathForSelectedRow {
            destinationVC.selectedCategory = array[indexPath.row]
        }
    }
    
    @objc func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: .none, preferredStyle: .alert)
        let add = UIAlertAction(title: "Add category", style: .default) { (UIAlertAction) in
            if let text = textField.text {
                let category = Category(context: self.context)
                category.name = text
                self.array.append(category)
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
    
    func save() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func load(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            array = try context.fetch(request)
        } catch {
            print("Error fetchin data from context \(error)")
        }
    }

}

extension CategoryTableViewController: UISearchResultsUpdating {
    
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
            let request : NSFetchRequest<Category> = Category.fetchRequest()
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            request.predicate = predicate
            load(with: request)
            tableView.reloadData()
        }
    }
    
}

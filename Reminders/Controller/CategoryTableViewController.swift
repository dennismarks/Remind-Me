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
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    
    var curIndex = 0
    var from = 0
    var to = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSearchController()
        self.title = "Reminders"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = add
        
        tableView.separatorStyle = .singleLine
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.2 // optional
        tableView.addGestureRecognizer(longPress)

        load()
        
        for item in array {
            print(item.position)
        }
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
        let cell = Bundle.main.loadNibNamed("CustomCategoryCell", owner: self, options: nil)?.first as! CustomCategoryCell
        cell.nameLabel.text = array[indexPath.row].name
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.cornerRadius = 15
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
                category.position = Int16(self.curIndex)
                self.curIndex += 1
                self.array.append(category)
                self.save()
                self.tableView.reloadData()
                print("Saved new category")
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
            print("Saved data")
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func load(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        let sort = NSSortDescriptor(key: "position", ascending: true)
        request.sortDescriptors = [sort]
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




// MARK: cell reorder / long press

extension CategoryTableViewController {

    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        let locationInView = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)

        if sender.state == .began {
            if indexPath != nil {
                dragInitialIndexPath = indexPath
                if self.from == 0 {
                    from = dragInitialIndexPath!.row
                }
                let cell = tableView.cellForRow(at: indexPath!)
                dragCellSnapshot = snapshotOfCell(inputView: cell!)
                var center = cell?.center
                dragCellSnapshot?.center = center!
                dragCellSnapshot?.alpha = 0.0
                tableView.addSubview(dragCellSnapshot!)

                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    self.dragCellSnapshot?.center = center!
                    self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                    self.dragCellSnapshot?.alpha = 0.99
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        cell?.isHidden = true
                    }
                })
            }
        } else if sender.state == .changed && dragInitialIndexPath != nil {
            var center = dragCellSnapshot?.center
            center?.y = locationInView.y
            dragCellSnapshot?.center = center!

            // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
            if indexPath != nil && indexPath != dragInitialIndexPath {
                // update your data model
                print("1 drag \(String(describing: dragInitialIndexPath?.row))")
                let dataToMove = array[dragInitialIndexPath!.row]
                array.remove(at: dragInitialIndexPath!.row)
                array.insert(dataToMove, at: indexPath!.row)
                tableView.moveRow(at: dragInitialIndexPath!, to: indexPath!)
                dragInitialIndexPath = indexPath
                print("2 drag \(String(describing: dragInitialIndexPath?.row))")
                self.to = indexPath!.row
            }
        } else if sender.state == .ended && dragInitialIndexPath != nil {
            let cell = tableView.cellForRow(at: dragInitialIndexPath!)
            cell?.isHidden = false
            cell?.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.dragCellSnapshot?.center = (cell?.center)!
                self.dragCellSnapshot?.transform = CGAffineTransform.identity
                self.dragCellSnapshot?.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    self.dragInitialIndexPath = nil
                    self.dragCellSnapshot?.removeFromSuperview()
                    self.dragCellSnapshot = nil
                    
                    self.array[self.to].position = Int16(self.to)
                    self.array[self.from].position = Int16(self.from)
                    
                    print("from \(self.from)")
                    print("to \(self.to)")
                    
                    self.save()
                }
            })
        }
    }

    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

}

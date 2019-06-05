//
//  ExpandingTableViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-06.
//  Copyright © 2019 Dennis M. All rights reserved.
//


import UIKit
import CoreData


class ExpandingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UpdateMainViewDelegate {
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var array = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    
    var curIndex = 0
    var from = 0
    var to = 0
    var curRow = 0
    
    var colourArray = ["#E2C7C0", "#ECDBD8", "#71768A", "#303747", "#191F2F", "#0D1319"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
//        longPress.minimumPressDuration = 0.2 // optional
//        self.tableView.addGestureRecognizer(longPress)
        
        self.tableView.separatorStyle = .none
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        statusBarView.frame.size.height = safeFrame.minY
//        statusBarView.layer.cornerRadius = 12.0
        load()
        curIndex = self.array.count
        print(curIndex)
        self.view.layer.opacity = 1.0
        
        for item in array {
            print(item.name!, item.position)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.layer.opacity = 1.0
    }
        
    var openingFrame: CGRect?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimator.animator
        presentationAnimator.openingFrame = openingFrame!
        presentationAnimator.transitionMode = .Present
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimator.animator
        presentationAnimator.openingFrame = openingFrame!
        presentationAnimator.transitionMode = .Dismiss
        return presentationAnimator
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomCategoryCell", owner: self, options: nil)?.first as! CustomCategoryCell
        cell.nameLabel.text = array[indexPath.row].name
//        cell.layer.borderWidth = 3
//        cell.layer.borderColor = UIColor.blue.cgColor
//        cell.layer.cornerRadius = 15
        cell.selectionStyle = .none
        cell.backgroundColor = hexStringToUIColor(hex: colourArray[indexPath.row])
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set frame of cell
        let attributesFrame = tableView.cellForRow(at: indexPath)?.frame
        let frameToOpenFrom = tableView.convert(attributesFrame!, to: tableView.superview)
        openingFrame = frameToOpenFrom
        
        curRow = indexPath.row
        self.performSegue(withIdentifier: "goToItems", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ItemsViewController
            destinationVC.transitioningDelegate = self
            destinationVC.modalPresentationStyle = .custom
            destinationVC.selectedCategory = array[curRow]
            destinationVC.tableViewColour = colourArray[curRow]
        }
        else if segue.identifier == "goToAddCategory" {
            let destinationVC = segue.destination as! AddNewCategoryViewController
            destinationVC.delegate = self
            destinationVC.modalPresentationStyle = .popover
            let popOverVC = destinationVC.popoverPresentationController
            popOverVC?.delegate = self
            popOverVC?.sourceView = self.addButton
            popOverVC?.sourceRect = CGRect(x: self.addButton.bounds.midX, y: self.addButton.bounds.minY - 3, width: 0, height: 0)
            destinationVC.preferredContentSize = CGSize(width: self.view.frame.width - 3, height: self.view.frame.height - 3)
        }
    }
    
    func addNewCategory() {
        UIView.animate(withDuration: 0.5) {
            self.view.layer.opacity = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.view.layer.opacity = 0.5
        }
        performSegue(withIdentifier: "goToAddCategory", sender: self)
        
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Add new category", message: .none, preferredStyle: .alert)
//        let add = UIAlertAction(title: "Add category", style: .default) { (UIAlertAction) in
//            if let text = textField.text {
//                let category = Category(context: self.context)
//                category.name = text
//                category.position = Int16(self.curIndex)
//                self.curIndex += 1
//                self.array.append(category)
//                self.save()
//                self.tableView.reloadData()
//                print("Saved new category")
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

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.context.delete(self.array[indexPath.row])
            self.array.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.save()
            completion(true)
        }
//        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
//            //            self.save()
//            completion(true)
//        }
        //        deleteAction.image = UIImage(named: "delete")
        //        deleteAction.backgroundColor = .white
//        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    func save() {
        do {
            try self.context.save()
            print("Saved data")
            for item in array {
                print(item.name!, item.position)
            }
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


extension ExpandingTableViewController {
    
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


// MARK: cell reorder / long press

//extension ExpandingTableViewController {
//
//    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
//        let locationInView = sender.location(in: tableView)
//        let indexPath = tableView.indexPathForRow(at: locationInView)
//
//        if sender.state == .began {
//            if indexPath != nil {
//                dragInitialIndexPath = indexPath
//                if self.from == 0 {
//                    from = dragInitialIndexPath!.row
//                }
//                let cell = tableView.cellForRow(at: indexPath!)
//                dragCellSnapshot = snapshotOfCell(inputView: cell!)
//                var center = cell?.center
//                dragCellSnapshot?.center = center!
//                dragCellSnapshot?.alpha = 0.0
//                tableView.addSubview(dragCellSnapshot!)
//
//                UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                    center?.y = locationInView.y
//                    self.dragCellSnapshot?.center = center!
//                    self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
//                    self.dragCellSnapshot?.alpha = 0.99
//                    cell?.alpha = 0.0
//                }, completion: { (finished) -> Void in
//                    if finished {
//                        cell?.isHidden = true
//                    }
//                })
//            }
//        } else if sender.state == .changed && dragInitialIndexPath != nil {
//            var center = dragCellSnapshot?.center
//            center?.y = locationInView.y
//            dragCellSnapshot?.center = center!
//
//            // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
//            if indexPath != nil && indexPath != dragInitialIndexPath {
//                // update your data model
////                print(" \(String(describing: dragInitialIndexPath?.row))")
//                let dataToMove = array[dragInitialIndexPath!.row]
//                array.remove(at: dragInitialIndexPath!.row)
//                array.insert(dataToMove, at: indexPath!.row)
//                tableView.moveRow(at: dragInitialIndexPath!, to: indexPath!)
//                dragInitialIndexPath = indexPath
////                print("2 drag \(String(describing: dragInitialIndexPath?.row))")
//                self.to = indexPath!.row
//            }
//        } else if sender.state == .ended && dragInitialIndexPath != nil {
//            let cell = tableView.cellForRow(at: dragInitialIndexPath!)
//            cell?.isHidden = false
//            cell?.alpha = 0.0
//            UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                self.dragCellSnapshot?.center = (cell?.center)!
//                self.dragCellSnapshot?.transform = CGAffineTransform.identity
//                self.dragCellSnapshot?.alpha = 0.0
//                cell?.alpha = 1.0
//            }, completion: { (finished) -> Void in
//                if finished {
//                    self.dragInitialIndexPath = nil
//                    self.dragCellSnapshot?.removeFromSuperview()
//                    self.dragCellSnapshot = nil
//
//                    self.array[self.to].position = Int16(self.to)
//                    self.array[self.from].position = Int16(self.from)
//
//                    print("from \(self.from)")
//                    print("to \(self.to)")
//
//                    for item in self.array {
//                        if (self.from < item.position) && (item.position < self.to) {
//                            item.position -= 1
//                        }
//                    }
//
//                    self.save()
//                }
//            })
//        }
//    }
//
//    func snapshotOfCell(inputView: UIView) -> UIView {
//        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
//        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        let cellSnapshot = UIImageView(image: image)
//        cellSnapshot.layer.masksToBounds = false
//        cellSnapshot.layer.cornerRadius = 0.0
//        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
//        cellSnapshot.layer.shadowRadius = 5.0
//        cellSnapshot.layer.shadowOpacity = 0.4
//        return cellSnapshot
//    }
//
//}


// This is we need to make it looks as a popup window on iPhone
extension ExpandingTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

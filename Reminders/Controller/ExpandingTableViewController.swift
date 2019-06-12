//
//  ExpandingTableViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-06.
//  Copyright © 2019 Dennis M. All rights reserved.
//


import UIKit
import CoreData
import UserNotifications

class ExpandingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UpdateMainViewDelegate, UpdateUIAfterGoBackDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
//    @IBOutlet weak var topSafeView: UIView!
//    @IBOutlet weak var bottomSafeView: UIView!
    
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    var hideCellAllowed: Bool!
    
    var array = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var curIndex = 0
    var from = 0
    var to = 0
    var curRow = 0
    
//    var colourArray = ["#E2C7C0", "#ECDBD8", "#71768A", "#303747", "#191F2F", "#0D1319"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        longPress.minimumPressDuration = 0.3 // optional
        tableView.addGestureRecognizer(longPress)
        
        self.tableView.separatorStyle = .none
        load()
        curIndex = self.array.count
        print("Current index -> \(curIndex)")
        self.view.layer.opacity = 1.0
        
        for item in array {
            print(item.name!, item.position)
        }
        
//        // Find size for blur effect.
//        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//        let bounds = self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -(statusBarHeight)).offsetBy(dx: 0, dy: -(statusBarHeight))
//        // Create blur effect.
//        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//        visualEffectView.frame = bounds!
//        // Set navigation bar up.
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.addSubview(visualEffectView)
//        self.navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let topSafeView = UIView()
        let bottomSafeView = UIView()
        
        self.view.addSubview(topSafeView)
        self.view.addSubview(bottomSafeView)

        bottomSafeView.translatesAutoresizingMaskIntoConstraints = false
        topSafeView.translatesAutoresizingMaskIntoConstraints = false
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        
        bottomSafeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomSafeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomSafeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bottomSafeView.heightAnchor.constraint(equalToConstant: window.frame.maxY - safeFrame.maxY).isActive = true
        bottomSafeView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        bottomSafeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomSafeView.frame.size.height = window.frame.maxY - safeFrame.maxY
        bottomSafeView.frame.size.width = view.frame.width
        
        topSafeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topSafeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topSafeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topSafeView.heightAnchor.constraint(equalToConstant: safeFrame.minY).isActive = true
        topSafeView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        topSafeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topSafeView.frame.size.height = safeFrame.minY
        topSafeView.frame.size.width = view.frame.width
        
        let visualEffectViewTop = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectViewTop.frame = topSafeView.bounds

        let visualEffectViewBot = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectViewBot.frame = bottomSafeView.bounds
        
        topSafeView.addSubview(visualEffectViewTop)
        bottomSafeView.addSubview(visualEffectViewBot)
        
        let origImage = UIImage(named: "add")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(tintedImage, for: .normal)
        addButton.tintColor = .black
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
//        cell.backgroundColor = hexStringToUIColor(hex: colourArray[indexPath.row])
        cell.backgroundColor = hexStringToUIColor(hex: array[indexPath.row].colour!)
        cell.nameLabel.textColor = hexStringToUIColor(hex: array[indexPath.row].tintColour!)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set frame of cell
        let attributesFrame = tableView.cellForRow(at: indexPath)?.frame
        let frameToOpenFrom = tableView.convert(attributesFrame!, to: tableView.superview)
        openingFrame = frameToOpenFrom
        
        curRow = indexPath.row
        UIView.animate(withDuration: 0.065) {
            self.addButton.layer.opacity = 0.0
        }
        
        UIView.animate(withDuration: 1) {
            self.view.layer.opacity = 0.0
        }
        
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ItemsViewController
            destinationVC.transitioningDelegate = self
            destinationVC.delegate = self
            destinationVC.modalPresentationStyle = .custom
            destinationVC.selectedCategory = array[curRow]
            destinationVC.tableViewColour = array[curRow].colour!
//            destinationVC.tableViewColour = "#3D3D3D"
        }
        else if segue.identifier == "goToAddCategory" {
            let destinationVC = segue.destination as! AddNewCategoryViewController
            destinationVC.delegate = self
            destinationVC.modalPresentationStyle = .popover
            let popOverVC = destinationVC.popoverPresentationController
            popOverVC?.delegate = self
            popOverVC?.sourceView = self.addButton
            popOverVC?.sourceRect = CGRect(x: self.addButton.bounds.midX, y: self.addButton.bounds.minY - 3, width: 0, height: 0)
            destinationVC.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        }
    }
    
    func addNewCategory(name: String, colour: String, tint: String) {
        
        if let viewWithTag = self.view.viewWithTag(100) {
            UIView.animate(withDuration: 0.5, animations: {
                viewWithTag.layer.opacity = 0.0
            }) { (true) in
                viewWithTag.removeFromSuperview()
            }
        }
//        UIView.animate(withDuration: 0.5) {
//            self.view.layer.opacity = 1.0
//        }
        let category = Category(context: self.context)
        category.name = name
        category.position = Int16(self.curIndex)
        category.colour = colour
        category.tintColour = tint
        self.curIndex += 1
        self.array.append(category)
        self.save()
        self.tableView.reloadData()
        print("Saved new category")
    }
    
    func dismissView() {
        print("Here1")
        if let viewWithTag = self.view.viewWithTag(100) {
            UIView.animate(withDuration: 0.5, animations: {
                viewWithTag.layer.opacity = 0.0
            }) { (true) in
                viewWithTag.removeFromSuperview()
            }
        }
//        UIView.animate(withDuration: 0.5) {
//            self.view.layer.opacity = 1.0
//        }
    }
    
    func updateUI() {
        self.view.layer.opacity = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            UIView.animate(withDuration: 1, animations: {
                self.addButton.layer.opacity = 0.85
            })
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let visualEffectViewTop = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectViewTop.frame = self.view.bounds
        visualEffectViewTop.layer.opacity = 0.0
        visualEffectViewTop.tag = 100
        self.view.addSubview(visualEffectViewTop)
        UIView.animate(withDuration: 0.5) {
//            self.view.layer.opacity = 0.6
            visualEffectViewTop.layer.opacity = 1.0
        }
        performSegue(withIdentifier: "goToAddCategory", sender: self)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let index = indexPath.row
            self.context.delete(self.array[indexPath.row])
            self.array.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            for item in self.array {
                if index < item.position {
                    item.position -= 1
                }
            }
            
            self.curIndex -= 1
            
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
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                from = (indexPath?.row)!
                print(from)
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!) as! CustomCategoryCell?
                My.cellSnapshot  = snapshotOfCell(cell!)
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    to = (indexPath?.row)!
                    print(to)
                    array.insert(array.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!) as! CustomCategoryCell?
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
                
                for i in 0...array.count-1 {
                    array[i].position = Int16(i)
                }
                
                save()
            }
        }

    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    struct My {
        static var cellSnapShot: UIView? = nil
    }
    
    struct Path {
        static var initialIndexPath: IndexPath? = nil
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

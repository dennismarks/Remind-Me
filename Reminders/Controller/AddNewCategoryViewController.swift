//
//  AddNewCategoryViewController.swift
//  Reminders
//
//  Created by Dennis M on 2019-06-09.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

protocol UpdateMainViewDelegate {
    func addNewCategory()
}

class AddNewCategoryViewController: UIViewController {
    
    var num = 0
    var delegate : UpdateMainViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIView.animate(withDuration: 0.5) {
            self.preferredContentSize = CGSize(width: self.view.frame.width - 7, height: self.view.frame.width - 7)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.delegate?.addNewCategory()
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.delegate?.addNewCategory()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

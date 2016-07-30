//
//  AddParkViewController.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 30/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import UIKit

class AddParkViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var park: Park?
    
    override func viewDidLoad() {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "unwindToParkListViewController"{
        self.park = Park(name: self.nameTextField.text!)
        }
    }
    
    
    @IBAction func savePark(sender: AnyObject) {
        
    }
    @IBAction func cancel(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

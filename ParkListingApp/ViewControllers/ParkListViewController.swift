//
//  ParkListViewController.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 19/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import UIKit

class ParkListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // declare variables parks is an array of parks
    var parks: [Park] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshParks()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showParkDetailViewController" {
            let destVC: ParkDetailViewController = segue.destinationViewController as! ParkDetailViewController
            
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                let park: Park = self.parks[selectedIndexPath.row]
                destVC.park = park
            }
        }
        
    }
    
    @IBAction func unwindToParkListViewController(segue: UIStoryboardSegue) {
        if let addParkVC: AddParkViewController = segue.sourceViewController as? AddParkViewController {
            if let park = addParkVC.park {
                self.parks.append(park)
                self.tableView.reloadData()
            }
        }
    }
    
    

    
    @IBAction func addPark(sender: AnyObject) {
        //add random park from an array of parks
        
        
        let park: Park = Park.createRandomPark()
        
        self.parks.append(park)
        
        self.tableView.reloadData()
        
        
    }
    
    func refreshParks() {
        ParkLoader.sharedLoader.readParksFromServer { (parks, error) -> Void in
            if let error = error {
                
            } else {
                self.parks = parks
                self.tableView.reloadData()
            }
        }
    }
    

}

// to set UITableVIewDataSource

extension ParkListViewController: UITableViewDataSource {
    
    // must 1) set number of rows in a section
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns the number of rows
        return parks.count
    }
    
    // must 2) set number of cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ParkCell = self.tableView.dequeueReusableCellWithIdentifier("ParkCell", forIndexPath: indexPath) as! ParkCell
        
        let park: Park = self.parks[indexPath.row]
        
        cell.park = park
        
        return cell
    }
}

// for UITableViewDelegate

extension ParkListViewController: UITableViewDelegate {
    
    // must have didSelectRowAtIndexPath
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // pass data forward using code
        
         let detailsVC: ParkDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParkDetailViewController") as! ParkDetailViewController
        
        let park: Park = self.parks[indexPath.row]
        detailsVC.park = park
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
    }
}

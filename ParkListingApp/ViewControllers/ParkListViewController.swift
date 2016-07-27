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

        // Do any additional setup after loading the view.
        self.preLoadData()
    }
    
    func preLoadData() {
        for (var i = 0; i < 20; i++) {
            let park: Park = Park.createRandomPark()
            self.parks.append(park)
        }
        
        self.tableView.reloadData()
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
    
    // randomParkName function
    
    

    
    @IBAction func addPark(sender: AnyObject) {
        //add random park from an array of parks
        
        
        let park: Park = Park.createRandomPark()
        
        self.parks.append(park)
        
        self.tableView.reloadData()
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
        let cell: UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        
        let park: Park = self.parks[indexPath.row]
        
        cell.textLabel?.text = park.name
        cell.imageView?.image = park.image
        
        return cell
    }
}

// for UITableViewDelegate

extension ParkListViewController: UITableViewDelegate {
    
    // must have didSelectRowAtIndexPath
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // do something
        
        let detailsVC: ParkDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParkDetailViewController") as! ParkDetailViewController
        
        let park: Park = self.parks[indexPath.row]
        detailsVC.park = park
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
    }
}

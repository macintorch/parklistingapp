//
//  ParkDetailViewController.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 19/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import UIKit

class ParkDetailViewController: UIViewController {

    var park: Park!
    @IBOutlet weak var imagePark: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkRatingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.parkNameLabel.text = self.park.name
        self.imagePark.image = self.park.image
        self.parkRatingLabel.text = "\(self.park.averageRating())"
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

}

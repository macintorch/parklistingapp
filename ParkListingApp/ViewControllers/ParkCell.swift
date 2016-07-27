//
//  ParkCell.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 27/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import UIKit

class ParkCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var park: Park! {
        didSet {
            updateDisplay()
        }
    }
    
    func updateDisplay() {
        self.nameLabel.text = self.park.name
        self.photoImageView.image = self.park.image
    }
    

}

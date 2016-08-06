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
    
    var loadImageTask: NSURLSessionDataTask?
    
    var park: Park! {
        didSet {
            updateDisplay()
        }
    }
    
    func updateDisplay() {
        self.nameLabel.text = self.park.name
        if let photo = self.park.image {
            self.photoImageView.image = photo
        } else if let photoURL = self.park.photoUrl {
            self.loadImageTask?.cancel()
        
        
        self.loadImageTask = ParkLoader.sharedLoader.loadImageTask(photoURL, completionBlock: { (image,error) -> Void in
            if let image = image {
                self.photoImageView.image = image
            }
        })
            self.loadImageTask?.resume()
        }
    }
}

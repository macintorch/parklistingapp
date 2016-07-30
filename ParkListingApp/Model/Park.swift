//
//  Park.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 19/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import Foundation

import UIKit


class Park: NSObject, NSCoding{
    var name: String?
    var image: UIImage?
    var location: String?
    var reviews: [Review] = []
    
    func encodeWithCoder(aCoder: NSCoder) {
        let keyedArchiver: NSKeyedArchiver = aCoder as! NSKeyedArchiver
        
        keyedArchiver.encodeObject(self.name, forKey: "PLDParkName")
        keyedArchiver.encodeObject(self.name, forKey: "PLDParkLocation")
        
        if self.image != nil {
            let imageData: NSData? = UIImagePNGRepresentation(self.image!)
            keyedArchiver.encodeObject( imageData, forKey: "PLDParkPhotoData")
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let keyedUnarchiver: NSKeyedUnarchiver = aDecoder as! NSKeyedUnarchiver
        
        let name: String = keyedUnarchiver.decodeObjectForKey("PLDParkName") as! String
        self.init(name: name)
        
        self.location = keyedUnarchiver.decodeObjectForKey("PLDParkLocation") as? String
        
        if let imageData = keyedUnarchiver.decodeObjectForKey("PLDParkPhotoData") as? NSData {
            self.image = UIImage(data: imageData)
        }
        self.reviews = []
    }
    
    init?(name: String) {
        self.name = name
        self.reviews = []
        super.init()
        if name.isEmpty {
            return nil
        }

    }
    
    // average rating logic
    
    func averageRating() -> Double {
        
        if reviews.count == 0 {
            return 0.0
        }
        var average: Double = 0.0
        for review in self.reviews {
            average += Double(review.rating)
        }
        
        return average / Double(reviews.count)
    }
    
    class func createRandomPark() -> Park {
        
        let dataset: [String] = ["Amazing Park", "Green Park", "Narmada Park", "Rose Park", "Tunnel Park"]
        let index: Int = Int(arc4random_uniform(UInt32(dataset.count)))
        let randomName: String = dataset[index]
        
        let park: Park = Park(name: randomName)!
        park.image = UIImage(named: randomName)
        
        return park
    }

    
}
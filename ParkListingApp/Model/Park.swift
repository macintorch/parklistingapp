//
//  Park.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 19/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import Foundation

import UIKit


class Park {
    var name: String?
    var image: UIImage?
    var location: String?
    var reviews: [Review] = []
    
    init?(name: String) {
        self.name = name
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
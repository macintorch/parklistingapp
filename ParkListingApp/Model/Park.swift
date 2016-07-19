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
    
    init(name: String) {
        self.name = name
        
    }
    
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
    
}
//
//  Review.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 19/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import Foundation


class Review {
    var dateCreate: NSDate?
    var rating: Int {
        
        // behaviorial check
        
        didSet {
            if rating < 1 {
                self.rating = 1
            } else if rating > 5 {
                self.rating = 5
            }
        }
    }
    
    
    init(rating: Int, date: NSDate = NSDate()) {
        self.rating = 0
        self.dateCreate =  date
    }
}
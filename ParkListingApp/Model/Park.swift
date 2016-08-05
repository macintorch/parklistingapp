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
    
    var objectId: String?
    var name: String?
    // to store photo on device
    var image: UIImage?
    // to store photo on server
    var photoUrl: NSURL?
    var photoFilename: String? {
        get {return self.photoUrl?.pathComponents?.last}
    }
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

// JSON API
extension Park {
    convenience init? (json: [String : AnyObject]) {
        // get vales from json dictionary
        let name: String = json["name"] as! String
        self.init(name: name)
        
        updateWithJson(json)
    }
    
    func updateWithJson(json: [String : AnyObject]) {
        if let name = json ["name"] as? String {
            self.name = name
        }
        
        if let objectId: String = json["objectId"] as? String {
            self.objectId = objectId
        }
        
        if let photoDict: [String : AnyObject] = json["photo"] as? [String : AnyObject] {
            if let photoUrlString: String = photoDict["url"] as? String {
                self.photoUrl = NSURL(string: photoUrlString)
            }
        }
    }
    
    func jsonDict() -> [String: AnyObject] {
        var jsonDict: [String : AnyObject] = ["name": self.name!,
                                              "location": self.location ?? NSNull()]
        
        if let _ = self.photoUrl {
            jsonDict["photo"] = ["name": self.photoFilename!, "__type": "File"]
        }
        return jsonDict
    }
}
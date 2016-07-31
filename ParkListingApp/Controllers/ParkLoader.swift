//
//  ParkLoader.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 31/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import Foundation

class ParkLoader {
    
    // Singleton Pattern
    
    static let sharedLoader: ParkLoader = ParkLoader()
    
    private init() {
      
    }
    
    // Manage data files
    
    let fileManager: NSFileManager = NSFileManager.defaultManager()
    
    func dataFileURL() -> NSURL {
        let documentDirectory: NSURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        let filePath: NSURL = documentDirectory.URLByAppendingPathComponent("data.plist")
        
        return filePath
    }
    
    
    func readParksFromFile() -> [Park] {
        let parkData: [NSData] = NSArray(contentsOfURL: self.dataFileURL()) as! [NSData]
        
        var parks: [Park] = []
        
        for data in parkData {
            let park: Park = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Park
            parks.append(park)
        }
        return parks
    }
    
    func saveParksToFile(parks: [Park]) {
        
        var parksData: [NSData] = []
        for park in parks {
            let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(park)
            parksData.append(data)
        }
        (parksData as NSArray).writeToURL(self.dataFileURL(), atomically: true)
    }
}
//
//  ParkPersistenceTest.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 30/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import XCTest
@testable import ParkListingApp

class ParkPersistenceTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("SavedFruits") == nil {
            let fruits: [String] = ["Apple","Durian","Rambutan"]
            defaults.setObject(fruits, forKey: "SavedFruits")
            defaults.synchronize()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWritingToFile() {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let documentDirectory: NSURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        let filePath: NSURL = documentDirectory.URLByAppendingPathComponent("data.plist")
        
        var parks: [Park] = []
        parks.append(Park.createRandomPark())
        parks.append(Park.createRandomPark())
        parks.append(Park.createRandomPark())
        
        var parksData: [NSData] = []
        for park in parks {
            let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(park)
            parksData.append(data)
        }
        
        (parksData as NSArray).writeToURL(filePath, atomically: true)
        
        var fileExists: Bool = fileManager.fileExistsAtPath(filePath.path!)
        XCTAssert(fileExists, "File should exists after write")
        
        NSLog("FIle path: \(filePath.path)")
    }
    
    func testReadingFromFile() {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let documentDirectory: NSURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        let filePath: NSURL = documentDirectory.URLByAppendingPathComponent("data.plist")
        
        let parkData: [NSData] = NSArray(contentsOfURL: filePath) as! [NSData]
        
        var parks: [Park] = []
        
        for data in parkData {
            let park: Park = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Park
            parks.append(park)
        }
        
        XCTAssert(parks.count == 3, "Should have loaded 3 parks from file")
    }
    
    
    func testSavingPark() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let park: Park = Park.createRandomPark()
        let parkData: NSData = NSKeyedArchiver.archivedDataWithRootObject(park)
        defaults.setObject(parkData, forKey: "testParkData")
        defaults.synchronize()
        
        let readParkData: NSData = defaults.objectForKey("testParkData") as! NSData
        let readPark: Park? = NSKeyedUnarchiver.unarchiveObjectWithData(readParkData) as? Park
        
        XCTAssertNotNil(readPark,"Should be able to read park data from default and return and object ")
        
        XCTAssertEqual(park.name, readPark!.name, "Names from park and recreated park should match")
        
    }

    func testReadingArray() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let fruits = defaults.objectForKey("SavedFruits") as? [String] {
            XCTAssert(fruits.count > 0, "Save list of fruits should contain some item")
        } else {
            XCTAssert(false, "Unable to read list of fruits")
        }
    }
    
    
    func testReadingFromDefaults() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Ainor", forKey: "SavedNamed")
        defaults.synchronize()
        
        let name : String? = defaults.stringForKey("SavedNamed")
        
        XCTAssertEqual("Ainor", name, "saved nameshould match")
        
        
        
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

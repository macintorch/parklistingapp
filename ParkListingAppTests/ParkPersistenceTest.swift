//
//  ParkPersistenceTest.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 30/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import XCTest

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

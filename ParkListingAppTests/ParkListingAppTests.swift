//
//  ParkListingAppTests.swift
//  ParkListingAppTests
//
//  Created by Ainor Syahrizal on 19/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import XCTest
@testable import ParkListingApp

class ParkListingAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadingHompage() {
        
        let expectation = self.expectationWithDescription("Load Task")
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let url: NSURL = NSURL(string: "http://apple.com")!
        
        let loadTask: NSURLSessionDataTask = session.dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            //code
        let htmlString: String? = String(data: data!, encoding: NSUTF8StringEncoding)
        XCTAssert(htmlString != nil, "Should have received some html String from server")
            
            NSLog("task completed")
            
            expectation.fulfill()
        }
        
        loadTask.resume()
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
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

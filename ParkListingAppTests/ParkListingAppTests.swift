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
    
    var session: NSURLSession!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        config.HTTPAdditionalHeaders = ["X-Parse-Application-Id": "xAQEz3WeqfNFDUrhwex0fhErS1dJkAPFa6PkdKMz", "X-Parse-REST-API-Key": "hp7HZgv18V3QoSUIUPy4YQaeCWMLFUqQH3Z85ulk", "Content-Type": "application/json"]
        
        self.session = NSURLSession(configuration: config)
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
    
    func testLoadingAPI() {
        
        // need a RUL
        
        // need to load the url
        
        // need to check results
        
        
        let expectation = self.expectationWithDescription("Load Task")
        
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        config.HTTPAdditionalHeaders = ["X-Parse-Application-Id": "xAQEz3WeqfNFDUrhwex0fhErS1dJkAPFa6PkdKMz", "X-Parse-REST-API-Key": "hp7HZgv18V3QoSUIUPy4YQaeCWMLFUqQH3Z85ulk", "Content-Type": "application/json"]
        
        let session = NSURLSession(configuration: config)
        let url: NSURL = NSURL(string: "https://api.parse.com/1/classes/Park")!
        
        let loadTask: NSURLSessionDataTask = session.dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            //code
            
            NSLog("task completed")
            expectation.fulfill()
        }
        
        loadTask.resume()
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func createDataTaskForPark(park: Park, filename: String, expectation: XCTestExpectation) -> NSURLSessionDataTask {
        let url: NSURL = NSURL(string: "https://api.parse.com/1/classes/Park")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        urlRequest.HTTPMethod = "POST"
        
        let jsonDict: [String : AnyObject] = [
            "name": park.name!,
            "location": park.location ?? NSNull(),
            "photo": ["name": filename, "__type": "File"]
        ]
        
        let jsonData: NSData = try! NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions(rawValue: 0))
        
        urlRequest.HTTPBody = jsonData
        
        let postTask: NSURLSessionDataTask = self.session.dataTaskWithRequest(urlRequest) { (data:NSData?, response: NSURLResponse?, error: NSError? ) -> Void in
            
            let httpCode: Int = (response as! NSHTTPURLResponse).statusCode
            
            XCTAssert(httpCode == 201, "Server should have returned 201 Created")
            
            
            let jsonString: String? = String(data: data!, encoding: NSUTF8StringEncoding)
            
            NSLog("Server \(httpCode): \(jsonString!)")
            
            expectation.fulfill()
        }
        return postTask
    }
    
    
    func testCreatingImageOnServer() {
        let imageExpectation = self.expectationWithDescription("Ceate Image")
        let parkExpectation = self.expectationWithDescription("Ceate Park")
        
        let url: NSURL = NSURL(string: "https://api.parse.com/1/files/photo.jpg")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        urlRequest.HTTPMethod = "POST"
        urlRequest.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let park: Park = Park.createRandomPark()
        let imageData: NSData = UIImageJPEGRepresentation(park.image!, 0.9)!
        
        //urlRequest.HTTPBody = imageData
        
        let uploadTask: NSURLSessionUploadTask = self.session.uploadTaskWithRequest(urlRequest, fromData: imageData) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            let httpCode: Int = (response as! NSHTTPURLResponse).statusCode
            
            XCTAssert(httpCode == 201, "Server should have returned 201 Created")
            
            // grad the file ID (name) from the response json
            
            let jsonDict: [String: AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [String : AnyObject]
            
            let filename: String = jsonDict["name"] as! String
            
            // Run another data tas to update Park
            let createTask: NSURLSessionDataTask = self.createDataTaskForPark(park, filename: filename, expectation: parkExpectation)
            createTask.resume()
            
            imageExpectation.fulfill()
        }
        uploadTask.resume()
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testLoadingImageFromServer() {
        let expectation = self.expectationWithDescription("Load Image")
        
        let url: NSURL = NSURL(string: "http://files.parsetfss.com/1359b29c-6b1f-4547-8bba-5c55514fd557/tfss-26c04bcf-5668-4131-ab0d-047f450b2f34-photo.jpg")!
        
        let imageTask: NSURLSessionDataTask = self.session.dataTaskWithURL(url) {
            (imageData: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            var image: UIImage!
            if let imageData = imageData {
                image = UIImage(data: imageData)
            }
            
            XCTAssertNotNil(image, "image should be loaded from server")
            expectation.fulfill()
        }
        imageTask.resume()
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    func testCreatingParkOnServer() {
        
        let expectation = self.expectationWithDescription("Create Park")
        
        let url: NSURL = NSURL(string: "https://api.parse.com/1/classes/Park")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        urlRequest.HTTPMethod = "POST"
        
        let park: Park = Park.createRandomPark()
        park.name = "KL Park"
        
        let jsonDict: [String : AnyObject] = [
                "name": park.name!,
                "location": park.location ?? NSNull()
        ]
        
        let jsonData: NSData = try! NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions(rawValue: 0))
        
        urlRequest.HTTPBody = jsonData
        
        let postTask: NSURLSessionDataTask = self.session.dataTaskWithRequest(urlRequest) { (data:NSData?, response: NSURLResponse?, error: NSError? ) -> Void in
            
            let httpCode: Int = (response as! NSHTTPURLResponse).statusCode
            
            XCTAssert(httpCode == 201, "Server should have returned 201 Created")
            
            
            let jsonString: String? = String(data: data!, encoding: NSUTF8StringEncoding)
            
            NSLog("Server \(httpCode): \(jsonString!)")
            
            expectation.fulfill()
        }
        
        postTask.resume()
        
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testJSONDataFromAPI() {
        let expectation = self.expectationWithDescription("Load Task")
        
        
        let url: NSURL = NSURL(string: "https://api.parse.com/1/classes/Park")!
        
        let loadTask: NSURLSessionDataTask = self.session.dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            //code
            
            let httpCode: Int = (response as! NSHTTPURLResponse).statusCode
            
            XCTAssert(httpCode == 200, "Server should have returned 200 content OK")
            
            var parks: [Park] = []
            // a dictionary [<key>: <value>]
            
            let json : [String : AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [String : AnyObject]
            // read the data Array from the returned json
            
             if let resultsArray: [ [String : AnyObject] ] = json["results"] as? [ [String : AnyObject]] {
                
                // go through each jason
                for jsonData in resultsArray {
                    
                    let name: String = jsonData["name"] as! String
                    let objectId: String = jsonData["objectId"] as! String
                    let park: Park = Park(name: name)!
                    parks.append(park)
                }
            }
            
            XCTAssert(parks.count > 0, "Parks array shouldn't be empty")
            
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

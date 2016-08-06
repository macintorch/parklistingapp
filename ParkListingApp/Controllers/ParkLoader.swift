//
//  ParkLoader.swift
//  ParkListingApp
//
//  Created by Ainor Syahrizal on 31/07/2016.
//  Copyright © 2016 Ainor Syahrizal. All rights reserved.
//

import UIKit

class ParkLoader {
    
    // Singleton Pattern
    
    static let sharedLoader: ParkLoader = ParkLoader()
    
    private init() {
      // initialize
        
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["X-Parse-Application-Id": "xAQEz3WeqfNFDUrhwex0fhErS1dJkAPFa6PkdKMz", "X-Parse-REST-API-Key": "hp7HZgv18V3QoSUIUPy4YQaeCWMLFUqQH3Z85ulk", "Content-Type": "application/json"]
        
        self.session = NSURLSession(configuration: config)
        self.baseURL = NSURL(string: "https://api.parse.com/1/")!
    }
    
    //Manage data from server
    let session: NSURLSession
    let baseURL: NSURL
    
    // Manage data files
    let fileManager: NSFileManager = NSFileManager.defaultManager()

}

// load parks from network

extension ParkLoader {
        
        func readParksFromServer(completionBlock: ((parks: [Park], error: NSError?) -> Void)?) {
            let url: NSURL = NSURL(string: "classes/Park", relativeToURL: self.baseURL)!
            
            let loadTask: NSURLSessionDataTask = self.session.dataTaskWithURL(url) {
                (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                // check returned data validity
                
                
                var json: [String : AnyObject]!
                        do {
                        json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [String : AnyObject]
                        } catch let jsonError {
                            //return error
                            completionBlock?(parks: [], error: jsonError as NSError)
                            return
                    }
                // process JSON into Park array
                var parksFromServer: [Park] = []
                
                if let resultsArray: [ [ String : AnyObject] ] = json["results"] as? [ [String : AnyObject] ] {
                    for jsonDict in resultsArray {
                            let park: Park = Park(json: jsonDict)!
                            parksFromServer.append(park)
                        }
                    }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionBlock?(parks: parksFromServer, error: nil)
                    
                    })
                
                
            }
            
                loadTask.resume()
    }


    func saveParkOnServer(park: Park, successBlock: ((succeeded: Bool, error: NSError?) -> Void)?) {
        if park.objectId == nil {
            createParkOnServer(park, successBlock: successBlock)
        } else {
            updateParkOnServer(park, successBlock: successBlock)
        }
    }
    
        func createParkOnServer(park: Park, successBlock:((succeeded: Bool, error: NSError?) -> Void)?) {
            let url: NSURL = NSURL(string: "classes/Park", relativeToURL: self.baseURL)!
            
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonDict: [String : AnyObject] = ["name": park.name!, "location": park.location ?? NSNull()]
            let jsonData: NSData = try! NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions(rawValue: 0))
            
            urlRequest.HTTPBody = jsonData
            
            let postTask: NSURLSessionDataTask = self.session.dataTaskWithRequest(urlRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                //check http code
                let httpCode: Int = (response as! NSHTTPURLResponse).statusCode
                
                // get new object ID and save to park
                let jsonString: String? = String(data: data!, encoding: NSUTF8StringEncoding)
                let json: [String : AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [String : AnyObject]
                park.objectId = json["objectId"] as? String
                
                successBlock?(succeeded: true, error: nil)
                NSLog("HTTP\(httpCode): \(jsonString!)")
            }
            
            postTask.resume()
        }
    func loadImageTask(imageURL: NSURL, completionBlock:((image: UIImage!, error: NSError?) -> Void)?) -> NSURLSessionDataTask {
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: imageURL)
        urlRequest.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        let task: NSURLSessionDataTask = self.session.dataTaskWithRequest(urlRequest) {
            (imageData: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            var image: UIImage! = nil
                if let imageData = imageData {
                image = UIImage(data: imageData)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionBlock?(image: image, error: error)
            })
            
            
        }
        return task
    }
    
    func updateParkOnServer(park: Park, successBlock:((succeeded: Bool, error: NSError?) -> Void)?) {
                let url: NSURL = NSURL(string: "parks/\(park.objectId!).json", relativeToURL: self.baseURL)!
        
                let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
                urlRequest.HTTPMethod = "PATCH"
        
                let jsonData: NSData = try! NSJSONSerialization.dataWithJSONObject(park.jsonDict(), options: NSJSONWritingOptions(rawValue: 0))
                urlRequest.HTTPBody = jsonData
        
                let patchTask: NSURLSessionDataTask = self.session.dataTaskWithRequest(urlRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    // code
                    let httpCode: Int = (response as! NSHTTPURLResponse).statusCode
        
                    let jsonString: String? = String(data: data!, encoding: NSUTF8StringEncoding)
                    NSLog("HTTP \(httpCode): \(jsonString!)")
                }
                patchTask.resume()
            }
}

// load parks from file
extension ParkLoader {
    
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

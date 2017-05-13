//
//  LockModel.swift
//  BikeParkingClub
//
//  Created by Yury Dymov on 5/13/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit

enum LockError: Error {
    case JSONParsingError
    case NetworkError
    case DataNil
    case RequestFailed
    case InvalidPayloadFormat
}

class LockModel {
    private static var _shared: LockModel = LockModel()
    
    public static var shared:LockModel {
        get {
            return self._shared
        }
    }
    
    private var _session: URLSession
    
    internal init() {
        self._session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    public func isLocked(complete:@escaping((Bool?, Error?)->Void)) {
        let req = URLRequest(url: URL(string: "https://thingspace.io/get/latest/dweet/for/parkbikeclub")!)
        
        let dataTask = self._session.dataTask(with: req) { (data, response, error) in
            if error != nil {
                return complete(nil, LockError.NetworkError)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    return complete(nil, LockError.RequestFailed)
                }
            } else {
                return complete(nil, LockError.RequestFailed)
            }
            
            if data == nil {
                return complete(nil, LockError.DataNil)
            }
            
            
            guard let jsonResponse: [String:AnyObject] = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject] else {
                return complete(nil, LockError.JSONParsingError)
            }
            
            guard let resultArray:[[String:AnyObject]] = jsonResponse["with"] as? [[String:AnyObject]] else {
                return complete(nil, LockError.InvalidPayloadFormat)
            }
            
            if (resultArray.count == 0) {
                return complete(nil, LockError.InvalidPayloadFormat)
            }
            
            guard let content:[String:AnyObject] = resultArray[resultArray.count - 1]["content"] as? [String:AnyObject] else {
                return complete(nil, LockError.InvalidPayloadFormat)
            }
            
            if (content["locked"] == nil) {
                return complete(nil, LockError.InvalidPayloadFormat)
            }
            
            complete(content["locked"] as? String == "true", nil)
        }
        
        dataTask.resume()
    }
    
    public func toggleLock(complete:@escaping(Error?)->Void) {
        isLocked { (locked, error) in
            if error != nil {
                return complete(error)
            }
            
            let req = URLRequest(url: URL(string: String(format: "https://thingspace.io/dweet/for/parkbikeclub?locked=%@", locked! ? "true" : "false"))!)
            
            let dataTask = self._session.dataTask(with: req) { (data, response, error) in
                if error != nil {
                    return complete(LockError.NetworkError)
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                        return complete(LockError.RequestFailed)
                    }
                } else {
                    return complete(LockError.RequestFailed)
                }
                
                if data == nil {
                    return complete(LockError.DataNil)
                }

                complete(nil)
            }
            
            dataTask.resume()
        }
    }
}

//
//  VerizonClient.swift
//  Ersi
//
//  Created by Yury Dymov on 5/14/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit

enum VerizonError: Error {
    case invalidResponse
}

class VerizonClient: NSObject {
    private static func _getToken(completion: ((String?, Error?)->Void)?) {
        let url = URL(string: "https://thingspace.verizon.com/api/ts/v1/oauth2/token")!
        //Post request to json
        let request = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        //request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let verizonKey = String("GAaKFdRykcb2sIbjRUNFsghYpGsa:XwJ0n0RffzNxULu1QWhtOIukv6sa").data(using: .utf8)!.base64EncodedString()
        
        request.addValue(String(format: "Basic %@", verizonKey), forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = String("grant_type=client_credentials")?.data(using: .utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if error != nil {
                print(error!)
                if (completion != nil) {
                    completion!(nil, error!)
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                
                let token = json["access_token"] as! String
                
                if (completion != nil) {
                    completion!(token, nil)
                }
                
            } catch {
                if (completion != nil) {
                    print("failed to parse json")
                    completion!(nil, VerizonError.invalidResponse)
                }
            }
        })
        task.resume()
    }
    
    static func registerCallback() {
        _getToken { (code, error) in
            if (error != nil) {
                return
            }
            
            let url = URL(string: "https://thingspace.verizon.com/api/messaging/v1/callbacks")!
            //Post request to json
            let request = NSMutableURLRequest(url: url)
            let session = URLSession.shared
            request.httpMethod = "POST"
            //request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            
            request.addValue(String(format: "Bearer %@", code!), forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try? JSONSerialization.data(withJSONObject: [
                "callbackType": "Default",
                "code": "900040002026",
                "url": "https://ps.pndsn.com/publish/pub-c-0eb1415c-3ea2-4b4f-857f-d53cad2a47d9/sub-c-17053e2c-383f-11e7-a268-0619f8945a4f/0/bike_parking_club_lock/toggleLock/{}",
                ], options: [])
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
            })
            
            task.resume()
        }
    }

}

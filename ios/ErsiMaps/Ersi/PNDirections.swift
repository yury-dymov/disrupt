//
//  PNDirections.swift
//  Ersi
//
//  Created by Yury Dymov on 5/14/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit
import CoreLocation

class PNDirections {
    public static func get(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, complete:((Data?, Error?)->Void)?) {
        let jsonString: [String:AnyObject] = [
            "locations": [
                [
                    "latLng": [
                        "lat": "\(from.latitude)",
                        "lng": "\(from.longitude)"
                    ]
                ],
                [
                    "latLng": [
                        "lat": "\(to.latitude)",
                        "lng": "\(to.longitude)"
                    ]
                ],
                ] as AnyObject
        ]
        
        PNClient.shared.write(channel: "esri_routing", payload: jsonString) { (status) in
            if (status == nil) {
                if (complete != nil) {
                    complete!(nil, PNClientError.pubNubFailure("empty status"))
                }
                
                return
            }
            
            
            complete?(status!.data as? Data, nil)
        }
    }
}

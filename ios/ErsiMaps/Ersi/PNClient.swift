//
//  PNClient.swift
//  Disrupt
//
//  Created by Yury Dymov on 5/13/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import PubNub

enum PNClientError: Error {
    case pubNubFailure(String)
}

extension NSNotification.Name {
    static let pubNubRecevied = NSNotification.Name("pubNubReceived")
}

class PNClient : NSObject, PNObjectEventListener {
    private static var _shared: PNClient = PNClient()
    public static var shared: PNClient {
        return _shared
    }
    
    private var _client: PubNub?
    private var _callback: ((Error?)->Void)?
    
    internal override init() {
        super.init()
        
        self._client = PubNub.client(with: PNConfiguration(publishKey: "pub-c-0eb1415c-3ea2-4b4f-857f-d53cad2a47d9", subscribeKey: "sub-c-17053e2c-383f-11e7-a268-0619f8945a4f"))
        
        _client!.add(self)
    }
    
    
    func setupWithCallback(_ callback: ((Error?)->Void)?) {
        _callback = callback
        _client!.subscribe(toChannels: ["bike_parking_club_lock", "routing_block", "Text_to_Speech_Converter"], withPresence: true)
    }
    
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        if status.operation == .subscribeOperation {
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    if (_callback != nil) {
                        _callback!(nil)
                    }
                } else {
                    if (_callback != nil) {
                        _callback!(PNClientError.pubNubFailure("This usually occurs if subscribe temporarily fails but reconnects. This means there was an error but there is no longer any issue."))
                    }
                }
            } else if status.category == .PNUnexpectedDisconnectCategory {
                if (_callback != nil) {
                    _callback!(PNClientError.pubNubFailure("This is usually an issue with the internet connection, this is an error, handle appropriately retry will be called automatically."))
                }
            } else {
                print("Looks like some kind of issues happened while client tried to subscribe or disconnected from network.")
                
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                
                if errorStatus.category == .PNAccessDeniedCategory {
                    if (_callback != nil) {
                        _callback!(PNClientError.pubNubFailure("This means that PAM does allow this client to subscribe to this channel and channel group configuration. This is another explicit error."))
                    }
                } else {
                    if (_callback != nil) {
                        _callback!(PNClientError.pubNubFailure("Unknown error"))
                    }
                }
            }
        }
    }
    
    func client(_ client: PubNub!, didReceiveMessage message: PNMessageResult!) {
    }
    
    public func write(channel: String, payload: Any) {
        _client?.publish(payload, toChannel: channel, withCompletion: nil)
    }
    
    public func write(channel: String, payload: Any, complete: @escaping((PNPublishStatus?)->Void)) {
        _client?.publish(payload, toChannel: channel, withCompletion: complete)
    }
}

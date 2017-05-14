//
//  PNTextToSpeech.swift
//  Ersi
//
//  Created by Yury Dymov on 5/14/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit



class PNTextToSpeech {
    public static func getSpeech(text: String, complete:((Data?, Error?)->Void)?) {
        PNClient.shared.write(channel: "Text_to_Speech_Converter", payload: ["text": text]) { (status) in
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

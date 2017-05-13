//
//  UIButton.swift
//  PNXUIKit
//
//  Created by Yury Dymov on 3/28/17.
//  Copyright © 2017 James Pham. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

var ActionBlockKey: UInt8 = 0

// a type for our action block closure
public typealias BlockButtonActionBlock = (_ sender: UIButton) -> Void

class ActionBlockWrapper {
    var block : BlockButtonActionBlock
    init(block: @escaping BlockButtonActionBlock) {
        self.block = block
    }
}

public extension UIButton {
    func block_setAction(block: @escaping BlockButtonActionBlock, for control: UIControlEvents) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(UIButton.block_handleAction), for: .touchUpInside)
    }
    
    func block_handleAction(sender: UIButton, for control:UIControlEvents) {
        
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender)
    }
}

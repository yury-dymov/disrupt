//
//  ViewController.swift
//  BikeParkingClub
//
//  Created by Yury Dymov on 5/13/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController {
    private lazy var toggleButton: UIButton = {
        let ret = UIButton()
        
        ret.setTitle("Toggle", for: .normal)
        ret.block_setAction(block: { (btn) in
            LockModel.shared.toggleLock(complete: { (err) in
                if err != nil {
                    print("Error: \(err!.localizedDescription)")
                } else {
                    print("Success")
                }
            })
        }, for: .touchUpInside)
        
        return ret
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.toggleButton)
        
        constrain(self.toggleButton) { btn in
            btn.width == 180
            btn.height == 44
            btn.centerX == btn.superview!.centerX
            btn.centerY == btn.superview!.centerY
        }
        
        self.view.backgroundColor = .red
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


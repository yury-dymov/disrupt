//
//  LockerViewController.swift
//  Ersi
//
//  Created by Alexander Sivura on 5/14/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit
import Lottie

class LockerViewController: UIViewController {
    
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet var segueTapGesture: UITapGestureRecognizer!
    @IBOutlet var lockTapGesture: UITapGestureRecognizer!
    @IBOutlet var unlockTapGesture: UITapGestureRecognizer!
    var lockAnimationView = LOTAnimationView(name: "lock_data")!
    var unlockAnimationView = LOTAnimationView(name: "unlock_data")!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.lockAnimationView);
        self.lockAnimationView.addGestureRecognizer(self.lockTapGesture)
    }

    @IBAction func didTapUnlock(_ sender: Any) {
        print("Did tap unlock")
        PNClient.shared.write(channel: "bike_parking_club_lock", payload: [
            "toggleLock": [:]
            ])
        self.unlockAnimationView.removeGestureRecognizer(self.unlockTapGesture)
        self.unlockAnimationView.play { (Bool) in
            print("animation complete")
//            self.unlockAnimationView.addGestureRecognizer(self.segueTapGesture)
            self.unlockAnimationView.removeFromSuperview()
            self.lockAnimationView = LOTAnimationView(name: "lock_data")!
            self.lockAnimationView.addGestureRecognizer(self.lockTapGesture)
            self.view.addSubview(self.lockAnimationView)
            self.bgImage.image = UIImage(named: "lock_bg");
        }
    }
    
    @IBAction func didTapLock(_ sender: Any) {
        print("Did tap lock")
        self.lockAnimationView.removeGestureRecognizer(self.lockTapGesture);
        PNClient.shared.write(channel: "bike_parking_club_lock", payload: [
            "toggleLock": [:]
            ])
        self.lockAnimationView.play(completion: { finished in
            print("animation complete")
            self.lockAnimationView.removeFromSuperview()
            self.unlockAnimationView = LOTAnimationView(name: "unlock_data")!
            self.unlockAnimationView.addGestureRecognizer(self.unlockTapGesture)
            self.view.addSubview(self.unlockAnimationView)
            self.bgImage.image = UIImage(named: "unlock_bg");
        })
    
    }

    @IBAction func didTapSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "last", sender: nil);
    }
}

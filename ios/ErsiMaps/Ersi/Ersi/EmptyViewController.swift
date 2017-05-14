//
//  EmptyViewController.swift
//  Ersi
//
//  Created by Yury Dymov on 5/13/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit
import AVFoundation
import Cartography

class EmptyViewController: UIViewController {
    private var _onDone: ((Void)->Void)?
    
    public var onDone: ((Void)->Void)? {
        get {
            return self._onDone
        }
        set {
            self._onDone = newValue
            
            if (self._done) {
                if newValue != nil {
                    newValue!()
                }
            }
        }
    }

    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector(("didTap:")))
    
    private lazy var _videoImageView: UIImageView = {
        let ret = UIImageView()
        
        ret.contentMode = .center
        ret.translatesAutoresizingMaskIntoConstraints = false
        
        return ret
    }()

    private func didTap(_ sender: Any) {
        if (self.onDone != nil) {
            self.onDone!()
        }
    }

    
    private lazy var _player: AVPlayer? = {
        guard let path = Bundle.main.path(forResource: "video-1494724997", ofType:"mp4") else {
            return nil
        }

        let ret = AVPlayer(url: URL(fileURLWithPath: path))
        
        return ret
    }()
    
    private lazy var _playerLayer: AVPlayerLayer = {
        let ret = AVPlayerLayer(player: self._player!)
        ret.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        return ret
    }()
    
    private var _done: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoFinished),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        self._videoImageView.addGestureRecognizer(self.tapGestureRecognizer);
        self.view.addSubview(self._videoImageView)
    

        self._videoImageView.layer.addSublayer(self._playerLayer)
        
        constrain(self._videoImageView) { videoImageView in
            videoImageView.edges == videoImageView.superview!.edges
        }
        

        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self._playerLayer.frame = self._videoImageView.frame
        
        self._player!.play()        
    }
    

    public func videoFinished() {
        if (self.onDone != nil) {
            self.onDone!()
        }
    }

}

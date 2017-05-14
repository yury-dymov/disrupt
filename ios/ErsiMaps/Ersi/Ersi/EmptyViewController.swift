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
    private var _currentIdx: Int = 1
    
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
    
    private lazy var _videoImageView: UIImageView = {
        let ret = UIImageView()
        
        ret.contentMode = .center
        ret.translatesAutoresizingMaskIntoConstraints = false
        
        return ret
    }()

    @objc private func didTap(_ sender: Any) {
        if (self._player!.rate > Float(0.1)) {
            return
        }
        
        self._currentIdx += 1
        
        guard let path = Bundle.main.path(forResource: "animation_step_0\(self._currentIdx)", ofType:"m4v") else {
            if (self.onDone != nil) {
                self.onDone!()
            }
            
            return
        }
        
        self._player?.replaceCurrentItem(with: AVPlayerItem(url: URL(fileURLWithPath: path)))
        self._player?.play()
    }

    
    private lazy var _player: AVPlayer? = {
        guard let path = Bundle.main.path(forResource: "animation_step_01", ofType:"m4v") else {
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

        self._videoImageView.isUserInteractionEnabled = true
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(didTap))
        self._videoImageView.addGestureRecognizer(tapGestureRecognizer);
    }
}

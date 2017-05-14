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
    private var _updating = false
    
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
        let activePlayer = self._currentIdx % 2 == 1 ? self._player! : self._nextPlayer
        let passivePlayer = self._currentIdx % 2 == 0 ? self._player! : self._nextPlayer
        
        if (_updating) {
            return
        }
        
        _updating = true
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (tm) in
            if (activePlayer.rate < Float(0.1)) {
                tm.invalidate()
                
                DispatchQueue.main.async {
                    self._currentIdx += 1
                    
                    guard let path = Bundle.main.path(forResource: "animation_step_0\(self._currentIdx)", ofType:"m4v") else {
                        if (self.onDone != nil) {
                            self.onDone!()
                        }
                        
                        return
                    }
                    
                    passivePlayer.replaceCurrentItem(with: AVPlayerItem(url: URL(fileURLWithPath: path)))
                    
                    let oldSublayer = self._videoImageView.layer.sublayers![self._videoImageView.layer.sublayers!.count - 1]
                    
                    let plaLayer = self.playerLayer(player: passivePlayer)
                    
                    plaLayer.frame = self._videoImageView.frame
                    
                    self._videoImageView.layer.addSublayer(plaLayer)
                    passivePlayer.play()
                    
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (tm) in
                        tm.invalidate()
                        self._updating = false
                        
                        DispatchQueue.main.async {
                            oldSublayer.removeFromSuperlayer()
                        }
                    }
                }
            }
        }
        
    }

    
    private lazy var _player: AVPlayer? = {
        guard let path = Bundle.main.path(forResource: "animation_step_01", ofType:"m4v") else {
            return nil
        }

        let ret = AVPlayer(url: URL(fileURLWithPath: path))
        
        return ret
    }()
    
    private lazy var _nextPlayer: AVPlayer = AVPlayer()
    
    func playerLayer(player: AVPlayer) -> AVPlayerLayer {
        let ret = AVPlayerLayer(player: player)
        
        ret.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        return ret
    }
    
    private var _done: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self._videoImageView.isUserInteractionEnabled = true
        self.view.addSubview(self._videoImageView)
    

        self._videoImageView.layer.addSublayer(playerLayer(player: self._player!))
        
        constrain(self._videoImageView) { videoImageView in
            videoImageView.edges == videoImageView.superview!.edges
        }
        

        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self._videoImageView.layer.sublayers![self._videoImageView.layer.sublayers!.count - 1].frame = self._videoImageView.frame
        
        self._player!.play()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(didTap))
        self._videoImageView.addGestureRecognizer(tapGestureRecognizer);
    }
}

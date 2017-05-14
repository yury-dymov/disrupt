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
    
    private func _proceed() {
        self._currentIdx += 1
        
        if (self._currentIdx > self._player.count) {
            if (self._onDone != nil) {
                self._onDone!()
            }
            return
        }
        
        self._videoImageView.layer.sublayers![self._videoImageView.layer.sublayers!.count - 1].removeFromSuperlayer()
        self._player[self._currentIdx - 1].play()
        
        self._updating = false
    }

    @objc private func didTap(_ sender: Any) {
        if (_updating) {
            return
        }
        
        if (self._player[self._currentIdx - 1].rate < Float(0.1)) {
            return _proceed()
        }
        
        _updating = true
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (tm) in
            if (self._player[self._currentIdx - 1].rate < Float(0.1)) {
                tm.invalidate()
                
                DispatchQueue.main.async {
                    self._proceed()
                }
            }
        }
        
    }

    
    private lazy var _player: [AVPlayer] = {
        var ret: [AVPlayer] = []
        
        for i in 1..<5 {
            let path = Bundle.main.path(forResource: "animation_step_0\(i)", ofType:"m4v")!
            
            ret.append(AVPlayer(url: URL(fileURLWithPath: path)))
        }
        
        return ret
    }()
    
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
        
        constrain(self._videoImageView) { videoImageView in
            videoImageView.edges == videoImageView.superview!.edges
        }
        

        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for i in 0..<4 {
            let subl = playerLayer(player: self._player[_player.count - i - 1])
            
            subl.frame = self._videoImageView.frame
            
            self._videoImageView.layer.addSublayer(subl)
        }
        
        self._player[0].play()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(didTap))
        self._videoImageView.addGestureRecognizer(tapGestureRecognizer);
    }
}

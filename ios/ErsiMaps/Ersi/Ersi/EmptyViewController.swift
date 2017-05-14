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
    
    private lazy var _videoImageView: UIImageView = {
        let ret = UIImageView()
        
        ret.contentMode = .center
        ret.translatesAutoresizingMaskIntoConstraints = false
        
        return ret
    }()

    
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
        
        
        self.view.addSubview(self._videoImageView)

        self._videoImageView.layer.addSublayer(self._playerLayer)
        
        constrain(self._videoImageView) { videoImageView in
            videoImageView.edges == videoImageView.superview!.edges
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

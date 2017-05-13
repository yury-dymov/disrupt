//
//  ViewController.swift
//  Ersi
//
//  Created by Alexander Sivura on 5/13/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit

import ArcGIS

class ViewController: UIViewController {
    
    public var mapType : AGSBasemapType?;

    @IBOutlet weak var mapView: AGSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.map = AGSMap(basemapType: self.mapType!, latitude: 40.7095646, longitude: -73.9870830, levelOfDetail: 17)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


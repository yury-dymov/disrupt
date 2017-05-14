//
//  MapViewController.swift
//  Ersi
//
//  Created by Alexander Sivura on 5/13/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit
import ArcGIS

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: AGSMapView!

    let initialLatitued =  40.7095646;
    let initialLongitude = -73.9870830;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.viewpointChangedHandler = { callback in
            print("Zoom \(String(describing: self.mapView.currentViewpoint(with: .centerAndScale)?.targetScale))")
        }

//        self.mapView.locationDisplay.start { [weak self] (error: Error?) -> Void in
//            if error == nil {
//                print("\(error)");
//            }
//        }


        self.mapView.map = AGSMap(basemapType: .darkGrayCanvasVector, latitude: initialLatitued, longitude: initialLongitude, levelOfDetail: 10)


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.setViewpoint(AGSViewpoint(center: AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: initialLatitued, longitude: initialLongitude)), scale: 4200.0), duration: 2.0)


    }
    



}

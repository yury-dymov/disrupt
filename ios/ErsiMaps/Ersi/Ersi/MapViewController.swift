//
//  MapViewController.swift
//  Ersi
//
//  Created by Alexander Sivura on 5/13/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit
import ArcGIS

class MapViewController: UIViewController, AGSGeoViewTouchDelegate {

    @IBOutlet weak var mapView: AGSMapView!

    var origin:AGSPoint!
    var destination:AGSPoint!


    var routeTask:AGSRouteTask!
    var routeParameters:AGSRouteParameters!
    
    var graphicsOverlay = AGSGraphicsOverlay()
    var routeGraphicsOverlay = AGSGraphicsOverlay()


    override func viewDidLoad() {
        super.viewDidLoad()
//        self.mapView.viewpointChangedHandler = { callback in
//            print("Zoom \(String(describing: self.mapView.currentViewpoint(with: .centerAndScale)?.targetScale))")
//        }

        self.origin = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(40.7095646, -73.987083))
        self.destination = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(40.7095710, -73.98627193))


        self.mapView.map = AGSMap(basemapType: .darkGrayCanvasVector, latitude: self.origin.x, longitude: self.origin.y, levelOfDetail: 10)

        self.mapView.touchDelegate = self
        
        //initialize the graphics overlay and add to the map view
        self.mapView.graphicsOverlays.add(self.graphicsOverlay)
        self.mapView.graphicsOverlays.add(self.routeGraphicsOverlay)
        
        let routeGraphic = AGSGraphic(geometry: AGSPolyline(points: [origin, destination]), symbol: self.routeSymbol(), attributes: nil)
        self.routeGraphicsOverlay.graphics.add(routeGraphic)
        


//        self.routeTask = AGSRouteTask(url: URL(string: "https://sampleserver6.arcgisonline.com/arcgis/rest/services/NetworkAnalysis/SanDiego/NAServer/Route")!)
//
//        self.getDefaultParameters()

    }

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage
    {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    private func graphicForPoint(_ point: AGSPoint) -> AGSGraphic {
        let markerImage = self.resizeImage(image: UIImage(named: "marker")!, newWidth: 90)
        let symbol = AGSPictureMarkerSymbol(image: markerImage)
//        symbol.leaderOffsetY = markerImage.size.height/2
        symbol.offsetY = markerImage.size.height/4
        let graphic = AGSGraphic(geometry: point, symbol: symbol, attributes: nil)
        return graphic
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.mapView.setViewpoint(AGSViewpoint(center: self.origin, scale: 4200.0), duration: 2.0)
        let graphic1 = self.graphicForPoint(self.origin)
        self.graphicsOverlay.graphics.add(graphic1)
        let graphic2 = self.graphicForPoint(self.destination)
        self.graphicsOverlay.graphics.add(graphic2)

    }
    
    //MARK: - AGSGeoViewTouchDelegate
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        //dismiss the callout
        self.mapView.callout.dismiss()
        
        //identify graphics at the tapped location
//        self.mapView.identify(self.graphicsOverlay, screenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, maximumResults: 1) { (result: AGSIdentifyGraphicsOverlayResult) -> Void in
//            if let error = result.error {
//                self.showAlert(error.localizedDescription)
//            }
//            else if result.graphics.count > 0 {
//                //show callout for the graphic
//                self.showCalloutForGraphic(result.graphics[0], tapLocation: mapPoint)
//            }
//        }
    }

    //MARK: - Route logic

    //method to get the default parameters for the route task
    func getDefaultParameters() {

        self.routeTask.defaultRouteParameters { [weak self] (params: AGSRouteParameters?, error: Error?) -> Void in
            if let error = error {
                print(error)
            }
            else {
                //on completion store the parameters
                self?.routeParameters = params
                self?.route()
            }
        }
    }

    func route() {
        //route only if default parameters are fetched successfully
        if self.routeParameters == nil {
            print("Default route parameters not loaded")
        }

        //set parameters to return directions
        self.routeParameters.returnDirections = true

        //clear previous routes
        self.routeGraphicsOverlay.graphics.removeAllObjects()

        //clear previous stops
        self.routeParameters.clearStops()

        //set the stops
        let stop1 = AGSStop(point: self.origin)
        stop1.name = "Origin"
        let stop2 = AGSStop(point: self.destination)
        stop2.name = "Destination"
        self.routeParameters.setStops([stop1, stop2])

        self.routeTask.solveRoute(with: self.routeParameters) { (routeResult: AGSRouteResult?, error: Error?) -> Void in
            if let error = error {
                print(error)
            }
            else {
                //show the resulting route on the map
                //also save a reference to the route object
                //in order to access directions
//                self.generatedRoute = routeResult!.routes[0]
                let routeGraphic = AGSGraphic(geometry: routeResult!.routes[0].routeGeometry, symbol: self.routeSymbol(), attributes: nil)
                self.routeGraphicsOverlay.graphics.add(routeGraphic)
            }
        }
    }

    //method provides a line symbol for the route graphic
    func routeSymbol() -> AGSSimpleLineSymbol {
        let symbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.yellow, width: 5)
        return symbol
    }
    



}

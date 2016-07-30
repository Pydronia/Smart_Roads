//
//  ViewController.swift
//  Smart Roads V2
//
//  Created by Jack Carey on 29/07/2016.
//  Copyright © 2016 Smart Roads. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let petrolDataLocation = NSBundle.mainBundle().pathForResource("petrol", ofType: "json")
        let petrolData = NSData(contentsOfFile: petrolDataLocation!)
        
        do {
            
            //let json = try NSJSONSerialization.JSONObjectWithData(petrolData!, options: []) as! [String: AnyObject]
            //print((json["features"]! as! [AnyObject]))
            
        } catch (let error) {
            print(error)
        }
        
        loadMap()
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.mapView //(self.view as! GMSMapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadMap() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6.0)
        //let mapView = GMSMapView.mapWithFrame(self.mapView.frame, camera: camera)
        //mapView.myLocationEnabled = true
        
        //self.view = mapView
        //print(self.mapView.frame)
        
        self.mapView.camera = camera
        
    }
 
    

}


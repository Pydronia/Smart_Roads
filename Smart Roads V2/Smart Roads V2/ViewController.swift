//
//  ViewController.swift
//  Smart Roads V2
//
//  Created by Jack Carey on 29/07/2016.
//  Copyright © 2016 Smart Roads. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var stations:[GMSMarker] = []
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let petrolDataLocation = NSBundle.mainBundle().pathForResource("petrol", ofType: "json")
        let petrolData = NSData(contentsOfFile: petrolDataLocation!)
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(petrolData!, options: []) as! [String: AnyObject]
            
            if let features  = json["features"] as? [[String: AnyObject]]{
                for i in features{
                    
                    let marker = GMSMarker()
                    //print(String(i["properties"]!["Name"]!!))
                    //long
//                  print(i["geometry"]!["coordinates"]!![0])
//                  //lat
//                  print(i["geometry"]!["coordinates"]!![1])
                    let lat = (i["geometry"]!["coordinates"]!![1]) as! Double
                    let lon = (i["geometry"]!["coordinates"]!![0]) as! Double
                    let name = String(i["properties"]!["Name"]!!)
                    
                    marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    marker.title = name
                    
                    stations.append(marker)
                    
                }
                
            }
            
            
//            print(json["features"]!["geometry"]!["coordinates"]!1!)
            
        } catch (let error) {
            print(error)
        }
        
        
        for i in stations{
            var marker = GMSMarker()
            marker = i
            marker.map = self.mapView
        }
        
        
        
        
        
        loadMap()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        /*
        //self.mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        marker2.title = "Sydney"
        marker2.snippet = "Australia"
        marker2.map = self.mapView //(self.view as! GMSMapView)
        */
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMap() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6.0)
        
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func snapLocation(sender: UIButton) {
        
        self.mapView.camera = GMSCameraPosition.cameraWithTarget((locationManager.location?.coordinate)!, zoom: 16.0)
        
    }
    
    

}


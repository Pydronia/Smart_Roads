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
    
    @IBOutlet weak var petrolNAme: UILabel!
    @IBOutlet weak var petrolDist: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var scanningField: UITextField!
    @IBOutlet weak var petrolButton: UIButton!
    @IBOutlet weak var busButton: UIButton!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var locationSnap: UIButton!
    
    var small: Double = 25000
    var closestStation = GMSMarker()
    var willSnap: Bool = false
    var petStations:[GMSMarker] = []
    var closePetStations:[GMSMarker] = []
    var busStations:[GMSMarker] = []
    var closeBusStations:[GMSMarker] = []
    let locationManager = CLLocationManager()
    
    var currentView: Int = 0
    //0: Petrol
    //1: Busstops
    
    var scanningRad: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let petrolDataLocation = NSBundle.mainBundle().pathForResource("petrol", ofType: "json")
        let canberraBusLocation = NSBundle.mainBundle().pathForResource("busstops", ofType: "json")
        //let melbourneBusLocation = NSBundle.mainBundle().pathForResource("melbourne_bus", ofType: "json")
        let petrolData = NSData(contentsOfFile: petrolDataLocation!)
        let canberraBus = NSData(contentsOfFile: canberraBusLocation!)
        //let melboureBus = NSData(contentsOfFile: melbourneBusLocation!)
        
        petrolButton.selected = true
        
        //loading dat petrol data
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
                    marker.appearAnimation = kGMSMarkerAnimationPop
                    marker.icon = UIImage(named: "petrol-2400px")
                    
                    petStations.append(marker)
                    
                }
                
            }
            
            
//            print(json["features"]!["geometry"]!["coordinates"]!1!)
            
        } catch (let error) {
            print(error)
        }
        
        
        
        //loading dat bus data
        do {
            let jsonBus = try NSJSONSerialization.JSONObjectWithData(canberraBus!, options: []) as! [String: AnyObject]
            if let busFeatures = jsonBus["stop"] as? [[String: AnyObject]]{
                for i in busFeatures{
                    let marker = GMSMarker()
                    
                    marker.title = i["stop_name"] as? String
                    
                    let latAndLong = i["stop_loc"] as! String
                    let lat = latAndLong.componentsSeparatedByString(", ")[0]
                    let long = latAndLong.componentsSeparatedByString(", ")[1]
                    let realLat = lat.stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "")
                    let realLong = long.stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "")
                    
                    let position = CLLocationCoordinate2D(latitude: Double(realLat)!, longitude: Double(realLong)!)
                    marker.position = position
                    marker.appearAnimation = kGMSMarkerAnimationPop
                    marker.icon = UIImage(named: "empty bus")
                    
                    busStations.append(marker)
                    
                }
            }
            
            
        } catch (let error) {
            print(error)
        }
        
        /*
        do {
            let jsonBus = try NSJSONSerialization.JSONObjectWithData(melboureBus!, options: []) as! [String: AnyObject]
            if let busFeatures = jsonBus["features"] as? [[String: AnyObject]]{
                for i in busFeatures{
                    
                    
                    let marker = GMSMarker()
                    
                    marker.title = "Bus Stop"
                    
                    
                    let lat = i["geometry"]!["coordinates"]!![0]!
                    let lon = i["geometry"]!["coordinates"]!![1]!
                    
                    let position = CLLocationCoordinate2D(latitude: Double(lat as! NSNumber), longitude: Double(lon as! NSNumber))
                    marker.position = position
                    marker.appearAnimation = kGMSMarkerAnimationPop
                    marker.icon = UIImage(named: "empty bus")
                    
                    busStations.append(marker)
                    
                }
            }
            
            
        } catch (let error) {
            print(error)
        }
        
        */
        
        
        
        
        
        loadMap()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
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
        
        willSnap = !willSnap
        sender.selected = !sender.selected
        
    }
    
    
    @IBAction func goToStation(sender: UIButton) {
        willSnap = false
        locationSnap.selected = false
        self.mapView.camera = GMSCameraPosition.cameraWithTarget(closestStation.position, zoom: 16.0)
    }
    
    @IBAction func changeRad(sender: UIButton) {
        scanningRad = Double(scanningField.text!)!*1000
    }
    
    
    
    
    @IBAction func petrolStation(sender: UIButton) {
        if currentView != 0{
            currentView = 0
            petrolButton.selected = true
            self.mapView.clear()
            willSnap = false
            locationSnap.selected = false
            busButton.selected = false
            closePetStations = []
        }
    }
    
    @IBAction func busStops(sender: UIButton) {
        if currentView != 1{
            currentView = 1
            busButton.selected = true
            self.mapView.clear()
            willSnap = false
            locationSnap.selected = false
            petrolButton.selected = false
            closeBusStations = []
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(willSnap){
            let latestLocation = locations.last!
            self.mapView.camera = GMSCameraPosition.cameraWithTarget((latestLocation.coordinate), zoom: 16.0)
        }
        
        //PETROL
        if(currentView == 0){
            
            indicatorLabel.text = "Nearest petrol station:"
            //display dem stations within range
            for i in petStations{
                if locationManager.location!.distanceFromLocation(CLLocation(latitude: i.position.latitude, longitude: i.position.longitude)) < scanningRad &&  !closePetStations.contains(i){
                    closePetStations.append(i)
                    var marker = GMSMarker()
                    marker = i
                    marker.map = self.mapView
                    
                }
            }
        
            //if there are nearby stations
            if closePetStations != []{
                //get closest station
            
                for i in closePetStations{
                    let distance = locationManager.location!.distanceFromLocation(CLLocation(latitude: i.position.latitude, longitude: i.position.longitude))
                    
                    if distance < small{
                        closestStation = i
                        small = distance
                    }
                }
            
            
            //writing
                if Int(small) < 1000{
                    petrolDist.text = String(Int(small)) + "m"
                } else {
                    petrolDist.text = String(Float(Int(small)/100)) + "km"
                }
            
                petrolNAme.text = closestStation.title
            
            } else if scanningRad != 0{
                petrolNAme.text = "No stations in radius"
                petrolDist.text = "N/A"
            } else {
                petrolNAme.text = "Please enter radius..."
                petrolDist.text = "N/A"
            }
        
            
            
        //BUS STATIONS
        } else if (currentView == 1){
            indicatorLabel.text = "Nearest bus stop:"
            
            for i in busStations{
                if locationManager.location!.distanceFromLocation(CLLocation(latitude: i.position.latitude, longitude: i.position.longitude)) < scanningRad &&  !closeBusStations.contains(i){
                    closeBusStations.append(i)
                    var marker = GMSMarker()
                    marker = i
                    marker.map = self.mapView
                }
            }
            
            
            //if there are nearby stations
            if closeBusStations != []{
                //get closest station
                
                for i in closeBusStations{
                    let distance = locationManager.location!.distanceFromLocation(CLLocation(latitude: i.position.latitude, longitude: i.position.longitude))
                    
                    if distance < small{
                        closestStation = i
                        small = distance
                    }
                }
                
                
                //writing
                if Int(small) < 1000{
                    petrolDist.text = String(Int(small)) + "m"
                } else {
                    petrolDist.text = String(Float(Int(small)/100)) + "km"
                }
                
                petrolNAme.text = closestStation.title
                
            } else if scanningRad != 0{
                petrolNAme.text = "No stops in radius"
                petrolDist.text = "N/A"
            } else {
                petrolNAme.text = "Please enter radius..."
                petrolDist.text = "N/A"
            }

            
        }
        

        
    }
        
}


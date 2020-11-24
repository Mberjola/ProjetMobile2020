//
//  ViewController.swift
//  testUserLocation
//
//  Created by Matthias Berjola on 09/11/2020.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indexchanged: UISegmentedControl!
    fileprivate var locationManager:CLLocationManager = CLLocationManager()
    

    @IBAction func indexChanged(_ sender: Any) {
        switch indexchanged.selectedSegmentIndex{
        case 0:
            searchInMap()
            
        case 1:
            mapView.removeAnnotations(mapView.annotations)
            
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        
        if (CLLocationManager.locationServicesEnabled()) {
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters:2500, longitudinalMeters: 2500)
                mapView.setRegion(viewRegion, animated: false)
            }

            

            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        
        mapView.showsUserLocation = true
        
        
        
        
        
        
        
    }
    
    
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            if let title = title {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = title
                
                
                mapView.addAnnotation(annotation)
                
                
                
            }
        }
        
    
    func searchInMap() {
        // 1
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        
        request.region = mapView.region;
        // 3
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
                
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })

}
    
    func searchInMapRandom(){
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        
        request.region = mapView.region;
        // 3
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
                
            let randNb = Int.random(in: 1...response!.mapItems.count)
            self.addPinToMapView(title: response!.mapItems[randNb].name, latitude: response!.mapItems[randNb].placemark.location!.coordinate.latitude, longitude: response!.mapItems[randNb].placemark.location!.coordinate.longitude)
        })
        
        
        
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            mapView.removeAnnotations(mapView.annotations);
            searchInMapRandom();
            
            
            
        }
    }

}

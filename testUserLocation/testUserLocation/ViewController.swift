//
//  ViewController.swift
//  testUserLocation
//
//  Created by Matthias Berjola on 09/11/2020.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {
    //on lit la carte au controlleur
    @IBOutlet weak var mapView: MKMapView!
    //on lit le bouton feedme au controlleur
    @IBOutlet weak var Feedme: UIButton!
    //on lit le bouton d'exit de la map au controlleur
    @IBOutlet weak var MapExit: UIButton!
    //On charge ici le manager de localisation, il va permettre notamment de placer des points sur la carte etc..
    fileprivate var locationManager:CLLocationManager = CLLocationManager()
    
    
    //Lorsque l'on appuie sur le bouton feedMe on effectue une recherche des restaurants à proximité.
    @IBAction func FeedMepressed(_ sender: UIButton) {
        searchInMap()
    }
    
    
    @IBAction func ExitMap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //On charge les différents paramètre du locationManager
        //On demande l'autorisation de l'user à utiliser sa position
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        //paramètre pour gérer la précision avec laquelle l'user est localisé
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        //Si la localisation est activée sur le téléphone on demande soit d'autoriser tout le temps, soit quand l'app est active.
        if (CLLocationManager.locationServicesEnabled()) {
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }
        
        //On détecte la position de l'utilisateur
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters:2500, longitudinalMeters: 2500)
                mapView.setRegion(viewRegion, animated: false)
            }

            
            //On met à jour la postion sur la carte avec la position de l'utilisateur
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        //On affiche la localisation de l'utilisateur
        mapView.showsUserLocation = true
        
        
        
    }
    
    
    //Fonction qui sert à afficher les pins sur la carte
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            if let title = title {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = title
                
                
                mapView.addAnnotation(annotation)
                
                
                
            }
        }
        
    //fonction qui cherche des éléments sur la carte
    func searchInMap() {
        // 1 on effectue une recherche des restaurants en langage naturel
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        //2 on définit la région sur laquelle on veux effectuer la région.
        request.region = mapView.region;
        // 3 on parcours le résultats et pour chaque item on place un pin
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
                
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })

}
    //Même chose que SearchInMap sauf qu'on place un pin choisit aléatoirement parmis ceux de la réponse à la requête
    func searchInMapRandom(){
        //1
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        //2
        request.region = mapView.region;
        // 3
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
                // on définit un nombre aléatoire choisit entre 1 et le nombre d'éléments de la réponse.
            let randNb = Int.random(in: 1...response!.mapItems.count)
            //On ajoute un pin correspondant à l'item selectionné
            self.addPinToMapView(title: response!.mapItems[randNb].name, latitude: response!.mapItems[randNb].placemark.location!.coordinate.latitude, longitude: response!.mapItems[randNb].placemark.location!.coordinate.longitude)
        })
        
        
        
        
    }
    
    //Fonction qui sert à détecter les secousses du téléphone.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            //si le téléphone est secoué. On enlève les annotations et on affiche un pin au hasard.
            mapView.removeAnnotations(mapView.annotations);
            searchInMapRandom();
            
            
            
            
        }
    }

}

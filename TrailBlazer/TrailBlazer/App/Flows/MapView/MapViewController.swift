//
//  MapViewController.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 17.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startConfigure()
        configureLocationManager()
    }

    func startConfigure(){
        let camera = GMSCameraPosition.camera(withTarget: startLocation, zoom: 10)
        mapView.camera = camera
    }
    
    func configureLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    @IBAction func currentLocatinButton(_ sender: UIBarButtonItem) {
        locationManager?.requestLocation()
    }
    
    @IBAction func beginTrackingButton(_ sender: UIBarButtonItem) {
        locationManager?.startUpdatingLocation()
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            let marker = GMSMarker(position: location.coordinate)
            marker.map = mapView
            print(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}

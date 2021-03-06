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
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = LocationManager.instance
    var route: GMSPolyline?{
        didSet{
            route?.strokeWidth = 5
            route?.strokeColor = .systemGreen
        }
    }
    var routePath: GMSMutablePath?
    var previousPath: GMSMutablePath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let realm = try Realm()
            let path = realm.objects(TrackHistory.self)
            if !path.isEmpty, let encodePath = path[0].encodedPath {
                previousPath = GMSMutablePath(fromEncodedPath: encodePath)
            }
        } catch {
            print(error)
        }

        startConfigure()
        configureLocationManager()
    }
    
    func startConfigure(){
        let camera = GMSCameraPosition.camera(withTarget: startLocation, zoom: 10)
        mapView.camera = camera
    }
    
    func configureLocationManager(){
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
        }
    }
    
    @IBAction func beginTrackingButton(_ sender: UIBarButtonItem) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func endTrackingButton(_ sender: UIBarButtonItem) {
        locationManager.stopUpdatingLocation()
        route?.map = nil
        routePath = nil
        do {
            let realm = try Realm()
            let path = realm.objects(TrackHistory.self)
            realm.beginWrite()
            if path.isEmpty {
                let firstPath = TrackHistory()
                firstPath.encodedPath = self.routePath?.encodedPath()
                realm.add(firstPath)
            } else {
                path[0].encodedPath = self.routePath?.encodedPath()
            }
            previousPath = self.routePath
            try realm.commitWrite()
        } catch {
            print(error)
        }
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func trackHistoryButton(_ sender: UIBarButtonItem) {
        route?.map = mapView
        routePath = previousPath
        route?.path = routePath
        if let previousPath = previousPath {
            let bounds = GMSCoordinateBounds(path: previousPath)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
            mapView.moveCamera(update)
        }
    }
    
}

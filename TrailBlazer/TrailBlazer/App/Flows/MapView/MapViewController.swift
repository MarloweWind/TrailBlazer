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
    var marker: GMSMarker?
    var passedImage: UIImage? = nil
    
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
                if self?.marker != nil {
                    self?.marker!.map = nil
                }
                self?.marker = GMSMarker(position: location.coordinate)
                if let image = self?.passedImage {
                    self?.marker!.icon =  self?.setMarkerAvatar(pickedImage: image, image: GMSMarker.markerImage(with: .red))
                }
                self?.marker!.map = self?.mapView
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
        marker?.map = nil
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
    
    func setMarkerAvatar(pickedImage: UIImage, image: UIImage) -> UIImage {
        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pickedImage)
        picImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageMarker(view: imgView)
        return newImage
    }
    
    func imageMarker(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
}

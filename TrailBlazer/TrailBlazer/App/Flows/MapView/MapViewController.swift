//
//  MapViewController.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 17.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var findMyLocationBrButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startConfigure()
    }

    func startConfigure(){
        let camera = GMSCameraPosition.camera(withTarget: startLocation, zoom: 10)
        mapView.camera = camera
    }
    
}

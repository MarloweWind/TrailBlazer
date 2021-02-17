//
//  MapViewControllerExt.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 17.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import Foundation
import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print(locations.first)
        }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

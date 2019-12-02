//
//  ViewController+Location.swift
//  HLWeather
//
//  Created by harry on 1/12/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit
import CoreLocation

extension ViewController {
    
    func startGetLocation() {
        if self.cm == nil {
            self.cm = CLLocationManager()
        }
        self.cm?.delegate = self
        self.cm?.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        } else {
            NSLog("fail getting location \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("fail getting location \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.last {
            ForecastLoader.shared.searchForLocation(l.coordinate, completionHandler: searchComplete)
            self.cm = nil
        }
    }

}

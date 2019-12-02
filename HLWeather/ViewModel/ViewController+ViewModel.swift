//
//  ViewController.swift
//  HLWeather
//
//  Created by harry on 30/11/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

private let MAP_SPAN = 0.08
private let KELV_TO_CEL = (-273.15)

extension ViewController {
    
    func postInitSetup() {
        if let sf = StationForecast.mostRecent() {
            self.busyView.isHidden = true
            self.updateForecast(sf)
        } else {
            // run for first time
            ForecastLoader.shared.searchForCity("Sydney,AU", completionHandler: searchComplete)
        }
    }
        
    func updateForecast(_ sf: StationForecast) {
        // hide busy view
        self.searchBar.isHidden = true
        self.busyView.isHidden = true
        // prepare forecast info
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.desc.text = sf.description
        self.temp.text = String(format:"%.1f°", sf.temp + KELV_TO_CEL)
        self.minmax.text = String(format:"Low:\t%.1f°\nHigh:\t%.1f°", (sf.min + KELV_TO_CEL), (sf.max + KELV_TO_CEL))
        self.time.text = "Last updated: \(dateFormatter.string(from: sf.updated))"
        self.navBar.topItem?.title = "\(sf.station.name) - \(sf.station.country)"
        // optional information
        var more = ""
        if let wspd = sf.wspd,
            let wdeg = sf.wdgr {
            more = more + "Wind speed: \(wspd) M/S\nWind direction: \(wdeg)°\n"
        }
        if let hum = sf.humidity {
            more = more + "Humidity: \(hum)%\n"
        }
        if let prs = sf.pressure {
            more = more + "Pressure: \(prs) hPa"
        }
        self.other.text = more
        if let ico = sf.icon {
            self.icon.image = UIImage(named: ico)
        }
        // handling map
        let cc = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(sf.station.lat), longitude: CLLocationDegrees(sf.station.lon)), span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(MAP_SPAN), longitudeDelta: CLLocationDegrees(MAP_SPAN)))
        self.map.setRegion(cc, animated: true)
        self.map.isUserInteractionEnabled = false
    }
    
    func searchComplete(data: Data?, error: Error?) {
        let searchText = searchBar.text ?? ""
        var message = "Unable to get forecast result for \(searchText)"
        if error != nil {
            NSLog("Search for city error \(error.debugDescription)")
            self.showAlert(error?.localizedDescription ?? message)
        } else {
            if let d = data,
                let json = try? JSON(data: d),
                let sf = StationForecast(from: json) {
                sf.save()
                self.updateForecast(sf)
                RecentSearch.shared.addEntry("\(sf.station.name),\(sf.station.country)")
            } else {
                if let d = data,
                    let json = try? JSON(data: d),
                    let msg = json["message"].string {
                    message = msg
                }
                self.showAlert(message)
            }
        }
        self.busyView.isHidden = true
    }
}

//
//  StationForcast.swift
//  HLWeather
//
//  Created by harry on 30/11/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import Foundation
import SwiftyJSON

private let KEY_RECENT = "MostRecent"

struct Station: Codable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}

struct StationForecast: Codable {
    let station: Station
    let description: String
    let temp: Double
    let min: Double
    let max: Double
    let updated: Date
    let icon: String?
    let wspd: Double?
    let wdgr: Double?
    let humidity: Int?
    let pressure: Int?

    init?(from json: JSON) {
        if let lat = json["coord"]["lat"].double,
            let lon = json["coord"]["lon"].double,
            let desc = json["weather"][0]["description"].string,
            let temp = json["main"]["temp"].double,
            let min = json["main"]["temp_min"].double,
            let max = json["main"]["temp_max"].double,
            let upd = json["dt"].int,
            let name = json["name"].string,
            let country = json["sys"]["country"].string {
            
            self.station = Station(name: name, country: country, lat: lat, lon: lon)
            self.description = desc
            self.temp = temp
            self.min = min
            self.max = max
            self.updated = Date(timeIntervalSince1970: TimeInterval(upd))
            
            self.icon = json["weather"][0]["icon"].string
            self.wspd = json["wind"]["speed"].double
            self.wdgr = json["wind"]["deg"].double
            self.humidity = json["main"]["humidity"].int
            self.pressure = json["main"]["pressure"].int
        } else {
            return nil
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let enc_sf = try? encoder.encode(self) {
            UserDefaults.standard.set(enc_sf, forKey: KEY_RECENT)
        } else {
            NSLog("Error encoding forecast \(self)")
        }
    }
    
    static func mostRecent() -> StationForecast? {
        if let sf_data = UserDefaults.standard.object(forKey: KEY_RECENT) as? Data {
            let decoder = JSONDecoder()
            if let sf = try? decoder.decode(StationForecast.self, from: sf_data) {
                return sf
            } else {
                NSLog("Error decoding forecast \(sf_data)")
            }
        }
        return nil
    }
}

//
//  APILoader.swift
//  HLWeather
//
//  Created by harry on 30/11/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class ForecastLoader {
    
    static let shared = ForecastLoader()
    
    private init() {
    }
    
    private func searchForParam(_ input: Parameters, completionHandler: @escaping (Data?, Error?) -> Void) {
        request("https://api.openweathermap.org/data/2.5/weather", parameters: input,
                encoding: URLEncoding(destination: .queryString)).responseData { response in
                    switch response.result {
                        case .success:
                            completionHandler(response.result.value, nil)
                        case let .failure(error):
                            completionHandler(nil, error)
                    }
        }
    }
    
    func searchForLocation(_ input: CLLocationCoordinate2D, completionHandler: @escaping (Data?, Error?) -> Void) {
        let parameters: Parameters = [
            "lat": input.latitude,
            "lon": input.longitude,
            "APPID": WEATHER_API_KEY
        ]
        self.searchForParam(parameters, completionHandler: completionHandler)
    }
    
    func searchForCity(_ input: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let parameters: Parameters = [
            "q": input,
            "APPID": WEATHER_API_KEY
        ]
        self.searchForParam(parameters, completionHandler: completionHandler)
    }
}

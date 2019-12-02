//
//  HLWeatherTests.swift
//  HLWeatherTests
//
//  Created by harry on 30/11/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import HLWeather

class HLWeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecentSearch() {
        let rs = RecentSearch.shared
        // test remove all to init
        rs.removeAll()
        XCTAssertEqual(0, rs.getList().count)
        // test add entry
        rs.addEntry("Brisbane,AU")
        XCTAssertEqual(1, rs.getList().count)
        XCTAssertEqual(["Brisbane,AU"], rs.getList())
        XCTAssertNotEqual(["Brisbane"], rs.getList())
        XCTAssertNotEqual(["Brisbane", "Sydney"], rs.getList())
        // test add duplicated entry
        rs.addEntry("Brisbane,AU")
        XCTAssertEqual(1, rs.getList().count)
        // test more than 1 entries
        RecentSearch.shared.addEntry("New York,US")
        XCTAssertEqual(["New York,US","Brisbane,AU"], rs.getList())
        // test empty entry
        RecentSearch.shared.addEntry("")
        XCTAssertEqual(["New York,US","Brisbane,AU"], rs.getList())
        // test list overflow
        rs.removeAll()
        XCTAssertEqual(0, rs.getList().count)
        rs.addEntry("1")
        rs.addEntry("2")
        rs.addEntry("3")
        rs.addEntry("4")
        rs.addEntry("5")
        XCTAssertEqual(5, rs.getList().count)
        rs.addEntry("6")
        rs.addEntry("7")
        rs.addEntry("8")
        rs.addEntry("9")
        rs.addEntry("10")
        XCTAssertEqual(10, rs.getList().count)
        rs.addEntry("11")
        XCTAssertEqual(10, rs.getList().count)
        XCTAssertEqual(["11","10","9","8","7","6","5","4","3","2"], rs.getList())
        // end test, restore empty
        rs.removeAll()
    }

    func testStationForecast() {
        // test good JSON input
        let sf = StationForecast.init(from: JSON(parseJSON: testJSON))
        XCTAssertNotNil(sf)
        XCTAssertEqual("AU", sf?.station.country)
        XCTAssertEqual("Sydney", sf?.station.name)
        XCTAssertEqual(32, sf?.humidity)
        XCTAssertEqual(8.6999999999999993, sf?.wspd)
        // test bad
        let sf1 = StationForecast.init(from: JSON(parseJSON: testJSON_F1))
        XCTAssertNil(sf1)
        // test minimum good example
        let sf2 = StationForecast.init(from: JSON(parseJSON: testJSON_S2))
        XCTAssertNotNil(sf2)
        XCTAssertNil(sf2?.icon)
        XCTAssertNil(sf2?.wspd)
        XCTAssertNil(sf2?.wdgr)
        XCTAssertNil(sf2?.humidity)
        XCTAssertNil(sf2?.pressure)
        // test save and load
        sf2?.save()
        let mr = StationForecast.mostRecent()
        XCTAssertNotNil(mr)
        XCTAssertEqual(mr?.temp, 292.83999999999997)
        // test load recent without presaved value
        let KEY_RECENT = "MostRecent"
        UserDefaults.standard.removeObject(forKey: KEY_RECENT)
        XCTAssertNil(StationForecast.mostRecent())
    }
    
    func testForecastLoader() {
        let fl = ForecastLoader.shared
        let apiCallExpectation = XCTestExpectation(description: "forecast API call finishes")
        fl.searchForCity("Bangkok", completionHandler: { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            apiCallExpectation.fulfill()
        })
        sleep(1)
        // test empty query
        let apiCallExpectation2 = XCTestExpectation(description: "forecast API call finishes")
        fl.searchForCity("", completionHandler: { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            if let d = data,
                let json = try? JSON(data: d) {
                XCTAssertEqual("400", json["cod"].string)
            } else {
                XCTFail("can't get error code")
            }
            apiCallExpectation2.fulfill()
        })
        sleep(1)
        // test 404
        let apiCallExpectation3 = XCTestExpectation(description: "forecast API call finishes")
        fl.searchForCity("abracadabra", completionHandler: { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            if let d = data,
                let json = try? JSON(data: d) {
                XCTAssertEqual("404", json["cod"].string)
            } else {
                XCTFail("can't get error code")
            }
            apiCallExpectation3.fulfill()
        })
        wait(for: [apiCallExpectation, apiCallExpectation2, apiCallExpectation3], timeout: 10)
    }

    let testJSON_F1 = "{}"
    let testJSON_S2 = """
{
  "main" : {
    "temp_max" : 294.25999999999999,
    "temp_min" : 291.48000000000002,
    "temp" : 292.83999999999997
  },
  "dt" : 1575242810,
  "cod" : 200,
  "name" : "Sydney",
  "weather" : [
    {
      "description" : "broken clouds"
    }
  ],
  "sys" : {
    "country" : "AU",
  },
  "coord" : {
    "lat" : -33.850000000000001,
    "lon" : 151.22
  }
}
"""
    let testJSON = """
{
  "clouds" : {
    "all" : 78
  },
  "main" : {
    "pressure" : 994,
    "temp_max" : 294.25999999999999,
    "temp_min" : 291.48000000000002,
    "humidity" : 32,
    "temp" : 292.83999999999997
  },
  "dt" : 1575242810,
  "cod" : 200,
  "id" : 2147714,
  "name" : "Sydney",
  "timezone" : 39600,
  "wind" : {
    "deg" : 290,
    "speed" : 8.6999999999999993
  },
  "visibility" : 10000,
  "base" : "stations",
  "weather" : [
    {
      "main" : "Clouds",
      "icon" : "04d",
      "id" : 803,
      "description" : "broken clouds"
    }
  ],
  "sys" : {
    "sunrise" : 1575225453,
    "country" : "AU",
    "type" : 1,
    "id" : 9600,
    "sunset" : 1575276678
  },
  "coord" : {
    "lat" : -33.850000000000001,
    "lon" : 151.22
  }
}
"""
}

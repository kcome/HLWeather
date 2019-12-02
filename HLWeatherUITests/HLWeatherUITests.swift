//
//  HLWeatherUITests.swift
//  HLWeatherUITests
//
//  Created by harry on 30/11/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import XCTest

class HLWeatherUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.buttons["🔍 Search"].tap()
        sleep(2)
        app.searchFields.element.tap()
        // search button is hidden by search bar
        XCTAssertEqual(app.buttons["🔍 Search"].isHittable, false)
        app.searchFields.element.typeText("\n")
        sleep(2)
        // search button is unhidden by closing search bar
        XCTAssertEqual(app.buttons["🔍 Search"].isHittable, true)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

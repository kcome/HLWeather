//
//  ViewController.swift
//  HLWeather
//
//  Created by harry on 30/11/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var other: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var minmax: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var buttonGPS: UIButton!
    @IBOutlet weak var buttonRecent: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var busyView: UIView!
    
    var cm: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeButton(self.buttonGPS)
        self.customizeButton(self.buttonSearch)
        self.customizeButton(self.buttonRecent)
        self.postInitSetup()
    }

    @IBAction private func searchButtonTapped(_ sender: UIButton) {
        self.searchBar.isHidden = false
        if let st = self.searchBar.text {
            if st.count > 0 {
                self.searchBar.delegate = nil
                self.searchBar.text = ""
                self.searchBar.delegate = self
            }
        }
        self.searchBar.becomeFirstResponder()
    }
    @IBAction private func recentButtonTapped(_ sender: UIButton) {
        let rr = RecentResultViewController()
        self.present(rr, animated: true)
    }
    
    @IBAction private func locButtonTapped(_ sender: UIButton) {
        self.startGetLocation()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // this will cause searchBarTextDidEndEditing() invoked
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {
            return
        }
        self.startSearch(searchText)
    }
    
    func startSearch(_ searchText: String) {
        if searchText.count <= 0 {
            self.searchBar.isHidden = true
            return
        }
        self.busyView.isHidden = false
        ForecastLoader.shared.searchForCity(searchText, completionHandler: searchComplete)
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    func customizeButton(_ b: UIButton) {
        b.layer.borderWidth = 0.8
        b.layer.cornerRadius = 6.0
        b.layer.borderColor = b.tintColor.cgColor
    }
}

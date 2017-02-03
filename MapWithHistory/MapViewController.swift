//
//  ViewController.swift
//  MapWithHistory
//
//  Created by Andrey Apet on 01.02.17.
//  Copyright © 2017 i.Apet. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    let openWeatherMapAPIKey = "301b469f9191937e7721032026c7356d"
    let requestUrl = "http://api.openweathermap.org/data/2.5/weather?"
    
    var requests = ObjectRequest()
    
    let locationManager = CLLocationManager()
    var addressString = ""
    var temperatureForUser = 0
    var forecastForUser = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(coordinate) { (respone, Error) in
            if let address = respone?.firstResult() {
                let lines = address.lines as [String]!
                self.addressString = (lines?.joined(separator: "\n\t"))!
                UIView.animate(withDuration: 0.25, animations: { self.view.layoutIfNeeded() })
            }
        }
    }
    
    func getWeatherForecast(latitude: Double, longitude: Double) {
        let weatherRequestURL = NSURL(string: "\(self.requestUrl)lat=\(latitude)&lon=\(longitude)&appid=\(self.openWeatherMapAPIKey)")
        let data = NSData(contentsOf: weatherRequestURL as! URL)
        let json = JSON(data: data as! Data)
        
        guard let temp = json["main"]["temp"].int else {return}
        guard let forecast = json["weather"][0]["description"].string else {return}
        
        self.temperatureForUser = temp - 273//kelvin in celsius
        self.forecastForUser = forecast
    }
    
    func queryRequsets() {
        let realm = try! Realm()
        let allReauests = realm.objects(ObjectRequest.self)
        for req in allReauests {
            print("\(req.coordinateLatitudeForUser) and \(req.dateOfRequest)")
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.locationManager.stopUpdatingLocation()
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.reverseGeocodeCoordinate(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.getWeatherForecast(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.clear()
        
        let tapRequest = ObjectRequest()
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = self.addressString
        marker.snippet = "\(coordinate.latitude), \(coordinate.longitude) \nTemperature: \(tapRequest.temperatureForUser) \nForecast: \(tapRequest.forecastForUser)"
        marker.map = self.mapView
        
        tapRequest.addressString = self.addressString
        tapRequest.coordinateLatitudeForUser = coordinate.latitude 
        tapRequest.coordinateLongitudeForUser = coordinate.longitude
        tapRequest.temperatureForUser = self.temperatureForUser
        tapRequest.forecastForUser = self.forecastForUser
        tapRequest.dateOfRequest = Date()
        self.requests = tapRequest
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(tapRequest)
            print("Added \(tapRequest.addressString)")
        }
    }
}

//
//  ViewController.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/4/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class CarsViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var weather: Weather?
    var cars: [Car] = []
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getWeatherData() {
        do {
            let weather: [Weather] = try context.fetch(Weather.fetchRequest())
            
            if weather.count > 0 {
                self.weather = weather.last
            }
        } catch {
            print("ERROR: fetching failed")
        }
    }
    
    private func getCarsData() {
        do {
            self.cars = try context.fetch(Car.fetchRequest())
        } catch {
            print("ERROR: fetching failed")
        }
    }
}


extension CarsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let weatherAPI = WeatherAPI()
            weatherAPI.getWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) {
                print("done")
            }
            
            locationManager.stopUpdatingLocation()
        }
    }
}

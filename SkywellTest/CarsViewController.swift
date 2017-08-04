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
import SDWebImage

class CarsViewController: UIViewController {
    let weatherIconCache = SDImageCache(namespace: "weather")
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var weatherTemperatureLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherCityLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var context: NSManagedObjectContext {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    var weather: Weather?
    var cars: [Car] = []
    
    lazy var locationManager: CLLocationManager? = {
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
            locationManager?.requestWhenInUseAuthorization()
        } else {
            locationManager?.startUpdatingLocation()
        }
        
        setupWeatherUI()
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
    
    internal func setupWeatherUI() {
        getWeatherData()
        
        self.weatherCityLabel.text = self.weather?.city
        self.weatherDescriptionLabel.text = self.weather?.weatherDescription
        
        if let temperature = self.weather?.temperature {
            self.weatherTemperatureLabel.text = String(temperature)
        } else {
            self.weatherTemperatureLabel.text = ""
        }
        
        if let weatherIconID = self.weather?.weatherIcon {
            if let weatherIcon = weatherIconCache.imageFromCache(forKey: weatherIconID) {
                self.weatherIconImageView.image = weatherIcon
            } else {
                self.weatherIconImageView.sd_setImage(with: URL(string: "http://openweathermap.org/img/w/\(weatherIconID).png"), completed: { (iconImage, error, cacheType, url) in
                    self.weatherIconImageView.image = iconImage
                    
                    self.weatherIconCache.store(iconImage, forKey: weatherIconID, toDisk: true)
                })
            }
        }
    }
}

extension CarsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let weatherAPI = WeatherAPI()
            weatherAPI.getWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) {
                self.weatherIconCache.clearDisk()
                self.setupWeatherUI()
            }
            
            locationManager?.stopUpdatingLocation()
            self.locationManager = nil
        }
    }
}

extension CarsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! CarTableViewCell
        
        let car: Car = self.cars[indexPath.row]
        
        cell.modelLabel.text = car.model
        cell.priceLabel.text = "\(car.price) $"
        
        return cell
    }
}

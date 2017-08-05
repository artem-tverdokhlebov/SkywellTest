//
//  WeatherAPI.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/4/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class WeatherAPI {
    let baseURL = "http://api.openweathermap.org/data/2.5"
    private let appID = "6611191635b61604e47a58a34646d1dd"
    
    var context: NSManagedObjectContext {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    lazy var weatherDataManager: WeatherDataManager = WeatherDataManager()
    
    func getWeatherData(latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        let language = Bundle.main.preferredLocalizations.first
        
        let parameters: Parameters = [
            "lat": latitude,
            "lon": longitude,
            "lang": language ?? "en",
            "units": "metric",
            "appid": appID
        ]
        
        Alamofire.request("\(baseURL)/weather", parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let city = json["name"].string
                let description = json["weather"].array?.first?.dictionary?["description"]?.string
                let icon = json["weather"].array?.first?.dictionary?["icon"]?.string
                
                if let temperature = json["main"].dictionary?["temp"]?.double {
                    self.weatherDataManager.setWeatherData(city: city, temperature: temperature, description: description, icon: icon)
                }
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }

    
}

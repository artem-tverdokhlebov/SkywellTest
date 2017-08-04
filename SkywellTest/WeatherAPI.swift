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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getWeatherData(latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        let parameters: Parameters = [
            "lat": latitude,
            "lon": longitude,
            "appid": appID
        ]
        
        Alamofire.request("\(baseURL)/weather", parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.setWeatherData(json: json)
                
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
    
    private func setWeatherData(json: JSON) {
        do {
            let weatherEntries: [Weather] = try self.context.fetch(Weather.fetchRequest())
            
            var weatherEntry: Weather?
            
            if weatherEntries.count > 0 {
                weatherEntry = weatherEntries.first
            } else {
                weatherEntry = Weather(context: context)
            }
            
            weatherEntry?.city = json["name"].string

            try context.save()
        } catch {
            print("ERROR: fetching failed")
        }
    }
}

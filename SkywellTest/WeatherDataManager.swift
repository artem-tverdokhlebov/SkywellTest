//
//  WeatherDataManager.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/4/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import UIKit
import CoreData

class WeatherDataManager {
    var context: NSManagedObjectContext {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    func setWeatherData(city: String?, temperature: Double, description: String?, icon: String?) {
        do {
            let weatherEntries: [Weather] = try self.context.fetch(Weather.fetchRequest())
            
            var weatherEntry: Weather?
            
            if weatherEntries.count > 0 {
                weatherEntry = weatherEntries.first
            } else {
                weatherEntry = Weather(context: context)
            }
            
            weatherEntry?.city = city
            weatherEntry?.temperature = temperature
            weatherEntry?.weatherDescription = description
            weatherEntry?.weatherIcon = icon
            
            try context.save()
        } catch {
            print("ERROR: fetching failed")
        }
    }
}

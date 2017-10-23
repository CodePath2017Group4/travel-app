//
//  Weather.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import AFNetworking

struct Weather {
    
    let dateAndTime: Date
    
    let city: String
    let country: String
    let longitude: Double
    let latitude: Double
    
    let weatherID: Int
    let mainWeather: String
    let weatherDescription: String
    let weatherIconID: String
    static let currentLocKey = "CurrentLocKey"

    fileprivate let temp: Double //in Kelvin
    
    var tempCelsius: Double {
        get {
            return temp - 273.15
        }
    }
    var tempFahrenheit: Double {
        get {
            return (temp - 273.15) * 1.8 + 32
        }
    }
    let humidity: Int
    let pressure: Int
    let cloudCover: Int
    let windSpeed: Double
    
    let windDirection: Double? // optionals
    let rainfallInLast3Hours: Double? // optionals
    
    let sunrise: Date
    let sunset: Date

    
    init(weatherData: [String: AnyObject]) {
        dateAndTime = Date(timeIntervalSince1970: weatherData["dt"] as! TimeInterval)
        city = weatherData["name"] as! String
        UserDefaults.standard.set(city, forKey: Weather.currentLocKey)

        let coordDict = weatherData["coord"] as! [String: AnyObject]
        longitude = coordDict["lon"] as! Double
        latitude = coordDict["lat"] as! Double
        
        let weatherArray = weatherData["weather"] as! [NSDictionary]
        
        let weatherDict = weatherArray.first as! [String: AnyObject]
        weatherID = weatherDict["id"] as! Int
        mainWeather = weatherDict["main"] as! String
        weatherDescription = weatherDict["description"] as! String
        weatherIconID = weatherDict["icon"] as! String
                
        let mainDict = weatherData["main"] as! [String: AnyObject]
        temp = mainDict["temp"] as! Double
        humidity = mainDict["humidity"] as! Int
        pressure = mainDict["pressure"] as! Int
        
        cloudCover = weatherData["clouds"]!["all"] as! Int
        
        let windDict = weatherData["wind"] as! [String: AnyObject]
        windSpeed = windDict["speed"] as! Double
        windDirection = windDict["deg"] as? Double
        
        if weatherData["rain"] != nil {
            let rainDict = weatherData["rain"] as! [String: AnyObject]
            rainfallInLast3Hours = rainDict["3h"] as? Double
        }
        else {
            rainfallInLast3Hours = nil
        }
        
        let sysDict = weatherData["sys"] as! [String: AnyObject]
        country = sysDict["country"] as! String
        sunrise = Date(timeIntervalSince1970: sysDict["sunrise"] as! TimeInterval)
        sunset = Date(timeIntervalSince1970:sysDict["sunset"] as! TimeInterval)
        
    }
    
    static func getCurrentLocation() -> String {

        return "\(UserDefaults.standard.object(forKey: Weather.currentLocKey) ?? "None")"
    }
    
}

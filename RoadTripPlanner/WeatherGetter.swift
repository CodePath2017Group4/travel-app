//
//  WeatherGetter.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WeatherGetter {
    
    fileprivate let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    fileprivate let openWeatherMapAPIKey = "45198e73474125498688dee8a7b20704"
    private var delegate: WeatherGetterDelegate

    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    
    func getWeatherByCity(city: String) {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double) {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    
    private func getWeather(weatherRequestURL: URL) {
        
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3
        
        let dataTask = session.dataTask(with: weatherRequestURL) {
            (data, response, error) -> Void in
            
            if let networkError = error {
                //print("Error:\n\(error)")
                self.delegate.didNotGetWeather(error: networkError as NSError)
                
            }
            else {
                do {
                    let weatherData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    let weather = Weather(weatherData: weatherData)
                    
                    self.delegate.didGetWeather(weather: weather)
                    
                }
                catch let jsonError as NSError {
                    self.delegate.didNotGetWeather(error: jsonError)
                }
            }
        }
        
        dataTask.resume()
    }
}

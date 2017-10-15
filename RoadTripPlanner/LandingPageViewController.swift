//
//  LandingPageViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/10/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking

class LandingPageViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var createTripButton: UIButton!
    
    @IBOutlet weak var nearMeButton: UIButton!
    
    @IBOutlet weak var alongTheRouteButton: UIButton!
    
    @IBOutlet weak var currentCity: UILabel!
    
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var temperatureImage: UIImageView!
    
    let locationManager = CLLocationManager()
    var weather: WeatherGetter!
    
    @IBOutlet weak var gasImageView: UIImageView!
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var poiImageView: UIImageView!
    
    @IBOutlet weak var shoppingImageView: UIImageView!
    
    let categoriesList = ["gas","food","poi","shopping"]
    var selectedTypes: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTripButton.layer.cornerRadius = createTripButton.frame.height / 2
        nearMeButton.layer.cornerRadius = createTripButton.frame.height / 2
        alongTheRouteButton.layer.cornerRadius = createTripButton.frame.height / 2
        
        nearMeButton.isHidden = true
        alongTheRouteButton.isHidden = true
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        
        nearMeButton.isHidden = true
        alongTheRouteButton.isHidden = true
        
        let gasImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        gasImageTap.numberOfTapsRequired = 1
        gasImageView.isUserInteractionEnabled = true
        gasImageView.tag = 0
        gasImageView.addGestureRecognizer(gasImageTap)
        
        
        let foodImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        foodImageTap.numberOfTapsRequired = 1
        foodImageView.isUserInteractionEnabled = true
        foodImageView.tag = 1
        foodImageView.addGestureRecognizer(foodImageTap)
        
        let poiImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        poiImageTap.numberOfTapsRequired = 1
        poiImageView.isUserInteractionEnabled = true
        poiImageView.tag = 2
        poiImageView.addGestureRecognizer(poiImageTap)
        
        let shoppingImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        shoppingImageTap.numberOfTapsRequired = 1
        shoppingImageView.isUserInteractionEnabled = true
        shoppingImageView.tag = 3
        shoppingImageView.addGestureRecognizer(shoppingImageTap)
        
        if(selectedTypes == nil) {
            selectedTypes = [String]()
        }
        
        getLocation()
        weather = WeatherGetter(delegate: self)

    }

    func categoryTapped(_ sender: UITapGestureRecognizer) {
        print("sender/  \(sender.view?.tag)")
        let selectedIndex = sender.view?.tag
        
        
        let selectedImg = sender.view
        
        if !selectedTypes.isEmpty { // Not empty    // .contains(categoriesList[selectedIndex!]) {
            
            if selectedTypes.contains(categoriesList[selectedIndex!]) {
                
                selectedImg?.transform = CGAffineTransform(scaleX: 1.1,y: 1.1);
                selectedImg?.alpha = 0.0
                
                UIView.beginAnimations("button", context:nil)
                UIView.setAnimationDuration(0.5)
                selectedImg?.transform = CGAffineTransform(scaleX: 1,y: 1);
                selectedImg?.alpha = 1.0
                UIView.commitAnimations()
                
                gasImageView.alpha = 1
                foodImageView.alpha = 1
                poiImageView.alpha = 1
                shoppingImageView.alpha = 1
                
                createTripButton.isHidden = selectedTypes.isEmpty//false
                nearMeButton.isHidden = !selectedTypes.isEmpty//true
                alongTheRouteButton.isHidden = !selectedTypes.isEmpty//true
                selectedTypes.removeAll()
                
            }
            
        }
        else {
            if gasImageView.tag != selectedIndex {
                
                gasImageView.alpha = 0.5
            }
            if foodImageView.tag != selectedIndex {
                
                foodImageView.alpha = 0.5
            }
            if poiImageView.tag != selectedIndex {
                
                poiImageView.alpha = 0.5
            }
            if shoppingImageView.tag != selectedIndex {
                
                shoppingImageView.alpha = 0.5
            }
            
            createTripButton.isHidden = selectedTypes.isEmpty//false
            nearMeButton.isHidden = !selectedTypes.isEmpty//true
            alongTheRouteButton.isHidden = !selectedTypes.isEmpty//true
            
            
            selectedImg?.transform = CGAffineTransform(scaleX: 1,y: 1);
            selectedImg?.alpha = 0.0
            
            UIView.beginAnimations("button", context:nil)
            UIView.setAnimationDuration(0.5)
            selectedImg?.transform = CGAffineTransform(scaleX: 1.1,y: 1.1);
            selectedImg?.alpha = 1.0
            UIView.commitAnimations()
            
            selectedTypes.append(categoriesList[selectedIndex!])
            
        }
        
        print("selectedTypes  \(selectedTypes)")
        
    }
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. In order to use this app, " +
                    "go to Settings → GeoExample → Location and select the \"While Using " +
                    "the App\" setting.")
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Utility methods
    // -----------------------
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    

    
}

extension LandingPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2  {
            return 30.0
        }
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            case 0, 2 : let headerCell = tableView.dequeueReusableCell(withIdentifier: "TripHeaderCell", for: indexPath) as! UITableViewCell
                    return headerCell

            case 1, 3 :  let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
                    tripCell.selectionStyle = .none

                    return tripCell
            default:  return UITableViewCell()

            
        }

    }
}

extension LandingPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        weather.getWeatherByCoordinates(latitude: newLocation.coordinate.latitude,
                                        longitude: newLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async() {
            self.showSimpleAlert(title: "Can't determine your location",
                                 message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
    
}

extension LandingPageViewController: WeatherGetterDelegate {
    
    func didGetWeather(weather: Weather) {
        
        DispatchQueue.main.async {
            self.currentCity.text = weather.city
            self.currentTemperature.text = "\(Int(round(weather.tempFahrenheit)))° F"
            self.temperatureImage.image = weather.weatherIconImgView.image
        }
    }
    
    func didNotGetWeather(error: NSError) {
        
        DispatchQueue.main.async() {
            self.showSimpleAlert(title: "Can't get the weather", message: "The weather service isn't responding.")
        }
    }
    
    
}


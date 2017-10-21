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
import YelpAPI

class LandingPageViewController: UIViewController {
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pagingView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
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
    
    @IBOutlet weak var labelOne: UILabel!
    
    @IBOutlet weak var labelTwo: UILabel!
    
    @IBOutlet weak var labelThree: UILabel!
    
    @IBOutlet weak var labelFour: UILabel!
    //drugstores, deptstores, flowers
    //food - bakeries, bagels, coffee, donuts, foodtrucks
    //hotels - bedbreakfast, campgrounds, guesthouses. hostels
    //thingstodo
        //arts - arcades, museums
        // active - aquariums, zoos, parks, amusementparks
    // nightlife
    //poi // publicservicesgovt - civiccenter, landmarks,
    //entertainmneet// arts - movietheaters, galleries, theater
    // servicestations
    let categoriesList = ["servicestations", "food", "publicservicesgovt"/*poi*/,"grocery"/*shopping"*/, "lodging", "things_to_do", "nightlife", "entertainment"]
    
    var selectedType = ""
    
    var businesses: [YLPBusiness]!


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

        getLocation()
        weather = WeatherGetter(delegate: self)
       
        //1
        //self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        let lodgingImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        lodgingImageTap.numberOfTapsRequired = 1
        gasImageView.isUserInteractionEnabled = true
        //gasImageView.tag = 4
        gasImageView.addGestureRecognizer(lodgingImageTap)
        labelOne.text = "Lodging"
        
        
        let thingsToDoImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        thingsToDoImageTap.numberOfTapsRequired = 1
        foodImageView.isUserInteractionEnabled = true
        //foodImageView.tag = 5
        foodImageView.addGestureRecognizer(thingsToDoImageTap)
        labelTwo.text = "Point of Interest"
        
        let nightlifeImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        nightlifeImageTap.numberOfTapsRequired = 1
        poiImageView.isUserInteractionEnabled = true
        //poiImageView.tag = 6
        poiImageView.addGestureRecognizer(nightlifeImageTap)
        labelThree.text = "Nightlife"
        
        let entertainmentImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        entertainmentImageTap.numberOfTapsRequired = 1
        shoppingImageView.isUserInteractionEnabled = true
        //shoppingImageView.tag = 7
        shoppingImageView.addGestureRecognizer(entertainmentImageTap)
        labelFour.text = "Enterntainment"
        

        self.scrollView.addSubview(pagingView)
        
        let gasImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        gasImageTap.numberOfTapsRequired = 1
        gasImageView.isUserInteractionEnabled = true
        gasImageView.tag = 0
        gasImageView.addGestureRecognizer(gasImageTap)
        labelOne.text = "Automotive"
        
        let foodImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        foodImageTap.numberOfTapsRequired = 1
        foodImageView.isUserInteractionEnabled = true
        foodImageView.tag = 1
        foodImageView.addGestureRecognizer(foodImageTap)
        labelTwo.text = "Food"
        
        let poiImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        poiImageTap.numberOfTapsRequired = 1
        poiImageView.isUserInteractionEnabled = true
        poiImageView.tag = 2
        poiImageView.addGestureRecognizer(poiImageTap)
        labelThree.text = "POI"
        
        let shoppingImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        shoppingImageTap.numberOfTapsRequired = 1
        shoppingImageView.isUserInteractionEnabled = true
        shoppingImageView.tag = 3
        shoppingImageView.addGestureRecognizer(shoppingImageTap)
        labelFour.text = "Shopping"
        
        self.scrollView.addSubview(pagingView)

        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 2, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 1

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
    }

    func categoryTapped(_ sender: UITapGestureRecognizer) {
        
        let selectedIndex = sender.view?.tag
        print("selectedIndex ===== >  \(selectedIndex)")

        
        let selectedImg = sender.view
        
        if !selectedType.isEmpty {
            
            //if selectedTypes.contains(categoriesList[selectedIndex!]) {
            if categoriesList.contains(selectedType) {

                print("in first if")
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
                
                createTripButton.isHidden = selectedType.isEmpty//false
                nearMeButton.isHidden = !selectedType.isEmpty//true
                alongTheRouteButton.isHidden = !selectedType.isEmpty//true
                //selectedTypes.removeAll()
                selectedType = ""
            }
            else {
                
                    
                    gasImageView.alpha = 0.5
                
                    
                    foodImageView.alpha = 0.5
               
                    
                    poiImageView.alpha = 0.5
                
                
                    
                    shoppingImageView.alpha = 0.5
                
                
                selectedImg?.transform = CGAffineTransform(scaleX: 1.1,y: 1.1);
                selectedImg?.alpha = 0.0
                
                UIView.beginAnimations("button", context:nil)
                UIView.setAnimationDuration(0.5)
                selectedImg?.transform = CGAffineTransform(scaleX: 1,y: 1);
                selectedImg?.alpha = 1.0
                UIView.commitAnimations()
                //selectedTypes.removeAll()
                //selectedTypes.append(categoriesList[selectedIndex!])
                selectedType = categoriesList[selectedIndex!]

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
            
            createTripButton.isHidden = selectedType.isEmpty//false
            nearMeButton.isHidden = !selectedType.isEmpty//true
            alongTheRouteButton.isHidden = !selectedType.isEmpty//true
            
            
            selectedImg?.transform = CGAffineTransform(scaleX: 1,y: 1);
            selectedImg?.alpha = 0.0
            
            UIView.beginAnimations("button", context:nil)
            UIView.setAnimationDuration(0.5)
            selectedImg?.transform = CGAffineTransform(scaleX: 1.1,y: 1.1);
            selectedImg?.alpha = 1.0
            UIView.commitAnimations()
            
            //selectedTypes.append(categoriesList[selectedIndex!])
            selectedType = categoriesList[selectedIndex!]
        }
        
        print("selectedType  \(selectedType)")
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue.identifier \(segue.identifier!)")

        if segue.identifier! == "NearMe"{//Constants.segueFilterIdentifier {
            print("Etered segue.identifier \(segue.identifier)")

            let mapViewController = segue.destination  as! MapViewController
            mapViewController.businesses = businesses
            mapViewController.searchTerm = selectedType
           //// mapViewController.searchBar = searchBar
           // mapViewController.filters = filters
            //    mapViewController.filters1 = filters1*/
            
        }
        else if segue.identifier! == "CreateTrip" {
            
            let createTripViewController = segue.destination  as! CreateTripViewController
            //createTripViewController.businesses = businesses
            //createTripViewController.searchBar = searchBar
            //mapViewController.filters = filters
            //    mapViewController.filters1 = filters1*/
            
        }
        else {
            
           /* if let cell = sender as? BusinessCell {
                let  indexPath = tableView.indexPath(for: cell)
                
                let selectedBusiness = businesses[(indexPath?.row)!]
                
                if let detailViewController = segue.destination as? DetailViewController {
                    detailViewController.business = selectedBusiness
                    detailViewController.filters = filters
                    //       detailViewController.filters1 = filters1
                    
                }
            }*/
        }
    }
    
    @IBAction func onCreateTrip(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        //let createTripViewController = storyBoard.instantiateViewController(withIdentifier: "CreateTrip") as! UINavigationController
        
       // self.navigationController?.pushViewController(createTripViewController.topViewController!, animated: true)
    }
    
    @IBAction func onNearMe(_ sender: Any) {

        performSearch(selectedType)
        
    }
    
    @IBAction func onAlongTheRoute(_ sender: Any) {
    }
    
    final func performSearch(_ term: String) {
print("term \(term)")
        if term != nil, term != "" {
            
            YelpFusionClient.sharedInstance.search(inCurrent: (locationManager.location?.coordinate)!, term: term, completionHandler:  { (businesses: [YLPBusiness]?, error: Error?) -> Void in
                
                self.businesses = businesses
                print("self.businesse -----\(self.businesses.count)")

            })
            /*YelpFusionClient.sharedInstance.search(withLocation : "san francisco", term: term, completionHandler:  { (businesses: [YLPBusiness]?, error: Error?) -> Void in
                
                    self.businesses = businesses
                    print("self.businesse -----\(self.businesses.count)")

                    //self.tableView.reloadData()
                
                })*/
        }
        else {
            
           /* Business.searchWithTerm(term: Constants.restaurants, completion: { (businesses: [Business]?, error: Error?) -> Void in
                
                self.businesses = businesses
                self.tableView.reloadData()
                
            })*/
        }
        
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

extension LandingPageViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
 
    
  //  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
        print("self.pageControl.currentPage ---=== \(self.pageControl.currentPage)")
        // Change the text accordingly
        if Int(currentPage) == 0{
            //textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
            gasImageView?.image = UIImage(named: "gasstation")
            labelOne.text = "Automotive"
            gasImageView.tag = 0

            foodImageView?.image = UIImage(named: "food")
            labelTwo.text = "Food"
            foodImageView.tag = 1
            poiImageView.tag = 2


            poiImageView?.image = UIImage(named: "poi")
            labelThree.text = "POI"
            poiImageView.tag = 2

            shoppingImageView?.image = UIImage(named: "shopping")
            labelFour.text = "Shopping"
            shoppingImageView.tag = 3


        }else if Int(currentPage) == 1{
            gasImageView?.image = UIImage(named: "lodging")
            labelOne.text = "Lodging"
            gasImageView.tag = 4

            foodImageView?.image = UIImage(named: "thingstodo")
            labelTwo.text = "Things to Do"
            foodImageView.tag = 5

            poiImageView?.image = UIImage(named: "nightlife")
            labelThree.text = "Nightlife"
            poiImageView.tag = 6

            shoppingImageView?.image = UIImage(named: "entertainment")
            labelFour.text = "Enterntainment"
            shoppingImageView.tag = 7


        }
    }
}

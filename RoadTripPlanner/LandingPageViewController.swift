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
import CDYelpFusionKit
import Parse

class LandingPageViewController: UIViewController {
   
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    let categoriesList = ["auto", "food, restaurant", "publicservicesgovt"/*poi*/,"shopping"/*shopping"*/, "hotels", "arts, active", "nightlife", "arts"]
    
    var selectedType = [String] ()
    
    var businesses: [CDYelpBusiness]!

    var trips: [Trip]!
    
    let testData = TestData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTripButton.layer.cornerRadius = createTripButton.frame.height / 2
        nearMeButton.layer.cornerRadius = createTripButton.frame.height / 2
        alongTheRouteButton.layer.cornerRadius = createTripButton.frame.height / 2
        
        nearMeButton.isHidden = true
        alongTheRouteButton.isHidden = true
        
       // tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 192
        //tableView.separatorStyle = .none
        
       // let tripTableViewCellNib = UINib(nibName: Constants.NibNames.TripTableViewCell, bundle: nil)
       // tableView.register(tripTableViewCellNib, forCellReuseIdentifier: Constants.ReuseableCellIdentifiers.TripTableViewCell)
        
        let tripCollectionViewCellNib = UINib(nibName: Constants.NibNames.TripCollectionViewCell, bundle: nil)
        collectionView.register(tripCollectionViewCellNib, forCellWithReuseIdentifier: Constants.ReuseableCellIdentifiers.TripCollectionViewCell)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        nearMeButton.isHidden = true
        alongTheRouteButton.isHidden = true

        getLocation()
        weather = WeatherGetter(delegate: self)
        
        trips = []
        loadUpcomingTrips()
        
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
        let foodImageFromFile = UIImage(named: "food")!
        
        foodImageView.image = foodImageFromFile.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        foodImageView.tintColor = UIColor(red: 22/255, green: 134/255, blue: 36/255, alpha: 1)//.green*/

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
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarLightTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarLightTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
               
        registerForNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        // Make the navigation bar completely transparent.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
                
    }

    fileprivate func loadUpcomingTrips() {
        ParseBackend.getTripsForUser(user: PFUser.current()!, areUpcoming: true, onlyConfirmed: true) { (trips, error) in
            if error == nil {
                if let t = trips {
                    log.info("Upcoming trip count \(t.count)")
                                      
                    self.trips = t
                    DispatchQueue.main.async {
                        //self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                }
            } else {
                log.error("Error loading upcoming trips: \(error!)")
            }
        }
    }
    
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tripWasModified(notification:)),
                                               name: Constants.NotificationNames.TripModifiedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tripDeleted(notification:)),
                                               name: Constants.NotificationNames.TripDeletedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tripCreated(notification:)),
                                               name: Constants.NotificationNames.TripCreatedNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tripCreated(notification: NSNotification) {
        // Reload trips
        loadUpcomingTrips()
    }
    
    func tripWasModified(notification: NSNotification) {
        let info = notification.userInfo
        let trip = info!["trip"] as! Trip
        let tripId = trip.objectId
        
        // Find the trip in the trips array.
        log.info("Trip with id: \(String(describing: tripId)) has been modified.")
        
        let matchingTrips = trips.filter { (trip) -> Bool in
            return trip.objectId == tripId
        }
        
        if matchingTrips.count > 0 {
            let match = matchingTrips.first!
            let index = trips.index(of: match)
            
            guard let idx = index else { return }
            
            // replace the trip with the new trip
            trips[idx] = trip
            
            // reload the trips
            collectionView.reloadData()
        }
    }
    
    func tripDeleted(notification: NSNotification) {
        // Reload trips
        loadUpcomingTrips()
    }
    
    func categoryTapped(_ sender: UITapGestureRecognizer) {
        
        let selectedIndex = sender.view?.tag
        print("selectedIndex ===== >  \(selectedIndex)")

        
        let selectedImg = sender.view
        
        if !selectedType.isEmpty {
            
            //if selectedTypes.contains(categoriesList[selectedIndex!]) {
            if categoriesList.contains(selectedType[0]) {

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
                selectedType.removeAll()
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
                selectedType.removeAll()
                selectedType.append(categoriesList[selectedIndex!])
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
            
            selectedType.append(categoriesList[selectedIndex!])
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

        if segue.identifier! == "NearMe" {

            let mapViewController = segue.destination  as! MapViewController
            mapViewController.businesses = businesses
            mapViewController.searchTerm = selectedType
            
        }
        else if segue.identifier! == "CreateTrip" {
            
            let createTripViewController = segue.destination  as! CreateTripViewController
            //createTripViewController.businesses = businesses
            //createTripViewController.searchBar = searchBar
            //mapViewController.filters = filters
            //    mapViewController.filters1 = filters1*/
            
        }
        else {
           
            let createTripViewController = segue.destination  as! CreateTripViewController

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
    
    final func performSearch(_ term: [String]) {

        if !term.isEmpty {
            
            YelpFusionClient.shared.searchQueryWith(location: locationManager.location!, term: term[0], completionHandler: {(businesses: [CDYelpBusiness]?, error: Error?) -> Void in
                
                self.businesses = businesses
    
            })
            // working
            /*YelpFusionClient.sharedInstance.searchQueryWith(location: locationManager.location!, term: term[0], completionHandler: {(businesses: [YLPBusiness]?, error: Error?) -> Void in
                     self.businesses = businesses
                                
                })*/
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LandingPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 || indexPath.row == 2  {
//            return 30.0
//        }
        return 192
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        switch indexPath.row {
//            case 0, 2 : let headerCell = tableView.dequeueReusableCell(withIdentifier: "TripHeaderCell", for: indexPath) as! UITableViewCell
//                    return headerCell
//
//            case 1, 3 :  let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
//                    tripCell.selectionStyle = .none
//
//                    return tripCell
//            default:  return UITableViewCell()
//
//
//        }
        
        let tripCell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.TripTableViewCell, for: indexPath) as! TripTableViewCell
        tripCell.trip = trips[indexPath.row]
        return tripCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Show the trip details view controller.
        
        let trip = trips[indexPath.row]
        log.info("Selected trip \(trip.name ?? "none")")
        
        let tripDetailsVC = TripDetailsViewController.storyboardInstance()
        tripDetailsVC?.trip = trip
        navigationController?.pushViewController(tripDetailsVC!, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
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


// MARK: - WeatherGetterDelegate
extension LandingPageViewController: WeatherGetterDelegate {
    
    func didGetWeather(weather: Weather) {
        
        DispatchQueue.main.async {
            self.currentCity.text = weather.city
            self.currentTemperature.text = "\(Int(round(weather.tempFahrenheit)))° F"
            
            let weatherIconID = weather.weatherIconID
            if UIImage(named: weatherIconID) == nil {
                let iconURL = URL(string: "http://openweathermap.org/img/w/\(weatherIconID)")
                self.temperatureImage.setImageWith(iconURL!)
            } else {
                self.temperatureImage.image = UIImage(named: weatherIconID)
            }
        }
    }
    
    func didNotGetWeather(error: NSError) {
        
        DispatchQueue.main.async() {
            self.showSimpleAlert(title: "Can't get the weather", message: "The weather service isn't responding.")
        }
    }
}

// MARK: - UIScrollViewDelegate
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
            let foodImageFromFile = UIImage(named: "food")!
            
            foodImageView.image = foodImageFromFile.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            foodImageView.tintColor = UIColor(red: 22/255, green: 134/255, blue: 36/255, alpha: 1)//.green*/

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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LandingPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseableCellIdentifiers.TripCollectionViewCell, for: indexPath)  as! TripCollectionViewCell
        cell.backgroundColor = UIColor.darkGray
        cell.trip = trips[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  trips.isEmpty {
                print("trips == \(trips.count)")
                let messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                messageLabel.text = "You dont have any upcoming trips."
                messageLabel.textColor = UIColor.gray
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
                messageLabel.sizeToFit()
                self.collectionView.backgroundView = messageLabel
                self.collectionView.backgroundView?.isHidden = false
            
        } else {
            self.collectionView.backgroundView?.isHidden = true
        }
        return trips.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        log.info("Selected cell at \(indexPath)")
        
        let trip = trips[indexPath.row]
        log.info("Selected trip \(trip.name ?? "none")")
        
        let tripDetailsVC = TripDetailsViewController.storyboardInstance()
        tripDetailsVC?.trip = trip
        navigationController?.pushViewController(tripDetailsVC!, animated: true)

    }
}

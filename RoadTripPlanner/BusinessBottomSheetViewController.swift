//
//  BussinessBottomSheetViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/24/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import YelpAPI
import CDYelpFusionKit
import MapKit
import Parse

class BusinessBottomSheetViewController: UIViewController {
    // holdView can be UIImageView instead
    @IBOutlet weak var holdView: UIView!
    //@IBOutlet weak var left: UIButton!
    @IBOutlet weak var right: UIButton!
    
    @IBOutlet weak var businessImage: UIImageView!
    
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var displayAddr1: UILabel!
    
    @IBOutlet weak var displayAddr2: UILabel!
    
    @IBOutlet weak var reviewImage: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!

    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var ratingTotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addPriceSymbolLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    let fullView: CGFloat = 100
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var openNowLabel: UILabel!
    var business: CDYelpBusiness!
    var businesses: [CDYelpBusiness]!


    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        
        if business != nil {
            if business.name != nil {
                businessNameLabel.text = "\((business?.name)!)"
            }
            
            if let reviewCount = business?.reviewCount {
                
                if (reviewCount == 1) {
                    reviewCountLabel.text = "\(reviewCount) \(Constants.BusinessLabels.reviewLabel)"
                } else {
                    reviewCountLabel.text = "\(reviewCount) \(Constants.BusinessLabels.reviewsLabel)"
                }
                
            }
            
            
            self.right.addTarget(self, action: #selector(DetailViewController().onTripAdd), for: .touchDown)
            //self.right.addTarget(self, action: #selector(self.onSavePlace), for: .allTouchEvents)
            
            if let businessImageUrl = business.imageUrl {
                //     imageView?.setImageWith(businessImageUrl)
                let backgroundImageView = UIImageView()
                let backgroundImage = UIImage()
                backgroundImageView.setImageWith(businessImageUrl)
                businessImage.image = backgroundImageView.image//setImageWith(businessImageUrl)
                businessImage.contentMode = .scaleAspectFill
                businessImage.clipsToBounds = true
            }
            
            if let bussinessAddr = business.location?.displayAddress {
                displayAddr1.text = bussinessAddr[0]
                displayAddr2.text = bussinessAddr[1]
            }
            
            if let bussinessAddr = business.location?.addressOne {
                print("bussinessAddr \(bussinessAddr)")
                print("bussinessAddr2 \(business.location?.addressTwo)")
                print("bussinessAddr3 \(business.location?.addressThree)")
                print("bussinessAddr  \(business.location?.displayAddress?.count)")
                for da in (business.location?.displayAddress)! {
                    print("da \(da)")
                    
                }
            }
            
            if let phone = business.displayPhone {
                phoneLabel.text = "\(phone)"
                print("display phone \(business.displayPhone)")
                
            }
            
            
            
            if let price = business.price {
                var nDollar = price.count
                
                var missingDollar = 4-nDollar
                var labelDollar = "$"
                var mPrice = ""
                for i in 0..<missingDollar {
                    mPrice += labelDollar
                    
                }
                priceLabel.text = "\(price)"
                addPriceSymbolLabel.text = "\(mPrice)"
            }
            else {
                priceLabel.isHidden = true
                addPriceSymbolLabel.isHidden = true
            }
            
            
            
            //print("business.distance \(business.distance)")
            
            if let distance = business.distance {
                var distInMiles = Double.init(distance as! NSNumber) * 0.000621371
                
                distanceLabel.text = String(format: "%.2f", distInMiles)
            }
            
            if let closed = business.isClosed {
                ///openNowLabel.textColor = closed ? UIColor.red : UIColor.green
                openNowLabel.text = closed ? "Closed" : "Open"
                
                if !closed {
                    if let hours = business.hours {
                        
                        
                    }
                }
                
                if let photos = business.photos {
                    for p in photos {
                        print("photos \(p)")
                    }
                }
                
                if let hours = business.hours {
                    
                    let date = Date()
                    let calendar = Calendar.current
                    let dayOfWeek = calendar.component(.weekday, from: date)
                    for hour in hours {
                        let textLabel = UILabel()
                        
                        textLabel.textColor = hour.isOpenNow! ? UIColor.green : UIColor.red
                        textLabel.text = hour.isOpenNow! ? "Open" : "Closed"
                        
                        let hourOpen = hour.open
                        
                        let textLabelExt = UILabel()
                        textLabelExt.text = ""
                        for  day in hourOpen! {
                            if (dayOfWeek-1) == day.day! {
                                print("hours end \(day.end)")
                                var timeString = day.end as! String
                                
                                
                                timeString.insert(":", at: (timeString.index((timeString.startIndex), offsetBy: 2)))
                                print("timeString \(timeString)")
                                
                                /*   let dateAsString = timeString
                                 let dateFormatter = DateFormatter()
                                 dateFormatter.dateFormat = "HH:mm"
                                 let hourClose = dateFormatter.date(from: dateAsString)
                                 print("hourClose \(hourClose)")
                                 
                                 dateFormatter.dateFormat = "h:mm a"
                                 let date12 = dateFormatter.string(from: date)
                                 
                                 
                                 //let hourClose = day.end!*/
                                textLabelExt.text = hour.isOpenNow! ? " untill \(amAppend(str: timeString))" : ""
                                
                            }
                        }
                        openNowLabel.text = "\(textLabel.text!) \(textLabelExt.text!)"
                        
                        print("dayOfWeek\(dayOfWeek)")
                        
                        
                        
                        if hour.isOpenNow! {
                            /// if let hours = business.hours {
                            
                            
                            //}
                            
                            for h in hours {
                                print("hours \(h.hoursType)")
                                print("hours \(h.isOpenNow)")
                                print("hours \(h.open)")
                                
                                for ho in h.open! {
                                    print("hours \(ho.day)")
                                    print("hours \(ho.end)")
                                    print("hours \(ho.isOvernight)")
                                    print("hours \(ho.toJSONString())")
                                    
                                }
                                
                                
                            }
                            
                        }
                    }
                }
                
                
                if let ratingsCount = business.rating {
                    
                    
                    if ratingsCount == 0  {
                        reviewImage.image = UIImage(named: "0star")
                    }
                    else if ratingsCount > 0 && ratingsCount <= 1 {
                        reviewImage.image = UIImage(named: "1star")
                    }
                    else if ratingsCount > 1 && ratingsCount <= 1.5 {
                        reviewImage.image = UIImage(named: "1halfstar")
                    }
                    else if ratingsCount > 1.5 && ratingsCount <= 2 {
                        reviewImage.image = UIImage(named: "2star")
                    }
                    else if ratingsCount > 2 && ratingsCount <= 2.5 {
                        reviewImage.image = UIImage(named: "2halfstar")
                    }
                    else if ratingsCount > 2.5 && ratingsCount <= 3 {
                        reviewImage.image = UIImage(named: "3star")
                    }
                    else if ratingsCount > 3 && ratingsCount <= 3.5 {
                        reviewImage.image = UIImage(named: "3halfstar")
                    }
                    else if ratingsCount > 3.5 && ratingsCount <= 4 {
                        reviewImage.image = UIImage(named: "4star")
                    }
                    else if ratingsCount > 4 && ratingsCount <= 4.5 {
                        reviewImage.image = UIImage(named: "4halfstar")
                    }
                    else {
                        reviewImage.image = UIImage(named: "5star")
                    }
                    
                    if !(ratingsCount.isLess(than: 4.0))  {
                        ratingsCountLabel.backgroundColor = UIColor(red: 39/255, green: 190/255, blue: 73/255, alpha: 1)
                        ratingTotalLabel.backgroundColor = UIColor(red: 39/255, green: 190/255, blue: 73/255, alpha: 1)
                    }
                    else if !(ratingsCount.isLess(than: 3.0)) && (ratingsCount.isLess(than: 4.0)) {
                        ratingsCountLabel.backgroundColor = UIColor.orange
                        ratingTotalLabel.backgroundColor = UIColor.orange
                    }
                    else {
                        ratingsCountLabel.backgroundColor = UIColor.yellow
                        ratingTotalLabel.backgroundColor = UIColor.yellow
                    }
                    
                    let labelString = UILabel()
                    labelString.font = UIFont.boldSystemFont(ofSize: 5)
                    labelString.text = "5"
                    
                    ratingsCountLabel.text = "\(business.rating!)" + " / " //+ labelString.text!
                }
                
            }
        }
        //  roundViews()
    }
    
    
    func amAppend(str:String) -> String{
        var temp = str
        var strArr = str.characters.split{$0 == ":"}.map(String.init)
        var hour = Int(strArr[0])!
        var min = Int(strArr[1])!
        if(hour > 12){
            temp = temp + " PM"
        }
        else{
            temp = temp + " AM"
        }
        return temp
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
        self.loadViewIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            //    let yComponent = self?.partialView
            //    self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    func registerForNotifications() {
        // Register to receive Businesses
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BussinessUpdate"),
                                               object: nil, queue: OperationQueue.main) {
                                                [weak self] (notification: Notification) in
                                                self?.business = notification.userInfo!["business"] as! CDYelpBusiness
                                                //self?.addAnnotationFor(businesses: (self?.businesses)!)
                                                print("self?.business id in nitofocation \(self?.business.id)")
                                                print("self?.business photod in nitofocation \(self?.business.photos?.count)")
                                                
                                                self?.view.setNeedsDisplay()
                                                //self?.tableView.reloadData()
                                                //self?.collectionView.reloadData()
                                                //self?.mapView.reloadInputViews()
        }
    }
    
    // @IBAction
    func onAddRemoveTrip(_ sender: Any) {
        print("onAddRemoveTrip")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("businesses \(businesses)")
        
        if(businesses == nil) {
            
            let createTripViewController = storyboard.instantiateViewController(withIdentifier: "CreateTripViewController") as! CreateTripViewController
            createTripViewController.startTextField.text = "Current Location"
            createTripViewController.destinationTextField.text = (self.business.location?.displayAddress![0])! + " " + (self.business.location?.displayAddress![1])!
            navigationController?.pushViewController(createTripViewController, animated: true)
            
        }
        else {
            let routeMapViewController = storyboard.instantiateViewController(withIdentifier: "RouteMapView") as! RouteMapViewController
            
            
            let selectedLoc = self.business.coordinates
            
            let currentLocMapItem = MKMapItem.forCurrentLocation()
            var coord = CLLocationCoordinate2D.init(latitude: (selectedLoc?.latitude)!, longitude: (selectedLoc?.longitude)!)
            let selectedPlacemark = MKPlacemark(coordinate: coord, addressDictionary: nil)
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
            
            let mapItems = [selectedMapItem, currentLocMapItem]
            
            var placemark = MKPlacemark(coordinate: coord)
            let addMapItem =  MKMapItem(placemark: placemark)
            
            let intermediateLocation = CLLocation.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            let intermediateSegment = TripSegment(name: placemark.title!, address: "Temp Address", geoPoint: PFGeoPoint(location: intermediateLocation))
            //self.trip?.addSegment(tripSegment: intermediateSegment)
            
            let selectedPlace = Places(cllocation: CLLocation.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
                , distance: 0, coordinate: placemark.coordinate)
            //selectedPlace.calculateDistance(fromLocation: startPlace.cllocation)
            routeMapViewController.placestops.append(selectedPlace)
            
            routeMapViewController.placestops.sort(by: { ($0.distance?.isLess(than: $1.distance! ))! })
            
            var stopIndex = 0
            for i in 0...routeMapViewController.placestops.count-1 {
                // if placestops[i].coordinate.latitude == placemark.coordinate.latitude && placestops[i].coordinate.longitude == placemark.coordinate.longitude  {
                stopIndex = i
                break
                //}
            }
            
            //  locationArray.insert((textField: UITextField(), mapItem: addMapItem), at: stopIndex)
            
            //self.mapView.removeOverlays(self.mapView.overlays)
            // routeMapViewController.calculateSegmentDirections(index: 0, time: 0, routes: [])
            
            // routeMapViewController.locationArray = locationArray
            //  routeMapViewController.trip = trip
            
            navigationController?.pushViewController(routeMapViewController, animated: true)
        }
        
        
        
        
    }
    
    @IBAction func onSavePlace(_ sender: Any) {
        
        print("onSavePlace")
    }
    
    
    
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
}


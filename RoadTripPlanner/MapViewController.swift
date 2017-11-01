//
//  MapViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/11/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import YelpAPI
import CDYelpFusionKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var center: CLLocationCoordinate2D!
    fileprivate var annotations:   [MKPointAnnotation]!
    let locationManager = CLLocationManager()
    
    var searchTerm: [String]!

    var businesses: [CDYelpBusiness]!
    var business: CDYelpBusiness!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
        mapView.register(PlaceMarkerView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.delegate = self
        mapView.tintColor = UIColor.blue.withAlphaComponent(0.7)
        getLocation()
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        annotation.coordinate = coordinate
        goToLocation(location: locationManager.location!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarDarkTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarDarkTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarLightTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarLightTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
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
    
    var searchedPlaces = [Places]()

    func registerForNotifications() {
        // Register to receive Businesses
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BussinessesDidUpdate"),
                                               object: nil, queue: OperationQueue.main) {
                                                [weak self] (notification: Notification) in
                                                self?.businesses = notification.userInfo!["businesses"] as! [CDYelpBusiness]
                                                
                                                self?.addAnnotationFor(businesses: (self?.businesses)!)
                                                self?.collectionView.reloadData()
                                                self?.mapView.reloadInputViews()
        }
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func makeSpanRegion()
    {
        var miles: Double = 5.0
        
        /*if let distInMeters = filters[Constants.filterDistance] {
         var distInMiles = Double.init(distInMeters as! NSNumber) * 0.000621371
         distInMiles = rounded(no: distInMiles, toPlaces: 1)
         
         if distInMiles > miles {
         miles = distInMiles
         }
         }
         */
        print("miles \(miles)")
        
      //  let scalingFactor: Double = abs( (cos(2 * M_PI * centerLocation.coordinate.latitude / 360.0) ))
        
        var span: MKCoordinateSpan = MKCoordinateSpan.init()
        
        span.latitudeDelta = miles/69.0
       // span.longitudeDelta = miles/(scalingFactor * 69.0)
        
        var region: MKCoordinateRegion = MKCoordinateRegion.init()
        region.span = span
        //region.center = centerLocation.coordinate
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func rounded(no : Double, toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (no * divisor).rounded() / divisor
    }
}

// MARK: - Map View Delegate methods

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID) // customize the annotion view
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        log.info("Selected business in map")
        
        let coordinate = view.annotation?.coordinate
        // Find the corresponding business
        let matches = businesses.filter { (business) -> Bool in
            business.coordinates?.latitude == coordinate?.latitude && business.coordinates?.longitude == coordinate?.longitude
        }
        
        if matches.count > 0 {
            let b = matches.first!
            // what index is this business at?
            let index = businesses.index(where: { (business) -> Bool in
                business.id == b.id
            })
            guard let idx = index else { return }
            log.info("Found business at index: \(idx)")
            
            // Scroll to this index in the collection view
            let indexPath = IndexPath(row: idx, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! Places
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func showDetailsFor(_ business: YLPBusiness) {
        
        /*let storyboard = UIStoryboard(name: Constants.main, bundle: Bundle.main)
         
         let controller = storyboard.instantiateViewController(withIdentifier: Constants.detailsReuseIdentifier) as! DetailViewController
         controller.business = business
         //controller.filters = filters
         
         self.navigationController?.pushViewController(controller, animated: true)*/
       
    }
    
  /*  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if self.center == nil {
            self.center = mapView.region.center
        } else {
            let before = CLLocation(latitude: self.center.latitude, longitude: self.center.longitude)
            let nowCenter = mapView.region.center
            let now = CLLocation(latitude: nowCenter.latitude, longitude: nowCenter.longitude)
        }
    }*/
}

// MARK: - Location Manager Delegate methods

extension MapViewController: CLLocationManagerDelegate {
    
    func addAnnotationFor(businesses: [CDYelpBusiness]) {
        
        self.annotations = []
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if(businesses != nil) {
            var tagValue = 0
            for business in businesses {

                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: (business.coordinates!.latitude)!, longitude: (business.coordinates?.longitude)!)
                
                let placestops = Places(title: business.name!,
                                        location: business.name!,
                                        type: (self.searchTerm[0]),
                                        cllocation: CLLocation.init(latitude: business.coordinates!.latitude!, longitude: business.coordinates!.longitude!),
                                        distance: 0,
                                        coordinate: CLLocationCoordinate2D(latitude: (business.coordinates?.latitude)!, longitude: (business.coordinates?.longitude)!))
                self.searchedPlaces.append(placestops)

                annotation.coordinate = coordinate
                annotation.title = business.name
                annotation.subtitle = business.id
                self.annotations.append(annotation)
                
            }
            self.mapView.addAnnotations((self.searchedPlaces))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       /* if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }*/
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      /*  if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }*/
    }
    
    
}
extension MapViewController : UICollectionViewDataSource, UICollectionViewDelegate {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BusCell
        cell.business = businesses[indexPath.row]

        YelpFusionClient.shared.apiClient?.fetchBusiness(byId: cell.business?.id!, locale: CDYelpLocale.english_unitedStates) { (business: CDYelpBusiness?, error: Error?)  in
            
            let notificationName = NSNotification.Name(rawValue: "BussinessUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["business": business! ])
            
            if business != nil  {
                business?.distance = cell.business.distance
                if self.businesses != nil && !self.businesses.isEmpty {
                    self.businesses[indexPath.row] = business!
                }

            }
           
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let businss = businesses?[indexPath.row]
        controller.business = businss
       // collectionView.visibleCells
        present(controller, animated: true, completion: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetContentOffsetPointer = targetContentOffset
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffsetPointer.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex*cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffsetPointer.pointee = offset
    }
}

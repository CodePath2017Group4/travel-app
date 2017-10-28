//
//  RouteMapViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import YelpAPI
import Parse

class RouteMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsTableView: DirectionsTableView!
    
    let fromLocation:CLLocation = CLLocation(latitude: 24.186965, longitude: 120.633268)

    
    var start: String!
    var destination: String!
    var selectedTypes: [String]!
    var locationArray: [(textField: UITextField?, mapItem: MKMapItem?)]!
    var activityIndicator: UIActivityIndicatorView?
    var termCategory: [String : [String]]!

    fileprivate var annotations:   [MKPointAnnotation]!
    var businesses = [YLPBusiness]()

    var trip: Trip?
    var placestops  = [Places]()
    var startPlace : Places!
    var timeVar = 0.0
    var routeVar = [MKRoute]()
    var routeCoordinatesDB = [String : [CLLocationCoordinate2D]]()
    var coords: [CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startCoordinate = locationArray[0].mapItem?.placemark.coordinate
     startPlace = Places(cllocation: CLLocation.init(latitude: (startCoordinate?.latitude)!, longitude: (startCoordinate?.longitude)!)
            , distance: 0, coordinate: startCoordinate!)
        startPlace.calculateDistance(fromLocation: startPlace.cllocation)
        placestops.append(startPlace)

        let destCoordinate = locationArray[1].mapItem?.placemark.coordinate
        let destPlace = Places(cllocation: CLLocation.init(latitude: (destCoordinate?.latitude)!, longitude: (destCoordinate?.longitude)!)
            , distance: 0, coordinate: destCoordinate!)
        destPlace.calculateDistance(fromLocation: startPlace.cllocation)
        placestops.append(destPlace)
        
        registerForNotifications()
        addActivityIndicator()
        calculateSegmentDirections(index: 0, time: 0, routes: [])
        
        mapView.delegate = self
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.backgroundColor = view.backgroundColor
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
             
        trip?.saveInBackground { (success, error) in
            if (success) {
                log.info("trip saved")
            } else {
                log.error(error?.localizedDescription ?? "Uknown Error")
            }
        }
        
        // Push the TripDetailsViewController onto the nav stack.

        guard let tripDetailsViewController = TripDetailsViewController.storyboardInstance() else { return }
        tripDetailsViewController.trip  = trip
        
        navigationController?.pushViewController(tripDetailsViewController, animated: true)
        
        
    }
    
    func calculateSegmentDirections(index: Int, time: TimeInterval, routes: [MKRoute]) /*-> [MKRoute]*/ {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = locationArray[index].mapItem
        request.destination = locationArray[index+1].mapItem

        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate() {
            (response: MKDirectionsResponse?, error: Error?) in
            if let routeResponse = response?.routes {
                print("routeResponse \(routeResponse)")
                
                let quickestRouteForSegment: MKRoute =  routeResponse.sorted(by: {$0.distance < $1.distance})[0] //shortest distance
                    //routeResponse.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})[0] //shortest time

                //var
                self.timeVar = time
                //var
                self.routeVar = routes

                self.routeVar.append(quickestRouteForSegment)
                self.timeVar += quickestRouteForSegment.expectedTravelTime
                
                if index+2 < self.locationArray.count {
                    self.calculateSegmentDirections(index: index+1, time: self.timeVar, routes: self.routeVar)
                } else {
                    self.showRoute(routes: self.routeVar, time: self.timeVar)
                    self.hideActivityIndicator()
                }
            } else if let _ = error {
                let alert = UIAlertController(title: nil, message: "Directions not available.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel) {
                    (alert) -> Void in
                        self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
       // return self.routeVar //change later to return each route separately
    }
    
    
    func getAllCoordinatesForRoutes(/*routeVar: [MKRoute]*/) //-> [String : [CLLocationCoordinate2D]]
    {
        if coords.isEmpty {
            
            // Calculatete for each route
            for i in 0..<routeVar.count {
                
                var route = routeVar[i]
                var pointCount = route.polyline.pointCount
        
                var coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointCount)

                route.polyline.getCoordinates(coordsPointer, range: NSMakeRange(0, pointCount))
        
                for i in 0..<pointCount {
                    coords.append(coordsPointer[i])
                }
        
                coordsPointer.deallocate(capacity: pointCount)
                performSearch(coords : coords, termCategory: termCategory)
                routeCoordinatesDB.updateValue(coords, forKey:  route.name)
                for c in 0..<coords.count {
                    print("routeCoordinates \(c) -- \(coords[c].latitude),  \(coords[c].longitude)")
                }

            }
        //return routeCoordinatesDB
        }
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
        
        /*let scalingFactor: Double = abs( (cos(2 * M_PI * centerLocation.coordinate.latitude / 360.0) ))
        
        var span: MKCoordinateSpan = MKCoordinateSpan.init()
        
        span.latitudeDelta = miles/69.0
        span.longitudeDelta = miles/(scalingFactor * 69.0)
        
        var region: MKCoordinateRegion = MKCoordinateRegion.init()
        region.span = span
        region.center = centerLocation.coordinate
        
        self.mapView.setRegion(region, animated: true)*/
    }
    
    func performSearch(coords : [CLLocationCoordinate2D], termCategory: [String : [String]]) {
        
        let noOfCoordinates = coords.count
        let noOfSearch = noOfCoordinates/25

        var firstSearchIndex = 0
        var secSearchIndex = 0
        var searchradius = 25
        //(0+2*firstSearchIndex)  //avaoiding the previous 25 search
        
        if(noOfSearch >  1) { // route atleast 25+ miles
            firstSearchIndex = (0+25) //25 miles from origin, the search will include origin and 50 miles into journey
            secSearchIndex = firstSearchIndex
        }
        else {
            secSearchIndex = coords.count/2
        }
        repeat {

            if(coords.count-secSearchIndex<0) {
                secSearchIndex = coords.count
                searchradius = coords.count - secSearchIndex/2
            }

            let locCoordinates = coords[secSearchIndex]
            for key in termCategory.keys {
                print("key \(key)")
                print("termCategory[key]! \(termCategory[key]!)")
               
                YelpFusionClient.sharedInstance.searchQueryWith(location: locCoordinates, term: key, params: termCategory[key], completionHandler: { (businesses: [YLPBusiness]?, error: Error?) -> Void in

                })
            }
            
            secSearchIndex = (0 + 2*secSearchIndex)
            
        } while secSearchIndex<coords.count
    }
    
    func registerForNotifications() {
        // Register to receive new business notifications
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BussinessesDidUpdate"),
                   object: nil, queue: OperationQueue.main) {
                                    [weak self] (notification: Notification) in
                                    var businesses = notification.userInfo!["businesses"] as! [YLPBusiness]
                                    for bb in businesses {
                                        self?.businesses.append(bb)
                                    }
                                    self?.addAnnotationFor(businesses: (self?.businesses)!)
                                    print("<<<<===Route viewcontriller===>>>>>>> \(self?.businesses.count)")
                                    self?.mapView.reloadInputViews()
        }

    }
    
    func showRoute(routes: [MKRoute], time: TimeInterval) {
        print("routes count ===== \(routes.count)")

        var directionsArray = [(startingAddress: String, endingAddress: String, route: MKRoute)]()
        for i in 0..<routes.count {
            plotPolyline(route: routes[i])
            let firstParam = locationArray[i].textField
            let firstParamText =  firstParam?.text!
            firstParam?.spellCheckingType = .no
            firstParam?.autocorrectionType = .no
            let secParam = locationArray[i+1].textField
            let secParamText =  secParam?.text!
            secParam?.spellCheckingType = .no
            secParam?.autocorrectionType = .no
            let routeParam = routes[i]
            let param = (startingAddress: firstParamText!,
                         endingAddress: secParamText!, route: routeParam )
            
            directionsArray.append(param)
            //[(startingAddress: firstParamText,endAddress: secParamText, route: routeParam )]
        }
        //displayDirections(directionsArray: directionsArray)
        //printTimeToLabel(time: time)

    }
    
    func displayDirections(directionsArray: [(startingAddress: String,
        endingAddress: String, route: MKRoute)]) {
        
        
        directionsTableView.directionsArray = directionsArray
        directionsTableView.delegate = directionsTableView
        directionsTableView.dataSource = directionsTableView
        directionsTableView.reloadData()
    }
    
    func printTimeToLabel(time: TimeInterval) {
        var timeString = time.formatted()
        //totalTimeLabel.text = "Total Time: \(timeString)"
        print("timeString \(timeString)")
    }
    
    
    func plotPolyline(route: MKRoute) {

        mapView.add(route.polyline)
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                      edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                                      animated: false)
        }
        else {
            let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect,
                                                       route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect,
                                      edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                                      animated: false)
        }
    }
}
    
extension RouteMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*CLGeocoder().reverseGeocodeLocation(locations.last!,
                                            completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                                                if let placemarks = placemarks {
                                                    let placemark = placemarks[0]
                                                }
                                                self.locationTuples[0].mapItem = MKMapItem(placemark:
                                                    MKPlacemark(coordinate: placemark.location!.coordinate,
                                                                addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
        })*/
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async() {
          //  self.showSimpleAlert(title: "Can't determine your location",message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
    
}

extension RouteMapViewController: MKMapViewDelegate {
    
    func addAnnotationFor(businesses: [YLPBusiness]) {
        print("addAnnotationFor")
        makeSpanRegion()
        
        self.annotations = []
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if(businesses != nil) {
            for business in businesses {
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: (business.location.coordinate?.latitude)!, longitude: (business.location.coordinate?.longitude)!)
                annotation.coordinate = coordinate
                annotation.title = business.name
                annotation.subtitle = business.identifier
                self.annotations.append(annotation)
            }
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("overlays.count \(mapView.overlays.count)")

        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)  // customize the annotion view
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton.init(type: .contactAdd) as UIView
            //if searchTerm == "gas" {
                annotationView?.image = UIImage(named: "gas.png")
            //}
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if (control as? UIButton)?.buttonType == UIButtonType.contactAdd {

            let index = (self.annotations as NSArray).index(of: view.annotation)
            
            let selectedLoc = view.annotation
            print("Annotation '\(selectedLoc?.title!)' has been selected")
            
            let currentLocMapItem = MKMapItem.forCurrentLocation()
            
            let selectedPlacemark = MKPlacemark(coordinate: (selectedLoc?.coordinate)!, addressDictionary: nil)
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
            
            let mapItems = [selectedMapItem, currentLocMapItem]
            
            // For map navigation
            //let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            //MKMapItem.openMaps(with: mapItems, launchOptions:launchOptions)

            var placemark = MKPlacemark(coordinate: (view.annotation?.coordinate)!)
            mapView.deselectAnnotation(view.annotation, animated: false)
            let addMapItem =  MKMapItem(placemark: placemark)
            
            let intermediateLocation = CLLocation.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            let intermediateSegment = TripSegment(name: placemark.title!, address: "Temp Address", geoPoint: PFGeoPoint(location: intermediateLocation))
            self.trip?.addSegment(tripSegment: intermediateSegment)
            
            let selectedPlace = Places(cllocation: CLLocation.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
                , distance: 0, coordinate: placemark.coordinate)
            selectedPlace.calculateDistance(fromLocation: startPlace.cllocation)
            placestops.append(selectedPlace)

            placestops.sort(by: { ($0.distance?.isLess(than: $1.distance! ))! })
            
            var stopIndex = 0
            for i in 0...placestops.count-1 {
                if placestops[i].coordinate.latitude == placemark.coordinate.latitude && placestops[i].coordinate.longitude == placemark.coordinate.longitude  {
                    stopIndex = i
                    break
                }
            }

            locationArray.insert((textField: UITextField(), mapItem: addMapItem), at: stopIndex)

            self.mapView.removeOverlays(self.mapView.overlays)
            calculateSegmentDirections(index: 0, time: 0, routes: [])
        }
        
    }
}

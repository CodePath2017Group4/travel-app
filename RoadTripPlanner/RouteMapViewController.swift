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

class RouteMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsTableView: DirectionsTableView!
    
    var start: String!
    var destination: String!
    var selectedTypes: [String]!
    var locationArray: [(textField: UITextField?, mapItem: MKMapItem?)]!
    var activityIndicator: UIActivityIndicatorView?
    
    fileprivate var annotations:   [MKPointAnnotation]!
    var businesses = [YLPBusiness]()

    var trip: Trip?

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func calculateSegmentDirections(index: Int, time: TimeInterval, routes: [MKRoute]) {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = locationArray[index].mapItem
        request.destination = locationArray[index+1].mapItem

        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate()  {
            (response: MKDirectionsResponse?, error: Error?) in
            if let routeResponse = response?.routes {
                print("routeResponse \(routeResponse)")
                
                let quickestRouteForSegment: MKRoute =  routeResponse.sorted(by: {$0.distance < $1.distance})[0] //shortest distance
                    //routeResponse.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})[0] //shortest time

                var timeVar = time
                var routeVar = routes

                routeVar.append(quickestRouteForSegment)
                timeVar += quickestRouteForSegment.expectedTravelTime
                
                if index+2 < self.locationArray.count {
                    self.calculateSegmentDirections(index: index+1, time: timeVar, routes: routeVar)
                } else {
                    self.showRoute(routes: routeVar, time: timeVar)
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
    }
    
    
    func getAllCoordinates(route: MKRoute) {
        var pointCount = route.polyline.pointCount
        
        var coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointCount)

        route.polyline.getCoordinates(coordsPointer, range: NSMakeRange(0, pointCount))
        
        var coords: [CLLocationCoordinate2D] = []
        for i in 0..<pointCount {
            coords.append(coordsPointer[i])
        }
        
        coordsPointer.deallocate(capacity: pointCount)
        performSearch(coords : coords)
        
        for c in 0..<coords.count {
           print("routeCoordinates \(c) -- \(coords[c].latitude),  \(coords[c].longitude)")
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
    
    func performSearch(coords : [CLLocationCoordinate2D]) {
        
        var noOfCoordinates = coords.count
        var noOfSearch = noOfCoordinates/25
        print("noOfSearch========== \(noOfSearch)")

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
            print("secSearchIndex b4 if========== \(secSearchIndex)")

            if(coords.count-secSearchIndex<0) {
                secSearchIndex = coords.count
                searchradius = coords.count - secSearchIndex/2
            }
            print("secSearchIndex after if========== \(secSearchIndex)")

            let locCoordinates = coords[secSearchIndex]
            
             YelpFusionClient.sharedInstance.search(inCurrent: locCoordinates, term: "gas", completionHandler:  { (businesses: [YLPBusiness]?, error: Error?) -> Void in
                
                print("businesses -----\(businesses?.count)")

                for bb in businesses! {
                    
                    //self.b.append(bb)
                }
                print("b -----\(self.businesses.count)")

                
                
                    
                })
            
            secSearchIndex = (0 + 2*secSearchIndex)
            
            
        } while secSearchIndex<coords.count
        
        
        
        
    
    }
    func registerForNotifications() {
        // Register to receive new tweet notifications
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BussinessesDidUpdate"),
                                               object: nil, queue: OperationQueue.main) {
                                                [weak self] (notification: Notification) in
                                                var businesses = notification.userInfo!["businesses"] as! [YLPBusiness]
                                                for bb in businesses {
                                                    self?.businesses.append(bb)

                                                }
                                                
                                                self?.addAnnotationFor(businesses: (self?.businesses)!)
                                                print("<<<<======>>>>>>> \(self?.businesses.count)")
                                                //    print("<<<<======>>>>>>> \(self?.businesses[0].url)")
                                                //self?.tableView.reloadData()
                                                self?.mapView.reloadInputViews()
        }
    }
    
    func showRoute(routes: [MKRoute], time: TimeInterval) {
        print("routes count ===== \(routes.count)")

        for i in 0..<routes.count {
            plotPolyline(route: routes[i])
            print("routes at [\(i)] ===== \(routes[i])")
            print("=====================================================================")

            
            getAllCoordinates(route: routes[i])

        }
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
            print("firstParamText \(firstParamText)")
            
            print("secParamText \(secParamText)")
            
            print("routeParam \(routeParam)")
            print("routeParam \((startingAddress: firstParamText!,endAddress: secParamText!, route: routeParam ))")
            
            
            let param = (startingAddress: firstParamText!,
                         endingAddress: secParamText!, route: routeParam )
            
            directionsArray.append(param)
            //[(startingAddress: firstParamText,endAddress: secParamText, route: routeParam )]
        }
        //displayDirections(directionsArray: directionsArray)
        //printTimeToLabel(time: time)
        print("directionsArray count ===== \(directionsArray.count)")

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
            print("inside mapview.overlays")
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                      edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                                      animated: false)
        }
        else {
            print("inside mapview.overlays else")

            let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect,
                                                       route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect,
                                      edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                                      animated: false)
        }
    }
}
    
extension RouteMapViewController: CLLocationManagerDelegate {
    
   /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!,
                                            completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                                                if let placemarks = placemarks {
                                                    let placemark = placemarks[0]
                                                }
                                                self.locationTuples[0].mapItem = MKMapItem(placemark:
                                                    MKPlacemark(coordinate: placemark.location!.coordinate,
                                                                addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
        })
    }*/
    
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
         
            locationArray[locationArray.count-1].mapItem = addMapItem
            locationArray[locationArray.count-1].textField = UITextField()
            calculateSegmentDirections(index: 0, time: 0, routes: [])

            print("entered callout")

            }
        }
    
}

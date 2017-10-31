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
import ARSLineProgress

class RouteMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsTableView: DirectionsTableView!
    
    @IBOutlet weak var navImageView: UIImageView!
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
    var destPlace : Places!
    var timeVar = 0.0
    var routeVar = [MKRoute]()
    var routeCoordinatesDB = [String : [CLLocationCoordinate2D]]()
    var coords: [CLLocationCoordinate2D] = []
    var loadTripOnMap = false

    // Remove test data
    /*private let goldenGate = TripSegment(name: "Golden Gate Bridge",
                                         address: "Golden Gate Bridge, San Francisco, CA 94129",
                                         location: CLLocation(latitude: 37.8199328, longitude: -122.4804491))
    private let ghiradelli = TripSegment(name: "Ghirardelli Square",
                                         address: "North Point Street, San Francisco, CA",
                                         location: CLLocation(latitude: 37.8058763, longitude: -122.4251442))
    
    private let facebook = TripSegment(name: "Facebook Headquarters",
                                       address: "1 Hacker Way, Menlo Park, CA 94025",
                                       location: CLLocation(latitude: 37.4845317, longitude: -122.1496421))
    
    private let apple = TripSegment(name: "Apple Infinite Loop",
                                    address: "1 Infinite Loop, Cupertino, CA 95014",
                                    location: CLLocation(latitude: 37.3316756, longitude: -122.032383))*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(PlacesMarkerView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
       // mapView.register(PlacesView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //========================================================================
        
        if !loadTripOnMap {
            
            let startCoordinate = locationArray[0].mapItem?.placemark.coordinate
            startPlace = Places(cllocation: CLLocation.init(latitude: (startCoordinate?.latitude)!, longitude: (startCoordinate?.longitude)!)
                , distance: 0, coordinate: startCoordinate!)
            startPlace.calculateDistance(fromLocation: startPlace.cllocation)
            startPlace.type = "start"
            placestops.append(startPlace)

            let destCoordinate = locationArray[1].mapItem?.placemark.coordinate
            destPlace = Places(cllocation: CLLocation.init(latitude: (destCoordinate?.latitude)!, longitude: (destCoordinate?.longitude)!)
                , distance: 0, coordinate: destCoordinate!)
            destPlace.calculateDistance(fromLocation: startPlace.cllocation)
            destPlace.type = "finish"
            placestops.append(destPlace)
            self.mapView.addAnnotations((self.placestops))
            //============================================================================
            
            registerForNotifications()
            addActivityIndicator()
        
            ARSLineProgress.ars_showOnView(self.view) {
                self.calculateSegmentDirections(index: 0, time: 0, routes: [])
            
            }
        
            ARSLineProgress.hideWithCompletionBlock {
                if self.coords.count != 0 {
                    ARSLineProgress.hide()
                }
                
            }
        
        } else {
        
          /*  var tripSF = Trip.createTrip(name: "Unnamed Trip", date: Date(), creator: PFUser.current()!)
            tripSF.addSegment(tripSegment: apple)
            tripSF.addSegment(tripSegment: facebook)
            tripSF.addSegment(tripSegment: ghiradelli)
            tripSF.addSegment(tripSegment: goldenGate)
            loadTripOnMap(trip: tripSF)*/

            //routeMapViewController.termCategory = ["restaurant" : ["restaurant"]]
            //routeMapViewController.loadTripOnMap = true
            if trip != nil {
                loadTripOnMap(trip: trip!)
                for t in (trip?.segments)! {
                print("trip \(t)")
                }
            }

        }
        
        let navImageTap = UITapGestureRecognizer(target: self, action: #selector(navImgTapped))
        navImageTap.numberOfTapsRequired = 1
        navImageView.isUserInteractionEnabled = true
        navImageView.addGestureRecognizer(navImageTap)
        
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
    
    func navImgTapped(_ sender: UITapGestureRecognizer) {
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
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
        let constantSearchRadius = 25
        let noOfCoordinates = coords.count
        let noOfSearch = noOfCoordinates/constantSearchRadius

        var firstSearchIndex = 0
        var secSearchIndex = 0
        var searchradius = constantSearchRadius
        //(0+2*firstSearchIndex)  //avaoiding the previous 25 search
        
        if(noOfSearch >  1) { // route atleast 25+ miles
            firstSearchIndex = (0+constantSearchRadius) //25 miles from origin, the search will include origin and 50 miles into journey
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
            print("termCategory \(termCategory.keys.count)")
            print("locCoordinates at \(secSearchIndex) =========================>>>>>> \(locCoordinates)")

            for key in termCategory.keys {
                print("key \(key)")
                print("termCategory[key]! \(termCategory[key]!)")
               
                YelpFusionClient.sharedInstance.searchQueryWith(location: locCoordinates, term: key, params: termCategory[key], completionHandler: { (businesses: [YLPBusiness]?, error: Error?) -> Void in

                })
            }
            
            secSearchIndex = (0 + secSearchIndex + constantSearchRadius)
            
        } while secSearchIndex<coords.count
    }
    var searchedPlaces = [Places]()
    
    func registerForNotifications() {
        // Register to receive new business notifications
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BussinessesDidUpdate"),
                   object: nil, queue: OperationQueue.main) {
                                    [weak self] (notification: Notification) in
                                    var businesses = notification.userInfo!["businesses"] as! [YLPBusiness]
                                    let searchType = notification.userInfo!["type"] as! String

                                    for bb in businesses {
                                        self?.businesses.append(bb)
                                        let placestops = Places(title: bb.name,
                                                             location: bb.name,
                                                             type: searchType,
                                                             cllocation: CLLocation.init(latitude: bb.location.coordinate!.latitude, longitude: bb.location.coordinate!.longitude),
                                                             distance: 0,
                                                             coordinate: CLLocationCoordinate2D(latitude: (bb.location.coordinate?.latitude)!, longitude: (bb.location.coordinate?.longitude)!))
                                        self?.searchedPlaces.append(placestops)
                                        
                                    }
                   
                    self?.mapView.addAnnotations((self?.searchedPlaces)!)

                                   // self?.addAnnotationFor(businesses: (self?.businesses)!)
                                    print("<<<<===Route viewcontriller===>>>>>>> \(self?.businesses.count)")
                                    self?.mapView.reloadInputViews()
        }
        
    }

    
    
    
    func showRoute(routes: [MKRoute], time: TimeInterval) {
        print("routes count ===== \(routes.count)")
        getAllCoordinatesForRoutes()
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
       /* self.mapView.removeAnnotations(self.mapView.annotations)
    
        var isContained = false
        for business in businesses {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: (business.location.coordinate?.latitude)!, longitude: (business.location.coordinate?.longitude)!)
            annotation.coordinate = coordinate
           // annotation.title = business.name
            //annotation.subtitle = business.identifier
            //self.annotations.append(annotation)

                
            let places = Places(title: business.name,
                                    location: business.name,
                                    type: "",
                                    cllocation:  CLLocation.init(latitude: (coordinate.latitude), longitude: (coordinate.longitude)),
                                    distance: 0,
                                    coordinate: coordinate)
                
            for stops in self.placestops {

                if places.coordinate.latitude == stops.coordinate.latitude && places.coordinate.longitude == stops.coordinate.longitude
                {
                    isContained = true
                    print("places \(places.title) is in stops^^^^^^^^^^^^^^^^^^^^^^^^")
                }
            }
            if !isContained {
                mapView.addAnnotation(places)
            }
                
            //self.annotations.append(places)
        }*/
            
        for stops in self.placestops {
            mapView.addAnnotation(stops)

        }
        // self.mapView.addAnnotations((self.placestops)) //only route
         
        self.mapView.addAnnotations(self.annotations)
    
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
    
    
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       /*
        
        guard let annotation = annotation as? Places else { return nil }//Artwork else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
         }
         return view

         
         */
        
     

 /* let reuseID = "myAnnotationView"

         
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
        return annotationView*/
    }*/
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Annotationview accesorytapped  has been selected")

        /*let location = view.annotation as! Places
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)*/
        
        //if (control as? UIButton)?.buttonType == UIButtonType.contactAdd {
         if (control as? UIButton)?.buttonType == UIButtonType.detailDisclosure {
          //  let index = (self.annotations as NSArray).index(of: view.annotation)
            
            self.mapView.removeAnnotations(placestops)

            if !placestops.isEmpty {
                placestops.remove(at: 0)
                placestops.remove(at: placestops.count-1)
            }
            let selectedLoc = view.annotation


            //self.mapView.removeAnnotations(placestops)

            print("Annotation '\(selectedLoc?.title!)' has been selected")
            
            let currentLocMapItem = MKMapItem.forCurrentLocation()
            
            let selectedPlacemark = MKPlacemark(coordinate: (selectedLoc?.coordinate)!, addressDictionary: nil)
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
            
            let mapItems = [selectedMapItem, currentLocMapItem]
            
            // For map navigation
            //let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            //MKMapItem.openMaps(with: mapItems, launchOptions:launchOptions)

            // get the stop
            var placemark = MKPlacemark(coordinate: (view.annotation?.coordinate)!)
            mapView.deselectAnnotation(view.annotation, animated: false)
            self.mapView.removeAnnotation(selectedLoc!)

            let addMapItem =  MKMapItem(placemark: placemark)
            
            // stop added
            let intermediateLocation = CLLocation.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            
            let intermediateSegment = TripSegment(name: placemark.title!, address: "Temp Address", geoPoint: PFGeoPoint(location: intermediateLocation))
            self.trip?.addSegment(tripSegment: intermediateSegment)
            
            let selectedPlace = Places(cllocation: CLLocation.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
                , distance: 0, coordinate: placemark.coordinate)
            selectedPlace.calculateDistance(fromLocation: startPlace.cllocation)
            placestops.append(selectedPlace)

            placestops.sort(by: { ($0.distance?.isLess(than: $1.distance! ))! })
            
            var toProceed = false
            var stopIndex = 0
            for i in 0...placestops.count-1 {
                let stop = placestops[i]
                stop.type = "\(i + 1)"
                placestops[i] = stop
print("stop type changed  **************\(placestops.count)**********************")
                print("stop type for \(i) changed  to \(i+1) == \(stop.type)")

                print("stop type changed  *************************************")

                if !toProceed {
                if placestops[i].coordinate.latitude == placemark.coordinate.latitude && placestops[i].coordinate.longitude == placemark.coordinate.longitude  {
                    stopIndex = i
                    toProceed == true
                    }
                    
                }
            }

            placestops.insert(startPlace, at: 0)
            placestops.append(destPlace)

            
            print("placestops.count \(placestops.count)")

            locationArray.insert((textField: UITextField(), mapItem: addMapItem), at: stopIndex+1)

            self.mapView.removeOverlays(self.mapView.overlays)
            calculateSegmentDirections(index: 0, time: 0, routes: [])
            
            /*for stops in placestops {
                mapView.addAnnotation(stops)
                //self.annotations.append(stops)
                
            }*/
            
            print("placestops.count \(placestops.count)")
            print("(mapView.annotations.count ============================ \(mapView.annotations.count)")

            self.mapView.addAnnotations((self.placestops)) //only route
        }
        
    }
    
    func loadTripOnMap(trip: Trip) {
        
        let stops = trip.segments
        var stops2Load =  [Places]()
        
        var startTrip: Places?
        var destTrip: Places?
        print("stops \(stops)")
        
        if stops?.count != 0 && (stops?.count)! > 1 {
            var start = stops![0]
            
            startTrip = Places(title: start.name!,
                                    location: start.address!,
                                    type: "start",
                                    cllocation: CLLocation.init(latitude: (start.geoPoint?.latitude)!, longitude: (start.geoPoint?.longitude)!),
                                    distance: 0,
                                    coordinate: CLLocationCoordinate2D(latitude: (start.geoPoint?.latitude)!, longitude: (start.geoPoint?.longitude)!))
            
            
            //========= already available from trip details but route calculation error =========
            //placemark, mapitem, locationArray all passed from trip details page.
            locationArray = []
            var stopPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (start.geoPoint?.latitude)!, longitude: (start.geoPoint?.longitude)!), addressDictionary: nil)
            var stopMapItem = MKMapItem(placemark: stopPlacemark)
            
            locationArray.append((textField: UITextField(), mapItem: stopMapItem))
            //-==================================
           
            var dest = stops![((stops?.endIndex)! - 1)]
            
            destTrip = Places(title: dest.name!,
                              location: dest.address!,
                              type: "finish",
                              cllocation: CLLocation.init(latitude: (dest.geoPoint?.latitude)!, longitude: (dest.geoPoint?.longitude)!),
                              distance: 0,
                              coordinate: CLLocationCoordinate2D(latitude: (dest.geoPoint?.latitude)!, longitude: (dest.geoPoint?.longitude)!))
            
            for stopIndex in 1..<(stops!.count - 1) {
                
                let stop = stops![stopIndex]
                
                let tripStops = Places(title: stop.name!,
                                       location: stop.address!,
                                       type: "",
                                       cllocation: CLLocation.init(latitude: (stop.geoPoint?.latitude)!, longitude: (stop.geoPoint?.longitude)!),
                                       distance: 0,
                                       coordinate: CLLocationCoordinate2D(latitude: (stop.geoPoint?.latitude)!, longitude: (stop.geoPoint?.longitude)!))
                
                tripStops.calculateDistance(fromLocation: startTrip?.cllocation)
                
                placestops.append(tripStops)
            }
            
            placestops.sort(by: { ($0.distance?.isLess(than: $1.distance! ))! })
            
            // Prevent Crash if placestops length is zero..
            if placestops.count > 0 {
                
                for i in 0...placestops.count-1 {
                    let stop = placestops[i]
                    stop.type = "\(i + 1)"
                    placestops[i] = stop
                    
                    //========= already available from trip details but route calculation error =========
                    stopPlacemark = MKPlacemark(coordinate: stop.coordinate, addressDictionary: nil)
                    stopMapItem = MKMapItem(placemark: stopPlacemark)
                    
                    locationArray.append((textField: UITextField(), mapItem: stopMapItem))
                    //-==================================
                }
            }
            
            
            placestops.insert(startTrip!, at: 0)
            placestops.append(destTrip!)
            
            //========= already available from trip details but route calculation error =========
            stopPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (dest.geoPoint?.latitude)!, longitude: (dest.geoPoint?.longitude)!), addressDictionary: nil)
            stopMapItem = MKMapItem(placemark: stopPlacemark)
            
            locationArray.append((textField: UITextField(), mapItem: stopMapItem))
            //-==================================

            self.mapView.removeOverlays(self.mapView.overlays)
            calculateSegmentDirections(index: 0, time: 0, routes: [])
            
            self.mapView.addAnnotations((self.placestops)) //only route
            
        }
        
    }
}

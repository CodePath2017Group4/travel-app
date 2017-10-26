//
//  YelpFusionClient.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/17/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import YelpAPI
//import AFNetworking
import CoreLocation

class YelpFusionClient {
    
    var yelpClient: YLPClient?
    
    static let sharedInstance = YelpFusionClient()
    
    func authorize() {
        
        YLPClient.authorize(withAppId: APIKeys.Yelp.clientId, secret: APIKeys.Yelp.clientSecret) { (client: YLPClient?, error: Error?) in
            
            if (client != nil) {
                self.yelpClient = client
                log.verbose("SUCCESS!")
                
            } else if (error != nil) {
                log.error(error!)
            }
        }
    }
    
    func search(withLocationName location: String, term: String) {
        yelpClient?.search(withLocation: location, term: term, limit: 20, offset: 0, sort: YLPSortType.bestMatched, completionHandler: { (search: YLPSearch?, error: Error?) in
            let businesses = search?.businesses
            log.info(businesses?.count ?? 0)
        
            for b in businesses! {
              log.info (b.name)
            }
        })
    }
    
    func searchQueryWith(location: CLLocationCoordinate2D, term: String, params: [String]? , completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {

        let query = YLPQuery(coordinate: YLPCoordinate(latitude: location.latitude, longitude: location.longitude))
        query.term = term
        query.limit = 10
        //query.radiusFilter = 25
        query.sort = YLPSortType.distance
        var category = Category(term: term)
        query.categoryFilter = params//["gasstation","bakeries"]//category.getCategoryList()
        
        yelpClient?.search(with: query, completionHandler : { (search: YLPSearch?, error: Error?) in
            
            let businesses = search?.businesses
            completionHandler(businesses, nil)
            
            // log.info(businesses)
            
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]?])
            
            for b in businesses! {
                log.info (b.name)
            }
            
        })
        
    }
    
    
    func searchQueryWith(location: CLLocation, term: String, completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {
        let query = YLPQuery(coordinate: YLPCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        query.term = term
        query.limit = 20
        //query.radiusFilter = 25
        query.sort = YLPSortType.distance
        var category = Category(term: term)
        query.categoryFilter = category.getCategoryList()
        
        yelpClient?.search(with: query, completionHandler : { (search: YLPSearch?, error: Error?) in
            
            let businesses = search?.businesses
            completionHandler(businesses, nil)
            
            // log.info(businesses)
            
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]?])
            
            for b in businesses! {
             log.info (b.name)
             }
            
        })
        
    }

    func searchWith(location: CLLocationCoordinate2D, term: String, completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {
        
        let query = YLPQuery(coordinate: YLPCoordinate(latitude: location.latitude, longitude: location.longitude))
        query.term = (term)
        query.limit = 20
        //query.radiusFilter = 25
        query.sort = YLPSortType.distance
        var category = Category(term: term)
        query.categoryFilter = category.getCategoryList()
        
        yelpClient?.search(with: query, completionHandler : { (search: YLPSearch?, error: Error?) in
        
            let businesses = search?.businesses
            completionHandler(businesses, nil)

           // log.info(businesses)

            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]?])

            
        })

    }

    func search(inCurrent location: CLLocationCoordinate2D, term: String, completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {

        var category = Category(term: term)
        var cat = category.getCategoryList().joined(separator: ",")

        yelpClient?.search(with: YLPCoordinate(latitude: location.latitude, longitude: location.longitude), term: term, limit: 25, offset: 0, sort: YLPSortType.bestMatched, completionHandler: { (search: YLPSearch?, error: Error?) in

            let businesses = search?.businesses
            completionHandler(businesses, nil)

            
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]])
            
            log.info(businesses?.count ?? 0)
           
        })
    }
    
    func search(withLocation location: CLLocation, term: String, completion: @escaping ([YLPBusiness]?, Error?) -> Void) {
        
        let ylpCoordinate = YLPCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        yelpClient?.search(with: ylpCoordinate, term: term, limit: 20, offset: 0, sort: YLPSortType.mostReviewed, completionHandler: { (search: YLPSearch?, error: Error?) in
                if error != nil {
                   log.error(error ?? "Unknown Error Occurred")
                   completion(nil, error)
                } else {
                   let businesses = search?.businesses
                  // log.info(businesses?.count ?? 0)
                    completion(businesses, nil)
                }
        })
   }
}


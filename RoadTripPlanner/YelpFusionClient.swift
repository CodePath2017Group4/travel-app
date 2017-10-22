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
    
    func search(withLocation location: String, term: String, completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {
        log.info("INSIDE SEARCH")
        
        yelpClient?.search(withLocation: location, term: term, limit: 20, offset: 0, sort: YLPSortType.bestMatched, completionHandler: { (search: YLPSearch?, error: Error?) in
            //success: { (search: YLPSearch, response: Any) -> Void in
            let businesses = search?.businesses// as! [Business]
            completionHandler(businesses, nil)
            log.info("yelp query \(YLPQuery.dictionaryWithValues(forKeys: ["parking","autoelectric"]))")
            // log.info(businesses)
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]])
            
            //success(newTweet)
            log.info(businesses?.count ?? 0)
            
            for b in businesses! {
                log.info (b.name)
            }
            
            //YLPQuery(location: "San Francisco, CA")
            
        })
    }
    
    func search(inCurrent location: CLLocationCoordinate2D, term: String, completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {
        log.info("INSIDE SEARCH")
        //var terms = "gas, museum"
        //log.info("yelp query \(YLPQuery.dictionaryWithValues(forKeys: ["parking","autoelectric"]))")

        yelpClient?.search(with: YLPCoordinate(latitude: location.latitude, longitude: location.longitude), term: term, limit: 25, offset: 0, sort: YLPSortType.bestMatched, completionHandler: { (search: YLPSearch?, error: Error?) in
            //success: { (search: YLPSearch, response: Any) -> Void in
            let businesses = search?.businesses// as! [Business]
            completionHandler(businesses, nil)

            log.info(businesses)
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]])
            
            //success(newTweet)
            log.info(businesses?.count ?? 0)
            
            for b in businesses! {
                log.info (b.name)
            }
            
            //YLPQuery(location: "San Francisco, CA")
            
        })
    }
    
    
    func search(inCurrent location: CLLocationCoordinate2D, term: [String : String], completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {
        log.info("INSIDE SEARCH with [string]")
        
        var serachTerm = "term=\(term["terms"]!)"
        serachTerm = serachTerm.hasSuffix(",") ? serachTerm.substring(to: serachTerm.index(before: serachTerm.endIndex)) : serachTerm
        serachTerm += serachTerm.characters.count>3 ? "&categories=\(term["sub"]!)" : serachTerm
        serachTerm = serachTerm.hasSuffix(",") ? serachTerm.substring(to: serachTerm.index(before: serachTerm.endIndex)) : serachTerm
        print("serachTerm \(serachTerm)")

        
        yelpClient?.search(with: YLPCoordinate(latitude: location.latitude, longitude: location.longitude), term: serachTerm, limit: 30, offset: 0, sort: YLPSortType.bestMatched, completionHandler: { (search: YLPSearch?, error: Error?) in
            //success: { (search: YLPSearch, response: Any) -> Void in
            let businesses = search?.businesses// as! [Business]
            completionHandler(businesses, nil)
            
            log.info(businesses)
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]])
            
            //success(newTweet)

            log.info(businesses?.count ?? 0)
            
            for b in businesses! {
                log.info (b.name)
            }
            //YLPQuery(location: "San Francisco, CA")
            
        })
    }
    
    func search(withLocation location: CLLocation, term: String, categories: [String]) {
        let ylpCoordinate = YLPCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let query = YLPQuery(coordinate: ylpCoordinate)
        query.categoryFilter = categories
        query.limit = 20
        query.offset = 0
        query.sort = YLPSortType.distance
        
        yelpClient?.search(with: query, completionHandler: { (search: YLPSearch?, error: Error?) in
            if error != nil {
                log.error(error ?? "Unknown Error Occurred")
            } else {
                let businesses = search?.businesses
                log.info(businesses?.count ?? 0)
                
//                for b in businesses! {
//                    log.info (b.name)
//                    log.info (b.location)
//                    let categories = b.categories
//                    for category in categories {
//                        log.info("Category: \(category.name)")
//                    }
//                }
            }
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
                log.info(businesses?.count ?? 0)
                completion(businesses, nil)
            }
        })
    }
        
}


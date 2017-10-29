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
import CDYelpFusionKit

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
    //used in create trip
    func searchQueryWith(location: CLLocationCoordinate2D, term: String, params: [String]? , completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {

        print("entered searchQueryWith")
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
            
             log.info(businesses)
            
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [YLPBusiness]?, "type": term])
            
            for b in businesses! {
                log.info (b.name)
            }
            
        })
        
    }
    
    // working - used in code
    func searchQueryWith(location: CLLocation, term: String, completionHandler: @escaping ([YLPBusiness]?, Error?) -> Void) {
        let query = YLPQuery(coordinate: YLPCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        query.term = term
        query.limit = 5
        query.radiusFilter = 8046
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
    
    
    func businessDetaillsWith(id: String, completionHandler: @escaping (YLPBusiness, Error?) -> Void) {

        yelpClient?.business(withId: id, completionHandler: { (search: YLPBusiness?, error: Error?) in
            let business = search

            for y in (business?.categories)! {
                print("cat \(y.name)")
            }

           /* let notificationName = NSNotification.Name(rawValue: "BussinessUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["business": business as! YLPBusiness?])*/

        })
        
        
    }
    
    func businessReviewsWith(id: String, completionHandler: @escaping (YLPBusiness, Error?) -> Void) {
        
        yelpClient?.reviewsForBusiness(withId: id, completionHandler: { (yelpReviews: YLPBusinessReviews?, error: Error?) in
            let reviews =    yelpReviews?.reviews
            for review in reviews! {
                print("cat \(review)")
            }
            
            let notificationName = NSNotification.Name(rawValue: "BussinessReview")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["reviews": reviews as! [YLPReview]])
            
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
    
    
    //========================= CDYelpFusionClient ==========
    
    static let shared = YelpFusionClient()
    
    var apiClient: CDYelpAPIClient!
    
    func configure() {

        let client = CDYelpAPIClient(clientId: APIKeys.Yelp.clientId,
                                         clientSecret: APIKeys.Yelp.clientSecret)
        
                                            
        if client.isAuthenticated() {
            self.apiClient = client
            log.verbose("Success!")
            
        } else  {
            log.verbose("Authentication Failure!")
            
        }
    }
    
    func businessWith(id: String, completionHandler: @escaping (CDYelpBusiness, Error?) -> Void) {
       // YelpFusionClient().configure()

        print("id \(id)")
        var idString = ""
       /* self.apiClient.searchBusinesses(byTerm: "gasstation", location: "San Francisco", latitude: nil, longitude: nil, radius: nil, categories: nil, locale: nil, limit: 1, offset: 0, sortBy: nil, priceTiers: nil, openNow: true, openAt: nil, attributes: nil) { (resonse: CDYelpSearchResponse?, error: Error?) in
            var t = resonse?.businesses
            
            print("t \(t?.count)")
            print("t \(t![0])")
            print("t \(t![0].id)")

            idString = (t![0].id)!
        }
        print("idString \(idString)")
        if (idString).isEmpty {
            
            idString = id
        }*/
        print("apiClient \(self.apiClient)")

        self.apiClient?.fetchBusiness(byId: "deli-board-san-francisco", locale: nil) { (business: CDYelpBusiness?, error: Error?) in
            print("inside CDYelpBusiness")

            let business = business
            print("business?.price \(business?.price)")
            
            let notificationName = NSNotification.Name(rawValue: "BussinessUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["business": business as! CDYelpBusiness?])

            
        }
    }
    
    
    
    

    
    func searchQueryWith(location: CLLocation, term: String, completionHandler: @escaping ([CDYelpBusiness]?, Error?) -> Void) {
       /* let query = YLPQuery(coordinate: YLPCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        query.term = term
        query.limit = 20
        //query.radiusFilter = 25
        query.sort = YLPSortType.distance
        var category = Category(term: term)
        query.categoryFilter = category.getCategoryList()
        print("apiClient in searchQueryWith \(apiClient)")*/
        
        print("term \(term)")
        

        apiClient?.searchBusinesses(byTerm: term, location: nil, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, radius: 40000, categories: nil, locale: nil, limit: 50, offset: 0, sortBy: CDYelpSortType.distance, priceTiers: nil, openNow: nil, openAt: nil, attributes: nil) { (response: CDYelpSearchResponse?, error: Error?) in
            
            let businesses = response?.businesses
            completionHandler(businesses, nil)
            
            let notificationName = NSNotification.Name(rawValue: "BussinessesDidUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["businesses": businesses as! [CDYelpBusiness]?])
            
            for b in businesses! {
                log.info ("====? "+b.name!)
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
}


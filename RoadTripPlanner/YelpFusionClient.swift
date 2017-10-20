//
//  YelpFusionClient.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/17/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import YelpAPI
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
    
    func search(withLocation location: CLLocation, term: String) {
        let ylpCoordinate = YLPCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let query = YLPQuery(coordinate: ylpCoordinate)
        query.categoryFilter = ["servicestations", "evchargingstations"]
        query.limit = 20
        query.offset = 0
        query.sort = YLPSortType.distance
        
        yelpClient?.search(with: query, completionHandler: { (search: YLPSearch?, error: Error?) in
            if error != nil {
                log.error(error ?? "Unknown Error Occurred")
            } else {
                let businesses = search?.businesses
                log.info(businesses?.count ?? 0)
                
                for b in businesses! {
                    log.info (b.name)
                    log.info (b.location)
                    let categories = b.categories
                    for category in categories {
                        log.info("Category: \(category.name)")
                    }
                }
            }
        })
        
//        yelpClient?.search(with: ylpCoordinate, term: term, limit: 20, offset: 0, sort: YLPSortType.distance, completionHandler: { (search: YLPSearch?, error: Error?) in
//            if error != nil {
//                log.error(error ?? "Unknown Error Occurred")
//            } else {
//                let businesses = search?.businesses
//                log.info(businesses?.count ?? 0)
//
//                for b in businesses! {
//                    log.info (b.name)
//                    log.info (b.location)
//                    let categories = b.categories
//                    for category in categories {
//                        log.info("Category: \(category.name)")
//                    }
//                }
//            }
//        })
    }
}


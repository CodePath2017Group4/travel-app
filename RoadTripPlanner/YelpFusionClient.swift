//
//  YelpFusionClient.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/17/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import YelpAPI

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
    
    func search(withLocation location: String, term: String) {
        yelpClient?.search(withLocation: location, term: term, limit: 20, offset: 0, sort: YLPSortType.bestMatched, completionHandler: { (search: YLPSearch?, error: Error?) in
            let businesses = search?.businesses
            log.info(businesses?.count ?? 0)
            
            for b in businesses! {
                log.info (b.name)
            }
        })
    }
}


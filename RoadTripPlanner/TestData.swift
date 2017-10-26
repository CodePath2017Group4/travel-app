//
//  TestData.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/21/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class TestData : NSObject{
    
    private let santaMonica = TripSegment(name: "Loews Santa Monica Beach Hotel",
                                          address: "1700 Ocean Ave, Santa Monica, CA 90401",
                                          location: CLLocation(latitude: 34.0091821, longitude: -118.4936843))
    
    private let universalStudios = TripSegment(name: "Universal Studios Hollywood",
                                               address: "100 Universal City Plaza, Universal City, CA 91608",
                                               location: CLLocation(latitude: 34.1381168, longitude: -118.3555723))
    
    private let harrisRanch = TripSegment(name: "Harris Ranch Inn & Restaurant",
                                          address: "24505 W Dorris Ave, Coalinga, CA 93210",
                                          location: CLLocation(latitude: 36.2536897, longitude: -120.2395319))
    
    private let ghiradelli = TripSegment(name: "Ghirardelli Square",
                                         address: "North Point Street, San Francisco, CA",
                                         location: CLLocation(latitude: 37.8058763, longitude: -122.4251442))
    
    private let facebook = TripSegment(name: "Facebook Headquarters",
                                       address: "1 Hacker Way, Menlo Park, CA 94025",
                                       location: CLLocation(latitude: 37.4845317, longitude: -122.1496421))
    
    private let apple = TripSegment(name: "Apple Infinite Loop",
                                    address: "1 Infinite Loop, Cupertino, CA 95014",
                                    location: CLLocation(latitude: 37.3316756, longitude: -122.032383))
    
    private let goldenGate = TripSegment(name: "Golden Gate Bridge",
                                         address: "Golden Gate Bridge, San Francisco, CA 94129",
                                         location: CLLocation(latitude: 37.8199328, longitude: -122.4804491))
    
    private let googleplex = TripSegment(name: "Googleplex",
                                         address: "1600 Amphitheatre Pkwy, Mountain View, CA 94043",
                                         location: CLLocation(latitude: 37.4219999, longitude: -122.0862462))
    
    private let mysteryHouse = TripSegment(name: "Winchester Mystery House",
                                           address: "525 S Winchester Blvd, San Jose, CA 95128",
                                           location: CLLocation(latitude: 37.369212, longitude: -121.8963867))
    
    private var segments: [TripSegment]!

    override init() {
        super.init()
        
        segments = [santaMonica, universalStudios, harrisRanch, ghiradelli, facebook, apple, goldenGate, googleplex, mysteryHouse]
    }
    
    func randomlySelectedTripSegment() -> TripSegment {
        let randomIndex = Int(arc4random_uniform(UInt32(segments.count)))
        return segments[randomIndex]
    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    func buildObjects(completion: @escaping ([Trip]?, Error?) -> Void) {
        var trips: [Trip] = []
        var users: [PFUser] = []
        
        // Create some trips for this user
        let currentUser = PFUser.current()!
        let date = generateRandomDate(daysBack: 20)!
        log.info("date selected: \(date)")
        let trip = Trip.createTrip(name: "\(currentUser.username!)'s Trip", date: date, creator: currentUser)
        
        trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
        trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
        trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
        
        // Add this user as a member to another member's trip
        ParseBackend.getUsers { (results, error) in
            if error == nil {
                users = results!
                
                let filtered = users.filter({ (user) -> Bool in
                    return !(user.username == "Deepthy" || user.username == "dr28" || user.username == "ntest1")
                })
                
//                for user in filtered {
//
//                    log.info(user.username!)
//
//                    if user.username! == "Deepthy" || user.username! == "dr28" || user.username! == "ntest1" {
//                        continue
//                    }
//
//                    // Create some trips for this user
//                    let date = self.generateRandomDate(daysBack: 20)!
//                    log.info("date selected: \(date)")
//                    let trip = Trip(name: "\(user.username!)'s Trip", date: Date(), creator: user)
//
//                    trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
//                    trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
//                    trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
//
//                    // Add some trip members
//                    for _ in 1...3 {
//                        let randomIndex = Int(arc4random_uniform(UInt32(filtered.count)))
//                        let randomUser = filtered[randomIndex]
//
//                        let tripMember = TripMember(user: randomUser, trip: trip)
//                        let status = Int(arc4random_uniform(3))
//                        if status == 0 {
//                            tripMember.setStatus(status: InviteStatus.Pending)
//                        } else if status == 1 {
//                            tripMember.setStatus(status: InviteStatus.Confirmed)
//                        } else {
//                            tripMember.setStatus(status: InviteStatus.Rejected)
//                        }
//
//                        tripMember.saveInBackground(block: { (success, error) in
//                            if (error != nil) {
//                                log.error(error!)
//                            } else {
//                                log.info("Trip Member saved: \(randomUser.username) on \(trip.name)")
//                            }
//                        })
//                    }
//                }
                
                let randomIndex = Int(arc4random_uniform(UInt32(filtered.count)))
                let randomUser = filtered[randomIndex]
                let trip = Trip.createTrip(name: "\(randomUser.username!)'s Trip", date: Date(), creator: randomUser)
                
                trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
                trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
                trip.addSegment(tripSegment: self.randomlySelectedTripSegment())
                
                // Add the current user as a trip member
                let tripMember = TripMember(user: currentUser, isCreator:false, trip: trip)
                
                let status = Int(arc4random_uniform(3))
                if status == 0 {
                    tripMember.setStatus(status: InviteStatus.Pending)
                } else if status == 1 {
                    tripMember.setStatus(status: InviteStatus.Confirmed)
                } else {
                    tripMember.setStatus(status: InviteStatus.Rejected)
                }
                
                tripMember.saveInBackground(block: { (success, error) in
                    if (error != nil) {
                        log.error(error!)
                    } else {
                        log.info("Trip Member saved: \(currentUser.username) on \(trip.name)")
                        trips.append(trip)
                        completion(trips, nil)
                    }
                })

                
            } else {
                log.error(error!)
                completion(nil, error)
            }
        }
    }
}

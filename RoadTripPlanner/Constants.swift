//
//  Contants.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/18/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

struct Constants {
    
    struct StoryboardIdentifiers {
        
    }
    
    struct ViewControllerIdentifiers {
        static let AlbumsNavigationController = "PhotoGallery"
        static let ProfileNavigationController = "Profile"
        static let TripsNavigationController = "LandingPage"
    }
    
    struct NotificationNames {
        static let LogoutPressedNotification = Notification.Name("LogoutPressedNotification")
    }
    
    struct ReuseableCellIdentifiers {
        static let TripSegmentCell = "TripSegmentCell"
    }
}

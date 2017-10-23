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
        static let TripModifiedNotification = Notification.Name("TripModifiedNotification")
    }
    
    struct ReuseableCellIdentifiers {
        static let TripSegmentCell = "TripSegmentCell"
        static let LocationSearchResultCell = "LocationSearchResultCell"
    }
    
    struct PrefabricatedEmailMessage {
        static let TripInvitationEmail = "Hey!<br><br> I recently started using Roadtripplanner to save my trip itinerary and capture my adventures as beautiful stories! Roadtripplanner allows to plan trips as a group. I have been enjoying the app so far and I would like to invite you to try it. More importantly I would like you to join me from early as trip planning to creating a beautiful memory together. <br><br> Let's hit the road. 🚗"
    }
}

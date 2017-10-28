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
        static let TripTableViewCell = "TripTableViewCell"
        static let FriendUserCell = "FriendUserCell"
        static let TripCollectionViewCell = "TripCollectionViewCell"
    }
    
    struct NibNames {
        static let TripTableViewCell = "TripTableViewCell"
        static let TripCollectionViewCell = "TripCollectionViewCell"
    }
    
    struct PrefabricatedEmailMessage {
        static let TripInvitationEmail = "Hey!<br><br> I recently started using Roadtripplanner to save my trip itinerary and capture my adventures as beautiful stories! Roadtripplanner allows to plan trips as a group. I have been enjoying the app so far and I would like to invite you to try it. More importantly I would like you to join me from early as trip planning to creating a beautiful memory together. <br><br> Let's hit the road. 🚗"
    }
    
    struct BusinessLabels {
        static let reviewLabel = "review"
        static let reviewsLabel = reviewLabel + "s"

    struct Colors {
        static let ButtonBackgroundColor = #colorLiteral(red: 0.128070116, green: 0.2497186661, blue: 0.3288468122, alpha: 1)        
        static let ViewBackgroundColor = #colorLiteral(red: 0.3147298992, green: 0.5574474335, blue: 0.7487674356, alpha: 1)
        static let NavigationBarDarkTintColor = #colorLiteral(red: 0.3147298992, green: 0.5574474335, blue: 0.7487674356, alpha: 1)
        static let NavigationBarLightTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let TextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        static let ColorPalette3314Color1 = #colorLiteral(red: 0.128070116, green: 0.2497186661, blue: 0.3288468122, alpha: 1)
        static let ColorPalette3314Color2 = #colorLiteral(red: 0.3147298992, green: 0.5574474335, blue: 0.7487674356, alpha: 1)
        static let ColorPalette3314Color3 = #colorLiteral(red: 0.8, green: 0.8588235294, blue: 0.9176470588, alpha: 1)
        static let ColorPalette3314Color4 = #colorLiteral(red: 0.9686265588, green: 0.9647503495, blue: 0.9645444751, alpha: 1)
        static let ColorPalette3314Color5 = #colorLiteral(red: 0.8603140116, green: 0.5897349119, blue: 0.6455273032, alpha: 1)
        
        static let ColorPalette3495Color1 = #colorLiteral(red: 0.4225752056, green: 0.4821543694, blue: 0.1652031243, alpha: 1)
        static let ColorPalette3495Color2 = #colorLiteral(red: 0.2797974348, green: 0.3562029898, blue: 0.4063227177, alpha: 1)
        static let ColorPalette3495Color3 = #colorLiteral(red: 0.6396746039, green: 0.7436213493, blue: 0.8436312079, alpha: 1)
        static let ColorPalette3495Color4 = #colorLiteral(red: 0.9606800675, green: 0.9608443379, blue: 0.9606696963, alpha: 1)
        static let ColorPalette3495Color5 = #colorLiteral(red: 0.5059583187, green: 0.4975892305, blue: 0.5223559737, alpha: 1)
        
        
    }
}

//
//  TripCollectionViewCell.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/27/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TripCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tripNameLabel: UILabel!
//    @IBOutlet weak var tripDescriptionLabel: UILabel!
    @IBOutlet weak var tripCoverPhoto: PFImageView!
    
//    @IBOutlet weak var tripCreatorImageView: PFImageView!
    
    var trip: Trip! {
        didSet {
            
//            tripCreatorImageView.image = #imageLiteral(resourceName: "user")
            tripCoverPhoto.image = #imageLiteral(resourceName: "trip_placeholder")
            
            tripNameLabel.text = trip.name
//            tripDescriptionLabel.text = ""
//            let creator = trip.creator
//            let avatarFile = creator.object(forKey: "avatar") as? PFFile
//            if avatarFile != nil {
//                tripCreatorImageView.file = avatarFile
//                tripCreatorImageView.loadInBackground()
//            }
            
            guard let coverPhoto = trip.coverPhoto else {
                tripCoverPhoto.image = #imageLiteral(resourceName: "trip_placeholder")
                return
            }
            tripCoverPhoto.file = coverPhoto
            tripCoverPhoto.loadInBackground()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        tripCreatorImageView.layer.cornerRadius = tripCreatorImageView.frame.size.height / 2
//        tripCreatorImageView.clipsToBounds = true
//        tripCreatorImageView.layer.borderColor = UIColor.white.cgColor
//        tripCreatorImageView.layer.borderWidth = 2.0
        
        tripCoverPhoto.clipsToBounds = true
    }
    
}

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

    @IBOutlet weak var tripCoverPhoto: PFImageView!
    
    var trip: Trip! {
        didSet {
            
            tripCoverPhoto.image = nil
            
            tripNameLabel.text = trip.name

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
        
        tripCoverPhoto.clipsToBounds = true
    }
    
}

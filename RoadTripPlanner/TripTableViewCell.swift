//
//  TripTableViewCell.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/22/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripDescriptionLabel: UILabel!
    @IBOutlet weak var tripBackgroundImageView: UIImageView!
    @IBOutlet weak var tripCreatorImageView: UIImageView!
    
    var trip: Trip! {
        didSet {
            tripNameLabel.text = trip.name
            tripDescriptionLabel.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tripCreatorImageView.layer.cornerRadius = tripCreatorImageView.frame.size.height / 2
        tripCreatorImageView.clipsToBounds = true
        tripCreatorImageView.layer.borderColor = UIColor.white.cgColor
        tripCreatorImageView.layer.borderWidth = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

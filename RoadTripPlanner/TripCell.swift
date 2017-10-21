//
//  TripCell.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/10/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {
    
    @IBOutlet weak var tripImageView: UIImageView!
    
    @IBOutlet weak var tripTitleLabel: UILabel!
    
    @IBOutlet weak var profileImg1: UIImageView!
    
    @IBOutlet weak var profileImg2: UIImageView!
    
    @IBOutlet weak var profileImg3: UIImageView!

    
    var tripCell: TripCell! {
        didSet {
            
            if let tripTitle = tripCell.tripTitleLabel {
                
            }
                    }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tripImageView.image = UIImage(named: "sf")
        tripImageView?.layer.cornerRadius = 3.0
        tripImageView?.layer.masksToBounds = true
        
        profileImg1.layer.cornerRadius = profileImg1.frame.height / 2

        profileImg2.layer.cornerRadius = profileImg2.frame.height / 2

        profileImg3.layer.cornerRadius = profileImg3.frame.height / 2

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

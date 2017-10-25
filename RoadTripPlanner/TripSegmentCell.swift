//
//  TripSegmentCell.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/19/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class TripSegmentCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var includeSwitch: UISwitch!
    
    var tripSegment: TripSegment! {
        didSet {
            
            tripSegment.fetchIfNeededInBackground { (object, error) in
                if error == nil {
                    let segment = object as! TripSegment
                    DispatchQueue.main.async {
                        self.placeNameLabel.text = segment.name
                        self.placeAddressLabel.text = segment.address
                        self.distanceLabel.text = ""
                                                
                    }
                } else {
                    self.placeNameLabel.text = ""
                    self.placeAddressLabel.text = ""
                    self.distanceLabel.text = ""
                    
                    log.error(error!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeNameLabel.preferredMaxLayoutWidth = placeNameLabel.frame.size.width
        placeAddressLabel.preferredMaxLayoutWidth = placeAddressLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
    
    }
}

//
//  TripInAlbumCell.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/21/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit

class TripSummaryCell: UITableViewCell {

    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setTrip(trip: Trip) {
        tripLabel.text = trip.name
        dateLabel.text = Utils.formatDate(date: trip.date!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

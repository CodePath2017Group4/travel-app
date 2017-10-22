//
//  LocationSearchResultCell.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/22/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchResultCell: UITableViewCell {
    
   
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultSubtitleLabel: UILabel!
    
    var searchCompletionResult: MKLocalSearchCompletion! {
        didSet {
            resultTitleLabel.text = searchCompletionResult.title
            resultSubtitleLabel.text = searchCompletionResult.subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

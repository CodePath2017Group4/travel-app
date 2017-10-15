//
//  TripDetailsCell.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

@objc protocol TripDetailsCellDelegate {
    
    @objc optional func tripDetailsCell(tripDetailsCell: TripDetailsCell, didComment tripStopLabel: UILabel)
    
}

class TripDetailsCell: UITableViewCell {

    @IBOutlet weak var tripStopLabel: UILabel!
    
    @IBOutlet weak var isTripIncluded: UISwitch!
    
    @IBOutlet weak var tripMilesLabel: UILabel!
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var tripSeparatorImage: UIImageView!
    var tripDetailsCell: TripDetailsCell! {
        didSet {
            
            
        }
    }
    
    weak var delegate: TripDetailsCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        let commentButtonTap = UITapGestureRecognizer(target: self, action: #selector(commentButtonTapped))
        commentButtonTap.numberOfTapsRequired = 1
        commentImageView?.isUserInteractionEnabled = true
        commentImageView?.addGestureRecognizer(commentButtonTap)
        

    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commentButtonTapped() {
        delegate?.tripDetailsCell!(tripDetailsCell: self, didComment: self.tripStopLabel)
        
    }

}

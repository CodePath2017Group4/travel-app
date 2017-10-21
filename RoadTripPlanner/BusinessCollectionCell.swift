//
//  BusinessCollectionCell.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import YelpAPI
import AFNetworking

class BusinessCollectionCell: UICollectionViewCell {
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    
    var business: YLPBusiness! {
        didSet {
            businessName.text = business.name
            imageView?.clipsToBounds = true
            
            if let businessImageUrl = business.imageURL {
                imageView?.setImageWith(businessImageUrl)
            }
            
            let ratingsCount = business.rating
            
            if ratingsCount >= 4  {
                ratingsCountLabel.backgroundColor = UIColor.green
            }
            else if ratingsCount >= 3 && ratingsCount < 4 {
                ratingsCountLabel.backgroundColor = UIColor.green
            }
            else {
                ratingsCountLabel.backgroundColor = UIColor.yellow
            }
                
            ratingsCountLabel.text = "\(business.rating)"
            
        }
    }
}

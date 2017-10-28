//
//  BusCell.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/26/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import YelpAPI
import AFNetworking
import CDYelpFusionKit

class BusCell: UICollectionViewCell {

    let detailView = DetailView(frame: CGRect.zero)
    
    // @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    
    var business: CDYelpBusiness! {
        didSet {
            businessName.text = business.name
            // imageView?.clipsToBounds = true
            
            if let businessImageUrl = business.imageUrl {
                //     imageView?.setImageWith(businessImageUrl)
                let backgroundImageView = UIImageView()
                let backgroundImage = UIImage()
                backgroundImageView.setImageWith(businessImageUrl)
                self.backgroundView = backgroundImageView//setImageWith(businessImageUrl)
                backgroundView?.contentMode = .scaleAspectFill
                backgroundView?.clipsToBounds = true

            }
            
            let ratingsCount = business.rating
            
            if !(ratingsCount?.isLess(than: 4.0))!  {
                ratingsCountLabel.backgroundColor = UIColor.green
            }
            else if !(ratingsCount?.isLess(than: 3.0))! && (ratingsCount?.isLess(than: 4.0))! {
                ratingsCountLabel.backgroundColor = UIColor.green
            }
            else {
                ratingsCountLabel.backgroundColor = UIColor.yellow
            }
            
            ratingsCountLabel.text = "\(business.rating!)"
            
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        //contentView.addSubview(detailView)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
     /*   let screenBounds = UIScreen.main.bounds
        let scale = bounds.width / screenBounds.width
        
        detailView.transitionProgress = 1
        detailView.frame = screenBounds
        detailView.transform = CGAffineTransform(scaleX: scale, y: scale)
        detailView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)*/
    }
}

//
//  BusinessDetailView.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/26/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

@IBDesignable class BusinessDetailView: UIView {
    
    
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var right: UIButton!
    
    @IBOutlet weak var reviewImage: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "BusinessBottomSheetViewController", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
       // contentView.frame = bounds
        // draggableImgView = draggableImgView(frame: CGRect(x: 0, y: 20, width: contentView.bounds.width, height: 200))
        
        //addSubview(contentView)
        
    }

}

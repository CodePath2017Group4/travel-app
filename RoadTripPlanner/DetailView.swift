//
//  DetailView.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/26/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

@IBDesignable class DetailView: UIView {

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
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    
    var transitionProgress: CGFloat = 0 {
        didSet {
            updateViews()
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.655, green: 0.737, blue: 0.835, alpha: 0.8)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    func updateViews() {
        let progress = min(max(transitionProgress, 0), 1)
        let antiProgress = 1.0 - progress
        
        let titleLabelOffsetTop: CGFloat = 20.0
        let titleLabelOffsetMiddle: CGFloat = bounds.height/2 - 44
        let titleLabelOffset = transitionProgress * titleLabelOffsetMiddle + antiProgress * titleLabelOffsetTop
        
        let subtitleLabelOffsetTop: CGFloat = 64
        let subtitleLabelOffsetMiddle: CGFloat = bounds.height/2
        let subtitleLabelOffset = transitionProgress * subtitleLabelOffsetMiddle + antiProgress * subtitleLabelOffsetTop
        
        titleLabel.frame = CGRect(x: 0, y: titleLabelOffset, width: bounds.width, height: 44)
        subtitleLabel.preferredMaxLayoutWidth = bounds.width
        subtitleLabel.frame = CGRect(x: 0, y: subtitleLabelOffset, width: bounds.width, height: subtitleLabel.font.lineHeight)
        imageView.alpha = progress
    }
    
    func setup() {
        addSubview(imageView)
        addSubview(overlayView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        clipsToBounds = true
        
        titleLabel.text = "Title of Business"
        //subtitleLabel.text = "Description of Business"
        imageView.image = UIImage(named: "sf")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        overlayView.frame = bounds
        updateViews()
    }

}

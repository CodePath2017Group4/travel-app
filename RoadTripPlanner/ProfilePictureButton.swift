//
//  ProfilePictureButton.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/16/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfilePictureButton: UIButton {

    var pictureCropping: FBSDKProfilePictureMode?
    var profileId: String?
    var profilePictureView: FBSDKProfilePictureView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSubviews()
    }
    
    fileprivate func initSubviews() {
        profilePictureView = FBSDKProfilePictureView(frame: self.bounds)
        profilePictureView?.layer.cornerRadius = self.bounds.size.width / 2
        profilePictureView?.clipsToBounds = true
        profilePictureView?.isUserInteractionEnabled = false
        insertSubview(profilePictureView!, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profilePictureView?.frame = self.bounds
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

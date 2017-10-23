//
//  Utils.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Foundation
import Parse
import UIKit

class Utils {
    class func formatDate(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(month)/\(day)/\(year)"
    }
    
    class func roundImageCorner(image: UIImageView) {
        image.layer.cornerRadius = image.frame.height / 2
    }
    
    class func imageToFile(image: UIImage) -> PFFile? {
        let data = UIImageJPEGRepresentation(image, 0.7)
        return PFFile(data: data!)
    }
    
    class func fileToImage(file: PFFile, callback: @escaping (UIImage) -> Void) {
        file.getDataInBackground(block: { (data, error) -> Void in
            if (error == nil) {
                if let data = data {
                    callback(UIImage(data: data)!)
                }
            }
        })
    }
}

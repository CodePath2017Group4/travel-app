//
//  Utils.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Foundation

class Utils {
    class func formatDate(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(month)/\(day)/\(year)"
    }
}

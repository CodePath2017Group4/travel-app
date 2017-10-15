//
//  CreateTripViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import DatePickerDialog

class CreateTripViewController: UIViewController {

    @IBOutlet weak var dateImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var clockImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateImageTap = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        dateImageTap.numberOfTapsRequired = 1
        dateImageView.isUserInteractionEnabled = true
        dateImageView.addGestureRecognizer(dateImageTap)
        
        
        let clockImageTap = UITapGestureRecognizer(target: self, action: #selector(clockTapped))
        clockImageTap.numberOfTapsRequired = 1
        clockImageView.isUserInteractionEnabled = true
        clockImageView.addGestureRecognizer(clockImageTap)
    }

    func dateTapped(_ sender: AnyObject) {
        DatePickerDialog(showCancelButton: false).show("Select Travel Date", doneButtonTitle: "Done", datePickerMode: .date) {

            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.dateLabel.text = formatter.string(from: dt)
            }
        }
        
    }
    
    func clockTapped(_ sender: UITapGestureRecognizer) {
        
    }
}

//
//  TripsDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/12/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
        
    @IBOutlet weak var emailGroupImageView: UIImageView!
    
    @IBOutlet weak var tripSettingsImageView: UIImageView!
    
    let tripStops = ["Mountain View, CA", "Shell, Menlo Park, CA", "San Fancisco, CA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        navigationController?.navigationBar.isHidden = true
        
        let emailGroupImageTap = UITapGestureRecognizer(target: self, action: #selector(emailGroupImageTapped))
        emailGroupImageTap.numberOfTapsRequired = 1
        emailGroupImageView.isUserInteractionEnabled = true
        emailGroupImageView.addGestureRecognizer(emailGroupImageTap)
        
        let tripSettingsImageTap = UITapGestureRecognizer(target: self, action: #selector(tripSettingsImageTapped))
        tripSettingsImageTap.numberOfTapsRequired = 1
        tripSettingsImageView.isUserInteractionEnabled = true
        tripSettingsImageView.addGestureRecognizer(tripSettingsImageTap)

    }
    
    func tripSettingsImageTapped(_ sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tripSettingsViewController = storyboard.instantiateViewController(withIdentifier: "TripSettings") as! UINavigationController
        self.navigationController?.pushViewController(tripSettingsViewController.topViewController!, animated: true)
        
    }
    
    func emailGroupImageTapped(_ sender: AnyObject) {
        
        
    }
}

extension TripDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsCell") as! TripDetailsCell
        cell.tripStopLabel.text = tripStops[indexPath.row]
        cell.tripSeparatorImage.isHidden = indexPath.row + 1 == tripStops.count
        cell.tripMilesLabel.isHidden = indexPath.row + 1 == tripStops.count
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    
    
}

// MARK: - TripDetailsCellDelegate
extension TripDetailsViewController: TripDetailsCellDelegate {
    
    func tripDetailsCell(tripDetailsCell: TripDetailsCell, didComment tripStopLabel: UILabel) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compmentsViewController = storyboard.instantiateViewController(withIdentifier: "compose") as! CommentsViewController
        
        self.navigationController?.pushViewController(compmentsViewController, animated: true)
    }
}




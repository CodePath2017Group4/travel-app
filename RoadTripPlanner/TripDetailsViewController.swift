//
//  TripsDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/12/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AFNetworking

class TripDetailsViewController: UIViewController {
    
    @IBOutlet weak var tripPhotoImageView: UIImageView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var emailGroupImageView: UIImageView!
    
    @IBOutlet weak var tripSettingsImageView: UIImageView!
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    var trip: Trip?
    
    let tripStops = ["Mountain View, CA", "Shell, Menlo Park, CA", "San Fancisco, CA"]
    
    static func storyboardInstance() -> TripDetailsViewController? {
        let storyboard = UIStoryboard(name: "TripDetailsViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? TripDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3.0
        
        if trip != nil {
            guard let trip = trip else { return }
            
            let creator = trip.creator
            let avatarFile = creator?.object(forKey: "avatar") as! PFFile
            profileImageView.file = avatarFile
            profileImageView.loadInBackground()
            
            tripNameLabel.text = trip.name
            
            setTripCoverPhoto()
            
            guard let tripSegments = trip.segments else { return }
            for segment in tripSegments {
                log.info(segment.name)
                log.info(segment.address)
            }
        }
    }
    
    fileprivate func setTripCoverPhoto() {
        let destination = trip?.segments?.last
        let location = CLLocation(latitude: (destination?.geoPoint?.latitude)!, longitude: (destination?.geoPoint?.longitude)!)
        YelpFusionClient.sharedInstance.search(withLocation: location, term: "landmarks", completion: { (businesses, error) in
            if error == nil {
                guard let results = businesses else {
                    return
                }
                log.verbose("num landmark results: \(results.count)")
                
                let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                let b = results[randomIndex]
                
                if let imageURL = b.imageURL {
                    log.info(imageURL)
                    
                    let imageRequest = URLRequest(url: imageURL)
                    self.tripPhotoImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                        if imageResponse != nil {
                            self.tripPhotoImageView.alpha = 0.0
                            self.tripPhotoImageView.image = image
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                self.tripPhotoImageView.alpha = 0.8
                            })
                        }
                    }, failure: { (request, response, error) in
                        log.error(error)
                    })
                    
                }
                
            } else {
                log.error(error ?? "unknown error occurred")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)        
    }
    
    @IBAction func tripSettingButtonPressed(_ sender: Any) {
    }
    
    @IBAction func albumButtonPressed(_ sender: Any) {
    }
    
    func tripSettingsImageTapped(_ sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tripSettingsViewController = storyboard.instantiateViewController(withIdentifier: "TripSettings") as! UINavigationController
        self.navigationController?.pushViewController(tripSettingsViewController.topViewController!, animated: true)
        
    }
    
    func albumImageTapped(_ sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let albumDetailsViewController = storyboard.instantiateViewController(withIdentifier: "AlbumDetails") as! AlbumDetailsViewController
        self.navigationController?.pushViewController(albumDetailsViewController, animated: true)
        
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




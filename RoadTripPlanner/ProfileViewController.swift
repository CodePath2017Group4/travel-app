//
//  ProfileViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, AddPhotoDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var tripsSummaryTable: UITableView!
    
    @IBOutlet weak var numAlbumsLabel: UILabel!
    @IBOutlet weak var numTripsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var trips: [Trip] = []
    
    //@IBOutlet weak var editPhotoButton: UIButton!
    //@IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileButton.layer.cornerRadius = profileButton.frame.size.height / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.layer.borderWidth = 3.0
        
        self.tripsSummaryTable.delegate = self
        self.tripsSummaryTable.dataSource = self
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarDarkTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarDarkTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.title = "Profile"

        let tripTableViewCellNib = UINib(nibName: Constants.NibNames.TripTableViewCell, bundle: nil)
        tripsSummaryTable.register(tripTableViewCellNib, forCellReuseIdentifier: Constants.ReuseableCellIdentifiers.TripTableViewCell)

        
        if PFUser.current() != nil {
            userNameLabel.text = PFUser.current()?.username
            let avatarFile = PFUser.current()?.object(forKey: "avatar") as? PFFile
            if avatarFile != nil {
                Utils.fileToImage(file: avatarFile!, callback: { (avatarImage: UIImage) in
                    self.profileButton.setBackgroundImage(avatarImage, for: .normal)
                })
            } else {
                self.profileButton.setBackgroundImage(UIImage(named: "user"), for: .normal)
            }
            
            
            requestTrips()
            requestAlbums()
            
        } else {
            userNameLabel.text = "Anonymous User"
            self.profileButton.setBackgroundImage(UIImage(named: "user"), for: .normal)
            self.numAlbumsLabel.text = "0"
            self.numTripsLabel.text = "0"
        }
    }
    
    // Make sure this request is not done on the main UI thread.
    private func requestAlbums() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseBackend.getAlbums(completionHandler: { (albums, error) in
                if albums != nil {
                    DispatchQueue.main.async {
                        let count = albums!.count
                        self.numAlbumsLabel.text = "\(count)"
                    }
                }
            })
        }
    }
    
    private func requestTrips() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseBackend.getTrips(completionHandler: { (trips, error) in
                if trips != nil {
                    
//                    self.trips = trips!
                    
                    DispatchQueue.main.async {
                        self.numTripsLabel.text = "\(trips!.count)"
                    }
                }
            })
        }
        
        ParseBackend.getTripsForUser(user: PFUser.current()!, areUpcoming: false) { (trips, error) in
            if error == nil {
                log.info("past trips count: \(trips!.count)")
                self.trips = trips!
                DispatchQueue.main.async {
                    self.tripsSummaryTable.reloadData()
                }
            } else {
                log.error(error!)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onProfileButtonTapped(_ sender: Any) {
        let vc = PhotoViewController.getVC()
        vc.delegate = self
        self.show(vc, sender: self)
    }
    
    func addPhoto(image: UIImage?) {
        if let image = image {
            profileButton.setBackgroundImage(image, for: .normal)
            
            let avatar = Utils.imageToFile(image: image)
            PFUser.current()!.setObject(avatar!, forKey: "avatar")
            PFUser.current()!.saveInBackground { (success, error) in
                if success {
                    log.info("Avatar updated")
                } else {
                    guard let error = error else {
                        log.error("Unknown error occurred saving avatar image")
                        return
                    }
                    log.error("Error saving avatar image: \(error)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as! TripSummaryCell
//        cell.setTrip(trip: trips[indexPath.row])
//        return cell
        
        let tripCell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.TripTableViewCell, for: indexPath) as! TripTableViewCell
        tripCell.trip = trips[indexPath.row]
        return tripCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

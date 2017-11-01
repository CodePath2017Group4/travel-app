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
//    @IBOutlet weak var tripsSummaryTable: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
//        self.tripsSummaryTable.delegate = self
//        self.tripsSummaryTable.dataSource = self
        
        let tripCollectionViewCellNib = UINib(nibName: Constants.NibNames.TripCollectionViewCell, bundle: nil)
        collectionView.register(tripCollectionViewCellNib, forCellWithReuseIdentifier: Constants.ReuseableCellIdentifiers.TripCollectionViewCell)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Add "Pull to refresh"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarDarkTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarDarkTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.title = "Profile"

//        let tripTableViewCellNib = UINib(nibName: Constants.NibNames.TripTableViewCell, bundle: nil)
//        tripsSummaryTable.register(tripTableViewCellNib, forCellReuseIdentifier: Constants.ReuseableCellIdentifiers.TripTableViewCell)
        
        self.numAlbumsLabel.text = "0"
        self.numTripsLabel.text = "0"
        
        if PFUser.current() != nil {
            userNameLabel.text = PFUser.current()?.username
            let avatarFile = PFUser.current()?.object(forKey: "avatar") as? PFFile
            if avatarFile != nil {
                Utils.fileToImage(file: avatarFile!, callback: { (avatarImage: UIImage) in
                    self.profileButton.setImage(avatarImage, for: .normal)
                })
            } else {
                self.profileButton.setImage(UIImage(named: "user"), for: .normal)
            }
            
            requestTripsAndAlbums(nil)
            
        } else {
            userNameLabel.text = "Anonymous User"
            self.profileButton.setBackgroundImage(UIImage(named: "user"), for: .normal)
        }
        
        registerForNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarDarkTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarDarkTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        print("refresh!")
        requestTripsAndAlbums(refreshControl)
    }
    
    private func stopRefreshing(_ refreshControl: UIRefreshControl?) {
        if let refreshControl = refreshControl {
            refreshControl.endRefreshing()
        }
    }
    
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tripWasModified(notification:)),
                                               name: Constants.NotificationNames.TripModifiedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tripDeleted(notification:)),
                                               name: Constants.NotificationNames.TripDeletedNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tripFromNotification(notification: NSNotification) -> Trip? {
        let info = notification.userInfo
        let trip = info!["trip"] as! Trip
        let tripId = trip.objectId!
        
        let matchingTrips = trips.filter { (trip) -> Bool in
            return trip.objectId == tripId
        }
        
        return matchingTrips.first
    }
    
    func tripWasModified(notification: NSNotification) {
        
        guard let trip = tripFromNotification(notification: notification) else {
            return
        }
        
        let index = trips.index(of: trip)
        guard let idx = index else { return }
        
        // replace the trip with the new trip
        trips[idx] = trip
        
        // reload the trips
        collectionView.reloadData()
        
    }
    
    func tripDeleted(notification: NSNotification) {
        
        guard let trip = tripFromNotification(notification: notification) else {
            return
        }
        
        let index = trips.index(of: trip)
        guard let idx = index else { return }

        // Remove the deleted trip from the trips array
        trips.remove(at: idx)
        
        self.numTripsLabel.text = "\(trips.count)"
        
        // Reload the collection view
        collectionView.reloadData()
    }
    
    private func requestTripsAndAlbums(_ refreshControl: UIRefreshControl?) {
        ParseBackend.getTripsForUser(user: PFUser.current()!, areUpcoming: false, onlyConfirmed: true) { (trips, error) in
            self.stopRefreshing(refreshControl)
            if error == nil {
                log.info("past trips count: \(trips!.count)")
                self.trips = trips!
                self.numTripsLabel.text = "\(trips!.count)"
                DispatchQueue.main.async {
                    //self.tripsSummaryTable.reloadData()
                    self.collectionView.reloadData()
                }
                ParseBackend.getAlbumsOnTrips(trips: trips!) { (albums, error) in
                    self.numAlbumsLabel.text = "\(albums!.count)"
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
            self.profileButton.setImage(image, for: .normal)
            
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
        if  trips.isEmpty {
            
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "You dont have any trips."
            messageLabel.textColor = UIColor.gray
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()
            self.collectionView.backgroundView = messageLabel
            self.collectionView.backgroundView?.isHidden = false
            
        }
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let tripCell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.TripTableViewCell, for: indexPath) as! TripTableViewCell
        tripCell.trip = trips[indexPath.row]
        return tripCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseableCellIdentifiers.TripCollectionViewCell, for: indexPath)  as! TripCollectionViewCell
        cell.backgroundColor = UIColor.darkGray
        cell.trip = trips[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        log.info("Selected cell at \(indexPath)")
        
        let trip = trips[indexPath.row]
        log.info("Selected trip \(trip.name ?? "none")")
        
        let tripDetailsVC = TripDetailsViewController.storyboardInstance()
        tripDetailsVC?.trip = trip
        navigationController?.pushViewController(tripDetailsVC!, animated: true)
        
    }
}

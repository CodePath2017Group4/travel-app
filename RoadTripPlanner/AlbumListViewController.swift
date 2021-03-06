//
//  AlbumListViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse
import UIKit

class AlbumListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddAlbumDelegate, DeleteAlbumDelegate, UpdateAlbumDelegate {

    var albums: [Album] = []
    var trips: [Trip] = []
    
    @IBOutlet weak var albumsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumsTable.delegate = self
        albumsTable.dataSource = self
        albumsTable.tableFooterView = UIView()

        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarDarkTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarDarkTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Add "Pull to refresh"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        albumsTable.insertSubview(refreshControl, at: 0)
        
//        fakeAlbums()
        requestTripsAndAlbums(nil)
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
    
    private func requestTripsAndAlbums(_ refreshControl: UIRefreshControl?) {
        if let user = PFUser.current() {
            ParseBackend.getTripsForUser(user: user, areUpcoming: false, onlyConfirmed: true) { (trips, error) in
                if error == nil {
                    self.trips = trips!
                    print("I have \(trips!.count) trips")
                    
                    if (trips?.isEmpty)! {
                        self.stopRefreshing(refreshControl)
                    }
                    ParseBackend.getAlbumsOnTrips(trips: trips!) { (albums, error) in
                        self.stopRefreshing(refreshControl)
                        if error == nil {
                            print("I have \(albums!.count) albums")
                            self.albums = albums!
                            DispatchQueue.main.async {
                                self.albumsTable.reloadData()
                            }
                        } else {
                            log.error("Error fetching albums: \(error!)")
                        }
                    }
                } else {
                    self.stopRefreshing(refreshControl)
                    log.error("Error fetching trips: \(error!)")
                }
            }
        } else {
            self.trips = []
        }
    }
    
    private func fakeAlbums() {
        let user = PFUser.current()!
        let date = Date()
        let trip = Trip.createTrip(name: "Bay Area", date: date, creator: user)
        trips.append(trip)
        
        let album = Album(albumName: "San Francisco", albumDescription: "Tour in San Francisco", trip: trip, owner: user)
        
        var photos: [UIImage] = [
            UIImage(named: "sf")!,
            UIImage(named: "profile1")!,
            UIImage(named: "profile2")!,
            UIImage(named: "profile3")!]
        for image in photos {
            let file = Utils.imageToFile(image: image)
            if let file = file {
                album.photos.append(file)
            }
        }

        for _ in 0...6 {
            albums.append(album)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if albums.count == 0 {
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "No albums available. Pleaae pull down to refresh"
            messageLabel.textColor = UIColor.gray
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()
            self.albumsTable.backgroundView = messageLabel
            self.albumsTable.backgroundView?.isHidden = false
        } else {
            self.albumsTable.backgroundView?.isHidden = true

        }
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumCell
        cell.displayAlbum(album: albums[indexPath.row])
        cell.albumIndex = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumDetailsVC = AlbumDetailsViewController.getVC()
        albumDetailsVC.album = Album()
        albumDetailsVC.album!.updated(copyFrom: self.albums[indexPath.row])
        albumDetailsVC.albumIndex = indexPath
        albumDetailsVC.delegate = self
        tableView.deselectRow(at: indexPath, animated: true)
        show(albumDetailsVC, sender: self)
    }
    
    func addAlbum(album: Album) {
        let newAlbum = Album()
        newAlbum.updated(copyFrom: album)
        self.albums.append(newAlbum)
        newAlbum.saveInBackground { (success, error) in
            if success {
                log.info("Album \(album.albumName) added")
            } else {
                guard let error = error else {
                    log.error("Unknown error occurred adding album \(album.albumName)")
                    return
                }
                log.error("Error adding album \(album.albumName): \(error)")
            }
        }
        self.albumsTable.reloadData()
    }
    
    func deleteAlbum(album: Album, indexPath: IndexPath) {
        if (album.owner == nil || PFUser.current() == nil || album.owner!.username != PFUser.current()!.username) {
            let alertController = UIAlertController(title: "Request denied", message: "You don't have permission to remove the album.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            
            self.present(alertController, animated: true)
        } else {
            print("delete albums \(indexPath.row)")
            let realAlbum = self.albums[indexPath.row]
            self.albums.remove(at: indexPath.row)
            realAlbum.deleteInBackground { (success, error) in
                if success {
                    log.info("Album \(realAlbum.albumName) deleted")
                } else {
                    guard let error = error else {
                        log.error("Unknown error occurred deleting album \(realAlbum.albumName)")
                        return
                    }
                    log.error("Error deleting album \(realAlbum.albumName): \(error)")
                }
            }
            self.albumsTable.reloadData()
        }
    }
    
    func updateAlbum(album: Album, indexPath: IndexPath?) {
        // TODO: should use @album
        if let indexPath = indexPath {
            print("updating albums \(indexPath.row)")
            self.albums[indexPath.row].updated(copyFrom: album)
            self.albums[indexPath.row].saveInBackground { (success, error) in
                if success {
                    log.info("Album \(album.albumName) updated")
                } else {
                    guard let error = error else {
                        log.error("Unknown error occurred updating album \(album.albumName)")
                        return
                    }
                    log.error("Error updating album \(album.albumName): \(error)")
                }
            }
            self.albumsTable.reloadData()
        }
    }
    
    @IBAction func addAlbumTapped(_ sender: UIButton) {
        let addAlbumVC = AddAlbumViewController.getVC()
        addAlbumVC.addAlbumDelegate = self
        addAlbumVC.shouldAddAlbum = true
        addAlbumVC.trips = self.trips
        show(addAlbumVC, sender: self)
    }
}

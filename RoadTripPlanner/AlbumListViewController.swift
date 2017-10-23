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
        
        fakeAlbums()
    }
    
    private func fakeAlbums() {
        let user = PFUser.current()!
        // SF
        
        let date = Date()
        let trip = Trip(name: "Bay Area", date: date, creator: user)
        trips.append(trip)
        
        let album = Album(albumName: "San Francisco", albumDescription: "Tour in San Francisco", trip: trip, owner: user)
        
        var photos: [UIImage] = [
            UIImage(named: "sf")!,
            UIImage(named: "profile1")!,
            UIImage(named: "profile2")!,
            UIImage(named: "profile3")!,
            UIImage(named: "profile1")!,
            UIImage(named: "profile2")!,
            UIImage(named: "profile3")!,
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
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsTable.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumCell
        cell.displayAlbum(album: albums[indexPath.row])
        cell.albumIndex = indexPath
        cell.delegate = self
        albumsTable.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumDetailsVC = AlbumDetailsViewController.getVC()
        albumDetailsVC.album = Album(copyFrom: self.albums[indexPath.row])
        albumDetailsVC.albumIndex = indexPath
        albumDetailsVC.delegate = self
        albumsTable.deselectRow(at: indexPath, animated: true)
        show(albumDetailsVC, sender: self)
    }
    
    func addAlbum(album: Album) {
        self.albums.append(Album(copyFrom: album))
        self.albumsTable.reloadData()
    }
    
    func deleteAlbum(album: Album, indexPath: IndexPath) {
        // TODO: should use @album
        print("delete albums \(indexPath.row)")
        self.albums.remove(at: indexPath.row)
        self.albumsTable.reloadData()
    }
    
    func updateAlbum(album: Album, indexPath: IndexPath?) {
        // TODO: should use @album
        if let indexPath = indexPath {
            print("updating albums \(indexPath.row)")
            self.albums[indexPath.row] = Album(copyFrom: album)
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

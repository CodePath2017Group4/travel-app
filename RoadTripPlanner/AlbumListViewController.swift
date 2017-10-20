//
//  AlbumListViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse
import UIKit

class AlbumListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var albums: [Album] = []
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
        let point = PFGeoPoint(latitude: 37.773972, longitude: -122.431297)
        let date = Date()
        let trip = Trip(name: "Bay Area", date: date, startPoint: point, destinationPoint: point, creator: user)
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
            let data = UIImageJPEGRepresentation(image, 0.7)
            if let file = PFFile(data: data!) {
                album.photos.append(file)
            }
        }

        for _ in 0...10 {
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
        cell.setSelected(false, animated: true)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        if vc is AlbumDetailsViewController {
            let albumDetailsVC = vc as! AlbumDetailsViewController
            let indexPath = albumsTable.indexPath(for: sender as! AlbumCell)!
            albumDetailsVC.album = Album(copyFrom: self.albums[indexPath.row])
        }
    }
}

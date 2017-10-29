//
//  NewAlbumViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/21/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Parse
import UIKit

class AddAlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var albumNameText: UITextField!
    @IBOutlet weak var albumDescriptionText: UITextView!
    @IBOutlet weak var tripTable: UITableView!

    // if @shouldAddAlbum == false, we will update the album instead
    var shouldAddAlbum: Bool = true
    var addAlbumDelegate: AddAlbumDelegate?
    
    var album: Album?
    var updateAlbumDelegate: UpdateAlbumDelegate?
    
    var selectedTripIndex: IndexPath?
    var selectedTrip: Trip?
    var trips: [Trip] = []
    
    static func getVC() -> AddAlbumViewController {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let addAlbumVC = storyboard.instantiateViewController(withIdentifier: "AddAlbumVC") as! AddAlbumViewController
        return addAlbumVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!shouldAddAlbum) {
            if let album = album {
                albumNameText.text = album.albumName
                albumDescriptionText.text = album.albumDescription
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addAlbumTapped))
        
        albumDescriptionText.layer.borderWidth = 1
        albumDescriptionText.layer.borderColor = UIColor.black.cgColor
        
        tripTable.delegate = self
        tripTable.dataSource = self
        tripTable.reloadData()
        
        albumNameText.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let prevIndex = selectedTripIndex {
            tableView.deselectRow(at: prevIndex, animated: false)
        }
        selectedTripIndex = indexPath
        selectedTrip = trips[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as! TripSummaryCell
        cell.setTrip(trip: trips[indexPath.row])
        return cell
    }

    func addAlbumTapped(_ sender: Any) {
        if (shouldAddAlbum) {
            if let selectedTrip = self.selectedTrip {
                let album = Album(albumName: albumNameText.text!, albumDescription: albumDescriptionText.text!, trip: selectedTrip, owner: PFUser.current()!)
                if let delegate = self.addAlbumDelegate {
                    delegate.addAlbum(album: album)
                }
                navigationController?.popViewController(animated: true)
            }
        } else {
            if let album = self.album {
                album.albumName = albumNameText.text!
                album.albumDescription = albumDescriptionText.text!
                if let delegate = self.updateAlbumDelegate {
                    delegate.updateAlbum(album: album, indexPath: nil)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
}

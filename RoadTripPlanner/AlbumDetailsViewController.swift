//
//  AlbumDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse
import UIKit

class AlbumDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AddPhotoDelegate {
    var album: Album?
    var albumIndex: IndexPath?

    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userImage1: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    @IBOutlet weak var userImage3: UIImageView!
    
    @IBOutlet weak var photoCollections: UICollectionView!
    
    var delegate: UpdateAlbumDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let album = album {
            navigationItem.title = album.albumName
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera-icon"), style: .plain, target: self, action: #selector(cameraTapped))
        
            for image in [userImage1, userImage2, userImage3] {
                image?.layer.cornerRadius = image!.frame.height / 2
            }
            descriptionLabel.text = album.albumDescription
            if let trip = album.trip {
                tripLabel.text = trip.name
                dateLabel.text = Utils.formatDate(date: trip.date!)
            }
        }
        photoCollections.delegate = self
        photoCollections.dataSource = self
        
        photoCollections.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let album = album {
            return album.photos.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.photoCollections.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        if let album = album {
            cell.photoImage.image = UIImage(named: "album-default")
            album.photos[indexPath.row].getDataInBackground(block: { (data, error) -> Void in
                if (error == nil) {
                    if let data = data {
                        cell.photoImage.image = UIImage(data: data)
                    }
                }
            })
        }
        return cell
    }
    
    func addPhoto(image: UIImage?) {
        print("add photo?")
        if let image = image {
            if let album = self.album {
                print("add photo")
                let data = UIImageJPEGRepresentation(image, 0.7)
                album.photos.append(PFFile(data: data!)!)
                self.photoCollections.reloadData()
                
                if let delegate = self.delegate {
                    delegate.updateAlbum(album: album, indexPath: self.albumIndex!)
                }
            }
        }
    }
    
    func cameraTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Photo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "photoVC") as! PhotoViewController
        vc.delegate = self
        self.show(vc, sender: nil)
    }
}

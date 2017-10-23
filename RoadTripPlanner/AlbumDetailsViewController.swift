//
//  AlbumDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse
import UIKit

class AlbumDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AddPhotoDelegate, UpdateAlbumDelegate {
    
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userImage1: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    @IBOutlet weak var userImage3: UIImageView!
    
    @IBOutlet weak var photoCollections: UICollectionView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var mode: AlbumEditMode = .View
    
    var album: Album?
    var albumIndex: IndexPath?
    var photoSelected: [Bool] = []
    var delegate: UpdateAlbumDelegate?
    
    static func getVC() -> AlbumDetailsViewController {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let albumDetailsVC = storyboard.instantiateViewController(withIdentifier: "AlbumDetailsVC") as! AlbumDetailsViewController
        return albumDetailsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mode = .View
        Utils.roundImageCorner(image: leftButton.imageView!)
        Utils.roundImageCorner(image: rightButton.imageView!)
        
        self.setAlbumMetadata()
        photoCollections.delegate = self
        photoCollections.dataSource = self
        
        setState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setAlbumMetadata() {
        if let album = album {
            navigationItem.title = album.albumName
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera-icon"), style: .plain, target: self, action: #selector(cameraTapped))
            
            for image in [userImage1, userImage2, userImage3] {
                Utils.roundImageCorner(image: image!)
            }
            descriptionLabel.text = album.albumDescription
            if let trip = album.trip {
                tripLabel.text = trip.name
                dateLabel.text = Utils.formatDate(date: trip.date)
            }
        }
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
            Utils.fileToImage(file: album.photos[indexPath.row], callback: { (image: UIImage) -> Void in
                cell.photoImage.image = image
                if (self.mode == .PhotoEdit && self.photoSelected[indexPath.row]) {
                    cell.backgroundView = UIImageView(image: UIImage(named: "frame"))
                } else {
                    cell.backgroundView = nil
                }
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        if (mode == .View) {
            if let album = self.album {
                let vc = PhotoGalleryViewController.getVC()
                vc.photos = album.photos
                vc.defaultIndex = indexPath.row
                self.show(vc, sender: nil)
            }
        } else if (mode == .PhotoEdit) {
            if (!photoSelected[indexPath.row]) {
                photoSelected[indexPath.row] = true
                cell.backgroundView = UIImageView(image: UIImage(named: "frame"))
            } else {
                photoSelected[indexPath.row] = false
                cell.backgroundView = nil
            }
        }
    }
    
    func addPhoto(image: UIImage?) {
        if let image = image {
            if let album = self.album {
                let file = Utils.imageToFile(image: image)
                album.photos.append(file!)
                self.photoSelected.append(false)
                self.photoCollections.reloadData()
                
                if let delegate = self.delegate {
                    delegate.updateAlbum(album: album, indexPath: self.albumIndex)
                }
            }
        }
    }
    
    func cameraTapped(_ sender: Any) {
        let vc = PhotoViewController.getVC()
        vc.delegate = self
        self.show(vc, sender: nil)
    }
    
    func updateAlbum(album: Album, indexPath: IndexPath?) {
        if self.album == nil {
            self.album = Album()
        }
        self.album!.updated(copyFrom: album)
        self.delegate?.updateAlbum(album: album, indexPath: self.albumIndex)
        self.setAlbumMetadata()
    }
    
    private func setState() {
        if (mode == .View) {
            leftButton.setTitle("Edit Album", for: .normal)
            rightButton.setTitle("Edit Photos", for: .normal)
            if let album = album {
                photoSelected = []
                if album.photos.count > 0 {
                    for _ in 0 ... album.photos.count - 1 {
                        photoSelected.append(false)
                    }
                }
                self.photoCollections.reloadData()
            }
        } else if (mode == .PhotoEdit) {
            leftButton.setTitle("Cancel", for: .normal)
            rightButton.setTitle("Remove", for: .normal)
        }
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        if (mode == .View) {
            // Edit Album
            if let album = self.album {
                let addAlbumVC = AddAlbumViewController.getVC()
                // set the edit mode
                addAlbumVC.shouldAddAlbum = false
                addAlbumVC.updateAlbumDelegate = self
                addAlbumVC.album = album
                addAlbumVC.trips = [album.trip!]
                show(addAlbumVC, sender: self)
            }
        } else if (mode  == .PhotoEdit) {
            // Cancel
            mode = .View
            setState()
        }
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        if (mode == .View) {
            // Edit Photo
            mode = .PhotoEdit
            setState()
        } else if (mode == .PhotoEdit) {
            // Delete Photos
            if let album = self.album {
                var photos: [PFFile] = []
                for i in 0 ... photoSelected.count - 1 {
                    if (!photoSelected[i]) {
                        photos.append(album.photos[i])
                    }
                }
                album.photos = photos
                if let delegate = self.delegate {
                    delegate.updateAlbum(album: album, indexPath: self.albumIndex!)
                }
                
                mode = .View
                self.album = album
                setState()
            }
        }
    }
}

enum AlbumEditMode {
    case View
    case PhotoEdit
}

//
//  AlbumDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import Parse
import UIKit

class AlbumDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddPhotoDelegate, UpdateAlbumDelegate {
    
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userImage1: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    @IBOutlet weak var userImage3: UIImageView!
    
    @IBOutlet weak var numPeopleLabel: UILabel!
    
    @IBOutlet weak var photoCollections: UICollectionView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var mode: AlbumEditMode = .View
    
    var album: Album?
    var albumIndex: IndexPath?
    var photos: [UIImage] = []
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
        leftButton.layer.cornerRadius = leftButton.frame.height / 3
        rightButton.layer.cornerRadius = leftButton.frame.height / 3
        Utils.roundImageCorner(image: userImage1)
        Utils.roundImageCorner(image: userImage2)
        Utils.roundImageCorner(image: userImage3)
        
        photoCollections.delegate = self
        photoCollections.dataSource = self
        
        self.setAlbumMetadata()
        self.setUserAvatar()
        self.setPhotos()
        self.setState()
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
    
    private func getImage(_ id: Int) -> UIImageView? {
        if (id == 0) {
            return self.userImage1
        } else if (id == 1) {
            return self.userImage2
        } else if (id == 2) {
            return self.userImage3
        }
        return nil
    }
    
    private func setUserAvatar() {
        if let album = self.album {
            let trips: [Trip] = [album.trip!]
            print("setUserAvatar for \(album.trip!)")
            ParseBackend.getTripMemberOnTrips(trips: trips, excludeCreator: false) {
                (tripMember, error) in
                if let tripMember = tripMember {
                    print("setUserAvatar, tripMember \(tripMember)")
                    print("setUserAvatar, owner \(album.trip!.creator)")
                    self.numPeopleLabel.text = "\(tripMember.count) people"
                    var numAvatarShown = 3
                    if (tripMember.count < numAvatarShown) {
                        numAvatarShown = tripMember.count
                        for i in tripMember.count ... 2 {
                            self.getImage(i)!.isHidden = true
                        }
                    }
                    
                    for i in  0 ... numAvatarShown - 1 {
                        self.getImage(i)!.image = #imageLiteral(resourceName: "user")
                        if let file = tripMember[i].user.object(forKey: "avatar") as? PFFile {
                            Utils.fileToImage(file: file) {
                                avatar in self.getImage(i)!.image = avatar
                            }
                        }
                    }
                } else {
                    print("Error to get past invitations: \(error)")
                }
            }
        }
    }
    
    private func setPhotos() {
        self.photos = []
        if let album = self.album {
            if (album.photos.count > 0) {
                for i in 0 ... (album.photos.count - 1) {
                    let image = UIImage(named: "album-default")
                    self.photos.append(image!)
                    Utils.fileToImage(file: album.photos[i], callback: { (image: UIImage) -> Void in
                        self.photos[i] = image
                        self.photoCollections.reloadData()
                    })
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor((collectionView.frame.size.width  - 2 * 3) / 2) - 3
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.photoCollections.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.photoImage.image = self.photos[indexPath.row]
        if (self.mode == .PhotoEdit && self.photoSelected[indexPath.row]) {
            cell.backgroundView = UIImageView(image: UIImage(named: "frame"))
        } else {
            cell.backgroundView = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        if (mode == .View) {
            let vc = PhotoGalleryViewController.getVC()
            vc.photos = self.photos
            vc.defaultIndex = indexPath.row
            self.show(vc, sender: nil)
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
                self.photos.append(image)
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
                    for _ in 0 ... self.photos.count - 1 {
                        photoSelected.append(false)
                    }
                }
                print("reload data \(album.photos.count)")
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
                mode = .View
                if (photoSelected.count == 0) {
                    setState()
                    return
                }
                var files: [PFFile] = []
                var updatedPhotos: [UIImage] = []
                for i in 0 ... photoSelected.count - 1 {
                    if (!photoSelected[i]) {
                        files.append(album.photos[i])
                        updatedPhotos.append(self.photos[i])
                    }
                }
                self.album!.photos = files
                self.photos = updatedPhotos
                
                setState()
                if let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.updateAlbum(album: self.album!, indexPath: self.albumIndex!)
                    }
                }
            }
        }
    }
}

enum AlbumEditMode {
    case View
    case PhotoEdit
}

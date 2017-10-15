//
//  AlbumDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var userImage1: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    @IBOutlet weak var userImage3: UIImageView!
    
    @IBOutlet weak var photoCollections: UICollectionView!
    
    var photos: [UIImage] = [
        UIImage(named: "profile1")!, UIImage(named: "profile2")!, UIImage(named: "profile3")!,
        UIImage(named: "profile1")!, UIImage(named: "profile2")!, UIImage(named: "profile3")!,
        UIImage(named: "profile1")!, UIImage(named: "profile2")!, UIImage(named: "profile3")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BBQ"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera-icon"), style: .plain, target: self, action: #selector(cameraTapped))
        
        for image in [userImage1, userImage2, userImage3] {
            image?.layer.cornerRadius = image!.frame.height / 2
        }
        
        tripLabel.text = "Bay Area"
        let fromDate = "05/01/2017"
        let toDate = "05/07/2017"
        dateLabel.text = "\(fromDate) - \(toDate)"
        photoCollections.delegate = self
        photoCollections.dataSource = self
        
        photoCollections.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.photoCollections.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.photoImage.image = self.photos[indexPath.row]
        //let originalFrame = cell.photoImage.frame
        //cell.photoImage.frame = CGRect(x: originalFrame.minX, y: originalFrame.minY, width: originalFrame.width, height: originalFrame.height * image!.size.width / originalFrame.width)
        //cell.photoImage.frame.size
        //cell.photoImage.sizeToFit()
        return cell
    }
    
    func cameraTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "photoVC") as! PhotoViewController
        self.show(vc, sender: nil)
    }
}

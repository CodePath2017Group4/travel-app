//
//  AlbumCell.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    
    @IBOutlet weak var deleteViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var deleteView: UIView!
    
    var delegate: DeleteAlbumDelegate?
    var albumIndex: IndexPath?
    var album: Album?
    
    var panRecognizer: UIPanGestureRecognizer?
    
    func displayAlbum(album: Album) {
        hideDelete()
        
        self.album = Album(copyFrom: album)
        albumImage.image = UIImage(named: "album-default")
        
        if (album.photos.count > 0) {
            album.photos[0].getDataInBackground(block: { (data, error) -> Void in
                if (error == nil) {
                    if let data = data {
                        self.albumImage.image = UIImage(data: data)
                    }
                }
            })
        }
        
        albumLabel.text = album.albumName
        if let owner = album.owner {
            createdByLabel.text = owner.username
        }
        if let trip = album.trip {
            tripLabel.text = trip.name
            if let date = trip.date {
                dateLabel.text = Utils.formatDate(date: date)
            } else {
                dateLabel.text = "unknown"
            }
        }
    }
    
    func hideDelete() {
        deleteViewTrailing.constant = -deleteView.frame.width
    }
    
    func showDelete() {
        deleteViewTrailing.constant = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panThisCell))
        self.panRecognizer!.delegate = self
        self.contentView.addGestureRecognizer(self.panRecognizer!)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func panThisCell(_ sender: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = sender.location(in: self)
        if sender.state == .began {
            print("Gesture began at: \(point)")
        } else if sender.state == .changed {
            let velocity = sender.velocity(in: self)
            if (velocity.x < 0) {
                // LEFT
                UIView.animate(withDuration: 0.5, animations: self.showDelete)
            } else if (velocity.x > 0){
                // RIGHT
                UIView.animate(withDuration: 0.5, animations: self.hideDelete)
            }
        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteAlbumTapped(_ sender: Any) {
        guard self.delegate != nil && self.album != nil && self.albumIndex != nil else {
            return
        }
        self.delegate!.deleteAlbum(album: self.album!, indexPath: self.albumIndex!)
    }
}

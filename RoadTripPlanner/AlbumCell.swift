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
    
    func displayAlbum(album: Album) {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

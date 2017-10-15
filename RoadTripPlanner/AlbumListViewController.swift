//
//  AlbumListViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class AlbumListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var albumsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumsTable.delegate = self
        albumsTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsTable.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumCell
        cell.albumImage.image = UIImage(named: "sf")
        cell.albumLabel.text = "San Francisco"
        cell.tripLabel.text = "Bay Area"
        cell.createdByLabel.text = "Nanxi"
        let fromDate = "05/01/2017"
        let toDate = "05/07/2017"
        cell.dateLabel.text = "\(fromDate) - \(toDate)"
        cell.setSelected(false, animated: true)
        return cell
    }
}

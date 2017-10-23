//
//  FriendsListViewController.swift
//  RoadTripPlanner
//
//  Created by Diana Fisher on 10/23/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import UIKit
import Parse

class FriendsListViewController: UIViewController {

    static func storyboardInstance() -> FriendsListViewController? {
        let storyboard = UIStoryboard(name: "FriendsListViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? FriendsListViewController
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var friends = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1605131328, green: 0.6328189969, blue: 0.6140672565, alpha: 1)
        let textAttributes = [NSForegroundColorAttributeName:#colorLiteral(red: 0.1605131328, green: 0.6328189969, blue: 0.6140672565, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.title = "Friends"
        
        ParseBackend.getUsers { (users, error) in
            if error == nil {
                for user in users! {
                    log.info(user.username!)
                }
                self.friends = users!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                log.error(error!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.FriendUserCell, for: indexPath) as! FriendUserCell
        cell.user = friends[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

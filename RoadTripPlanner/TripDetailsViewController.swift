//
//  TripsDetailsViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/12/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AFNetworking
import MessageUI

class TripDetailsViewController: UIViewController {
    
    @IBOutlet weak var tripPhotoImageView: UIImageView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var emailGroupImageView: UIImageView!
    @IBOutlet weak var editTableButton: UIButton!
    @IBOutlet weak var addStopButton: UIButton!
    @IBOutlet weak var addFriendsButton: UIButton!
    
    @IBOutlet weak var tripSettingsImageView: UIImageView!
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    var trip: Trip?
    
    var tripSegments: [TripSegment] = []
    
    static func storyboardInstance() -> TripDetailsViewController? {
        let storyboard = UIStoryboard(name: "TripDetailsViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? TripDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3.0
        
        registerForNotifications()
        
        if trip != nil {
            guard let trip = trip else { return }
            
            let creator = trip.creator
            
            let avatarFile = creator?.object(forKey: "avatar") as? PFFile
            if avatarFile != nil {
                profileImageView.file = avatarFile
                profileImageView.loadInBackground()                
            }
            
            tripNameLabel.text = trip.name
            
            setTripCoverPhoto()
            
            guard let segments = trip.segments else { return }
            self.tripSegments = segments
            
        }
    }
        
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TripDetailsViewController.tripWasModified(notification:)),
                                               name: Constants.NotificationNames.TripModifiedNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tripWasModified(notification: NSNotification) {
        let info = notification.userInfo
        let trip = info!["trip"] as! Trip
        
        // Update the trip segments and reload the table view
        self.tripSegments = trip.segments!
        self.tableView.reloadData()
    }
    
    fileprivate func setTripCoverPhoto() {
        let destination = trip?.segments?.last
        let location = CLLocation(latitude: (destination?.geoPoint?.latitude)!, longitude: (destination?.geoPoint?.longitude)!)
        YelpFusionClient.sharedInstance.search(withLocation: location, term: "landmarks", completion: { (businesses, error) in
            if error == nil {
                guard let results = businesses else {
                    return
                }
                log.verbose("num landmark results: \(results.count)")
                
                let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                let b = results[randomIndex]
                
                if let imageURL = b.imageURL {
                    log.info(imageURL)
                    
                    let imageRequest = URLRequest(url: imageURL)
                    self.tripPhotoImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                        if imageResponse != nil {
                            self.tripPhotoImageView.alpha = 0.0
                            self.tripPhotoImageView.image = image
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                self.tripPhotoImageView.alpha = 0.8
                            })
                        }
                    }, failure: { (request, response, error) in
                        log.error(error)
                    })
                    
                }
                
            } else {
                log.error(error ?? "unknown error occurred")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)        
    }
    
    // MARK: - IBAction methods
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editTableButton.setTitle("  Edit", for: .normal)
            editTableButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            tableView.setEditing(true, animated: true)
            editTableButton.setTitle("  Done", for: .normal)
            let doneColor = UIColor(red: 234/255.0, green: 76/255.0, blue: 28/255.0, alpha: 1)
            editTableButton.setTitleColor(doneColor, for: .normal)
        }
        
        // Disable other buttons if we are editing the table.
        addStopButton.isEnabled = !tableView.isEditing
        addFriendsButton.isEnabled = !tableView.isEditing
    }
    
    @IBAction func tripSettingButtonPressed(_ sender: Any) {
    }
    
    @IBAction func albumButtonPressed(_ sender: Any) {
    }
    
    @IBAction func addFriendsButtonPressed(_ sender: Any) {
        let friendsVC = FriendsListViewController.storyboardInstance()
        navigationController?.pushViewController(friendsVC!, animated: true)
    }
    
    
    @IBAction func addStopButtonPressed(_ sender: Any) {
        
        // Present the AddStopViewController modally.
        guard let addStopVC = AddStopViewController.storyboardInstance() else { return }
        addStopVC.trip = trip
        
        present(addStopVC, animated: true, completion: nil)
    }
    
    func tripSettingsImageTapped(_ sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tripSettingsViewController = storyboard.instantiateViewController(withIdentifier: "TripSettings") as! UINavigationController
        self.navigationController?.pushViewController(tripSettingsViewController.topViewController!, animated: true)
        
    }
    
    func albumImageTapped(_ sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let albumDetailsViewController = storyboard.instantiateViewController(withIdentifier: "AlbumDetails") as! AlbumDetailsViewController
        self.navigationController?.pushViewController(albumDetailsViewController, animated: true)
        
    }
    
    func emailImageTapped(_ sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([])
        
        if #available(iOS 11.0, *) {
            let fromEmail = trip?.creator?.email != nil ? "\((trip?.creator?.email)!)" : ""
            mailComposerVC.setPreferredSendingEmailAddress("\(fromEmail)")
        }

        var emailSubject = User.currentUser?.userName != nil ? "\((User.currentUser?.userName)!)'s" :""
        emailSubject += trip?.name != nil ? "\((trip?.name)!)" : "My Road Trip"
        mailComposerVC.setSubject("\(emailSubject) !")
        mailComposerVC.setMessageBody("\(Constants.PrefabricatedEmailMessage.TripInvitationEmail)", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(
            title: "Could Not Send Email",
            message: "Your device could not send Email. Please check Email configuration and try again.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TripDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripSegments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.TripSegmentCell, for: indexPath) as! TripSegmentCell
        cell.tripSegment = tripSegments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Let all cells be reordered.
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tripSegmentToMove = tripSegments[sourceIndexPath.row]
        
        tripSegments.remove(at: sourceIndexPath.row)
        tripSegments.insert(tripSegmentToMove, at: destinationIndexPath.row)
    }
    
}

// MARK: - TripDetailsCellDelegate
extension TripDetailsViewController: TripDetailsCellDelegate {
    
    func tripDetailsCell(tripDetailsCell: TripDetailsCell, didComment tripStopLabel: UILabel) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compmentsViewController = storyboard.instantiateViewController(withIdentifier: "compose") as! CommentsViewController
        
        self.navigationController?.pushViewController(compmentsViewController, animated: true)
    }
}

extension TripDetailsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}




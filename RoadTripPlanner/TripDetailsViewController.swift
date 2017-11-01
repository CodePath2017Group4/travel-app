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
import MapKit

class TripDetailsViewController: UIViewController {
        
    @IBOutlet weak var coverPhotoImageView: PFImageView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var tripDateLabel: UILabel!
    
    @IBOutlet weak var emailGroupImageView: UIImageView!
    @IBOutlet weak var editTableButton: UIButton!
    @IBOutlet weak var addStopButton: UIButton!
    @IBOutlet weak var addFriendsButton: UIButton!    
    @IBOutlet weak var viewOnMapButton: UIButton!
    
    @IBOutlet weak var tripSettingsImageView: UIImageView!
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    var trip: Trip?
    
    static func storyboardInstance() -> TripDetailsViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        
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
        
        // Make the navigation bar completely transparent.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        
        navigationController?.navigationBar.tintColor = Constants.Colors.ColorPalette3314Color4
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.ColorPalette3314Color4]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "md_settings"), style: .plain, target: self, action: #selector(tripSettingButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "md_home"), style: .plain, target: self, action: #selector(homeButtonPressed(_:)))
        
        registerForNotifications()
        
        guard let trip = trip else { return }
        setUserInterfaceValues(trip: trip)
        
    }
    
    fileprivate func setUserInterfaceValues(trip: Trip) {
        let creator = trip.creator
        
        let tripDate = trip.date
        tripDateLabel.text = Utils.formatDate(date: tripDate)
        
        let avatarFile = creator.object(forKey: "avatar") as? PFFile
        if avatarFile != nil {
            profileImageView.file = avatarFile
            profileImageView.loadInBackground()
        }
        
        tripNameLabel.text = trip.name
        
        if let coverPhotoFile = trip.coverPhoto {
            coverPhotoImageView.file = coverPhotoFile
            coverPhotoImageView.loadInBackground()
        }
        
        tableView.reloadData()
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
        
        setUserInterfaceValues(trip: trip)
    }
    
    fileprivate func loadLandmarkImageFromDesitination(location: CLLocation) {
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
                    self.coverPhotoImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                        if imageResponse != nil {
                            self.coverPhotoImageView.alpha = 0.0
                            self.coverPhotoImageView.image = image

                            let coverImageFile = Utils.imageToFile(image: image)!
                            self.trip?.setCoverPhoto(file: coverImageFile)
                            self.trip?.saveInBackground()

                            UIView.animate(withDuration: 0.3, animations: {
                                self.coverPhotoImageView.alpha = 0.8
                            })
                        }
                    }, failure: { (request, response, error) in
                        self.coverPhotoImageView.image = #imageLiteral(resourceName: "trip_placeholder")
                        log.error(error)
                    })
                }
            } else {
                log.error(error ?? "unknown error occurred")
                self.coverPhotoImageView.image = #imageLiteral(resourceName: "trip_placeholder")
            }
        })
    }

    fileprivate func setTripCoverPhoto() {
        let destination = trip?.segments?.last
        destination?.fetchInBackground(block: { (object, error) in
            if error == nil {
                let location = CLLocation(latitude: (destination?.geoPoint?.latitude)!, longitude: (destination?.geoPoint?.longitude)!)
                self.loadLandmarkImageFromDesitination(location: location)
            } else {
                log.error(error!)
            }
        })
    }
    
    fileprivate func saveChanges() {
        guard let trip = self.trip else { return }
        trip.saveInBackground(block: { (success, error) in
            if error == nil {
                log.info("Trip save success: \(success)")
                
                
            } else {
                log.error("Error saving trip: \(error!)")
            }
        })
    }
    
    // MARK: - IBAction methods
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editTableButton.setTitle(" Edit", for: .normal)
            editTableButton.setTitleColor(UIColor.white, for: .normal)
            saveChanges()
        } else {
            tableView.setEditing(true, animated: true)
            editTableButton.setTitle(" Done", for: .normal)
            let doneColor = UIColor(red: 234/255.0, green: 76/255.0, blue: 28/255.0, alpha: 1)
            editTableButton.setTitleColor(doneColor, for: .normal)
        }
        
        // Disable other buttons if we are editing the table.
        addStopButton.isEnabled = !tableView.isEditing
        addFriendsButton.isEnabled = !tableView.isEditing
        viewOnMapButton.isEnabled = !tableView.isEditing
    }
    
    @IBAction func tripSettingButtonPressed(_ sender: Any) {
        
        showAlertController()
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        // Unwind to the root view controller.
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        
        // Create a locations array from the trip segments.  Locations array consists of tuples of UITextFields and MKMapItem objects.
        guard let trip = trip else { return }
        
        var locations: [(textField: UITextField?, mapItem: MKMapItem?)]  = []
        
        if let segments = trip.segments {
            for segment in segments {
                
                let address = segment.address
                
                let lat = segment.geoPoint?.latitude
                let lng = segment.geoPoint?.longitude
                let location = CLLocation(latitude: lat!, longitude: lng!)
                let placemark = MKPlacemark(coordinate: location.coordinate)
                let mapItem = MKMapItem(placemark: placemark) as MKMapItem?
                let textField = UITextField(frame: CGRect.zero) as UITextField?
                textField?.text = address
                let tuple = (textField: textField, mapItem: mapItem)
                locations.append(tuple)
            }
        }
        
        // Launch the map screen.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let routeMapViewController = storyboard.instantiateViewController(withIdentifier: "RouteMapView") as! RouteMapViewController
        routeMapViewController.trip  = trip
        routeMapViewController.locationArray = locations
        routeMapViewController.termCategory = ["restaurant" : ["restaurant"]]
        routeMapViewController.loadTripOnMap = true
        navigationController?.pushViewController(routeMapViewController, animated: true)
    }
    
    @IBAction func addFriendsButtonPressed(_ sender: Any) {
        guard let friendsVC = FriendsListViewController.storyboardInstance() else { return }
        friendsVC.trip = trip
        navigationController?.pushViewController(friendsVC, animated: true)
    }
    
    
    @IBAction func addStopButtonPressed(_ sender: Any) {
        
        // Present the AddStopViewController modally.
        guard let addStopVC = AddStopViewController.storyboardInstance() else { return }
        addStopVC.trip = trip
        
        present(addStopVC, animated: true, completion: nil)
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
            let fromEmail = trip?.creator.email != nil ? "\((trip?.creator.email)!)" : ""
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
    
    // MARK: - UIAlertController action sheet
    func showAlertController() {
        
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: NSLocalizedString("Trip Settings", comment: "Default action"), style: .`default`, handler: { _ in
            log.verbose("Trip Settings selected")
            self.showSettings()
        }))
        
//        alert.addAction(UIAlertAction(title: "Write a Review", style: .default, handler: { _ in
//            log.verbose("Review selected")
//        }))
        
        alert.addAction(UIAlertAction(title: "Delete Trip", style: .destructive, handler: { _ in
            log.verbose("Delete Trip selected")
            self.deleteTrip()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            log.verbose("Cancel selected")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action sheet action handlers
    func showSettings() {
        guard let settingsVC = TripSettingsViewController.storyboardInstance() else { return }
        settingsVC.trip = trip
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func deleteTrip() {
        // Confirm they want the trip deleted.
        let alert = UIAlertController(title: "Delete Trip?", message: "Are you sure you would like to delete this trip?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: { _ in
            log.verbose("No selected")
        })
        
        let confirmAction = UIAlertAction(title: "I'm Sure!", style: .default, handler: { _ in
            log.verbose("Delete confirmed")
            self.trip?.deleteInBackground(block: { (success, error) in
                if error == nil {
                    log.info("Trip deletion success: \(success)")
                    if success {
                        // Post a notification that the trip has been deleted.
                        NotificationCenter.default.post(name: Constants.NotificationNames.TripDeletedNotification, object: nil, userInfo: ["trip": self.trip!])
                        // Return to the previous screen.
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    log.error("Error deleting trip: \(error!)")
                }
            })
        })
        
        alert.addAction(noAction)
        alert.addAction(confirmAction)
        
        alert.preferredAction = noAction
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TripDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trip = self.trip else { return 0 }
        guard let segments = trip.segments else { return 0 }
        return segments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseableCellIdentifiers.TripSegmentCell, for: indexPath) as! TripSegmentCell
        cell.tripSegment = trip?.segments?[indexPath.row]
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
        guard let trip = self.trip else { return }
        guard var segments = trip.segments else { return }
        
        let tripSegmentToMove = segments[sourceIndexPath.row]
        
        segments.remove(at: sourceIndexPath.row)
        segments.insert(tripSegmentToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let trip = self.trip else { return }
        
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            // Remove the segment from the segments array.
            trip.deleteSegment(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            saveChanges()
            
            // Post a notification that the trip has been modified
            NotificationCenter.default.post(name: Constants.NotificationNames.TripModifiedNotification, object: nil, userInfo: ["trip": trip])
        }
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




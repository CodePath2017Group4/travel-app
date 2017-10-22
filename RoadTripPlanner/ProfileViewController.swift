//
//  ProfileViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var tripsSummaryTable: UITableView!
    @IBOutlet weak var numAlbumsLabel: UILabel!
    @IBOutlet weak var numTripsLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 3.0
        
        editPhotoButton.layer.cornerRadius = 5
        
        numAlbumsLabel.text = "0"
        numTripsLabel.text = "0"
        
        if PFUser.current() != nil {
            userNameLabel.text = PFUser.current()?.username
            let avatarFile = PFUser.current()?.object(forKey: "avatar") as? PFFile
            if avatarFile != nil {
                avatarFile?.getDataInBackground(block: { (imageData, error) in
                    if error == nil {
                        let avatarImage = UIImage(data: imageData!)
                        self.profileImage.image = avatarImage
                        
                    }
                })
            } else {
                profileImage.image = #imageLiteral(resourceName: "user")
            }
            
        } else {
            userNameLabel.text = "Anonymous User"
            profileImage.image = #imageLiteral(resourceName: "user")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editPhotoButtonPressed(_ sender: Any) {
        // Instantiate a UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available, so we'll use the photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController

        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Resize image to fit the image view
        let width = profileImage.frame.size.width
        let height = profileImage.frame.size.height
        
        let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.image = editedImage
        
        UIGraphicsBeginImageContext(avatarImageView.frame.size)
        avatarImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Save the edited image as the new user avatar.
        let avatar = PFFile(name: PFUser.current()!.username, data: UIImagePNGRepresentation(resizedImage!)!)
        PFUser.current()!.setObject(avatar!, forKey: "avatar")
        PFUser.current()!.saveInBackground { (success, error) in
            if success {
                log.info("Avatar updated")
            } else {
                guard let error = error else {
                    log.error("Unknown error occurred saving avatar image")
                    return
                }
                log.error("Error saving avatar image: \(error)")
            }
        }
        
        // Dismiss the UIImagePickerController
        dismiss(animated: true) {
            self.profileImage.image = resizedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        log.verbose("Canceled")
    }
}

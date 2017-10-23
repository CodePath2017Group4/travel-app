//
//  ProfileViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, AddPhotoDelegate {
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var tripsSummaryTable: UITableView!
    
    @IBOutlet weak var numAlbumsLabel: UILabel!
    @IBOutlet weak var numTripsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //@IBOutlet weak var editPhotoButton: UIButton!
    //@IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileButton.layer.cornerRadius = profileButton.frame.size.height / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.layer.borderWidth = 3.0
        
        
        numAlbumsLabel.text = "0"
        numTripsLabel.text = "0"
        
        if PFUser.current() != nil {
            userNameLabel.text = PFUser.current()?.username
            let avatarFile = PFUser.current()?.object(forKey: "avatar") as? PFFile
            if avatarFile != nil {
                Utils.fileToImage(file: avatarFile!, callback: { (avatarImage: UIImage) in
                    self.profileButton.setBackgroundImage(avatarImage, for: .normal)
                })
            } else {
                self.profileButton.setBackgroundImage(UIImage(named: "user"), for: .normal)
            }
            
        } else {
            userNameLabel.text = "Anonymous User"
            self.profileButton.setBackgroundImage(UIImage(named: "user"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func onProfileButtonTapped(_ sender: Any) {
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
    */
    
    @IBAction func onProfileButtonTapped(_ sender: Any) {
        let vc = PhotoViewController.getVC()
        vc.delegate = self
        self.show(vc, sender: self)
    }
    
    func addPhoto(image: UIImage?) {
        print("....?")
        if let image = image {
            profileButton.setBackgroundImage(image, for: .normal)
            
            let avatar = Utils.imageToFile(image: image)
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
            
        }
    }
}

/*
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
*/

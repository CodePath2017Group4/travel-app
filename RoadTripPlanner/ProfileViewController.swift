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
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage?.layer.cornerRadius = profileImage!.frame.height / 2
        numAlbumsLabel.text = "0"
        numTripsLabel.text = "0"
        
        if PFUser.current() != nil {
            userNameLabel.text = PFUser.current()?.username
        } else {
            userNameLabel.text = "Anonymous User"
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
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
//        self.selectedImage = editedImage
        
        // Dismiss the UIImagePickerController
        dismiss(animated: true) {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        log.verbose("Canceled")
    }
}

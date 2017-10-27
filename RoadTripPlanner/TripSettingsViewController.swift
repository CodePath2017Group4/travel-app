//
//  TripSettingsViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/15/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import ARSLineProgress

class TripSettingsViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameCharacterCountLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionCharacterCountLabel: UILabel!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var tripDatePicker: UIDatePicker!
    
    let nameMaxCharCount = 50
    let descriptionMaxCharCount = 250
    
    var trip: Trip?
    var originalDescription: String?
    
    static func storyboardInstance() -> TripSettingsViewController? {
        let storyboard = UIStoryboard(name: "TripSettingsViewController", bundle: nil)
        
        return storyboard.instantiateInitialViewController() as? TripSettingsViewController
    }
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        descriptionTextView.delegate = self
        descriptionTextView.inputAccessoryView = toolbar
        
        nameTextField.delegate = self
        
        nameTextField.text = trip?.name
        originalDescription = trip?.tripDescription
        descriptionTextView.text = originalDescription
        
        // Load the cover image
        let coverImageFile = trip?.coverPhoto
        if coverImageFile != nil {
            Utils.fileToImage(file: coverImageFile!, callback: { (image) in
                self.coverImageView.image = image
            })
        }
        
        tripDatePicker.date = trip?.date ?? Date()
        
        checkNameTextLength(text: nameTextField?.text)
        checkDescriptionTextLength(text: descriptionTextView?.text)
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarLightTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarLightTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Trip Settings"

        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveChangesPressed(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // MARK: - IBAction Methods
    @IBAction func changeCoverButtonPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .popover
        
        present(imagePicker, animated: true) {
            
        }
    }
        
    @IBAction func doneButtonPressed(_ sender: Any) {
        descriptionTextView.resignFirstResponder()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        descriptionTextView.resignFirstResponder()
        descriptionTextView.text = originalDescription
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        
        guard let trip = trip else { return }
        trip.name = nameTextField.text
        trip.tripDescription = descriptionTextView.text
        trip.date = tripDatePicker.date
        
        let coverPhotoImage = coverImageView.image
        if coverPhotoImage != nil {
            trip.coverPhoto = Utils.imageToFile(image: coverPhotoImage!)
        }
        
        ARSLineProgress.showWithPresentCompetionBlock {
            log.verbose("Showed progress overlay")
        }
        
        trip.saveInBackground { (success, error) in
            if error == nil {
                log.info("Update trip success: \(success)")
                if success {
                    
                    // Post a notification that the trip has been modified
                    NotificationCenter.default.post(name: Constants.NotificationNames.TripModifiedNotification, object: nil, userInfo: ["trip": self.trip!])
                    
                    ARSLineProgress.hideWithCompletionBlock {
                        log.verbose("Hid progress overlay")
                        ARSLineProgress.showSuccess()
                    }
                }
            } else {
                ARSLineProgress.hideWithCompletionBlock {
                    log.verbose("Hid progress overlay")
                    ARSLineProgress.showFail()
                }
                log.error("Error updating trip: \(error!)")
            }
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = Utils.formatDate(date: selectedDate)
        log.info("selected date: \(formattedDate)")
    }
    
    
    fileprivate func checkNameTextLength(text: String?) {
        guard let text = text else { return }
        
        let characterCount = text.characters.count
        let remainingCount = nameMaxCharCount - characterCount
        
        if remainingCount < 0 {
            nameCharacterCountLabel.textColor = UIColor.red
        } else {
            nameCharacterCountLabel.textColor = UIColor.darkGray
        }
        
        nameCharacterCountLabel.text = "\(remainingCount)"
    }
    
    fileprivate func checkDescriptionTextLength(text: String?) {
        guard let text = text else { return }
        
        let characterCount = text.characters.count
        let remainingCount = descriptionMaxCharCount - characterCount
        
        if remainingCount < 0 {
            descriptionCharacterCountLabel.textColor = UIColor.red
        } else {
            descriptionCharacterCountLabel.textColor = UIColor.darkGray
        }
        
        descriptionCharacterCountLabel.text = "\(remainingCount)"
    }
    
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension TripSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("chosenImage \(chosenImage)")
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }    
}

// MARK: - UITextViewDelegate
extension TripSettingsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        checkDescriptionTextLength(text: textView.text)        
    }
    
}

// MARK: - UITextFieldDelegate
extension TripSettingsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        checkNameTextLength(text: textField.text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

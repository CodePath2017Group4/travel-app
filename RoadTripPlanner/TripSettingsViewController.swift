//
//  TripSettingsViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/15/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
protocol HeightForTextView {
    func heightOfTextView(height: CGFloat)
}

class TripSettingsViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameCharacterCountLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionCharacterCountLabel: UILabel!
    @IBOutlet var toolbar: UIToolbar!
    
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
        
        checkNameTextLength(text: nameTextField?.text)
        
        navigationController?.navigationBar.tintColor = Constants.Colors.NavigationBarLightTintColor
        let textAttributes = [NSForegroundColorAttributeName:Constants.Colors.NavigationBarLightTintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Trip Settings"

        
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
    
    fileprivate func checkNameTextLength(text: String?) {
        guard let text = text else { return }
        
        let characterCount = text.characters.count
        let remainigCount = 60 - characterCount
        
        if remainingCount < 0 {
            nameCharacterCountLabel.textColor = UIColor.red
        } else {
            nameCharacterCountLabel.textColor = UIColor.darkGray
        }
        
        nameCharacterCountLabel.text = remainingCount
    }
    
    fileprivate func checkDescriptionTextLength(text: String?) {
        guard let text = text else { return }
        
        let characterCount = text.characters.count
        let remainingCount = 250 - characterCount
        
        if remainingCount < 0 {
            descriptionCharacterCountLabel.textColor = UIColor.red
        } else {
            descriptionCharacterCountLabel.textColor = UIColor.darkGray
        }
        
        descriptionCharacterCountLabel.text = remainingCount
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

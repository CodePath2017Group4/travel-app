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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeCoverImageView: UIImageView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var tripTitleTextView: UITextView!
    
    @IBOutlet weak var titleView: UIView!
    let picker = UIImagePickerController()
    var delgate:HeightForTextView?

    var textViewHeight = CGFloat()
    fileprivate var counterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let changeCoverImageTap = UITapGestureRecognizer(target: self, action: #selector(changeCoverImageTapped))
        changeCoverImageTap.numberOfTapsRequired = 1
        changeCoverImageView.isUserInteractionEnabled = true
        changeCoverImageView.addGestureRecognizer(changeCoverImageTap)
        
        tripTitleTextView.textContainer.maximumNumberOfLines = 2
        tripTitleTextView.textContainer.lineBreakMode = .byWordWrapping
        tripTitleTextView.isScrollEnabled = false
        tripTitleTextView.delegate = self

        picker.delegate = self
        
        
        let screenWidth = UIScreen.main.bounds.width
        counterLabel = UILabel()
        counterLabel.frame = CGRect(x: screenWidth - 40, y: 0, width: 30, height: 50)
        counterLabel.font = UIFont(name: "HelveticaNeue-medium", size: 16)
        counterLabel.textColor = UIColor.white
        let charactersLeft = 50 - tripTitleTextView.text.characters.count
        counterLabel.text = "\(charactersLeft)"
        titleView.addSubview(counterLabel)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func changeCoverImageTapped(_ sender: AnyObject) {
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)

        
    }
    
}
extension TripSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripSettingsCell1") as! UITableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripSettingsCell2") as! UITableViewCell
            return cell        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

//MARK: Delegates
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

extension TripSettingsViewController: HeightForTextView {
    
    func heightOfTextView(height: CGFloat) {
        
        textViewHeight = height
        self.titleView.frame.size.height = self.titleView.frame.height + textViewHeight
        
    }
    
}

// MARK: - Text View delegate methods
extension TripSettingsViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let currentCount = textView.text.characters.count
        
        if (currentCount > 0) {
            textView.placeholder = ""
        }
        
        let charactersLeft = 50 - currentCount
        counterLabel.text = "\(charactersLeft)"

    }
    
}


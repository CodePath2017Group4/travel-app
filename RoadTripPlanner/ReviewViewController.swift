//
//  ReviewViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/15/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet var mainPushUpView: UIView!
    
    fileprivate var topTitleLabel: UILabel!

    fileprivate var continueButton: UIButton!
    fileprivate var isReadyToContinue = false

    var initialY: CGFloat!
    var offset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialY = mainPushUpView.frame.origin.y
        offset = -50
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            
                self.keyboardWillShow()
        
        }
        setupNavbar()
        self.automaticallyAdjustsScrollViewInsets = false
        
        composeTextView.placeholder = "Example: This propably the best gas station in town. Gas prices are reasonable right off US 101. Restrooms are well maintained."
        composeTextView.delegate = self
        
        setupCustomBottomBar()
        keyboardWillShow()
        
    }
    
    func keyboardWillShow() {
        
        mainPushUpView.frame.origin.y = initialY + offset
    }
    
    func setupNavbar() {
        
        let cancelImageView = UIImageView(image: UIImage(named: "cancel"))
            cancelImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        if let navigationBar = self.navigationController?.navigationBar {
            let navBarWidth = navigationBar.frame.width
            
            let frame = CGRect(x: navBarWidth - navBarWidth + 10, y: 0, width: navBarWidth, height: navigationBar.frame.height)
            
            topTitleLabel = UILabel(frame: frame)
            topTitleLabel.textColor = UIColor.black
            topTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
            topTitleLabel.text = "Shell, Menlo Park"
            navigationBar.addSubview(topTitleLabel)
        }
        
        
    }
    
    
    func setupCustomBottomBar() {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        
        customView.backgroundColor = UIColor.white
        customView.layer.borderColor = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1).cgColor
        
        customView.layer.borderWidth = 0.3
        composeTextView.inputAccessoryView = customView
        
        self.view.addSubview(composeTextView)
        let screenWidth = UIScreen.main.bounds.width
        
        let addTextImage = UIImage(named: "addtext")
        let addTextImageView = UIImageView(image: addTextImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        
        addTextImageView.tintColor = UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        addTextImageView.frame = CGRect(x: screenWidth - 350, y: 10, width: 30, height: 30)

        customView.addSubview(addTextImageView)

        
        let cameraImage = UIImage(named: "camera-icon")
        let cancelImageView = UIImageView(image: cameraImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        
        cancelImageView.tintColor = UIColor(red: 156.0/255.0, green: 156.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        cancelImageView.frame = CGRect(x: screenWidth - 300, y: 10, width: 30, height: 30)

        customView.addSubview(cancelImageView)

    
        continueButton = UIButton()
        continueButton.frame = CGRect(x: screenWidth - 80, y: 10, width: 70, height: 30)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.clipsToBounds = true
        continueButton.layer.masksToBounds = true
        setContinueButton(ready: isReadyToContinue)
        customView.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
        
    }
    
    @IBAction func onCancelButto(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func cancelTapped() {
        composeTextView.resignFirstResponder()
    }
    

    func setContinueButton(ready: Bool) {
        
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.borderWidth = 0
        isReadyToContinue = ready
        continueButton.isUserInteractionEnabled = ready
        
        if (!ready) {
            continueButton.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 0.5)
        } else {
            continueButton.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        }
    }
    
    func onContinue() {
        
        // Next step here
    }
}

// MARK: - Text View delegate methods
extension ReviewViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let currentCount = textView.text.characters.count
        
        if (currentCount > 0) {
            textView.placeholder = ""
        }
        else{
            textView.placeholder = "What's happening?"
        }
        
        
        if (isReadyToContinue) {
            if (currentCount < 0 || currentCount > 500) {
                setContinueButton(ready: false)
            }
        } else {
            if (currentCount < 500 && currentCount > -1) {
                setContinueButton(ready: true)
            }
        }
    }
    
}

extension UITextView: UITextViewDelegate {
    
    override open var bounds: CGRect {
        
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
 
    
    private func resizePlaceholder() {
        
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        
        let placeholderLabel = UILabel()
        placeholderLabel.frame = CGRect(x: 8, y: 9, width: 280, height: 30)
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        placeholderLabel.textColor = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1)
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
        
    }
    
}

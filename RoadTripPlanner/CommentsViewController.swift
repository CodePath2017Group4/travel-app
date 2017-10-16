//
//  CommentsViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet var mainPushUpView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var ScreeName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    fileprivate var bottomCounterLabel: UILabel!
    
    fileprivate var postButton: UIButton!
    fileprivate var isReadyToPost = false
    
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
        
        composeTextView.placeholder = "What's happening?"
        composeTextView.delegate = self
        
        setupCustomBottomBar()
        setCountdownLabels(left: 140)
        setPostButton(ready: true)
        
        userName.isHidden = true
        ScreeName.isHidden = true
        keyboardWillShow()
    }
    
    func keyboardWillShow() {
        
        mainPushUpView.frame.origin.y = initialY + offset
    }
    
    func setupNavbar() {
      //  let cancelImageView = UIImageView(image: UIImage(named: "cancel"))
      //  cancelImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let profileImage = UIImage(named: "profile")
            let profileImageView = UIImageView(image: profileImage)
            profileImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    
            profileImageView.layer.cornerRadius = (profileImageView.frame.size.width)/2
            profileImageView.clipsToBounds = true

                    
            let leftbarButton = UIBarButtonItem.init(customView: profileImageView)
            self.navigationItem.leftBarButtonItem = leftbarButton
        
        
            self.navigationController?.navigationBar.isHidden = false

    }
    
    
    func setupCustomBottomBar() {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        
        customView.backgroundColor = UIColor.white
        customView.layer.borderColor = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1).cgColor
        
        customView.layer.borderWidth = 0.3
        composeTextView.inputAccessoryView = customView
        
        self.view.addSubview(composeTextView)
        let screenWidth = UIScreen.main.bounds.width
        
        bottomCounterLabel = UILabel()
        bottomCounterLabel.frame = CGRect(x: screenWidth - 120, y: 0, width: 30, height: 50)
        bottomCounterLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        setCountdownLabels(left: 140)
        
        customView.addSubview(bottomCounterLabel)
        
        postButton = UIButton()
        postButton.frame = CGRect(x: screenWidth - 80, y: 10, width: 70, height: 30)
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        postButton.layer.cornerRadius = postButton.frame.height / 2
        postButton.clipsToBounds = true
        postButton.layer.masksToBounds = true
        setPostButton(ready: isReadyToPost)
        customView.addSubview(postButton)
        
        postButton.addTarget(self, action: #selector(sendTweet), for: .touchUpInside)
        
    }
    
    @IBAction func onCancelButton(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func cancelTapped() {
        composeTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)

    }
    
    
    func setCountdownLabels(left: Int) {
        
        bottomCounterLabel.text = "\(left)"
        
        if (left > 20) {
            bottomCounterLabel.textColor = UIColor(red: 101/255, green: 119/255, blue: 134/255, alpha: 1)
        } else {
            bottomCounterLabel.textColor = UIColor.red
        }
    }
    
    func setPostButton(ready: Bool) {
        
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.layer.borderWidth = 0
        isReadyToPost = ready
        postButton.isUserInteractionEnabled = ready
        
        
        if (!ready) {
            postButton.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 0.5)
        } else {
            postButton.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        }
    }
    
    func sendTweet() {
        composeTextView.resignFirstResponder()
    }
}

// MARK: - Text View delegate methods
extension CommentsViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let currentCount = textView.text.characters.count
        
        if (currentCount > 0) {
            textView.placeholder = ""
        }
        else{
            textView.placeholder = "What's happening?"
        }
        
        let charactersLeft = 140 - currentCount
        setCountdownLabels(left: charactersLeft)
        
        if (isReadyToPost) {
            if (charactersLeft < 0 || charactersLeft > 139) {
                setPostButton(ready: false)
            }
        } else {
            if (charactersLeft < 140 && charactersLeft > -1) {
                setPostButton(ready: true)
            }
        }
    }
    
}


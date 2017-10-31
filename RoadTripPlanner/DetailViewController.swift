//
//  DetailViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/26/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import YelpAPI
import CDYelpFusionKit


class DetailViewController: UIViewController {

    @IBOutlet weak var detailView: DetailView!
    @IBOutlet var closeButton: UIButton!
    
  var businessDetailView: BusinessDetailView!
    
    let contentView = UIView()
    private let kContentViewTopOffset: CGFloat = 64
    private let kContentViewBottomOffset: CGFloat = 64
    private let kContentViewAnimationDuration: TimeInterval = 1.4
    var businss: YLPBusiness!
    var business: CDYelpBusiness!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect(x: 0, y: kContentViewTopOffset, width: view.bounds.width, height: view.bounds.height-kContentViewTopOffset)

        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize.zero
       ///self.businessDetailView = BusinessDetailView(frame: CGRect(x: 10, y: kContentViewTopOffset, width: view.bounds.width, height: view.bounds.height-kContentViewTopOffset))
       // self.myPopupView = popupView(frame: CGRect(x: 10, y: 200, width: 300, height: 200))
        let businessView = BusinessBottomSheetViewController()
        businessView.business = business

        detailView.titleLabel.text = business.name
        if let businessImageUrl = business.imageUrl {
            //     imageView?.setImageWith(businessImageUrl)
            let backgroundImageView = UIImageView()
            let backgroundImage = UIImage()
            backgroundImageView.setImageWith(businessImageUrl)
            detailView.imageView.image = backgroundImageView.image//setImageWith(businessImageUrl)
            detailView.contentMode = .scaleAspectFill
            detailView.clipsToBounds = true
        }
    
       //contentView.addSubview(businessView.view)
       // contentView.addSubview(businessView.view)
       // businessView.didMove(toParentViewController: self)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
        view.addSubview(contentView)
    }
    func registerForNotifications() {
        // Register to receive Businesses
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BussinessUpdate"),
                                               object: nil, queue: OperationQueue.main) {
                                                [weak self] (notification: Notification) in
                                                self?.business = notification.userInfo!["business"] as! CDYelpBusiness
                                                //self?.addAnnotationFor(businesses: (self?.businesses)!)
                                                print("self?.business in nitofocation \(self?.business.id)")
                                                //self?.tableView.reloadData()
                                                //self?.collectionView.reloadData()
                                                //self?.mapView.reloadInputViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  addBottomSheetView()
        let businessView = BusinessBottomSheetViewController()
        businessView.business = business
        contentView.addSubview(businessView.view)
       // businessView.didMove(toParentViewController: self)

    }
    
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //@objc
    func handlePan(pan: UIPanGestureRecognizer) {
        print("handlePan")
        
        switch pan.state {
        case .began: print("began")
            fallthrough
        case .changed: print("changed")
        contentView.frame.origin.y += pan.translation(in: view).y
        pan.setTranslation(CGPoint.zero, in: view)
        
        let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
        print("progress \(progress)")
        detailView.transitionProgress = progress
            
        case .ended: print("ended")
            fallthrough
        case .cancelled: print("canceled")
        let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
        if progress > 0.5 {
            let duration = TimeInterval(1-progress) * kContentViewAnimationDuration
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: { () -> Void in
                [self]
                
                self.detailView.transitionProgress = 1
                self.contentView.frame.origin.y = self.view.bounds.height - self.kContentViewBottomOffset
                
            }, completion: nil)
        }
        else {
            let duration = TimeInterval(progress) * kContentViewAnimationDuration
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { () -> Void in
                [self]
                
                self.detailView.transitionProgress = 0
                self.contentView.frame.origin.y = self.kContentViewTopOffset
                
            }, completion: nil)
            }
            
        default: print("default")
        ()
        }
        
        
    }
    
   

    

}

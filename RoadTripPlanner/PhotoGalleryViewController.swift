//
//  PhotoGalleryViewController.swift
//  RoadTripPlanner
//
//  Created by Nanxi Kang on 10/22/17.
//  Copyright © 2017 RoadTripPlanner. All rights reserved.
//

import Parse
import UIKit

class PhotoGalleryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var defaultIndex: Int = 0
    var photos: [UIImage] = []
    
    static func getVC() -> PhotoGalleryViewController {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "photoGalleryVC") as! PhotoGalleryViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add swipe gesture
        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
            imageView.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            imageView.isUserInteractionEnabled = true
            imageView.isMultipleTouchEnabled = true
        }
        
        showImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showImage() {
        if (defaultIndex >= 0 && defaultIndex < photos.count) {
            self.imageView.image = self.photos[defaultIndex]
            navigationItem.title = "\(defaultIndex + 1)/\(photos.count)"
        }
    }
    
    @IBAction func onSwipe(_ sender: UISwipeGestureRecognizer) {
        print("on Swipe \(sender.direction)")
        print("\(defaultIndex) and \(photos.count)")
        let direction = sender.direction
        if (direction == .left && defaultIndex + 1 < photos.count) {
            defaultIndex = defaultIndex + 1
            showImage()
        } else if (direction == .right && defaultIndex > 0) {
            defaultIndex = defaultIndex - 1
            showImage()
        }
    }
}

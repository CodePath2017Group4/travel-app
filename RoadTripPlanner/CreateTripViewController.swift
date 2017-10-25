//
//  CreateTripViewController.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import DatePickerDialog
import CoreLocation
import MapKit
import YelpAPI
import Parse

class CreateTripViewController: UIViewController {
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var createTripButton: UIButton!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var autoImageView: UIImageView!
    
    @IBOutlet weak var autoSubView: UIView!
    @IBOutlet weak var autoBackImageView: UIImageView!
    @IBOutlet weak var allAutoImageView: UIImageView!
    @IBOutlet weak var gasImageView : UIImageView!
    @IBOutlet weak var parkingImageView: UIImageView!
    @IBOutlet weak var chargingImageView: UIImageView!
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var foodSubView: UIView!
    @IBOutlet weak var foodBackImageView: UIImageView!
    @IBOutlet weak var allFoodImageView: UIImageView!
    @IBOutlet weak var cafeImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var breakfastImageView: UIImageView!
    @IBOutlet weak var drinksImageView: UIImageView!
    @IBOutlet weak var burgerImageView: UIImageView!
    
    @IBOutlet weak var poiImageView: UIImageView!
    
    @IBOutlet weak var poiSubView: UIView!
    @IBOutlet weak var poiBackImage: UIImageView!
    @IBOutlet weak var allPoiImageView: UIImageView!
    @IBOutlet weak var landmarkImageView: UIImageView!
    @IBOutlet weak var historicImageView: UIImageView!
    @IBOutlet weak var monumentImageView: UIImageView!
    
    @IBOutlet weak var shoppingImageView: UIImageView!
    
    @IBOutlet weak var lodgingImageView: UIImageView!
    
    @IBOutlet weak var lodgingSubView: UIView!
    @IBOutlet weak var lodgingBackImageView: UIImageView!
    @IBOutlet weak var allLodgingImageView: UIImageView!
    @IBOutlet weak var hotelsImageView: UIImageView!
    @IBOutlet weak var hostelImageView: UIImageView!
    @IBOutlet weak var bbImageView: UIImageView!
    @IBOutlet weak var campImageView: UIImageView!
    @IBOutlet weak var guestImageView: UIImageView!

    @IBOutlet weak var ttdImageView: UIImageView!
    
    @IBOutlet weak var ttdSubView: UIView!
    @IBOutlet weak var ttdBackImage: UIImageView!
    @IBOutlet weak var allBackImageView: UIImageView!
    @IBOutlet weak var museumsImageView: UIImageView!
    @IBOutlet weak var zooImageView: UIImageView!
    @IBOutlet weak var amusementImageView: UIImageView!
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var arcadeImageView: UIImageView!

    @IBOutlet weak var entertainmentImageView: UIImageView!
    
    @IBOutlet weak var entertainmentSubView: UIView!
    @IBOutlet weak var entertainmentBackImageView: UIImageView!
    @IBOutlet weak var allEntertainmentImageView: UIImageView!
    @IBOutlet weak var moviesImageView: UIImageView!
    @IBOutlet weak var galleriesImageView: UIImageView!
    @IBOutlet weak var nightlifeImageView: UIImageView!
    @IBOutlet weak var theatersImageView: UIImageView!
    
    @IBOutlet weak var reststopImageView: UIImageView!
    
    fileprivate var isSubViewOpen = false
    
    let autoCategoriesList = ["back", "all", "servicestations", "autoelectric", "parking"]
    let foodCategoriesList = ["back", "all", "cafe", "restaurant", "breakfast_brunch", "bars", "burgers"] //#178426
    let poiCategoriesList = ["back", "all", "landmarks", "civiccenter", "townhall"]
    let shoppingCategoriesList = ["back", "all", "deptstores", "drugstores", "flowers"]
    let lodgingCategoriesList = ["back", "all", "hotels", "hostels", "bedbreakfast", "campgrounds", "guesthouses"]
    let ttdCategoriesList = ["back", "all", "museums", "aquariums, zoos", "amusementparks", "parks", "arcades",]
    let entertainmentCategoriesList = ["back", "all", "moviestheaters", "galaries", "nightlife", "theater"]

    var termCategory: [String : [String]]!
    var selectedTypes: [String]!

    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    let locationManager = CLLocationManager()
    
    var locationsArray: [(textField: UITextField?, mapItem: MKMapItem?)] {
        var filtered = locationTuples.filter({ $0.mapItem != nil })
        //filtered += [filtered.first!] //Round trip
        return filtered
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startTextField.tag = 1
        destinationTextField.tag = 2
        
        let startLeftViewLabel = UILabel.init(frame: CGRect(x:0,y:0,width:50, height:21))
        var attributedString = NSAttributedString(string: "  From :", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : UIColor.lightGray])
        startLeftViewLabel.attributedText = attributedString
        startTextField.leftView = startLeftViewLabel
        startTextField.leftViewMode = .always
        
        let toLeftViewLabel = UILabel.init(frame: CGRect(x:0,y:0,width:50, height:21))
        attributedString = NSAttributedString(string: "      To  :", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : UIColor.lightGray])
        toLeftViewLabel.attributedText = attributedString
        destinationTextField.leftView = toLeftViewLabel
        destinationTextField.leftViewMode = .always

        startTextField.delegate = self
        destinationTextField.delegate = self
        
        getLocation()
        
        locationTuples = [(startTextField, nil), (destinationTextField, nil)]

        createTripButton.layer.cornerRadius = createTripButton.frame.height / 2
        autoSubView.isHidden = true
        foodSubView.isHidden = true
        poiSubView.isHidden = true
        lodgingSubView.isHidden = true
        ttdSubView.isHidden = true
        entertainmentSubView.isHidden = true
        
        setupAutoView()
        setupFoodView()
        setupPOIView()
        setupShoppingView()
        setupLodgingView()
        setupTTDView()
        setupEntertainmentView()
        setupReststopView()
        
        let dateImageTap = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        dateImageTap.numberOfTapsRequired = 1
        dateImageView.isUserInteractionEnabled = true
        dateImageView.addGestureRecognizer(dateImageTap)
        
        
        let clockImageTap = UITapGestureRecognizer(target: self, action: #selector(clockTapped))
        clockImageTap.numberOfTapsRequired = 1
        clockImageView.isUserInteractionEnabled = true
        clockImageView.addGestureRecognizer(clockImageTap)
        self.navigationController?.navigationBar.isHidden = false
        
        if(termCategory == nil) {
            termCategory = [String : [String]]()
        }
        if(selectedTypes == nil) {
            selectedTypes = [String]()
        }
    }
    
    func setupAutoView() {
        
        // Main Auto Category
        
        let autoSubImagesTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        autoSubImagesTap.numberOfTapsRequired = 1
        autoImageView.isUserInteractionEnabled = true
        autoImageView.tag = 0
        autoImageView.addGestureRecognizer(autoSubImagesTap)
        
        // Auto Subcategory
        let backAutoImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        backAutoImageTap.numberOfTapsRequired = 1
        autoBackImageView.isUserInteractionEnabled = true
        autoBackImageView.tag = 0
        autoBackImageView.addGestureRecognizer(backAutoImageTap)
        
        let allAutoImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        allAutoImageTap.numberOfTapsRequired = 1
        allAutoImageView.isUserInteractionEnabled = true
        allAutoImageView.tag = 1
        allAutoImageView.addGestureRecognizer(allAutoImageTap)
        
        let gasImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        gasImageTap.numberOfTapsRequired = 1
        gasImageView.isUserInteractionEnabled = true
        gasImageView.tag = 2
        gasImageView.addGestureRecognizer(gasImageTap)
        
        let chargingImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        chargingImageTap.numberOfTapsRequired = 1
        chargingImageView.isUserInteractionEnabled = true
        chargingImageView.tag = 3
        chargingImageView.addGestureRecognizer(chargingImageTap)
        
        let parkingImageTap = UITapGestureRecognizer(target: self, action: #selector(autoSubCategoryTapped))
        parkingImageTap.numberOfTapsRequired = 1
        parkingImageView.isUserInteractionEnabled = true
        parkingImageView.tag = 4
        parkingImageView.addGestureRecognizer(parkingImageTap)
        
    }
    
    
    func setupFoodView() {
        
        // Main Food Category
        let foodImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        foodImageTap.numberOfTapsRequired = 1
        foodImageView.isUserInteractionEnabled = true
        foodImageView.tag = 1
        foodImageView.addGestureRecognizer(foodImageTap)
        
        // Food Subcategory
        let backFoodImageTap = UITapGestureRecognizer(target: self, action: #selector(foodSubCategoryTapped))
        backFoodImageTap.numberOfTapsRequired = 1
        foodBackImageView.isUserInteractionEnabled = true
        foodBackImageView.tag = 0
        foodBackImageView.addGestureRecognizer(backFoodImageTap)
        
        let allFoodImageTap = UITapGestureRecognizer(target: self, action: #selector(foodSubCategoryTapped))
        allFoodImageTap.numberOfTapsRequired = 1
        allFoodImageView.isUserInteractionEnabled = true
        allFoodImageView.tag = 1
        allFoodImageView.addGestureRecognizer(allFoodImageTap)
        
        let cafeImageTap = UITapGestureRecognizer(target: self, action: #selector(foodSubCategoryTapped))
        cafeImageTap.numberOfTapsRequired = 1
        cafeImageView.isUserInteractionEnabled = true
        cafeImageView.tag = 2
        cafeImageView.addGestureRecognizer(cafeImageTap)
        
        let restaurantImageTap = UITapGestureRecognizer(target: self, action: #selector(foodSubCategoryTapped))
        restaurantImageTap.numberOfTapsRequired = 1
        restaurantImageView.isUserInteractionEnabled = true
        restaurantImageView.tag = 3
        restaurantImageView.addGestureRecognizer(restaurantImageTap)
        
        let breakfastImageTap = UITapGestureRecognizer(target: self, action: #selector(foodSubCategoryTapped))
        breakfastImageTap.numberOfTapsRequired = 1
        breakfastImageView.isUserInteractionEnabled = true
        breakfastImageView.tag = 4
        breakfastImageView.addGestureRecognizer(breakfastImageTap)
        
        let drinksImageTap = UITapGestureRecognizer(target: self, action: #selector(foodSubCategoryTapped))
        drinksImageTap.numberOfTapsRequired = 1
        drinksImageView.isUserInteractionEnabled = true
        drinksImageView.tag = 5
        drinksImageView.addGestureRecognizer(drinksImageTap)
        
        let burgerImageTap = UITapGestureRecognizer(target: self, action: #selector(foodSubCategoryTapped))
        burgerImageTap.numberOfTapsRequired = 1
        burgerImageView.isUserInteractionEnabled = true
        burgerImageView.tag = 6
        burgerImageView.addGestureRecognizer(burgerImageTap)

    }
    
    func setupPOIView() {
        
        // Main POI Category
        let poiImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        poiImageTap.numberOfTapsRequired = 1
        poiImageView.isUserInteractionEnabled = true
        poiImageView.tag = 2
        poiImageView.addGestureRecognizer(poiImageTap)
        
        // POI Subcategory
        let backPOIImageTap = UITapGestureRecognizer(target: self, action: #selector(poiSubCategoryTapped))
        backPOIImageTap.numberOfTapsRequired = 1
        poiBackImage.isUserInteractionEnabled = true
        poiBackImage.tag = 0
        poiBackImage.addGestureRecognizer(backPOIImageTap)
        
        let allPOIImageTap = UITapGestureRecognizer(target: self, action: #selector(poiSubCategoryTapped))
        allPOIImageTap.numberOfTapsRequired = 1
        allPoiImageView.isUserInteractionEnabled = true
        allPoiImageView.tag = 1
        allPoiImageView.addGestureRecognizer(allPOIImageTap)
        
        let landImageTap = UITapGestureRecognizer(target: self, action: #selector(poiSubCategoryTapped))
        landImageTap.numberOfTapsRequired = 1
        landmarkImageView.isUserInteractionEnabled = true
        landmarkImageView.tag = 2
        landmarkImageView.addGestureRecognizer(landImageTap)
        
        let historicImageTap = UITapGestureRecognizer(target: self, action: #selector(poiSubCategoryTapped))
        historicImageTap.numberOfTapsRequired = 1
        historicImageView.isUserInteractionEnabled = true
        historicImageView.tag = 3
        historicImageView.addGestureRecognizer(historicImageTap)
        
        let monumentImageTap = UITapGestureRecognizer(target: self, action: #selector(poiSubCategoryTapped))
        monumentImageTap.numberOfTapsRequired = 1
        monumentImageView.isUserInteractionEnabled = true
        monumentImageView.tag = 4
        monumentImageView.addGestureRecognizer(monumentImageTap)
        
    }
    
    func setupShoppingView() {
        
        // Main Shopping Category
        let shoppingImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        shoppingImageTap.numberOfTapsRequired = 1
        shoppingImageView.isUserInteractionEnabled = true
        shoppingImageView.tag = 3
        shoppingImageView.addGestureRecognizer(shoppingImageTap)
    
    }
    
    func setupLodgingView() {
        
        // Main Lodging Category
        let loddingImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        loddingImageTap.numberOfTapsRequired = 1
        lodgingImageView.isUserInteractionEnabled = true
        lodgingImageView.tag = 4
        lodgingImageView.addGestureRecognizer(loddingImageTap)
        
        // Lodging Subcategory
        
        let backLodgingImageTap = UITapGestureRecognizer(target: self, action: #selector(lodgingSubCategoryTapped))
        backLodgingImageTap.numberOfTapsRequired = 1
        lodgingBackImageView.isUserInteractionEnabled = true
        lodgingBackImageView.tag = 0
        lodgingBackImageView.addGestureRecognizer(backLodgingImageTap)
        
        let allImageTap = UITapGestureRecognizer(target: self, action: #selector(lodgingSubCategoryTapped))
        allImageTap.numberOfTapsRequired = 1
        allLodgingImageView.isUserInteractionEnabled = true
        allLodgingImageView.tag = 1
        allLodgingImageView.addGestureRecognizer(allImageTap)
        
        let hotelImageTap = UITapGestureRecognizer(target: self, action: #selector(lodgingSubCategoryTapped))
        hotelImageTap.numberOfTapsRequired = 1
        hotelsImageView.isUserInteractionEnabled = true
        hotelsImageView.tag = 2
        hotelsImageView.addGestureRecognizer(hotelImageTap)

        let hostelsImageTap = UITapGestureRecognizer(target: self, action: #selector(lodgingSubCategoryTapped))
        hostelsImageTap.numberOfTapsRequired = 1
        hostelImageView.isUserInteractionEnabled = true
        hostelImageView.tag = 3
        hostelImageView.addGestureRecognizer(hostelsImageTap)
        
        let bbImageTap = UITapGestureRecognizer(target: self, action: #selector(lodgingSubCategoryTapped))
        bbImageTap.numberOfTapsRequired = 1
        bbImageView.isUserInteractionEnabled = true
        bbImageView.tag = 4
        bbImageView.addGestureRecognizer(bbImageTap)
        
        let campImageTap = UITapGestureRecognizer(target: self, action: #selector(lodgingSubCategoryTapped))
        campImageTap.numberOfTapsRequired = 1
        campImageView.isUserInteractionEnabled = true
        campImageView.tag = 5
        campImageView.addGestureRecognizer(campImageTap)
        
        let guestImageTap = UITapGestureRecognizer(target: self, action: #selector(lodgingSubCategoryTapped))
        guestImageTap.numberOfTapsRequired = 1
        guestImageView.isUserInteractionEnabled = true
        guestImageView.tag = 6
        guestImageView.addGestureRecognizer(guestImageTap)
        
    }
    
    func setupTTDView() {
        
        // Main TTD Category
        let ttdImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        ttdImageTap.numberOfTapsRequired = 1
        ttdImageView.isUserInteractionEnabled = true
        ttdImageView.tag = 5
        ttdImageView.addGestureRecognizer(ttdImageTap)
        
        // TTD Subcategory
        let ttdBackImageTap = UITapGestureRecognizer(target: self, action: #selector(ttdSubCategoryTapped))
        ttdBackImageTap.numberOfTapsRequired = 1
        ttdBackImage.isUserInteractionEnabled = true
        ttdBackImage.tag = 0
        ttdBackImage.addGestureRecognizer(ttdBackImageTap)
        
        let allImageTap = UITapGestureRecognizer(target: self, action: #selector(ttdSubCategoryTapped))
        allImageTap.numberOfTapsRequired = 1
        allBackImageView.isUserInteractionEnabled = true
        allBackImageView.tag = 1
        allBackImageView.addGestureRecognizer(allImageTap)
        
        let museumImageTap = UITapGestureRecognizer(target: self, action: #selector(ttdSubCategoryTapped))
        museumImageTap.numberOfTapsRequired = 1
        museumsImageView.isUserInteractionEnabled = true
        museumsImageView.tag = 2
        museumsImageView.addGestureRecognizer(museumImageTap)
        
        let zooImageTap = UITapGestureRecognizer(target: self, action: #selector(ttdSubCategoryTapped))
        zooImageTap.numberOfTapsRequired = 1
        zooImageView.isUserInteractionEnabled = true
        zooImageView.tag = 3
        zooImageView.addGestureRecognizer(zooImageTap)
        
        let amparkImageTap = UITapGestureRecognizer(target: self, action: #selector(ttdSubCategoryTapped))
        amparkImageTap.numberOfTapsRequired = 1
        amusementImageView.isUserInteractionEnabled = true
        amusementImageView.tag = 4
        amusementImageView.addGestureRecognizer(amparkImageTap)
        
        let parkImageTap = UITapGestureRecognizer(target: self, action: #selector(ttdSubCategoryTapped))
        parkImageTap.numberOfTapsRequired = 1
        parkImageView.isUserInteractionEnabled = true
        parkImageView.tag = 5
        parkImageView.addGestureRecognizer(parkImageTap)
        
        let arcadeImageTap = UITapGestureRecognizer(target: self, action: #selector(ttdSubCategoryTapped))
        arcadeImageTap.numberOfTapsRequired = 1
        arcadeImageView.isUserInteractionEnabled = true
        arcadeImageView.tag = 4
        arcadeImageView.addGestureRecognizer(arcadeImageTap)
        
    }
    
    func setupEntertainmentView() {
        
        // Main Entertainment Category
        let entertainmentImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        entertainmentImageTap.numberOfTapsRequired = 1
        entertainmentImageView.isUserInteractionEnabled = true
        entertainmentImageView.tag = 6
        entertainmentImageView.addGestureRecognizer(entertainmentImageTap)
        
        // Entertainment Subcategory
        let backImageTap = UITapGestureRecognizer(target: self, action: #selector(entertainmentSubCategoryTapped))
        backImageTap.numberOfTapsRequired = 1
        entertainmentBackImageView.isUserInteractionEnabled = true
        entertainmentBackImageView.tag = 0
        entertainmentBackImageView.addGestureRecognizer(backImageTap)
        
        let allImageTap = UITapGestureRecognizer(target: self, action: #selector(entertainmentSubCategoryTapped))
        allImageTap.numberOfTapsRequired = 1
        allEntertainmentImageView.isUserInteractionEnabled = true
        allEntertainmentImageView.tag = 1
        allEntertainmentImageView.addGestureRecognizer(allImageTap)
        
        let moviesImageTap = UITapGestureRecognizer(target: self, action: #selector(entertainmentSubCategoryTapped))
        moviesImageTap.numberOfTapsRequired = 1
        moviesImageView.isUserInteractionEnabled = true
        moviesImageView.tag = 2
        moviesImageView.addGestureRecognizer(moviesImageTap)
        
        let galleriesImageTap = UITapGestureRecognizer(target: self, action: #selector(entertainmentSubCategoryTapped))
        galleriesImageTap.numberOfTapsRequired = 1
        galleriesImageView.isUserInteractionEnabled = true
        galleriesImageView.tag = 3
        galleriesImageView.addGestureRecognizer(galleriesImageTap)
        
        let nightlifeImageTap = UITapGestureRecognizer(target: self, action: #selector(entertainmentSubCategoryTapped))
        nightlifeImageTap.numberOfTapsRequired = 1
        nightlifeImageView.isUserInteractionEnabled = true
        nightlifeImageView.tag = 4
        nightlifeImageView.addGestureRecognizer(nightlifeImageTap)
        
        let theaterImageTap = UITapGestureRecognizer(target: self, action: #selector(entertainmentSubCategoryTapped))
        theaterImageTap.numberOfTapsRequired = 1
        theatersImageView.isUserInteractionEnabled = true
        theatersImageView.tag = 5
        theatersImageView.addGestureRecognizer(theaterImageTap)
        
    }
    
    func setupReststopView() {
        
        // Main Rest Stop Category
        let restStopImageTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        restStopImageTap.numberOfTapsRequired = 1
        reststopImageView.isUserInteractionEnabled = true
        reststopImageView.tag = 7
        reststopImageView.addGestureRecognizer(restStopImageTap)
    }
    
    func categoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        
        print("categoryTapped \(selectedIndex)")
        let selectedImg = sender.view

        if autoImageView.tag == selectedIndex {
            
            self.view.setNeedsUpdateConstraints()
            isSubViewOpen = !isSubViewOpen
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = true
                self.autoSubView.isHidden = false
                self.view.layoutIfNeeded()
                
            }
        }
        if foodImageView.tag == selectedIndex {
            
            self.view.setNeedsUpdateConstraints()
            isSubViewOpen = !isSubViewOpen
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = true
                self.foodSubView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
        if poiImageView.tag == selectedIndex {
            
            self.view.setNeedsUpdateConstraints()
            isSubViewOpen = !isSubViewOpen
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = true
                self.poiSubView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
        if shoppingImageView.tag == selectedIndex {
            
            buttonClickAnimation(button: selectedImg!)

            if !selectedTypes.contains("shopping") {
                selectedTypes.append("shopping")
            }
        }
        
        if lodgingImageView.tag == selectedIndex {
            
            self.view.setNeedsUpdateConstraints()
            isSubViewOpen = !isSubViewOpen
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = true
                self.lodgingSubView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
        if ttdImageView.tag == selectedIndex {
            
            self.view.setNeedsUpdateConstraints()
            isSubViewOpen = !isSubViewOpen
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = true
                self.ttdSubView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
        if entertainmentImageView.tag == selectedIndex {
            
            self.view.setNeedsUpdateConstraints()
            isSubViewOpen = !isSubViewOpen
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = true
                self.entertainmentSubView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
        if reststopImageView.tag == selectedIndex {
            
            buttonClickAnimation(button: selectedImg!)

            if !selectedTypes.contains("reststops") {
                selectedTypes.append("reststops")
            }
        }
    }
    
    func autoSubCategoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        
        if selectedIndex! != 0 && selectedIndex! != 1 {
            
            let selectedImg = sender.view
            buttonClickAnimation(button: selectedImg!)
            
            if termCategory.keys.contains("auto") {
                var categoryArray = termCategory["auto"]
                if !(categoryArray?.contains(autoCategoriesList[selectedIndex!]))! {
                    categoryArray?.append(autoCategoriesList[selectedIndex!])
                }
                termCategory.updateValue(categoryArray!, forKey: "auto")

            }
        }
        else {
            if selectedIndex == 1 {
                //selectedTypes.removeAll()
                //selectedTypes.append(autoCategoriesList[selectedIndex!])
                //termCategory.removeValue(forKey: "auto")
                termCategory.updateValue([autoCategoriesList[selectedIndex!]], forKey: "auto")

            }
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = false
                self.autoSubView.isHidden = true
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func foodSubCategoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        let selectedImg = sender.view
        
        if selectedIndex! != 0 && selectedIndex! != 1 {
            
            buttonClickAnimation(button: selectedImg!)
            
            if selectedIndex! != 5 {
                if termCategory.keys.contains("restaurants") {
                    var categoryArray = termCategory["restaurants"]
                    if !(categoryArray?.contains(foodCategoriesList[selectedIndex!]))! {
                        categoryArray?.append(foodCategoriesList[selectedIndex!])
                        print("categoryArray in if ===== >  \(categoryArray)")
                    }
                    termCategory["restaurants"] = categoryArray
                }
                else {
                    termCategory["restaurants"] = [foodCategoriesList[selectedIndex!]]
                }
            }
            else {
                if termCategory.keys.contains("nightlife") {
                    var categoryArray = termCategory["nightlife"]
                    if !(categoryArray?.contains("bars"))! {
                        categoryArray?.append("bars")
                        print("categoryArray in if ===== >  \(categoryArray)")
                    }
                    termCategory.updateValue(categoryArray!, forKey: "nightlife")

                }
                else {
                    termCategory.updateValue(["bars"], forKey: "nightlife")

                }
            }
            
        }
        else {
            if selectedIndex == 1 {
                termCategory.updateValue([foodCategoriesList[selectedIndex!]], forKey: "restaurants")
                termCategory.updateValue(["bars"], forKey: "nightlife")
            }
            
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = false
                self.foodSubView.isHidden = true
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func poiSubCategoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        let selectedImg = sender.view
        
        if selectedIndex! != 0 && selectedIndex! != 1 {
            
            buttonClickAnimation(button: selectedImg!)
            
            if termCategory.keys.contains("publicservicesgovt") {
                var categoryArray = termCategory["publicservicesgovt"]
                if !(categoryArray?.contains(poiCategoriesList[selectedIndex!]))! {
                    categoryArray?.append(poiCategoriesList[selectedIndex!])
                }
                termCategory.updateValue(categoryArray!, forKey: "publicservicesgovt")
                
            }


        }
        else {
            if selectedIndex == 1 {
           
                termCategory.updateValue(Category.poiSubCategory["publicservicesgovt"]!, forKey: "publicservicesgovt")

            }
            
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = false
                self.poiSubView.isHidden = true
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func lodgingSubCategoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        
        let selectedImg = sender.view
        
        if selectedIndex! != 0 && selectedIndex! != 1 {
            
            buttonClickAnimation(button: selectedImg!)
            
            UIView.commitAnimations()
            
            if termCategory.keys.contains("hotels") {
                var categoryArray = termCategory["hotels"]
                if !(categoryArray?.contains(lodgingCategoriesList[selectedIndex!]))! {
                    categoryArray?.append(lodgingCategoriesList[selectedIndex!])
                    print("categoryArray in if ===== >  \(categoryArray)")
                }
                termCategory.updateValue(categoryArray!, forKey: "hotels")
                
            }
        }
        else {
            if selectedIndex == 1 {
                termCategory.updateValue(Category.hotelsSubCategories["hotels"]!, forKey: "hotels")

            }
            
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = false
                self.lodgingSubView.isHidden = true
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func ttdSubCategoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        
        let selectedImg = sender.view
        
        if selectedIndex! != 0 && selectedIndex! != 1 {
            
            buttonClickAnimation(button: selectedImg!)
            
            if selectedIndex! == 2 || selectedIndex! == 6 {
                if termCategory.keys.contains("arts") {
                    var categoryArray = termCategory["arts"]
                    if !(categoryArray?.contains(ttdCategoriesList[selectedIndex!]))! {
                        categoryArray?.append(ttdCategoriesList[selectedIndex!])
                    }
                    termCategory.updateValue(categoryArray!, forKey: "arts")

                }
                else {
                    termCategory.updateValue([ttdCategoriesList[selectedIndex!]], forKey: "arts")

                }
            }
            else {
                if termCategory.keys.contains("active") {
                    var categoryArray = termCategory["active"]
                    categoryArray?.append(ttdCategoriesList[selectedIndex!])
                    termCategory.updateValue(categoryArray!, forKey: "active")
                    
                }
                else {
                    termCategory.updateValue([ttdCategoriesList[selectedIndex!]], forKey: "active")
                    
                }
            }
        }
        else {
            if selectedIndex == 1 {
                termCategory.updateValue(Category.TDOSubCategory["arts"]!, forKey: "arts")
                termCategory.updateValue(Category.TDOSubCategory["active"]!, forKey: "active")

            }
            
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = false
                self.ttdSubView.isHidden = true
                self.view.layoutIfNeeded()
        
            }
        }
    }
    
    func entertainmentSubCategoryTapped(_ sender: UITapGestureRecognizer) {
        let selectedIndex = sender.view?.tag
        
        let selectedImg = sender.view
        buttonClickAnimation(button: selectedImg!)
        
        if selectedIndex! != 0 && selectedIndex! != 1 {
            
            selectedTypes.append(entertainmentCategoriesList[selectedIndex!])
            
            if selectedIndex! != 4 {
                if termCategory.keys.contains("arts") {
                    var categoryArray = termCategory["arts"]
                    if !(categoryArray?.contains(entertainmentCategoriesList[selectedIndex!]))! {
                        categoryArray?.append(entertainmentCategoriesList[selectedIndex!])
                    }
                    termCategory.updateValue(categoryArray!, forKey: "arts")
                    
                }
                else {
                    termCategory.updateValue([entertainmentCategoriesList[selectedIndex!]], forKey: "arts")
                    
                }
            }
            else {
                termCategory.updateValue(["All"], forKey: "nightlife")
            }
        }
        else {
            if selectedIndex == 1 {
                termCategory.updateValue(["All"], forKey: "nightlife")
                termCategory.updateValue(Category.entertainmentSubCategory["arts"]!, forKey: "arts")

            }
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 1) {
                self.categoryView.isHidden = false
                self.entertainmentSubView.isHidden = true
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func buttonClickAnimation(button selectedImg: UIView) {
        selectedImg.transform = CGAffineTransform(scaleX: 1.1,y: 1.1);
        selectedImg.alpha = 0.0
        
        UIView.beginAnimations("button", context:nil)
        UIView.setAnimationDuration(0.5)
        selectedImg.transform = CGAffineTransform(scaleX: 1,y: 1);
        selectedImg.alpha = 1.0
        UIView.commitAnimations()
    }
    
    @IBAction func swapFields(_ sender: Any) {
        swap(&startTextField.text, &destinationTextField.text)
        swap(&locationTuples[0].mapItem, &locationTuples[1].mapItem)
    }
    
    func dateTapped(_ sender: AnyObject) {
        DatePickerDialog(showCancelButton: false).show("Select Travel Date", doneButtonTitle: "Done", datePickerMode: .date) {

            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.dateLabel.text = formatter.string(from: dt)
            }
        }
        
    }
    
    func clockTapped(_ sender: UITapGestureRecognizer) {
        
    }
    var timeVar = 0.0
    var routevar = [MKRoute] ()

    @IBAction func onStartTrip(_ sender: Any) {
        
        performSearch(termCategory: termCategory)
        
    }
    
    final func performSearch(termCategory: [String : [String]]/*_ term: [String]?*/) {
       
    }
    
    func showAddressTable(addresses: [String], textField: UITextField, placemarks: [CLPlacemark]) {
        
        let addressTableView = AddressTableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        addressTableView.addresses = addresses
        addressTableView.currentTextField = textField
        addressTableView.placemarkArray = placemarks
        addressTableView.mainViewController = self
        addressTableView.delegate = addressTableView
        addressTableView.dataSource = addressTableView
        view.addSubview(addressTableView)
    }
    
    fileprivate func tripSegmentFromMapItem(mapItem: MKMapItem) -> TripSegment {
        
        let placemark = mapItem.placemark
        let name = placemark.name ?? mapItem.name ?? ""
        let locality = placemark.locality ?? ""
        let administrativeArea = placemark.administrativeArea ?? ""  // state
        let postalCode = placemark.postalCode ?? ""
        let isoCountryCode = placemark.isoCountryCode ?? ""
        let address = "\(name), \(locality), \(administrativeArea) \(postalCode), \(isoCountryCode)"
        
        log.info(address)
        
        let geoPoint = PFGeoPoint(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        
        let tripSegment = TripSegment(name: name, address: address, geoPoint: geoPoint)
        return tripSegment
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "StartTrip" {

            // Create a new trip object and save it to the database
            let startSegment = tripSegmentFromMapItem(mapItem: locationTuples[0].mapItem!)
            let destSegment = tripSegmentFromMapItem(mapItem: locationTuples[1].mapItem!)
            
            let trip = Trip(name: destSegment.name ?? "Unnamed Trip", date: Date(), creator: PFUser.current()!)
            trip.addSegment(tripSegment: startSegment)
            trip.addSegment(tripSegment: destSegment)
            
           /* trip.saveInBackground {
                (success, error) in
                if (success) {
                    log.info("trip saved")
                } else {
                    log.error(error?.localizedDescription ?? "Uknown Error")
                }
            }*/
            
            let routeMapViewController = segue.destination  as! RouteMapViewController
            routeMapViewController.locationArray = locationsArray
            routeMapViewController.trip  = trip
            routeMapViewController.termCategory  = termCategory

        }
       
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if locationTuples[0].mapItem == nil || locationTuples[1].mapItem == nil {
            showAlert("Please enter a valid starting point and at least one destination.")
            return false
            
        } else {
            return true
        }
    }
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. In order to use this app, " +
                    "go to Settings → Location and select the \"While Using " + "the App\" setting.")
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
    
    
    // MARK: - Utility methods
    // -----------------------
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
}

extension CreateTripViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    self.locationTuples[0].mapItem = MKMapItem(placemark:
                    MKPlacemark(coordinate: placemark.location!.coordinate,
                    addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
                                                   
                }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async() {
            self.showSimpleAlert(title: "Can't determine your location",
                                 message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
}

extension CreateTripViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        
        let currentTextField = locationTuples[textField.tag-1].textField
        let newPosition = currentTextField?.endOfDocument
        currentTextField?.selectedTextRange = currentTextField?.textRange(from: newPosition!, to: newPosition!)

        CLGeocoder().geocodeAddressString(currentTextField!.text!, completionHandler: {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
                    if let placemarks = placemarks {
                        var addresses = [String]()
                        for placemark in placemarks {
                            print("placemark \(placemark)"); addresses.append(self.formatAddressFromPlacemark(placemark: placemark))
                        }
                                       
                        self.showAddressTable(addresses: addresses, textField: currentTextField!, placemarks: placemarks)
                    } else {
                        self.showAlert("Address not found.")

                    }
            })
    }
    
    func showAlert(_ alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel) {
            (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        
        locationTuples[textField.tag-1].mapItem = nil
        return true
    }
}

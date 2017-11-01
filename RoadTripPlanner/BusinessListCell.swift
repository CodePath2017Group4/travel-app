//
//  BusinessListCell.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/30/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import AFNetworking
import YelpAPI

@objc protocol BusinessListCellDelegate {
    
    @objc optional func businessListCell(businessListCell: BusinessListCell, didTapAddImage business: YLPBusiness)
}

class BusinessListCell: UITableViewCell {
    
    @IBOutlet weak var busImageView: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var displayAddr1: UILabel!
    
    @IBOutlet weak var displayAddr2: UILabel!
    
    @IBOutlet weak var reviewImage: UIImageView!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var addImageView: UIImageView!
    //@IBOutlet weak var ratingTotalLabel: UILabel!
    // @IBOutlet weak var priceLabel: UILabel!
    //  @IBOutlet weak var addPriceSymbolLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var openNowLabel: UILabel!
    weak var delegate: BusinessListCellDelegate?

    var isAdded = false // need to address later
    var business: YLPBusiness! {
        didSet {
            businessName.text = business.name
            
            if let businessImageUrl = business.imageURL {
                busImageView?.setImageWith(businessImageUrl)
                busImageView?.contentMode = .scaleAspectFill
                busImageView?.clipsToBounds = true
                let backgroundimageView = UIImageView()
                backgroundimageView.contentMode = .scaleAspectFill
                backgroundimageView.clipsToBounds = true
                backgroundimageView.setImageWith(businessImageUrl)
                
                // self.backgroundView = backgroundimageView
            }
            
            let ratingsNoCount = business.rating
            
            if !(ratingsNoCount.isLess(than: 4.0))  {
                ratingsCountLabel.backgroundColor = UIColor.green
            }
            else if !(ratingsNoCount.isLess(than: 3.0)) && (ratingsNoCount.isLess(than: 4.0)) {
                ratingsCountLabel.backgroundColor = UIColor.green
            }
            else {
                ratingsCountLabel.backgroundColor = UIColor.yellow
            }
            
            ratingsCountLabel.text = "\(business.rating)"
            
            
            if (business.reviewCount == 1) {
                reviewCountLabel.text = "\(business.reviewCount) \(Constants.BusinessLabels.reviewLabel)"
            } else {
                reviewCountLabel.text = "\(business.reviewCount) \(Constants.BusinessLabels.reviewsLabel)"
            }
            
            if  business.location.address != nil {
                displayAddr1.text = business.location.address[0]
                displayAddr2.text = "\(business.location.city) \(business.location.stateCode)"//business.location.address[0]
                print("business.location.cout \(business.location)")
            }
            
            /*    if let bussinessAddr = business.location?.addressOne {
             print("bussinessAddr \(bussinessAddr)")
             print("bussinessAddr2 \(business.location?.addressTwo)")
             print("bussinessAddr3 \(business.location?.addressThree)")
             print("bussinessAddr  \(business.location?.displayAddress?.count)")
             for da in (business.location?.displayAddress)! {
             print("da \(da)")
             
             }
             
             }*/
            
            if let phone = business.phone {
                phoneLabel.text = "\(phone)"
                print("display phone \(business.phone)")
                
            }
            
            /*if let price = business.price {
             var nDollar = price.count
             
             var missingDollar = 4-nDollar
             var labelDollar = "$"
             var mPrice = ""
             for i in 0..<missingDollar {
             mPrice += labelDollar
             
             }
             priceLabel.text = "\(price)"
             addPriceSymbolLabel.text = "\(mPrice)"
             }
             else {
             priceLabel.isHidden = true
             addPriceSymbolLabel.isHidden = true
             }*/
            
            //print("business.distance \(business.distance)")
            
            /*  if let distance = business.distance {
             var distInMiles = Double.init(distance as! NSNumber) * 0.000621371
             
             distanceLabel.text = String(format: "%.2f", distInMiles)
             }*/
            
            //if
            let closed = business.isClosed //{
            openNowLabel.textColor = closed ? UIColor.red : UIColor.green
            openNowLabel.text = closed ? "Closed" : "Open"
            
            /*if !closed {
             if let hours = business.hours {
             
             
             }
             }*/
            //  }
            
            /* if let photos = business.photos {
             for p in photos {
             print("photos \(p)")
             }
             }*/
            
            /*if let hours = business.hours {
             
             let date = Date()
             let calendar = Calendar.current
             let dayOfWeek = calendar.component(.weekday, from: date)
             for hour in hours {
             let textLabel = UILabel()
             
             textLabel.textColor = hour.isOpenNow! ? UIColor.green : UIColor.red
             textLabel.text = hour.isOpenNow! ? "Open" : "Closed"
             
             let hourOpen = hour.open
             
             let textLabelExt = UILabel()
             textLabelExt.text = ""
             for  day in hourOpen! {
             if (dayOfWeek-1) == day.day! {
             print("hours end \(day.end)")
             var timeString = day.end as! String
             
             
             timeString.insert(":", at: (timeString.index((timeString.startIndex), offsetBy: 2)))
             print("timeString \(timeString)")
             
             /*   let dateAsString = timeString
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "HH:mm"
             let hourClose = dateFormatter.date(from: dateAsString)
             print("hourClose \(hourClose)")
             
             dateFormatter.dateFormat = "h:mm a"
             let date12 = dateFormatter.string(from: date)
             
             
             //let hourClose = day.end!*/
             textLabelExt.text = hour.isOpenNow! ? " untill \(amAppend(str: timeString))" : ""
             
             }
             }
             openNowLabel.text = "\(textLabel.text!) \(textLabelExt.text!)"
             
             print("dayOfWeek\(dayOfWeek)")
             
             
             
             if hour.isOpenNow! {
             /// if let hours = business.hours {
             
             
             //}
             
             for h in hours {
             print("hours \(h.hoursType)")
             print("hours \(h.isOpenNow)")
             print("hours \(h.open)")
             
             for ho in h.open! {
             print("hours \(ho.day)")
             print("hours \(ho.end)")
             print("hours \(ho.isOvernight)")
             print("hours \(ho.toJSONString())")
             
             }
             
             
             }
             
             }
             
             }
             }*/
            
            let ratingsCount = business.rating
            
            if ratingsCount == 0  {
                reviewImage.image = UIImage(named: "0star")
            }
            else if ratingsCount > 0 && ratingsCount <= 1 {
                reviewImage.image = UIImage(named: "1star")
            }
            else if ratingsCount > 1 && ratingsCount <= 1.5 {
                reviewImage.image = UIImage(named: "1halfstar")
            }
            else if ratingsCount > 1.5 && ratingsCount <= 2 {
                reviewImage.image = UIImage(named: "2star")
            }
            else if ratingsCount > 2 && ratingsCount <= 2.5 {
                reviewImage.image = UIImage(named: "2halfstar")
            }
            else if ratingsCount > 2.5 && ratingsCount <= 3 {
                reviewImage.image = UIImage(named: "3star")
            }
            else if ratingsCount > 3 && ratingsCount <= 3.5 {
                reviewImage.image = UIImage(named: "3halfstar")
            }
            else if ratingsCount > 3.5 && ratingsCount <= 4 {
                reviewImage.image = UIImage(named: "4star")
            }
            else if ratingsCount > 4 && ratingsCount <= 4.5 {
                reviewImage.image = UIImage(named: "4halfstar")
            }
            else {
                reviewImage.image = UIImage(named: "5star")
            }
            
            if !(ratingsCount.isLess(than: 4.0))  {
                ratingsCountLabel.backgroundColor = UIColor(red: 39/255, green: 190/255, blue: 73/255, alpha: 1)
                // ratingTotalLabel.backgroundColor = UIColor(red: 39/255, green: 190/255, blue: 73/255, alpha: 1)
            }
            else if !(ratingsCount.isLess(than: 3.0)) && (ratingsCount.isLess(than: 4.0)) {
                ratingsCountLabel.backgroundColor = UIColor.orange
                //  ratingTotalLabel.backgroundColor = UIColor.green
            }
            else {
                ratingsCountLabel.backgroundColor = UIColor.yellow
                //  ratingTotalLabel.backgroundColor = UIColor.yellow
            }
            
            /* let labelString = UILabel()
             labelString.font = UIFont.boldSystemFont(ofSize: 5)
             labelString.text = "5"
             
             ratingsCountLabel.text = "\(business.rating)" + " / " //+ labelString.text!*/
            
            
        }
    }
    
    
    func amAppend(str:String) -> String{
        var temp = str
        var strArr = str.characters.split{$0 == ":"}.map(String.init)
        var hour = Int(strArr[0])!
        var min = Int(strArr[1])!
        if(hour > 12){
            temp = temp + " PM"
        }
        else{
            temp = temp + " AM"
        }
        return temp
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let addImageTap = UITapGestureRecognizer(target: self, action: #selector(addImageTapped))
        addImageTap.numberOfTapsRequired = 1
        addImageView?.isUserInteractionEnabled = true
        addImageView?.addGestureRecognizer(addImageTap)
        
    }
    
    func setAddImage(selected: Bool) {
        if (isAdded) {
            addImageView?.image = UIImage(named: "check")
        } else {
            addImageView?.image = UIImage(named: "plus")
        }
    }
    
    func addImageTapped() {
        
        print("addImageTapped")
        isAdded = !isAdded
        setAddImage(selected: isAdded)
        delegate?.businessListCell?(businessListCell: self, didTapAddImage: self.business)
        
    }
}


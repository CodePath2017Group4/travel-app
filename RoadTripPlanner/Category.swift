//
//  Category.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/20/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class Category {
    
    static let categoriesList = ["servicestations", "food", "publicservicesgovt"/*poi*/,"grocery"/*shopping"*/, "lodging", "things_to_do", "nightlife", "entertainment"]
    
    static let foodSubCategories = ["food" : ["bakeries", "bagels", "coffee", "donuts", "foodtrucks"], "restaurants" : [""]]
    static let shoppingSubCategories = ["shopping" : ["drugstores", "deptstores", "flowers"]]
    static let hotelsSubCategories = ["hotels" : ["bedbreakfast", "campgrounds", "guesthouses", "hostels"]]
    static let TDOSubCategory = ["arts" : ["arcades", "museums"], "active" : ["aquariums", "zoos", "parks", "amusementparks"]]
    static let poiSubCategory = ["publicservicesgovt" : ["landmarks", "civiccenter"]]
    static let entertainmentSubCategory = ["arts" : ["moviestheaters", "galaries", "theater"]]
    static let automotiveSubCategory = ["auto" : ["servicestations", "autoelectric", "parking"]]

    //drugstores, deptstores, flowers
    //food - bakeries, bagels, coffee, donuts, foodtrucks
    //hotels - bedbreakfast, campgrounds, guesthouses. hostels
    //thingstodo
    //arts - arcades, museums
    // active - aquariums, zoos, parks, amusementparks
    // nightlife
    //poi // publicservicesgovt - civiccenter, landmarks,
    //entertainmneet// arts - movietheaters, galleries, theater
    // servicestations
    final func constructSearchTerm(_ term: String, _ subcategories: [String]) -> [String : String] {
        var terms = ""
        var subCat = ""
        
        if term == "auto" {
            terms += (Category.automotiveSubCategory).keys.joined(separator: ",")
            if subcategories.contains("all") {
                subCat += ((Category.automotiveSubCategory ["auto"])?.joined(separator: ","))!
            }
            else {
                subCat += subcategories.joined(separator: ",")
            }
        }
        
        if term == Category.categoriesList[1] {
            terms += (Category.foodSubCategories).keys.joined(separator: ",")
            if subcategories.contains("all") {
                for key in (Category.foodSubCategories).keys {
                    subCat += ((Category.foodSubCategories [key])?.joined(separator: ","))!
                    subCat += ","
                }
            }
            else {
                subCat += subcategories.joined(separator: ",")
                
            }
        }
        
        if term == Category.categoriesList[2] {
            terms += (Category.poiSubCategory).keys.joined(separator: ",")
            if subcategories.contains("all") {
                for key in (Category.poiSubCategory).keys {
                    subCat += ((Category.poiSubCategory [key])?.joined(separator: ","))!
                        subCat += ","
                }
            }
            else {
                subCat += subcategories.joined(separator: ",")
                
            }
        }
        
        if term == Category.categoriesList[3] {
            terms += (Category.shoppingSubCategories).keys.joined(separator: ",")
            if subcategories.contains("all") {
                for key in (Category.shoppingSubCategories).keys {
                    subCat += ((Category.shoppingSubCategories [key])?.joined(separator: ","))!
                        subCat += ","
                }
            }
            else {
                subCat += subcategories.joined(separator: ",")
                
            }
        }
        
        if term == Category.categoriesList[4] {
            terms += (Category.hotelsSubCategories).keys.joined(separator: ",")
            if subcategories.contains("all") {
                for key in (Category.hotelsSubCategories).keys {
                    subCat += ((Category.hotelsSubCategories [key])?.joined(separator: ","))!
                        subCat += ","
                }
            }
            else {
                subCat += subcategories.joined(separator: ",")
                
            }
        }
        
        if term == Category.categoriesList[5] {
            terms += (Category.TDOSubCategory).keys.joined(separator: ",")
            if subcategories.contains("all") {
                for key in (Category.TDOSubCategory).keys {
                    subCat += ((Category.TDOSubCategory [key])?.joined(separator: ","))!
                        subCat += ","
                }
            }
            else {
                subCat += subcategories.joined(separator: ",")
                
            }
        }
        
        if term == Category.categoriesList[6] {
            terms += "nightlife"
        }
        
        if term == Category.categoriesList[7] {
            terms += (Category.entertainmentSubCategory).keys.joined(separator: ",")
            if subcategories.contains("all") {
                for key in (Category.entertainmentSubCategory).keys {
                    subCat += ((Category.entertainmentSubCategory [key])?.joined(separator: ","))!
                        subCat += ","
                }
            }
            else {
                subCat += subcategories.joined(separator: ",")
                
            }
        }
        
        return ["terms" : terms, "sub" : subCat]
        
    }
        
}


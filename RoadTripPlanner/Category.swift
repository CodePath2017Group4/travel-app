//
//  Category.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/20/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class Category {
    
    var terms: [String]!
    
    static let categoriesList = ["servicestations", "food", "publicservicesgovt"/*poi*/,"grocery"/*shopping"*/, "lodging", "things_to_do", "nightlife", "entertainment"]
    
    static let automotiveSubCategory = ["auto" : ["servicestations", "autoelectric", "parking"]] as [String:[String]]
    static let foodSubCategories = ["food" : ["bakeries", "bagels", "coffee", "donuts", "foodtrucks"], "restaurants" : ["All"]]
    static let poiSubCategory = ["publicservicesgovt" : ["landmarks", "civiccenter", "townhall"]]
    static let shoppingSubCategories = ["shopping" : ["drugstores", "deptstores", "flowers"]]
    static let hotelsSubCategories = ["hotels" : ["bedbreakfast", "campgrounds", "guesthouses", "hostels"]]
    static let TDOSubCategory = ["arts" : ["arcades", "museums"], "active" : ["aquariums", "zoos", "parks", "amusementparks"]]
    static let nightlifeSubCategory = ["nightlife" : ["All"]]
    static let entertainmentSubCategory = ["arts" : ["moviestheaters", "galaries", "theater"]]
    
    init(term: String?) {
        var termArray = [String]()
        print("term!.contains(,)  ============================ \(term!.contains(","))")

        if (term!.contains(",")) {
            let termCArray = term?.characters.split(separator: ",") //.split(separator: ",") as! [String]

            for termString in termCArray! {
                let value = String(termString)
                termArray.append(value)
            }
        }
        else {
            termArray.append((term)!)
        }
        print("termArray  ==========in initi================= \(termArray)")

        self.terms = termArray
    }

    func getCategoryList() -> [String] {
        print("term ==========in get list================== \(terms)")

        var categorylist = [String]()
        print("terms  ============================ \(terms)")

        print("terms!.contains(auto)   ============================ \(terms!.contains("auto") )")
            
        if terms!.contains("auto") {
            let autoList = Category.automotiveSubCategory ["auto"] as! [String]
            categorylist.append(contentsOf: autoList)
            print("categorylist inside if ============================ \(categorylist)")
        }

        if terms!.contains("publicservicesgovt") {
            let poiList = Category.poiSubCategory ["publicservicesgovt"] as! [String]
            categorylist.append(contentsOf: poiList)
            print("categorylist inside if ============================ \(categorylist)")
            
        }
        
        if terms!.contains("food") || terms!.contains("restaurants") {
            var foodList = Category.foodSubCategories ["food"] as! [String]
            foodList.append(contentsOf: Category.foodSubCategories ["restaurants"] as! [String])
            
            categorylist.append(contentsOf: foodList)
            print("categorylist inside if ============================ \(categorylist)")
            
        }
        
        if terms!.contains("shopping") {
            var shoppingList = Category.shoppingSubCategories ["shopping"] as! [String]
            
            categorylist.append(contentsOf: shoppingList)
            print("categorylist inside if ============================ \(categorylist)")
            
        }
        
        if terms!.contains("hotels") {
            var hotelsList = Category.hotelsSubCategories ["hotels"] as! [String]
            
            categorylist.append(contentsOf: hotelsList)
            print("categorylist inside if ============================ \(categorylist)")
            
        }
        
        if terms!.contains("arts") || terms!.contains("active") {
            var tdoList = Category.TDOSubCategory ["arts"] as! [String]
            tdoList.append(contentsOf: Category.TDOSubCategory ["active"] as! [String])
            
            categorylist.append(contentsOf: tdoList)
            print("categorylist inside if ============================ \(categorylist)")
            
        }
        
        if terms!.contains("nightlife") {
            var nightlifeList = Category.nightlifeSubCategory ["nightlife"] as! [String]
            
            categorylist.append(contentsOf: nightlifeList)
            print("categorylist inside if ============================ \(categorylist)")
            
        }
        
        if terms!.contains("arts") {
            var entertainmentList = Category.entertainmentSubCategory ["arts"] as! [String]
            
            categorylist.append(contentsOf: entertainmentList)
            print("categorylist inside if ============================ \(categorylist)")
            
        }
        
        return categorylist

    }
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
    /*final func constructSearchTerm(_ term: String, _ subcategories: [String]) -> [String : String] {
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
        
    }*/
        
}


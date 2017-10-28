//
//  Parameters+CDYelpFusionKit.swift
//  CDYelpFusionKit
//
//  Created by Christopher de Haan on 11/10/16.
//
//  Copyright (c) 2016-2017 Christopher de Haan <contact@christopherdehaan.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Alamofire

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    static func searchParameters(withTerm term: String?,
                                 location: String?,
                                 latitude: Double?,
                                 longitude: Double?,
                                 radius: Int?,
                                 categories: [CDYelpCategoryFilter]?,
                                 locale: CDYelpLocale?,
                                 limit: Int?,
                                 offset: Int?,
                                 sortBy: CDYelpSortType?,
                                 priceTiers: [CDYelpPriceTier]?,
                                 openNow: Bool?,
                                 openAt: Int?,
                                 attributes: [CDYelpAttributeFilter]?) -> Parameters {
        var params: Parameters = [:]
        
        if let term = term,
            term != "" {
            params["term"] = term
        }
        if let location = location,
            location != "" {
            params["location"] = location
        }
        if let latitude = latitude {
            params["latitude"] = latitude
        }
        if let longitude = longitude {
            params["longitude"] = longitude
        }
        if let radius = radius {
            params["radius"] = radius
        }
        if let categories = categories,
            categories.count > 0 {
            
            var categoriesString = ""
            for category in categories {
                categoriesString = categoriesString + category.rawValue + ","
            }
            let parametersString = categoriesString.substring(to: categoriesString.index(before: categoriesString.endIndex))
            params["categories"] = parametersString
        }
        if let locale = locale,
            locale.rawValue != "" {
            params["locale"] = locale.rawValue
        }
        if let limit = limit {
            params["limit"] = limit
        }
        if let offset = offset {
            params["offset"] = offset
        }
        if let sortBy = sortBy,
            sortBy.rawValue != "" {
            params["sort_By"] = sortBy.rawValue
        }
        if let priceTiers = priceTiers,
            priceTiers.count > 0 {
            
            var priceString = ""
            for priceTier in priceTiers {
                priceString = priceString + priceTier.rawValue + ","
            }
            let parametersString = priceString.substring(to: priceString.index(before: priceString.endIndex))
            params["price"] = parametersString
        }
        if let openNow = openNow {
            params["open_now"] = openNow
        }
        if let openAt = openAt {
            params["open_at"] = openAt
        }
        if let attributes = attributes,
            attributes.count > 0 {
            
            var attributesString = ""
            for attribute in attributes {
                attributesString = attributesString + attribute.rawValue + ","
            }
            let parametersString = attributesString.substring(to: attributesString.index(before: attributesString.endIndex))
            params["attributes"] = parametersString
        }
        
        return params
    }
    
    static func phoneParameters(withPhoneNumber phoneNumber: String!) -> Parameters {
        var params: Parameters = [:]
        
        if let phone = phoneNumber,
            phone != "" {
            params["phone"] = phone
        }
        
        return params
    }
    
    static func transactionsParameters(withLocation location: String?,
                                       latitude: Double?,
                                       longitude: Double?) -> Parameters {
        var params: Parameters = [:]
        
        if let location = location,
            location != "" {
            params["location"] = location
        }
        if let latitude = latitude {
            params["latitude"] = latitude
        }
        if let longitude = longitude {
            params["longitude"] = longitude
        }
        
        return params
    }
    
    static func businessParameters(withLocale locale: CDYelpLocale?) -> Parameters {
        var params: Parameters = [:]
        
        if let locale = locale,
            locale.rawValue != "" {
            params["locale"] = locale.rawValue
        }
        
        return params
    }
    
    static func reviewsParameters(withLocale locale: CDYelpLocale?) -> Parameters {
        var params: Parameters = [:]
        
        if let locale = locale,
            locale.rawValue != "" {
            params["locale"] = locale.rawValue
        }
        
        return params
    }
    
    static func autocompleteParameters(withText text: String!,
                                       latitude: Double!,
                                       longitude: Double!,
                                       locale: CDYelpLocale?) -> Parameters {
        var params: Parameters = [:]
        
        if let text = text,
            text != "" {
            params["text"] = text
        }
        if let latitude = latitude {
            params["latitude"] = latitude
        }
        if let longitude = longitude {
            params["longitude"] = longitude
        }
        if let locale = locale,
            locale.rawValue != "" {
            params["locale"] = locale.rawValue
        }
        
        return params
    }
}

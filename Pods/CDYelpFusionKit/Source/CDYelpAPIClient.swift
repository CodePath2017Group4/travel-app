//
//  CDYelpAPIClient.swift
//  CDYelpFusionKit
//
//  Created by Christopher de Haan on 11/7/16.
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
import AlamofireObjectMapper

public class CDYelpAPIClient: NSObject {
    
    private lazy var manager: Alamofire.SessionManager = {
        if let accessToken = self.oAuthClient.accessToken() {
            // Get the default headers
            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            // Add the Authorization header
            headers["Authorization"] = "Bearer \(accessToken)"
            // Create a custom session configuration
            let configuration = URLSessionConfiguration.default
            // Add the Authorization header
            configuration.httpAdditionalHeaders = headers
            // Create a session manager with the custom configuration
            return Alamofire.SessionManager(configuration: configuration)
        } else {
            return Alamofire.SessionManager()
        }
    }()
    private let oAuthClient: CDYelpOAuthClient!
    
    // MARK: - Initializers
    
    ///
    /// Initializes a new CDYelpAPIClient object.
    ///
    /// - parameters:
    ///   - clientId: (**Required**) A unique identifier for the Yelp application used for authenticating with the Yelp Fusion API.
    ///   - clientSecret: (**Required**) A unique key for the Yelp application used for authenticating with the Yelp Fusion API. **Do not share this key**.
    ///
    /// - returns: Void
    ///
    public init(clientId: String!,
                clientSecret: String!) {
        assert((clientId != nil && clientId != "") &&
            (clientSecret != nil && clientSecret != ""), "Both a clientId and clientSecret are required to query the Yelp Fusion V3 Developers API oauth endpoint.")
        self.oAuthClient = CDYelpOAuthClient(clientId: clientId,
                                        clientSecret: clientSecret)
        super.init()
        self.authenticate()
    }
    
    // MARK: - Authentication Methods
    
    ///
    /// Attempts to authenticate the Yelp application credentials with the Yelp Fusion API if the Yelp application has not already authenticated.
    ///
    /// - returns: Void
    ///
    private func authenticate() {
        if self.oAuthClient.isAuthorized() == false {
            self.oAuthClient.authorize { (successful, error) in

                if let error = error {
                    print("authorize() failure: ", error.localizedDescription)
                }
            }
        }
    }
    
    ///
    /// Determines whether or not the Yelp application has successfully authenticated with the Yelp Fusion API.
    ///
    /// - returns: Bool
    ///
    public func isAuthenticated() -> Bool {
        return self.oAuthClient.isAuthorized()
    }
    
    ///
    /// Removes the Yelp Fusion API authentication credentials.
    ///
    /// - returns: Void
    ///
    public func unauthenticate() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: CDYelpDefaults.accessToken)
        userDefaults.removeObject(forKey: CDYelpDefaults.expiresIn)
        userDefaults.synchronize()
    }
    
    // MARK: - Yelp Fusion API Methods
    
    ///
    /// This endpoint returns up to 1000 businesses based on the provided search criteria. It has basic information about each business. To get detailed information or reviews, use a returned business id and refer to **fetchBusiness(byId: )** and **fetchReviews(forBusinessId: )**.
    ///
    /// - parameters:
    ///   - byTerm: (Optional) A search term for the Yelp Fusion API to query. (e.g. "food", "restaurants"). If byTerm isn’t included all data will be searched. The byTerm keyword also accepts business names (e.g. "Starbucks").
    ///   - location: (**Required**) Can be (Optional) if either latitude or longitude is provided. Specifies the combination of "address, neighborhood, city, state or zip, optional country" to be used when querying the Yelp Fusion API for businesses.
    ///   - latitude: (**Required**) Can be (Optional) if location is provided. The latitude of the location the Yelp Fusion API should search nearby.
    ///   - longitude: (**Required**) Can be (Optional) if location is provided. The longitude of the location the Yelp Fusion API should search nearby.
    ///   - radius: (Optional) The search radius in meters. If the value is too large, a AREA_TOO_LARGE error may be returned. **The maximum value is 40,000 meters (25 miles)**.
    ///   - categories: (Optional) The categorie(s) to filter the search results with. Use the **CDYelpCategoryFilter** enum to get the list of supported categories. `categories` can be an array of categories (e.g. [.bars, .parks] will filter the results to show businesses that are listed as Bars or Parks).
    ///   - locale: (Optional) Specifies the locale to return the business information in. Use the **CDYelpLocale** enum to get the list of supported locales.
    ///   - limit: (Optional) The number of business results to return. By default, the value is set to 20. **The maximum value is 50**.
    ///   - offset: (Optional) A number the list of returned business results should be offset by.
    ///   - sortBy: (Optional) The sort mode that will be used on the returned business results. Use the **CDYelpSortType** enum to get the list of supported sort types. By default sortBy is set to .bestMatch. The .rating sort is not strictly sorted by the rating value, but by an adjusted rating value that takes into account the number of ratings, similar to a bayesian average. This is so a business with 1 rating of 5 stars doesn’t immediately jump to the top.
    ///   - price: (Optional) The pricing levels to filter the search result with. Use the **CDYelpPriceTier** enum to get the list of supported pricing levels. `price` can be an array of pricing levels (e.g. [.oneDollarSign, .twoDollarSigns, .threeDollarSigns] will filter the results to show businesses that are listed as $, $$, or $$$).
    ///   - openNow: (Optional) When set to true, only businesses open at the current time will be returned. The default value is false. **Notice that open_at and open_now cannot be used together**.
    ///   - openAt: (Optional) An integer representing the Unix time in the same timezone of the search location. If specified, only businesses open at the given time will be returned. **Notice that open_at and open_now cannot be used together**.
    ///   - attributes: (Optional) Additional filters to restrict search results. Use the **CDYelpAttributeFilter** enum to get the list of supported attribute filters. `attributes` can be an array of attributes. If multiple attributes are used, only businesses that satisfy ALL attributes will be returned in search results (e.g. the attributes [.hotAndNew, .cashback] will return businesses that are Hot and New AND offer Cash Back).
    ///   - completion: A completion block in which Yelp Fusion V3 Developers API search endpoint response or error can be parsed.
    ///
    /// - returns: (CDYelpSearchResponse?, Error?) -> Void
    ///
    public func searchBusinesses(byTerm term: String?,
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
                                 attributes: [CDYelpAttributeFilter]?,
                                 completion: @escaping (CDYelpSearchResponse?, Error?) -> Void) {
        assert((latitude != nil && longitude != nil) ||
            (location != nil && location != ""), "Either a latitude and longitude or a location are required to query the Yelp Fusion V3 Developers API search endpoint.")
        if let radius = radius {
            assert((radius <= 40000), "The radius must be 40,000 meters or less to query the Yelp Fusion V3 Developers API search endpoint.")
        }
        if let limit = limit {
            assert((limit <= 50), "The limit must be 50 or less to query the Yelp Fusion V3 Developers API search endpoint.")
        }
        
        if self.isAuthenticated() == true {
            
            let params = Parameters.searchParameters(withTerm: term,
                                                     location: location,
                                                     latitude: latitude,
                                                     longitude: longitude,
                                                     radius: radius,
                                                     categories: categories,
                                                     locale: locale,
                                                     limit: limit,
                                                     offset: offset,
                                                     sortBy: sortBy,
                                                     priceTiers: priceTiers,
                                                     openNow: openNow,
                                                     openAt: openAt,
                                                     attributes: attributes)

            self.manager.request(CDYelpRouter.search(parameters: params)).responseObject { (response: DataResponse<CDYelpSearchResponse>) in

                switch response.result {
                case .success(let searchResponse):
                    completion(searchResponse, nil)
                case .failure(let error):
                    print("searchBusinesses(byTerm) failure: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    ///
    /// This endpoint returns a list of businesses based on the provided phone number. It is possible for more than one businesses having the same phone number (for example, chain stores with the same +1 800 phone number). At this time, this endpoint does not return businesses without any reviews.
    ///
    /// - parameters:
    ///   - byPhoneNumber: (**Required**) The phone number of the business for the Yelp Fusion API to query. It must start with + and include the country code, (e.g. "+14159083801").
    ///   - completion: A completion block in which Yelp Fusion V3 Developers API phone search endpoint response or error can be parsed.
    ///
    /// - returns: (CDYelpSearchResponse?, Error?) -> Void
    ///
    public func searchBusinesses(byPhoneNumber phoneNumber: String!,
                                 completion: @escaping (CDYelpSearchResponse?, Error?) -> Void) {
        assert((phoneNumber != nil && phoneNumber != ""), "A business phone number is required to query the Yelp Fusion V3 Developers API phone endpoint.")
        
        if self.isAuthenticated() == true {
        
            let params = Parameters.phoneParameters(withPhoneNumber: phoneNumber)
            
            self.manager.request(CDYelpRouter.phone(parameters: params)).responseObject { (response: DataResponse<CDYelpSearchResponse>) in
                
                switch response.result {
                case .success(let searchResponse):
                    completion(searchResponse, nil)
                case .failure(let error):
                    print("searchBusinesses(byPhone) failure: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    ///
    /// This endpoint returns a list of businesses which support certain transactions. At this time, this endpoint does not return businesses without any reviews. Currently, this endpoint only supports food delivery in the US.
    ///
    /// - parameters:
    ///   - byType: (**Required**) A transaction type for the Yelp Fusion API to query.
    ///   - latitude: (**Required when location isn't provided**) The latitude of the location you want delivery from.
    ///   - longitude: (**Required when location isn't provided**) The longitude of the location you want delivery from.
    ///   - location: (**Required when latitude and longitude aren't provided**) The address of the location you want delivery from.
    ///   - completion: A completion block in which Yelp Fusion V3 Developers API transactions endpoint response or error can be parsed.
    ///
    /// - returns: (CDYelpSearchResponse?, Error?) -> Void
    ///
    public func searchTransactions(byType type: CDYelpTransactionType!,
                                   location: String?,
                                   latitude: Double?,
                                   longitude: Double?,
                                   completion: @escaping (CDYelpSearchResponse?, Error?) -> Void) {
        assert((latitude != nil && longitude != nil) ||
            (location != nil && location != ""), "Either a latitude and longitude or a location are required to query the Yelp Fusion V3 Developers API transactions endpoint.")
        
        if self.isAuthenticated() == true {
        
            let params = Parameters.transactionsParameters(withLocation: location,
                                                           latitude: latitude,
                                                           longitude: longitude)
            
            self.manager.request(CDYelpRouter.transactions(type: type.rawValue, parameters: params)).responseObject { (response: DataResponse<CDYelpSearchResponse>) in
                
                switch response.result {
                case .success(let searchResponse):
                    completion(searchResponse, nil)
                case .failure(let error):
                    print("searchTransactions(byType) failure: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    ///
    /// This endpoint returns the detail information of a business. To get a business id, refer to **searchBusinesses(byTerm: )**, **searchBusinesses(byPhoneNumber: )**, **searchTransactions(byType: )** or **autocompleteBusinesses(byText: )**. To get review information for a business, refer to **fetchReviews(forBusinessId: )**. At this time, this endpoint does not return businesses without any reviews.
    ///
    /// - parameters:
    ///   - byId: (**Required**) The identifier of the business for the Yelp Fusion API to query.
    ///   - completion: A completion block in which Yelp Fusion V3 Developers API business endpoint response or error can be parsed.
    ///
    /// - returns: (CDYelpBusiness?, Error?) -> Void
    ///
    public func fetchBusiness(byId id: String!,
                              locale: CDYelpLocale?,
                              completion: @escaping (CDYelpBusiness?, Error?) -> Void) {
        assert((id != nil && id != ""), "A business id is required to query the Yelp Fusion V3 Developers API business endpoint.")
        
        if self.isAuthenticated() == true {
        
            let params = Parameters.businessParameters(withLocale: locale)
            
            self.manager.request(CDYelpRouter.business(id: id, parameters: params)).responseObject { (response: DataResponse<CDYelpBusiness>) in
                
                switch response.result {
                case .success(let business):
                    completion(business, nil)
                case .failure(let error):
                    print("fetchBusiness(byId) failure: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    ///
    /// This endpoint returns the up to three reviews for a business.
    ///
    /// - parameters:
    ///   - forBusinessId: (**Required**) The identifier of the business for the Yelp Fusion API to query.
    ///   - locale: (Optional) The interface locale; this determines the language for the reviews to return.
    ///   - completion: A completion block in which Yelp Fusion V3 Developers API reviews endpoint response or error can be parsed.
    ///
    /// - returns: (CDYelpReviewsResponse?, Error?) -> Void
    ///
    public func fetchReviews(forBusinessId id: String!,
                             locale: CDYelpLocale?,
                             completion: @escaping (CDYelpReviewsResponse?, Error?) -> Void) {
        assert((id != nil && id != ""), "A business id is required to query the Yelp Fusion V3 Developers API reviews endpoint.")
        
        if self.isAuthenticated() == true {
        
            let params = Parameters.reviewsParameters(withLocale: locale)
            
            self.manager.request(CDYelpRouter.reviews(id: id, parameters: params)).responseObject { (response: DataResponse<CDYelpReviewsResponse>) in
                
                switch response.result {
                case .success(let reviewsResponse):
                    completion(reviewsResponse, nil)
                case .failure(let error):
                    print("fetchReviews(forBusinessId) failure: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    ///
    /// This endpoint returns autocomplete suggestions for search keywords, businesses and categories, based on the input text.
    ///
    /// - parameters:
    ///   - byText: (**Required**) The text for the Yelp Fusion API to query.
    ///   - latitude: (**Required**) The latitude of the location to look for business autocomplete suggestions.
    ///   - longitude: (**Required**) The longitude of the location to look for business autocomplete suggestions.
    ///   - locale: (Optional) The interface locale; this determines the language for the autocomplete suggestions to return.
    ///   - completion: A completion block in which Yelp Fusion V3 Developers API autocomplete endpoint response or error can be parsed.
    ///
    /// - returns: (CDYelpAutoCompleteResponse?, Error?) -> Void
    ///
    public func autocompleteBusinesses(byText text: String!,
                                       latitude: Double!,
                                       longitude: Double!,
                                       locale: CDYelpLocale?,
                                       completion: @escaping (CDYelpAutoCompleteResponse?, Error?) -> Void) {
        assert((text != nil && text != "") &&
            latitude != nil &&
            longitude != nil, "A search term, latitude, and longitude are required to query the Yelp Fusion V3 Developers API autocomplete endpoint.")
        
        if self.isAuthenticated() == true {
            
            let params = Parameters.autocompleteParameters(withText: text,
                                                           latitude: latitude,
                                                           longitude: longitude,
                                                           locale: locale)
            
            self.manager.request(CDYelpRouter.autocomplete(parameters: params)).responseObject { (response: DataResponse<CDYelpAutoCompleteResponse>) in
                
                switch response.result {
                case .success(let autocompleteResponse):
                    completion(autocompleteResponse, nil)
                case .failure(let error):
                    print("autocompleteBusinesses(byText) failure: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    ///
    /// Cancels any in progress or pending API requests.
    ///
    /// - returns: Void
    ///
    public func cancelAllPendingAPIRequests() {
        self.manager.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}

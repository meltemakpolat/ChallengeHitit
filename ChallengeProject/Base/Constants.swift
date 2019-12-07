//
//  Constants.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit

class Constants: NSObject {

    private struct Domains{
        
        static let development = "http://www.omdbapi.com"
        static let production = ""
        
        static let active = development
        
    }
    
    private struct Routes {
        
        static let api = "/?apikey=\(Constants.apiKey)"
        
    }
    
    struct URL {
        
        static let getFilmsOrDetail = Domains.active + Routes.api
    }
    
    // MARK: *** UserDefaults Keys Constants
    struct UserDefaults {
        
        static let firebaseToken = "firebaseToken"
    }
    
    //MARK: *** Firebase Log Keys Constants
    struct FirebaseEventName {
        
        static let filmDetails = "filmDetails"
    }
    
    // MARK: *** Other Constants
    static let apiKey = "92a820"
    
}

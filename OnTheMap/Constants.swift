//
//  Constants.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/1/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import Foundation

struct Constants {
    
    struct NotificationConstants {
        static let KStudentsRefreshNotification = "StudentsRefresh"
    }
    
    struct Udacity {
        // MARK: URLs
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let AccountSignUpURL = "https://www.udacity.com/account/auth#!/signup"
        static let APISessions = "/api/session"
    }
    
    struct UdacityKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    struct Parse {
        // MARK: API Key
        static let ParseAppID = ""
        static let RestApiKey = ""

        // MARK: URLs
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
    }
    
    
    struct ParseMethods {
        //MARK: StudentLocation
        static let StudentLocation = "/parse/classes/StudentLocation"
        
    }
    
}

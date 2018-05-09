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
        
        struct ParseKeys {
            static let ParseWhereKey = "where"
            static let ParseUniqueKey = "uniqueKey"
            static let ParseFirstNameKey = "firstName"
            static let ParseLastNameKey =  "lastName"
            static let ParseMapStringKey = "mapString"
            static let ParseMediaURLKey = "mediaURL"
            static let ParseLatitudeKey = "latitude"
            static let ParseLongitudeKey = "longitude"
            static let ParseLimitKey = "limit"
            static let ParseOrderKey = "order"
        }
        
        struct ParseValues {
            static let ParseLimitValue = "100"
            static let ParseDescendingOrderValue = "-updatedAt"
        }
        
        
        struct ParseMethods {
            //MARK: StudentLocation
            static let StudentLocation = "/parse/classes/StudentLocation"
            
        }
    }
    
    
    
}

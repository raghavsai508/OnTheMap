//
//  NetworkManagerConvenience.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/2/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    // MARK: Students Information Methods
    func getStudentsInformation(_ completionHandlerForStudentInformtion: @escaping (_ students: [StudentInformation]?,_ error: NSError?) -> Void ) -> URLSessionDataTask? {
        
        var components = getParseURLComponents()
        
        components.queryItems = [
                                URLQueryItem(name: Constants.Parse.ParseKeys.ParseLimitKey, value: Constants.Parse.ParseValues.ParseLimitValue),
                                URLQueryItem(name: Constants.Parse.ParseKeys.ParseOrderKey, value: Constants.Parse.ParseValues.ParseDescendingOrderValue)
                                ]
        
        let url = components.url!
        print(url)
        var request = URLRequest(url: url)
        request.addValue(Constants.Parse.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return taskForURLRequest(request,apiType: .apiParse) { (dataObject, error) in
            if error != nil {
                completionHandlerForStudentInformtion(nil,error)
            } else {
                if let results = dataObject?["results"] as? [[String:AnyObject]] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: results, options: [])
                        let safeStudentsArray = try JSONDecoder().decode([Safe<StudentInformation>].self, from: data)
                        let students = safeStudentsArray.compactMap{ $0.value }
                        completionHandlerForStudentInformtion(students,nil)
                    } catch {
                        // NO need to set it completion Handler
                        print(error)
                    }
                } else {
                    var errorString = ""
                    if let errorValue = dataObject?["error"] as? String {
                        errorString = errorValue
                    }
                    
                    let userInfo = [NSLocalizedDescriptionKey : "Could not retreive users location: \(errorString)"]
                    completionHandlerForStudentInformtion(nil,NSError(domain: "getStudentsInformation", code: 0, userInfo: userInfo))
                }
            }
        }
    }
    
    func getCurrentStundentInformation(_ completionHandlerForCurrentStudent: @escaping (_ studentInformation: StudentInformation?, _ error: NSError?) -> Void) -> URLSessionDataTask? {

        var components = getParseURLComponents()

        let dataStore = DataStore.sharedInstance()
        
        let jsonBody = "{\"\(Constants.Parse.ParseKeys.ParseUniqueKey)\":\"\(dataStore.accountID)\"}"
        
        components.queryItems = [URLQueryItem(name: Constants.Parse.ParseKeys.ParseWhereKey, value: jsonBody)]
        let url = components.url!
        print(url)
        var request = URLRequest(url: url)
        
        request.addValue(Constants.Parse.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

        return taskForURLRequest(request, apiType: .apiParse) { (dataObject, error) in
            if error != nil {
                completionHandlerForCurrentStudent(nil,error)
            } else {
                if let results = dataObject?["results"] as? [[String:AnyObject]] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: results, options: [])
                        let safeStudentsArray = try JSONDecoder().decode([Safe<StudentInformation>].self, from: data)
                        let students = safeStudentsArray.compactMap{ $0.value }
                        completionHandlerForCurrentStudent(students[0],nil)
                    } catch {
                        // NO need to set it completion Handler
                        print(error)
                    }
                } else{
                    
                    let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(String(describing: dataObject))'"]
                    completionHandlerForCurrentStudent(nil,NSError(domain: "getCurrentStundentInformation", code: 0, userInfo: userInfo))
                }
            }
        }
    }
    
    func updateStudentLocation(method: String,latitude: Double,longitude: Double, mediaURL: String,_ completionHandlerForPostStudentLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        let studentInfo = DataStore.sharedInstance().currentStudent
        
        var components = getParseURLComponents()
        if method == "PUT" {
            components.path = components.path + "/\(studentInfo!.objectId)"
        }
        
        let url = components.url!
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(Constants.Parse.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let uniqueKey = studentInfo?.uniqueKey ?? ""
        let firstName = studentInfo?.firstName ?? ""
        let lastName = studentInfo?.lastName ?? ""
        let mapString = studentInfo?.mapString ?? ""
        
        let jsonBody = "{\"\(Constants.Parse.ParseKeys.ParseUniqueKey)\": \"\(uniqueKey)\", \"\(Constants.Parse.ParseKeys.ParseFirstNameKey)\": \"\(firstName)\", \"\(Constants.Parse.ParseKeys.ParseLastNameKey)\": \"\(lastName)\",\"\(Constants.Parse.ParseKeys.ParseMapStringKey)\": \"\(mapString)\", \"\(Constants.Parse.ParseKeys.ParseMediaURLKey)\": \"\(mediaURL)\",\"\(Constants.Parse.ParseKeys.ParseLatitudeKey)\": \(latitude), \"\(Constants.Parse.ParseKeys.ParseLongitudeKey)\": \(longitude)}"
        
        request.httpBody = jsonBody.data(using: .utf8)
        
        return taskForURLRequest(request, apiType: .apiParse) { (dataObject, error) in
            if error != nil {
                completionHandlerForPostStudentLocation(false, error!)
            } else {
                if  dataObject?["objectId"] != nil || dataObject?["updatedAt"] != nil {
                    completionHandlerForPostStudentLocation(true, nil)
                } else {
                    var errorString = ""
                    if let errorValue = dataObject?["error"] as? String {
                        errorString = errorValue
                    }
                    
                    let userInfo = [NSLocalizedDescriptionKey : "Could not update student location: '\(errorString)'"]
                    completionHandlerForPostStudentLocation(false, NSError(domain: "postStudentLocation", code: 0, userInfo: userInfo))
                }
            }
        }
        
    }
    
    
    //MARK: Login Methods
    func loginWith(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) -> URLSessionDataTask? {
        
        let jsonBody = "{\"udacity\": {\"\(Constants.UdacityKeys.Username)\": \"\(username)\", \"\(Constants.UdacityKeys.Password)\": \"\(password)\"}}"
        
        var components = URLComponents()
        components.scheme = Constants.Udacity.APIScheme
        components.host = Constants.Udacity.APIHost
        components.path = Constants.Udacity.APISessions
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)

        return taskForURLRequest(request,apiType: .apiUdacity) { (dataObject, error) in
            if error != nil {
                completionHandlerForLogin(false,error!.localizedDescription)
            } else {
                if let session = dataObject?["session"] as? AnyObject,
                    let sessionID = session["id"] as? String,
                    let account = dataObject?["account"] as? AnyObject,
                    let accountID = account["key"] as? String {
                    let dataStore = DataStore.sharedInstance()
                    dataStore.loginSessionID(sessionID: sessionID)
                    dataStore.loginAccountID(accountID: accountID)
                    print(dataStore.sessionID)
                    completionHandlerForLogin(true,nil)
                } else if let errorMessage = dataObject?["error"] as? String {
                    completionHandlerForLogin(false,errorMessage)
                }
            }
        }
    }
    
    func logout(_ completionHandlerForLogout: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        var components = URLComponents()
        components.scheme = Constants.Udacity.APIScheme
        components.host = Constants.Udacity.APIHost
        components.path = Constants.Udacity.APISessions

        var request = URLRequest(url: components.url!)
        request.httpMethod = "DELETE"

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        return taskForURLRequest(request, apiType: .apiUdacity, completionHandlerForRequest: { (dataObject, error) in
            if error != nil {
                completionHandlerForLogout(false,error)
            } else {
                if let session = dataObject?["session"] as? AnyObject,
                    let _ = session["id"] as? String {
                    let dataStore = DataStore.sharedInstance()
                    dataStore.logoutSession()
                    completionHandlerForLogout(true,nil)
                } else if let errorMessage = dataObject?["error"] as? String {
                    let userInfo = [NSLocalizedDescriptionKey : "Could not Logout student location: '\(String(describing: errorMessage))'"]
                    completionHandlerForLogout(false,NSError(domain: "postStudentLocation", code: 0, userInfo: userInfo))
                }
            }
        })
        
    }
    
    
    
    //MARK: Helper methods
    func getParseURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = Constants.Parse.APIScheme
        components.host = Constants.Parse.APIHost
        components.path = Constants.Parse.ParseMethods.StudentLocation
        return components
    }
    
    
    
}

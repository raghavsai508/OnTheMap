//
//  NetworkManagerConvenience.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/2/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import Foundation

extension NetworkManager {
    // MARK: GET Convenience Methods
    
    func getStudentsInformation(_ completionHandlerForStudentInformtion: @escaping (_ students: [StudentInformation]?,_ error: NSError?) -> Void ) {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.APIScheme
        components.host = Constants.Parse.APIHost
        components.path = Constants.ParseMethods.StudentLocation
        
        let url = components.url!
        print(url)
        var request = URLRequest(url: url)
        request.addValue(Constants.Parse.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        taskForURLRequest(request,apiType: .apiParse) { (dataObject, error) in
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
                        print(error)
//                        completionHandlerForStudentInformtion(nil,error as NSError)
                    }
                }
            }
        }
    }
    
    
    func loginWith(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        
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

        taskForURLRequest(request,apiType: .apiUdacity) { (dataObject, error) in
                
            if error != nil {
                completionHandlerForLogin(false,error!.localizedDescription)
            } else {
                if let session = dataObject?["session"] as? AnyObject,let sessionID = session["id"] as? String {
                    let dataStore = DataStore.sharedInstance()
                    dataStore.loginSessionID(sessionID: sessionID)
                    print(dataStore.sessionID)
                    completionHandlerForLogin(true,nil)
                } else if let errorMessage = dataObject?["error"] as? String {
                    completionHandlerForLogin(false,errorMessage)
                }
            }
            
        }
    }
    
}

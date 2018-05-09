//
//  NetworkManager.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/2/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    enum APIType {
        case apiUdacity
        case apiParse
    }
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> NetworkManager {
        struct Singleton {
            static var sharedInstance = NetworkManager()
        }
        return Singleton.sharedInstance
    }
    
    
    //MARK: URLRequest
    func taskForURLRequest(_ urlRequest: URLRequest,apiType: APIType, completionHandlerForRequest: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForRequest(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler) s
            
            self.convertDataWithCompletionHandler(data,apiType: apiType,completionHandlerForConvertData: completionHandlerForRequest)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    private func convertDataWithCompletionHandler(_ data: Data,apiType: APIType, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            switch apiType {
                case .apiUdacity:
                    let range = Range(5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                case .apiParse:
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            }
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    
    // create a URL from parameters
    private func urlFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Udacity.APIScheme
        components.host = Constants.Udacity.APIHost
        components.path = withPathExtension ?? ""
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

    
    
}

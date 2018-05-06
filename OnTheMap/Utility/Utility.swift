//
//  Utility.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/5/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import Foundation
import UIKit

extension NetworkManager {
    class func verifyURL(urlString: String?) -> Bool {
        if let urlString = urlString, let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

extension UIViewController {
    func showAlert(message: String, title: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

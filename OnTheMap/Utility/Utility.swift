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
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showLoadingImage() {
        let loadingImageView = UIImageView(image: UIImage(named: "loading"))
        loadingImageView.tag = 99
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingImageView)
        view.bringSubview(toFront: loadingImageView)
        let views = ["loading": loadingImageView, "view": view] as [String: Any]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=0)-[loading(50)]", options: NSLayoutFormatOptions.alignAllCenterY , metrics: nil, views: views)
        let verticalConstraints  = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=0)-[loading(50)]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
    }
    
    func hideLoadingImage() {
        let subViews = view.subviews
        for view in subViews {
            if view is UIImageView && view.tag == 99 {
                view.removeFromSuperview()
            }
        }
    }
}

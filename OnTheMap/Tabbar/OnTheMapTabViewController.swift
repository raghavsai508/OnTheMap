//
//  OnTheMapTabViewController.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/2/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import UIKit

class OnTheMapTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentsInformation()
        getCurrentStudentInformation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Get Students Information
    private func getStudentsInformation() {
        
        // Show Loading indicator
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                viewController.showLoadingImage()
            }
        }
        
        
        let networkManager = NetworkManager.sharedInstance()
        _ = networkManager.getStudentsInformation { (studentsInformation, error) in
            DispatchQueue.main.async {
                //Hide the Loading Indicator
                if let viewControllers = self.viewControllers {
                    for viewController in viewControllers {
                        viewController.hideLoadingImage()
                    }
                }
                
                if error == nil {
                    DataStore.sharedInstance().storeStudents(studentsData: studentsInformation!)
                    NotificationCenter.default.post(name: Notification.Name(Constants.NotificationConstants.KStudentsRefreshNotification), object: nil)
                }
            }
        }
    }
    
    func getCurrentStudentInformation() {
        let networkManager = NetworkManager.sharedInstance()
       _ = networkManager.getCurrentStundentInformation { (studentInformation, error) in
            DispatchQueue.main.async {
                if error == nil, let studentInformation = studentInformation {
                    DataStore.sharedInstance().storeCurrentStudent(currentStudent: studentInformation)
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    
    //MARK: Actions
    @IBAction func btnLogoutAction(_ sender: Any) {
        let networkManager = NetworkManager.sharedInstance()
        _ = networkManager.logout { (success, error) in
            DispatchQueue.main.async {
                if success {
                    print("successfully logged out")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(message: error!.localizedDescription, title: "")
                }
            }
        }
        
    }
    
    @IBAction func btnAddLocationAction(_ sender: Any) {
        if let studentInfo = DataStore.sharedInstance().currentStudent {
            showOverwriteAlert(userName: "\(studentInfo.firstName) \(studentInfo.lastName)")
        } else {
            showInformationPostController()
        }
    }
    
    @IBAction func btnRefreshAction(_ sender: Any) {
        self.getStudentsInformation()
    }
    
    //MARK: Helper Methods
    private func showInformationPostController() {
        if let navigationController = storyboard?.instantiateViewController(withIdentifier: "AddMapNavController") as? UINavigationController {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
//    private func addLoadingImageFor(viewController: UIViewController) {
//        let loadingImageView = UIImageView(image: UIImage(named: "loading"))
//        loadingImageView.tag = 99
//        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
//        viewController.view.addSubview(loadingImageView)
//        viewController.view.bringSubview(toFront: loadingImageView)
//        let views = ["loading": loadingImageView, "view": viewController.view] as [String: Any]
//        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=0)-[loading(50)]", options: NSLayoutFormatOptions.alignAllCenterY , metrics: nil, views: views)
//        let verticalConstraints  = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=0)-[loading(50)]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
//        NSLayoutConstraint.activate(horizontalConstraints)
//        NSLayoutConstraint.activate(verticalConstraints)
//    }
//
//    private func removeLoadingImageFor(viewController: UIViewController) {
//        let subViews = viewController.view.subviews
//        for view in subViews {
//            if view is UIImageView && view.tag == 99 {
//                view.removeFromSuperview()
//            }
//        }
//    }
    
    
    
    
    //MARK: Utility Methods
    private func showOverwriteAlert(userName: String) {
        let message = "User \"\(userName)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { _ in
            DataStore.sharedInstance().updateOverwriteStudentLocation(overwriteStudentLocation: true)
            self.showInformationPostController()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(overwriteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }

    
}

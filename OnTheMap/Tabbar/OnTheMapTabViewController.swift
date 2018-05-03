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
        self.getStudentsInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI Get Students Information
    private func getStudentsInformation() {
        let networkManager = NetworkManager.sharedInstance()
        networkManager.getStudentsInformation { (studentsInformation, error) in
            DispatchQueue.main.async {
                if error == nil {
                    DataStore.sharedInstance().storeStudents(studentsData: studentsInformation!)
                    NotificationCenter.default.post(name: Notification.Name(Constants.NotificationConstants.KStudentsRefreshNotification), object: nil)

                }
            }
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        let dataStore = DataStore.sharedInstance()
        dataStore.logoutSession()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddLocationAction(_ sender: Any) {
    }
    
    @IBAction func btnRefreshAction(_ sender: Any) {
        self.getStudentsInformation()
    }
    
    
}

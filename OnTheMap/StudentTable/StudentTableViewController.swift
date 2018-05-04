//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/2/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    //MARK: Private Variable
    internal var studentsArray: [StudentInformation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
        registerForNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations()
    }
    
    private func registerForNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(loadStudentLocations), name: Notification.Name(Constants.NotificationConstants.KStudentsRefreshNotification), object: nil)
    }

    
     @objc private func loadStudentLocations() {
        if let students = DataStore.sharedInstance().students {
            studentsArray = students
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as! StudentTableViewCell
        let studentInfo = studentsArray[indexPath.row]
        cell.configureStudentCell(studentInfo: studentInfo)
        return cell
    }

    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = studentsArray[indexPath.row]
        if verifyURL(urlString: studentInfo.mediaURL) {
            UIApplication.shared.open(URL(string: studentInfo.mediaURL)!, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: Helper methods
    private func verifyURL(urlString: String?) -> Bool {
        if let urlString = urlString, let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    
}

//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/2/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Private Variable
    internal var studentsArray: [StudentInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.registerForNotifications()
    }

    private func registerForNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(loadStudentLocations), name: Notification.Name(Constants.NotificationConstants.KStudentsRefreshNotification), object: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Map Loading
    @objc private func loadStudentLocations() {
        if let students = DataStore.sharedInstance().students {
            studentsArray = students
            for studentInfo in studentsArray {
                let studentName = studentInfo.firstName + studentInfo.lastName
                let coordinate = CLLocationCoordinate2D(latitude: studentInfo.latitude, longitude: studentInfo.longitude)
                let studentAnnotation = StudentAnnotation(studentName: studentName, urlString: studentInfo.mediaURL, coordinate: coordinate)
                self.mapView.addAnnotation(studentAnnotation)
            }
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    
    
    
}

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations()
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
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        if let students = DataStore.sharedInstance().students {
            studentsArray = students
            for studentInfo in studentsArray {
                let studentName = studentInfo.firstName + studentInfo.lastName
                let coordinate = CLLocationCoordinate2D(latitude: studentInfo.latitude, longitude: studentInfo.longitude)
                let studentAnnotation = StudentAnnotation(studentName: studentName, urlString: studentInfo.mediaURL, coordinate: coordinate)
                mapView.addAnnotation(studentAnnotation)
            }
        }
    }
    
    
    //MARK: Internal Utility Methods
    internal func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StudentAnnotation else { return nil }
        let annotationIdentifier = "StudentAnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        openURLForAnnotationView(view: view)
    }
    
    //MARK: MapView Helper methods
    private func openURLForAnnotationView(view: MKAnnotationView) {
        if view.annotation is StudentAnnotation,
            let annotation = view.annotation as? StudentAnnotation,
            verifyURL(urlString: annotation.urlString) {
            UIApplication.shared.open(URL(string: annotation.urlString!)!, options: [:], completionHandler: nil)
        } else {
            showAlert(withMessage: "Invalid URL")
        }
    }
    
    
    private func verifyURL(urlString: String?) -> Bool {
        if let urlString = urlString, let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    
}

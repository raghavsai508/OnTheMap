//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/4/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: Private Variables
    private lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Outlet Actions
    @IBAction func btnFindLocationAction(_ sender: Any) {
        
        if txtLocation.text!.isEmpty {
            showAlert(message: "Must Enter a Location", title: "Location Not Found")
        } else if txtWebsite.text!.isEmpty {
            showAlert(message: "Must Enter a Website", title: "Location Not Found")
        } else {
            if NetworkManager.verifyURL(urlString: txtWebsite.text) {
                geocoder.geocodeAddressString(txtLocation.text!) { (placemarks, error) in
                    self.processGeoAddress(withPlacemarks: placemarks, error: error)
                }
            } else {
                showAlert(message: "Invalid Link. Include HTTP(S)://.", title: "Location Not Found")
            }
        }
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnFinishAction(_ sender: Any) {
        
    }
    
    
    
    //MARK: Helper Methods
    private func processGeoAddress(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            showAlert(message: "Could Not Geocode the String", title: "Location Not Found")
        } else {
            var placemark: CLPlacemark?
            if let placemarks = placemarks, placemarks.count > 0 {
                placemark = placemarks.first
            }
            
            if let placemark = placemark,
                let coordinate = placemark.location?.coordinate,
                let name = placemark.name,
                let administrativeArea = placemark.administrativeArea,
                let country = placemark.country {
                mapContainerView.isHidden = false
                let annotation = MKPointAnnotation()
                annotation.title = "\(name), \(administrativeArea), \(country)"
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                mapView.setCenter(annotation.coordinate, animated: true)
            } else {
                showAlert(message: "Could Not Geocode the String", title: "Location Not Found")
            }
        }
    }
}

// MARK: - InformationPostingViewController: UITextFieldDelegate
extension InformationPostingViewController: UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

extension InformationPostingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AddAnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}

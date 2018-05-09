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
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: Private Variables
    private lazy var geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var sessionDataTask: URLSessionDataTask?
    
    //MARK: Internal Variables
    internal var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
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
                showLoadingImage()
                geocoder.geocodeAddressString(txtLocation.text!) { (placemarks, error) in
                    self.hideLoadingImage()
                    self.processGeoAddress(withPlacemarks: placemarks, error: error)
                }
            } else {
                showAlert(message: "Invalid Link. Include HTTP(S)://.", title: "Location Not Found")
            }
        }
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        if let dataTask = sessionDataTask {
            dataTask.cancel()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnFinishAction(_ sender: Any) {
        let overwriteStudentLocation = DataStore.sharedInstance().overwriteStudentLocation
        showLoadingImage()
        if overwriteStudentLocation {
            sessionDataTask = NetworkManager.sharedInstance().updateStudentLocation(method: "PUT", latitude: (placemark?.location?.coordinate.latitude)!, longitude: (placemark?.location?.coordinate.longitude)!, mediaURL: txtWebsite.text!) { (success, error) in
                DispatchQueue.main.async {
                    self.hideLoadingImage()
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.showAlert(message: error!.localizedDescription, title: "")
                    }
                }
            }
        } else {
            sessionDataTask = NetworkManager.sharedInstance().updateStudentLocation(method: "POST", latitude: (placemark?.location?.coordinate.latitude)!, longitude: (placemark?.location?.coordinate.longitude)!, mediaURL: txtWebsite.text!) { (success, error) in
                DispatchQueue.main.async {
                    self.hideLoadingImage()
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.showAlert(message: error!.localizedDescription, title: "")
                    }
                }
            }
        }
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
                self.placemark = placemark
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func userDidTap(_ sender: Any) {
        resignIfFirstResponder(txtLocation)
        resignIfFirstResponder(txtWebsite)
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: Show/Hide Keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        scrollView.isScrollEnabled = true
        let keyboardHeightValue = keyboardHeight(notification)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeightValue, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardHeightValue
        if let activeField = activeField {
            if (!aRect.contains(activeField.frame.origin)){
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let keyboardHeightValue = keyboardHeight(notification)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardHeightValue, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.endEditing(true)
        scrollView.isScrollEnabled = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
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

// MARK: - InformationPostingViewController (Notifications)
private extension InformationPostingViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

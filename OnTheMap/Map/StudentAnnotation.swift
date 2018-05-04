//
//  StudentAnnotation.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/3/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation {
    let studentName: String?
    let urlString: String?
    let coordinate: CLLocationCoordinate2D
    
    init(studentName: String, urlString: String, coordinate: CLLocationCoordinate2D) {
        self.studentName = studentName
        self.urlString = urlString
        self.coordinate = coordinate
        super.init()
    }
    
    var title: String? {
        return studentName
    }
    
    var subtitle: String? {
        return urlString
    }
    
    
}

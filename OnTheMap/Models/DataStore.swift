//
//  DataStore.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/2/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import Foundation

class DataStore: NSObject {
    // MARK: Public Properties
    private(set) var sessionID: String = ""
    private(set) var accountID: String = ""
    private(set) var students: [StudentInformation]?
    private(set) var currentStudent: StudentInformation?
    private(set) var overwriteStudentLocation: Bool = false
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> DataStore {
        struct Singleton {
            static var sharedInstance = DataStore()
        }
        return Singleton.sharedInstance
    }
    
    // Login Methods
    func loginSessionID(sessionID: String) {
        self.sessionID = sessionID
    }
    
    func logoutSession() {
        sessionID = ""
        //Make Service Call for logging out to remove session id
    }
    
    func loginAccountID(accountID: String) {
        self.accountID = accountID
    }
    
    // Students Store 
    func storeStudents(studentsData: [StudentInformation]) {
        self.students = studentsData
    }
    
    func storeCurrentStudent(currentStudent: StudentInformation) {
        self.currentStudent = currentStudent
    }
    
    func updateOverwriteStudentLocation(overwriteStudentLocation: Bool) {
        self.overwriteStudentLocation = overwriteStudentLocation
    }
    
    
}

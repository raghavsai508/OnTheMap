//
//  StudentTableViewCell.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/3/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblURLString: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureStudentCell(studentInfo: StudentInformation) {
        lblFullName.text = studentInfo.firstName + studentInfo.lastName
        lblURLString.text = studentInfo.mediaURL
    }
    
}

//
//  SecondViewController.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {
    
    var detailedStudent: DetailedStudent = DetailedStudent();
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var campus: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var projectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail.text = detailedStudent.email
        profilePicture.image = detailedStudent.profilePicture
        campus.text = detailedStudent.campus
    }
    

    

    
  
}



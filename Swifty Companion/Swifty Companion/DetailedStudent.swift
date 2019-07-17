//
//  DetailedStudent.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/17.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit

class DetailedStudent {
    let name: String
    let email: String
    let campus: String
    let profilePicture: UIImage
    
    init(name: String, campus: String, profilePicture: UIImage){
        self.name = name
        self.campus = campus
        self.profilePicture = profilePicture
        self.email = name+"@student.wethinkcode.co.za"
    }
    init(){
        self.name = ""
        self.campus = ""
        self.profilePicture = UIImage(named: "default")!
        self.email = ""
    }

}

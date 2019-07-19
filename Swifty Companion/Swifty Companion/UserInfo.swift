//
//  UserInfo.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/19.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit

class UserInfo {
    let mark:String
    let name:String
    let slug:String
    let userType:String
    
    init(mark: String, name: String, slug: String, userType:String) {
        self.mark = mark
        self.name = name
        self.slug = slug
        self.userType = userType
    }
}

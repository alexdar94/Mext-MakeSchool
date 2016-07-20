//
//  User.swift
//  Mext
//
//  Created by Alex Lee on 18/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation

class User {
    var UID = ""
    var email = ""
    var displayName = ""
    var photoUrl = ""
    var phoneNumber = ""
    var friends = [String]()
    
    init(){}
    
    init(UID: String, email: String, displayName: String, photoUrl: String, phoneNumber: String){
        self.UID = UID
        self.email = email
        self.displayName = displayName
        self.photoUrl = photoUrl
        self.phoneNumber = phoneNumber
    }
}
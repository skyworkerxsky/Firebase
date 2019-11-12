//
//  User.swift
//  ToDo-Firebase
//
//  Created by Алексей on 12/11/2019.
//  Copyright © 2019 Alexey Makarov. All rights reserved.
//

import Foundation
import Firebase

struct MyUser {
    
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}

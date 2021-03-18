//
//  User.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 24.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object{
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
}

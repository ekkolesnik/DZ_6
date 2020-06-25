//
//  Users.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 10.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object, Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.firstName < rhs.firstName
    }
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var image: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }

}

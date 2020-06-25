//
//  Groups.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 12.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

class Groups: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var id: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

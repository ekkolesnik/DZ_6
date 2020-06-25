//
//  File.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 27.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

class Photo: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageURL: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

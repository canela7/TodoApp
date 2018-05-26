//
//  Item.swift
//  Todo
//
//  Created by Brian Canela on 5/26/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

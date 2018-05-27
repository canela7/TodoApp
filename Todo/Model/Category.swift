//
//  Category.swift
//  Todo
//
//  Created by Brian Canela on 5/26/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    let items = List<Item>()
    
}

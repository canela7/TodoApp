//
//  Item.swift
//  Todo
//
//  Created by Brian Canela on 5/23/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import Foundation

//encodable for this customize class can save items , decode to load items, thus use Codable
class Item: Codable {
    
    var title : String = "";
    var done : Bool = false;
    
    
}

//
//  Item.swift
//  todoey
//
//  Created by mac on 4/29/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    let paterntCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

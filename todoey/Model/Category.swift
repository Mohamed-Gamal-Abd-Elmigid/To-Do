//
//  Category.swift
//  todoey
//
//  Created by mac on 4/29/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object
{
   @objc  dynamic var name : String = ""
   @objc dynamic var color : String = "" 
    let items = List<Item>()
    
}

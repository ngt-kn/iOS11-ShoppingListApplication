//
//  ListItem.swift
//  MyListApp
//
//  Created by Kenneth Nagata on 5/12/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import Foundation
import RealmSwift

// ListItem objects data model managed by Realm
class ListItem: Object {
    // Declare class properties
    @objc dynamic var itemName: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var price: Float = 0
    @objc dynamic var quantity: Int = 0
    // Set up many to on relationship w/Category
    var parentCategory = LinkingObjects(fromType: Category.self , property: "items")
}

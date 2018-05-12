//
//  Category.swift
//  MyListApp
//
//  Created by Kenneth Nagata on 5/12/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import Foundation
import RealmSwift

// Category objects data model managed by Realm
class Category: Object {
    
    // class properties
    @objc dynamic var categoryName: String = ""
    let items = List<ListItem>() // Set a one to many relationship to ListItem
}

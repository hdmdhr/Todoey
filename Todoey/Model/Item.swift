//
//  Item.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/8.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

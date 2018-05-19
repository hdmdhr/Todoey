//
//  Category.swift
//  Todoey
//
//  Created by 胡洞明 on 2018/5/8.
//  Copyright © 2018年 胡洞明. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var colorHex = ""
    
    var items = List<Item>()
}

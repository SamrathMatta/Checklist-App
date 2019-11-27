//
//  Item2.swift
//  Checklist App
//
//  Created by Samrath Matta on 11/26/19.
//  Copyright © 2019 Samrath Matta. All rights reserved.
//

import Foundation
import RealmSwift

class Item2 : Object {
    @objc dynamic var titlle : String = ""
    @objc dynamic var done: Bool = false
}

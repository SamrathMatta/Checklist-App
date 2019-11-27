//
//  Data.swift
//  Checklist App
//
//  Created by Samrath Matta on 11/26/19.
//  Copyright © 2019 Samrath Matta. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}

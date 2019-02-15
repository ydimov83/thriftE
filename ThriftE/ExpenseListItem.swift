//
//  ThriftEItem.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import Foundation

class ExpenseListItem: NSObject, Codable {
    var name = ""
    var amount = ""
    var date = Date()
}

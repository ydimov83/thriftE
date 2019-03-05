//
//  Expense+CoreDataProperties.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/4/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var name: String

}

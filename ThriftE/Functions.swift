//
//  Functions.swift
//  ThriftE
//
//  Created by Yavor Dimov on 2/24/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import Foundation

var total: Double = 0.00
var categoryTotal: [Double] = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let CoreDataSaveFailedNotification =
    Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

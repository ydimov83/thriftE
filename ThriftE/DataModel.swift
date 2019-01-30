//
//  DataModel.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/30/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//


import Foundation


class DataModel {
    var items = [ExpenseListItem]()
    
    init () {
        loadChecklists()
    }
    //MARK: - Data Management
    
    //Find out where app directory is
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("pathing stuff: \(paths[0])")
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("ShoppingList.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        
        // the do statement here is used since we know that the code after it can throw an error, thus we must be able to catch it if it occurs
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([ExpenseListItem].self, from: data)
            }
            catch {
                print("Encountered an error trying to decode data: \(error.localizedDescription)")
            }
        }
    }
}

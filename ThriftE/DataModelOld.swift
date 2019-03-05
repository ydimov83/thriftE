//
//  DataModel.swift
//  ThriftE
//
//  Created by Yavor Dimov on 1/30/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//


import Foundation


class DataModelOld {
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
        return documentsDirectory().appendingPathComponent("ExpenseList.plist")
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
        
        //TODO: - Remove from final version
        //Load dummy data for testing if no saved data exists
        if items.count == 0 {
            items.append(ExpenseListItem(name: "car service", amount: 10.00, category: .car))
             items.append(ExpenseListItem(name: "car wash", amount: 30.00, category: .car))
             items.append(ExpenseListItem(name: "veggies", amount: 7.00, category: .groceries))
             items.append(ExpenseListItem(name: "fruit", amount: 13.00, category: .groceries))
        }
    }
    
    //MARK: - Helper Methods
    func updateTotals() {
        //Zero out existing totals first to avoid miscalculation
        total = 0.00
        categoryTotal =  [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
        var catIndex: Int?

        for item in items {
            total = total + item.amount
            
            //Map the category to an index
            ExpenseCategories.allCases.forEach{
                if item.category == $0.rawValue{
                    catIndex = getHashValueFromCategoryName(category: $0)
                }
            }
            categoryTotal[catIndex!] = categoryTotal[catIndex!] + item.amount
            print("categoryTotal for \(item.category) is: \(categoryTotal[catIndex!])")
        }
        print("Grand total is: \(total)")
    }
    
}

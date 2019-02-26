//
//  AnalyzeExpensesViewController.swift
//  ThriftE
//
//  Created by Yavor Dimov on 2/24/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class AnalyzeExpensesViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        totalLabel.text = "\(total)"
        print("total is: \(total)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

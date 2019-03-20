//
//  DateCollectionViewCell.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/19/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
 
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateLabelText: String = "" {
        didSet
        {
            dateLabel.text = dateLabelText
        }
    }
    
}

//
//  ExpenseListCell.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/14/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class ExpenseListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        selectedBackgroundView = selection    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

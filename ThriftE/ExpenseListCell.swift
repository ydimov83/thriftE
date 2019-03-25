//
//  ExpenseListCell.swift
//  ThriftE
//
//  Created by Yavor Dimov on 3/14/19.
//  Copyright © 2019 Yavor Dimov. All rights reserved.
//

import UIKit

class ExpenseListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        selectedBackgroundView = selection    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with expense: Expense) {
        nameLabel.text = expense.name
        imageView?.image = UIImage(named: expense.category)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let dateLabel = formatter.string(from: expense.date)
        
        if expense.amount > 0 {
            detailLabel?.text = "$\(expense.amount) \(dateLabel)"
        } else {
            detailLabel.text = dateLabel
        }
    }

}

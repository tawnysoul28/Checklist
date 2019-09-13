//
//  ChecklistTableViewCell.swift
//  Checklist
//
//  Created by Bob on 24/08/2019.
//  Copyright © 2019 Bob. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell { //это Backing Cell

    @IBOutlet weak var checkmarkLabel: UILabel!
    @IBOutlet weak var todoTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

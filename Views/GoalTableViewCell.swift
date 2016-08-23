//
//  GoalTableViewCell.swift
//  Gimme Dough
//
//  Created by Miriam Hendler on 7/12/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var amoountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

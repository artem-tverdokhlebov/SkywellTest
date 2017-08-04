//
//  CarTableViewCell.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/4/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

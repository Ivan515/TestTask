//
//  CustomCell.swift
//  MapWithHistory
//
//  Created by Andrey Apet on 03.02.17.
//  Copyright © 2017 i.Apet. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var dateInCell: UILabel!
    @IBOutlet weak var timeInCell: UILabel!
    @IBOutlet weak var cityInCell: UILabel!
    @IBOutlet weak var latInCell: UILabel!
    @IBOutlet weak var longInCell: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

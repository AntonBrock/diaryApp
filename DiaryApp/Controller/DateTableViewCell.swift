//
//  DateTableViewCell.swift
//  DiaryApp
//
//  Created by Admin on 29.07.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTask: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

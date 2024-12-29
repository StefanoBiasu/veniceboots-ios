//
//  SeaLevelLegendCell.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 18/08/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit

class SeaLevelLegendCell: UITableViewCell {

    @IBOutlet weak var seaLevel: UILabel!
    @IBOutlet weak var color: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.color.backgroundColor = .systemPink
        self.seaLevel.text = "100"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

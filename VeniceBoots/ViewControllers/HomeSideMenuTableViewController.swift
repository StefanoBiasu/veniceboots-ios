//
//  HomeSideMenuTableViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 14/07/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import UIKit
class HomeSideMenuTableViewController : SideMenuTableViewController {
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var seaLevelsLabel: UILabel!
    @IBOutlet weak var simulateLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLabel.text = NSLocalizedString("current_sea_level_menu", comment: "")
        seaLevelsLabel.text = NSLocalizedString("sea_levels_menu", comment: "")
        simulateLabel.text = NSLocalizedString("simulate_sea_level_menu", comment: "")
        settingsLabel.text = NSLocalizedString("settings_menu", comment: "")
        infoLabel.text = NSLocalizedString("info_menu", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.view.backgroundColor = VBConstants.getColor1(self.traitCollection)
    }
}

//
//  SimulateSeaLevelViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 22/03/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit

class SimulateSeaLevelViewController: LegendContainerViewController, SimulateSeaLevelViewControllerDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var seaLevelSelectionLabel: UILabel!
    @IBOutlet weak var select: UIBarButtonItem!
        
    func didSelect(_ seaLevel: String) {
        levelRequestPath = seaLevel
        let last_updated_text = NSLocalizedString("simulate_sea_level_selected", comment: "")
        let text = String.localizedStringWithFormat(last_updated_text, seaLevel)
        seaLevelSelectionLabel.text = text
        self.select.title = seaLevel + " >"
        updateInfoLabel(true)
        self.refresh(seaLevel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelRequestPath = "background"
        self.navigationItem.title = NSLocalizedString("simulate_sea_levels_navigation_title", comment: "")
        self.select.title = NSLocalizedString("simulate_sea_levels_select", comment: "")
        let footerText = NSLocalizedString("simulate_sea_level_no_selection", comment: "")
        seaLevelSelectionLabel.text = footerText
        updateInfoLabel(false)
        infoLabel.layer.masksToBounds = true
        infoLabel.layer.cornerRadius = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nav = segue.destination as? UINavigationController {
            let sideMenyTVC = nav.viewControllers.first as! SeaLevelsSideMenuTableViewController
            sideMenyTVC.delegate = self
        }
    }

    func updateInfoLabel(_ isSeaLevelSelected: Bool) {
        let langStr = Locale.current.languageCode
        var rangeForGreen = NSRange(location:0,length:5)
        if langStr == "it" {
            rangeForGreen = NSRange(location:8,length:5)
        }
        
        var text = NSLocalizedString("info_label_green_areas_unselected", comment: "")
        if isSeaLevelSelected {
            text = NSLocalizedString("info_label_green_areas", comment: "")
        }
        let myMutableString = NSMutableAttributedString(string: text,
                                                        attributes: nil)
        myMutableString.addAttribute(.foregroundColor, value: UIColor.green, range: rangeForGreen)
        infoLabel.attributedText = myMutableString
    }
}

protocol SimulateSeaLevelViewControllerDelegate {
    func didSelect(_ seaLevel: String)
}

//
//  CSLContainerViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 22/03/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit

class CurrentSeaLevelViewController: LegendContainerViewController {
    @IBOutlet weak var seaLevelButton: UIButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("current_sea_level_navigation_title", comment: "")
        infoLabel.layer.masksToBounds = true
        infoLabel.layer.cornerRadius = 5
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.traitCollection.userInterfaceStyle == .dark {
            seaLevelButton.setTitleColor(.black, for: .normal)
            seaLevelButton.setTitleColor(.label, for: .selected)
        } else {
            seaLevelButton.setTitleColor(.white, for: .normal)
            seaLevelButton.setTitleColor(.label, for: .selected)
        }
    }
    @IBAction func refresh(_ sender: Any) {
        getSeaLevel(forceRefresh:false)
    }
        
    override func seaLevelResponse(result: Bool, seaLevel: SeaLevel?) {
        if result {
            let levelRequestPath = self.getLevelRequestPath(seaLevel: seaLevel)
            self.refresh(levelRequestPath)
            
            let last_updated_text = NSLocalizedString("last_updated_sea_level", comment: "")
            let text = String.localizedStringWithFormat(last_updated_text, Utils.formatSeaLevel(seaLevel: seaLevel?.seaLevel)) + ". " + NSLocalizedString("sea_level_update", comment: "")
            self.seaLevelButton.setTitle(text, for:.normal)
            guard let sl = seaLevel?.seaLevel else { return }
            if sl >= Double(0.80) {
                self.infoLabel.text = NSLocalizedString("info_label_green_areas", comment: "")
            } else {
                self.infoLabel.text = NSLocalizedString("current_sea_level_info_label_no_areas", comment: "")
            }
        }
    }
    
}

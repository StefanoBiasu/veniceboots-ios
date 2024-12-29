//
//  SeaLevelsSideMenuTableViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 27/06/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import UIKit

class SeaLevelsSideMenuTableViewController : SideMenuTableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.view.backgroundColor = VBConstants.getColor1(self.traitCollection)
    }
    
    var delegate: SimulateSeaLevelViewControllerDelegate? = nil
     
    @IBAction func close(_ sender: UIButton) {
        delegate?.didSelect(String(sender.tag))
        dismiss(animated: true, completion: nil)
    }
}

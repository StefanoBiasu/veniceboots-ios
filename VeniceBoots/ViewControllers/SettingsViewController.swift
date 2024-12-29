//
//  SettingsViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 27/07/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UITableViewController {
    
    @IBOutlet weak var resetMapCacheButton: UIButton!
    private var backgroundView: GradientView!
    
    @IBAction func resetDb(_ sender: Any) {
        let coreDataTileSource = CoreDataTileSource(withName: "", persistentContainerName: "", completionClosure: { (coreDataTileSource) in
        })
        coreDataTileSource.free()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView = GradientView(frame: self.view.frame)
        backgroundView.startColor = VBConstants.getColor1(self.traitCollection)
        backgroundView.endColor = VBConstants.getColor2(self.traitCollection)
        self.tableView.backgroundView = backgroundView
        self.navigationController?.view.backgroundColor = VBConstants.getColor2(self.traitCollection)
        self.navigationItem.title = NSLocalizedString("settings_navigation_title", comment: "")
        resetMapCacheButton.setTitle(NSLocalizedString("settings_reset_map_cache", comment: ""), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.setNeedsDisplay()
    }
}

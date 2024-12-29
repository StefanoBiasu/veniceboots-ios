//
//  SeaLevelsViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 22/03/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit

class SeaLevelsViewController: SLMapContainerViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infolabel: UILabel!
    @IBOutlet weak var legendTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeaLevelLegendCell", for: indexPath) as! SeaLevelLegendCell
        cell.backgroundColor = .clear
        cell.color.backgroundColor = legendColorBy(indexPath.row)
        cell.seaLevel.text = legendLabelBy(indexPath.row)
        return cell
    }
    
    @IBOutlet weak var seaLevelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("sea_levels_navigation_title", comment: "")
        self.getSeaLevel = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
        self.legendTableView.register(SeaLevelLegendCell.self, forCellReuseIdentifier: "SeaLevelLegendCell")
        self.legendTableView.register(UINib(nibName: "SeaLevelLegendCell", bundle: nil), forCellReuseIdentifier: "SeaLevelLegendCell")
        infolabel.text = NSLocalizedString("info_label_sea_levels_legend", comment: "")
        infolabel.layer.masksToBounds = true
        infolabel.layer.cornerRadius = 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.legendTableView.reloadData()
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
    
    override func parentViewDidLoad() {
        self.refresh(VBConstants.SEA_LEVEL_FULL)
    }
    
    override func seaLevelResponse(result: Bool, seaLevel: SeaLevel?) {
        if result {
            let last_updated_text = NSLocalizedString("last_updated_sea_level", comment: "")
            let seaLevel = Utils.formatSeaLevel(seaLevel: seaLevel?.seaLevel)
            let text = String.localizedStringWithFormat(last_updated_text, seaLevel) + ". " + NSLocalizedString("sea_level_update", comment: "")
            self.seaLevelButton.setTitle(text, for:.normal);
        }
    }

    func maximumSeaLevel() -> Double {
        return 200
    }
    
    func minimumSeaLevel() -> Double {
        return 100
    }
    
    func legendLabelBy(_ index:Int) -> String {
        return VBConstants.COLORS_BY_LABEL[index].label
    }
    
    func legendColorBy(_ index:Int) -> UIColor {
        return VBConstants.COLORS_BY_LABEL[index].color
    }
}

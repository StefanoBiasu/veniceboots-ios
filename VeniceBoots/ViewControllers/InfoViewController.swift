//
//  InfoViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 01/08/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    private var backgroundView: GradientView!
    
    @IBOutlet weak var provisionsLabel: UILabel!
    @IBOutlet weak var legalLabel: UILabel!
    @IBOutlet weak var credits: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
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
        self.view.insertSubview(backgroundView, at: 0)
        self.navigationController?.view.backgroundColor = VBConstants.getColor2(self.traitCollection)
        self.navigationItem.title = NSLocalizedString("settings_navigation_title", comment: "")
        self.provisionsLabel.text = NSLocalizedString("info_text_provisions", comment: "")
        self.legalLabel.text = NSLocalizedString("info_text_legal", comment: "")
        self.credits.text = NSLocalizedString("info_text_credits", comment: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.setNeedsDisplay()
    }
}

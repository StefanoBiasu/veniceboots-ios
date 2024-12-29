//
//  HomeViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 15/03/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    @IBOutlet weak var lastUpdateDate: UILabel!
    @IBOutlet weak var currentSeaLevel: UILabel!
    
    private var backgroundView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView = GradientView(frame: self.view.frame)
        self.tableView.backgroundColor = .clear
        
        self.navigationController?.view.backgroundColor = VBConstants.getColor2(self.traitCollection)
        self.navigationController?.view.insertSubview(backgroundView, at: 0)
        
        self.refreshControl?.addTarget(self, action:#selector(HomeViewController.refresh(sender:)), for: UIControl.Event.valueChanged)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc func appMovedToForeground() {
        retrieveCurrentSeaLevel()
        refreshViewColors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        retrieveCurrentSeaLevel()
        refreshViewColors()
    }
    
    func refreshViewColors() {
        backgroundView.startColor = VBConstants.getColor1(self.traitCollection)
        backgroundView.endColor = VBConstants.getColor2(self.traitCollection)
        self.navigationController?.view.backgroundColor = VBConstants.getColor2(self.traitCollection)
        self.tableView.reloadData()
    }
    
    @objc func refresh(sender:AnyObject) {
        retrieveCurrentSeaLevel()
    }
    
    fileprivate func retrieveCurrentSeaLevel() {
        CurrentSeaLevelManager.shared().getLevel(forceRefresh: true) { (result, seaLevel) in
            if result {
                self.lastUpdateDate.text = String(describing: Utils.formatSeaLevelServiceDate(seaLevel?.date))
                self.currentSeaLevel.text = Utils.formatSeaLevel(seaLevel: seaLevel?.seaLevel) + " cm"
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.setNeedsDisplay()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.view.setNeedsDisplay()
            }
        }
    }
}

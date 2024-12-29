//
//  GMViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 03/02/2019.
//  Copyright © 2019 Stefano Biasutti. All rights reserved.
//
import UIKit
import SwiftSoup

class SLMapContainerViewController: UIViewController {
    
    private var mapViewController : SLMapViewControllerProtocol
    
    var getSeaLevel : Bool = true
    
    @IBOutlet weak var bottomInfoBackgroundView: GradientView!
    @IBOutlet weak var mapView: UIView!
    @IBAction func restorePosition(_ sender: Any) {
        mapViewController.setInitialPosition()
    }
    
    // MARK: - init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.mapViewController = SLMapKitMapViewController(nibName:nil, bundle: nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        self.mapViewController = SLMapKitMapViewController(nibName:nil, bundle: nil)
        super.init(coder: coder)
    }
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewController.view.frame = self.mapView.bounds
        self.mapView.addSubview(mapViewController.view)
        addConstrained(mapViewController.view)
        addChild(mapViewController)
        self.mapViewController.didMove(toParent:self)
        parentViewDidLoad()
        if getSeaLevel {
            getSeaLevel(forceRefresh: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.isTranslucent = true
        let navigationBarAppearance = self.navigationController!.navigationBar
        let backgroundBarImage = UIImage.imageWithColor(color: VBConstants.getColor1(self.traitCollection), size:navigationBarAppearance.bounds.size)
        navigationBarAppearance.setBackgroundImage(backgroundBarImage, for: .default)
        navigationBarAppearance.setBackgroundImage(backgroundBarImage, for: .compact)
        
        let isLight = self.traitCollection.userInterfaceStyle == .light
        bottomInfoBackgroundView.startColor = isLight ? VBConstants.getColor1(self.traitCollection) : VBConstants.getColor2(self.traitCollection)
        bottomInfoBackgroundView.endColor = isLight ? VBConstants.getColor2(self.traitCollection) : VBConstants.getColor1(self.traitCollection)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.navigationBar.isTranslucent = false
        let navigationBarAppearance = self.navigationController!.navigationBar
        navigationBarAppearance.setBackgroundImage(nil, for: .default)
        navigationBarAppearance.setBackgroundImage(nil, for: .compact)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomInfoBackgroundView.setNeedsDisplay()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.view.setNeedsDisplay()
            }
        }
    }
    // MARK: - methods to call for subclasses
    func parentViewDidLoad() {}
    
    func seaLevelResponse(result: Bool, seaLevel: SeaLevel?) {}
    
    func refresh(_ levelRequestPath: String) {
        mapViewController.refresh(levelRequestPath)
    }
    
    // MARK: - Utils
    func getSeaLevel(forceRefresh: Bool) {
        CurrentSeaLevelManager.shared().getLevel(forceRefresh: forceRefresh) { (result, seaLevel) in
            if !result {
                //TODO: [sb] handle error: another view with the error.
            }
            self.seaLevelResponse(result:result, seaLevel:seaLevel)
        }
    }
    
    func getLevelRequestPath(seaLevel: SeaLevel?) -> String {
        var result = "background"
        
        guard seaLevel != nil else {
            return result
        }
        let seaLevelNumber = Int((seaLevel?.seaLevel)! * 100)
        if (seaLevelNumber >= 80) {
            result = String(seaLevelNumber)
        }
        return result
    }
    
    func addConstrained(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: self.mapView.topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor).isActive = true
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

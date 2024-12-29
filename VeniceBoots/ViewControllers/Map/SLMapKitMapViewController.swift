//
//  SLMapkitMapViewController.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 13/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire
import CocoaLumberjack

class SLMapKitMapViewController : UIViewController, SLMapViewControllerProtocol, MKMapViewDelegate {
    
    private var mapView : SLMapView?
    private var overlay: MKTileOverlay!
    private var currentLevel : String? = VBConstants.SEA_LEVEL_BACKGROUND
    private var firstTime = true
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MAP DELEGATE
        self.mapView = SLMapView(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width, height: self.view.bounds.height))
        self.mapView!.delegate = self
        self.mapView!.showsCompass = true
        
        // Get existent last update date for currentLevel tiles
        overlay = SLMapKitTileOverlay(levelRequestPath: currentLevel!)
        overlay.canReplaceMapContent = true
        self.mapView!.addOverlay(overlay, level: .aboveLabels)
        
        self.view.addSubview(self.mapView!)
        addConstrained(self.mapView!)
        
        self.mapView!.showsUserLocation = true;
        self.mapView!.mapType = .mutedStandard
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        self.mapView!.showsUserLocation = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTime {
            setInitialPosition()
            firstTime = !firstTime
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mapView!.delegate = nil
        mapView = nil
        overlay = nil
        currentLevel = nil
    }

    private func addConstrained(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    /*func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        } else {
            return MKTileOverlayRenderer()
        }
    }*/
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let tileOverlay as MKTileOverlay:
            return HackTileOverlayRenderer(tileOverlay: tileOverlay)
        case is GridOverlay:
            return DelayedGridOverlayRenderer()
        default:
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    
    func setInitialPosition() {
        //CENTER MAP TO THIS POI
        let location = SLMapConfig.shared().initialPositionCoordinate2d
        let zoomLevel = SLMapConfig.shared().initialPosition.zoomLevel
        self.mapView!.setCenterCoordinate(coordinate: location, zoomLevel: zoomLevel, animated: false)
        
    }
    
    func refresh(_ levelRequestPath: String) {
        loadTiles(levelRequestPath)
    }
    
    private func loadTiles(_ levelRequestPath: String) {
        if (currentLevel != levelRequestPath) {
            currentLevel = levelRequestPath
            
            self.mapView!.removeOverlay(self.overlay)
            self.overlay = SLMapKitTileOverlay(levelRequestPath:levelRequestPath)
            self.overlay.canReplaceMapContent = true
            self.mapView!.addOverlay(self.overlay, level: .aboveLabels)
        }
    }
}

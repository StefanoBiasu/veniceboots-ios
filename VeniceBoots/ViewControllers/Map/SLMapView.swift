//
//  SLMapView.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 14/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class SLMapView: MKMapView, UIGestureRecognizerDelegate {
    
    private var lastZoomLevel = Float()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action:#selector(self.handlePinch(gestureRecognizer:)))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
    }
    
    var zoomLevel: Float {
        get {
            return Float(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1);
        }
        
        set (newZoomLevel) {
            lastZoomLevel = newZoomLevel
            setCenterCoordinate(coordinate:self.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }

    func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Float, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    @objc func handlePinch(gestureRecognizer: UIPinchGestureRecognizer) {
        
        if lastZoomLevel == 0 {
            lastZoomLevel = self.zoomLevel
        }
        
        if self.zoomLevel > 20 && lastZoomLevel <= self.zoomLevel {
            self.zoomLevel = 19
        } else
            if self.zoomLevel < 13 {
            let location = SLMapConfig.shared().initialPositionCoordinate2d
            let zoomLevel = SLMapConfig.shared().initialPosition.zoomLevel
            self.setCenterCoordinate(coordinate: location, zoomLevel: zoomLevel, animated: false)
        }
    }
    
    @objc func doubleTapped() {

        if self.zoomLevel >= 19 && lastZoomLevel <= self.zoomLevel {
            self.zoomLevel = 18
        } else if self.zoomLevel < 13 {
            let location = SLMapConfig.shared().initialPositionCoordinate2d
            let zoomLevel = SLMapConfig.shared().initialPosition.zoomLevel
            self.setCenterCoordinate(coordinate: location, zoomLevel: zoomLevel, animated: false)
        }
    }
}

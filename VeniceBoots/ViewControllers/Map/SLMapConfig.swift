//
//  SLMapConfig.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 13/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import CoreLocation

class SLMapConfig {

    let TILE_SERVER_BASE_URL_DEFAULT = "https://tile.openstreetmap.org"
    let TILE_SERVER_BASE_URL_LOCAL = "https://biasu.net"
    let APPLICATION_NAME = "veniceboots"
    let TILE_SERVER_PATH = "tile"
    
    private var _initialPosition = InitialPosition(45.438000, 12.333800, 13)
    private var _maxZoom : Float = 20
    private var _minZoom : Float = 12
    
    private static var sharedSLMapConfig: SLMapConfig = {
        let sLMapConfig = SLMapConfig()
        return sLMapConfig
    }()

    class func shared() -> SLMapConfig {
        return sharedSLMapConfig
    }
    
    var initialPosition: InitialPosition {
        get {
            _initialPosition
        }
        set {
            _initialPosition = newValue
        }
    }
    
    var initialPositionCoordinate2d: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: _initialPosition.latitude, longitude: _initialPosition.longitude)
        }
    }
    
    var maxZoom : Float {
        get {
            _maxZoom
        }
        set {
            _maxZoom = newValue
        }
    }
    
    var minZoom : Float {
        get {
            _minZoom
        }
        set {
            _minZoom = newValue
        }
    }
}

struct InitialPosition {
    
    init(_ latitude:Double, _ longitude: Double, _ zoomLevel: Float) {
        self.latitude = latitude
        self.longitude = longitude
        self.zoomLevel = zoomLevel
    }
    
    var latitude: Double
    var longitude: Double
    var zoomLevel: Float
}

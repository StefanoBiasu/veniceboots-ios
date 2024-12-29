//
//  TileID.swift
//  MapBoxTest
//
//  Created by Davide Ramo on 02/01/2018.
//  Copyright © 2018 F360. All rights reserved.
//

import CoreLocation
import MapKit

struct TileID {
    
    var x : Int
    var y : Int
    var z : Int
    
    init(x:Int, y:Int, z:Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    var location : CLLocationCoordinate2D {
        get {
            return TileID.location(forTileId: self)
        }
    }
    
    var bbox : (topleft : CLLocationCoordinate2D, bottomright : CLLocationCoordinate2D) {
        get {
            return TileID.bbox(forTileId: self)
        }
    }
    
    //MARK: - Utilities
    
    static func tileID(path:MKTileOverlayPath) -> TileID {
        return TileID(x: path.x, y: path.y, z: path.z)
    }
    
    static func tileId(forLocation location:CLLocationCoordinate2D, zoom:Int) -> TileID {
        
        let tileX = Int(floor((location.longitude + 180) / 360.0 * pow(2.0, Double(zoom))))
        let tileY = Int(floor((1 - log( tan( location.latitude * Double.pi / 180.0 ) + 1 / cos( location.latitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom))))
        
        return TileID(x:tileX, y:tileY, z:zoom)
    }
    
    static func location(forTileId id:TileID) -> CLLocationCoordinate2D {
        let n : Double = pow(2.0, Double(id.z))
        let lon = (Double(id.x) / n) * 360.0 - 180.0
        let lat = atan( sinh (.pi - (Double(id.y) / n) * 2 * Double.pi)) * (180.0 / .pi)
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    static func bbox(forTileId id:TileID) -> (topleft : CLLocationCoordinate2D, bottomright : CLLocationCoordinate2D) {
        let topLeftLT = self.location(forTileId: id)
        let nextId = TileID(x: id.x + 1, y: id.y + 1, z: id.z)
        let bottomRightLT = self.location(forTileId: nextId)
        let topLeft = CLLocationCoordinate2D(latitude: topLeftLT.latitude, longitude: topLeftLT.longitude)
        let bottomRight = CLLocationCoordinate2D(latitude: bottomRightLT.latitude, longitude: bottomRightLT.longitude)
        return (topLeft,bottomRight)
    }
}

extension TileID: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
    
    static func == (lhs: TileID, rhs: TileID) -> Bool {
        return
            lhs.x == rhs.x &&
                lhs.y == rhs.y &&
                lhs.z == rhs.z
    }
    
}

extension TileID: CustomStringConvertible {
    
    var description: String {
        get {
            let location = TileID.location(forTileId: self)
            return "\(z):\(x):\(y) - lat:\(location.latitude) long:\(location.longitude)"
        }
    }
}

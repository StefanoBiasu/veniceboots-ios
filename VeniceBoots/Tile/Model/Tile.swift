//
//  Tile.swift
//  MapBoxTest
//
//  Created by Davide Ramo on 16/01/2018.
//  Copyright © 2018 F360. All rights reserved.
//

import UIKit

class Tile: NSObject {
    
    var identifier : TileID
    var content : Data?
    var date : Date
    
    init(withId id:TileID, _ date: Date) {
        identifier = id
        self.date = date
    }
    
    convenience init(withId id:TileID, data:Data?, date: Date) {
        self.init(withId: id, date)
        content = data
        self.date = date
    }
    
    convenience init(withTile mo:TileMO, date: Date) {
        let id = TileID(x: Int(mo.x), y: Int(mo.y), z: Int(mo.z))
        self.init(withId: id, data: mo.image, date: date)
    }
    
    static func sizeForTilesCount(_ count:UInt) -> UInt {
        return 256
    }
    
    
}

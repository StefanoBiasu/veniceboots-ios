//
//  TileSourceProtocol.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 15/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation

protocol TileSourceProtocol {
    
    func tile(withId id:TileID, path: String, completionClosure: @escaping (Tile?) -> ())
}

//
//  TilePersistenceProtocol.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 15/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation

protocol TilePersistenceProtocol {
    
    func store(_ tile: Tile,linkedToPath path:String?, completionClosure: @escaping (Bool,Error?) -> ())
}

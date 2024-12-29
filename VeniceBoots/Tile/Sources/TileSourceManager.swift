//
//  TileSourceManager.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 19/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation

class TileSourceManager {
    private let _urlTileSource : URLTileSource
    private let _defaultUrlTileSource : URLTileSource
    private let _coreDataTileSource : CoreDataTileSource
    
    init() {
        _defaultUrlTileSource = URLTileSource(true)
        _urlTileSource = URLTileSource(false)
        _coreDataTileSource = CoreDataTileSource(withName: "", persistentContainerName: "", completionClosure: { (coreDataTileSource) in
        })
    }
    
    var defaultUrlTileSource : URLTileSource {
        get {
            return _defaultUrlTileSource
        }
    }
    var urlTileSource : URLTileSource {
        get {
            return _urlTileSource
        }
    }
    var coreDataTileSource : CoreDataTileSource {
        get {
            return _coreDataTileSource
        }
    }
}

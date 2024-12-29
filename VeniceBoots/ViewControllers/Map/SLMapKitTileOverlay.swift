//
//  SLMapkitTileOverlay.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 14/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import MapKit
import CocoaLumberjack

class SLMapKitTileOverlay : MKTileOverlay {
    
    private var levelRequestPath: String
    private let tileSourceManager = TileSourceManager()
    
    init(levelRequestPath: String) {
        self.levelRequestPath = levelRequestPath
        super.init(urlTemplate: nil)
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let id = TileID(x: path.x, y: path.y, z: path.z)
        // round to the nearest 10
        if self.levelRequestPath != VBConstants.SEA_LEVEL_BACKGROUND && self.levelRequestPath != VBConstants.SEA_LEVEL_FULL {
            let level = Int(Double(self.levelRequestPath)!)
            let remainder = level.remainderReportingOverflow(dividingBy: 10)
            if remainder.partialValue != 0 {
                levelRequestPath = String(Int((Double(levelRequestPath)!/Double(10)).rounded() * 10))
            }
        }
        tileSourceManager.coreDataTileSource.tile(withId: id, path:levelRequestPath, completionClosure: { (cachedTile) in
            if let tile = cachedTile {
                // DDLogVerbose("Loaded cached tile: \(id)")
                result(tile.content, nil)
            } else {
                DDLogInfo("Tile not found!: \(id)")
                self.tileSourceManager.urlTileSource.tile(withId: id, path:self.levelRequestPath, completionClosure: { (downloadedTile) in
                    if let tile = downloadedTile {
                        self.store(tile, linkedToPath: self.levelRequestPath, completionClosure: { (success, error) in
                            if success {
                                // DDLogVerbose("Cached tile: \(id)")
                            } else {
                                DDLogError("Error occurred caching tile: \(id). Error: \(String(describing: error))")
                            }
                        })
                        // DDLogVerbose("Loaded tile: \(id)")
                        result(tile.content, nil)
                    } else {
                        let defaultId = TileID(x: path.x, y: path.z, z: path.y)
                        self.tileSourceManager.defaultUrlTileSource.tile(withId: defaultId, path:self.levelRequestPath, completionClosure: { (downloadedDefaultTile) in
                            guard let tile = downloadedDefaultTile  else {
                                DDLogError("Error occurred downloading tileID: \(id).")
                                //TODO [sb] add error
                                result(nil, nil)
                                return
                            }
                            // DDLogVerbose("Loaded default tile: \(id)")
                            result(tile.content, nil)
                        })
                    }
                })
            }
        })
    }
    
    func store(_ tile: Tile, linkedToPath path: String?, completionClosure: @escaping (Bool, Error?) -> ()) {
        tileSourceManager.coreDataTileSource.store(tile, linkedToPath: path, completionClosure: completionClosure)
    }
}

//
//  CoreDataTileSource.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 15/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class CoreDataTileSource : TileSourceProtocol, TilePersistenceProtocol {
    
    let name: String
    let persistentContainer : NSPersistentContainer
    var storeTilesMOC : NSManagedObjectContext?
    
    init(withName name: String, persistentContainerName: String, completionClosure: @escaping (CoreDataTileSource) -> ()) {
        self.name = name
        self.persistentContainer = NSPersistentContainer(name: persistentContainerName)
        self.persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            self.storeTilesMOC = self.persistentContainer.newBackgroundContext()
            self.storeTilesMOC?.automaticallyMergesChangesFromParent = true
            completionClosure(self)
        }
    }
    
    func tile(withId id:TileID, path:String, completionClosure: @escaping (Tile?) -> ()) {
        
        persistentContainer.performBackgroundTask { (moc) in
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(TileMO.self))
            fetch.predicate = NSPredicate(format: "x == %ld AND y == %ld AND z == %ld AND path.path == %@", id.x,id.y,id.z, path)
            do {
                let tiles = try moc.fetch(fetch) as! [TileMO]
                if tiles.count > 0 {
                    if tiles.count > 1 {
                        DDLogWarn("More than 1 tile have been found for ID \(id)")
                    }
                    
                    let mo = tiles[0]
                    let result = Tile(withTile: mo, date: (mo.path?.lastUpdateDate)!)
                    completionClosure(result)
                } else {
                    completionClosure(nil)
                }
            } catch {
                DDLogError("Failed to fetch tiles: \(error)")
                completionClosure(nil)
            }
        }
    }
    
    var canStore : Bool {
        get {
            return false
        }
    }
    
    func store(_ tile: Tile, linkedToPath path:String?, completionClosure: @escaping (Bool,Error?) -> ()) {
        
        storeTilesMOC?.perform {
            var currentPath : PathMO?
            if path != nil {
                do {
                    let fetchPath = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(PathMO.self))
                    fetchPath.predicate = NSPredicate(format: "path == %@", path!)
                    let currentPaths = try self.storeTilesMOC?.fetch(fetchPath) as! [PathMO]
                    if currentPaths.count > 0 {
                        currentPath = currentPaths.first
                    } else {
                        currentPath = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(PathMO.self), into: self.storeTilesMOC!) as? PathMO
                        currentPath?.path = path
                    }
                } catch {
                    DDLogError("Failed to fetch pathMO : \(String(describing: path))")
                    completionClosure(false,error)
                    return
                }
            }
            
            //Update image+paths if already present in DB
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(TileMO.self))
            fetch.predicate = NSPredicate(format: "x == %ld AND y == %ld AND z == %ld", tile.identifier.x,tile.identifier.y,tile.identifier.z)
            do {
                let tiles = try self.storeTilesMOC?.fetch(fetch) as! [TileMO]
                if tiles.count > 0 {
                    let tileMO = tiles[0]
                    tileMO.image = tile.content
                    
                    if let currentPathMO = currentPath {
                        currentPathMO.addToTiles(tileMO)
                        currentPathMO.lastUpdateDate = Date()
                    }
                    
                    do {
                        try self.storeTilesMOC?.save()
                    } catch {
                        DDLogError("Failed to update tiles: \(error)")
                        completionClosure(false,error)
                        return
                    }
                    completionClosure(true,nil)
                    return
                }
            } catch {
                DDLogError("Failed to fetch tiles before store: \(error)")
                completionClosure(false,error)
                return
            }
            
            //Insert new if not already in DB
            let tileMO = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(TileMO.self), into: self.storeTilesMOC!) as! TileMO
            tileMO.x = Double(tile.identifier.x)
            tileMO.y = Double(tile.identifier.y)
            tileMO.z = Double(tile.identifier.z)
            tileMO.image = tile.content
            if currentPath != nil {
                currentPath?.addToTiles(tileMO)
                currentPath?.lastUpdateDate = Date()
            }
            
            do {
                try self.storeTilesMOC?.save()
            } catch {
                DDLogError("Failed to save tiles: \(error)")
                completionClosure(false,error)
                return
            }
            
            completionClosure(true,nil)
        }
    }
    
    //    var storeSize : Int {
    //        get {
    //            var result = Int(0)
    //            self.storeTilesMOC?.performAndWait {
    //                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(TileMO.self))
    //                fetch.resultType = .countResultType
    //                if let tilesCount = try? self.storeTilesMOC?.count(for:fetch) {
    //                    result = (tilesCount!*20/1024)
    //                } else {
    //
    //                    let fm = FileManager.default
    //                    var size = Int(0)
    //                    for storeDescription in persistentContainer.persistentStoreDescriptions {
    //                        if let url = storeDescription.url {
    //
    //                            if let attributes = try? fm.attributesOfItem(atPath: url.path) {
    //
    //                                if let storeSize = attributes[FileAttributeKey.size] as? Double {
    //                                    size += Int(storeSize / 1000000.0)
    //                                }
    //                            }
    //                        }
    //                    }
    //                    result = size
    //                }
    //            }
    //            return result
    //        }
    //    }
    
    func free() {
        self.storeTilesMOC?.perform {
            let fetchTiles = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(TileMO.self))
            let fetchPaths = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(PathMO.self))
            do {
                let tilesToDelete = try self.storeTilesMOC?.fetch(fetchTiles) as! [TileMO]
                for tileToDelete in tilesToDelete {
                    self.storeTilesMOC?.delete(tileToDelete)
                }
                let pathsToDelete = try self.storeTilesMOC?.fetch(fetchPaths) as! [PathMO]
                for pathToDelete in pathsToDelete {
                    self.storeTilesMOC?.delete(pathToDelete)
                }
                try self.storeTilesMOC?.save()
            } catch {
                DDLogError("Error executing TileMO deletion! Error: \(error)")
            }
        }
    }
}

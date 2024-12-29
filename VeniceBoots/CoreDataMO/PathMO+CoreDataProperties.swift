//
//  PathMO+CoreDataProperties.swift
//  
//
//  Created by Stefano Biasutti on 26/07/2020.
//
//

import Foundation
import CoreData


extension PathMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PathMO> {
        return NSFetchRequest<PathMO>(entityName: "PathMO")
    }

    @NSManaged public var lastUpdateDate: Date?
    @NSManaged public var path: String?
    @NSManaged public var tiles: NSSet?

}

// MARK: Generated accessors for tiles
extension PathMO {

    @objc(addTilesObject:)
    @NSManaged public func addToTiles(_ value: TileMO)

    @objc(removeTilesObject:)
    @NSManaged public func removeFromTiles(_ value: TileMO)

    @objc(addTiles:)
    @NSManaged public func addToTiles(_ values: NSSet)

    @objc(removeTiles:)
    @NSManaged public func removeFromTiles(_ values: NSSet)

}

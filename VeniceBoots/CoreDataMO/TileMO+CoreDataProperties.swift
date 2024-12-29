//
//  TileMO+CoreDataProperties.swift
//  
//
//  Created by Stefano Biasutti on 26/07/2020.
//
//

import Foundation
import CoreData


extension TileMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TileMO> {
        return NSFetchRequest<TileMO>(entityName: "TileMO")
    }

    @NSManaged public var image: Data?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double
    @NSManaged public var path: PathMO?

}

//
//  GridOverlay.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 29/12/24.
//  Copyright © 2024 Stefano Biasutti. All rights reserved.
//
import MapKit

final class GridOverlay: NSObject, MKOverlay {

    var boundingMapRect: MKMapRect {
        return .world
    }

    var coordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: boundingMapRect.midX, y: boundingMapRect.midY).coordinate
    }
}

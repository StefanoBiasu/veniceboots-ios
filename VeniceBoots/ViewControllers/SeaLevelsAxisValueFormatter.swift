//
//  SeaLevelsAxisValueFormatter.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 21/06/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import Charts

final class SeaLevelsAxisValueFormatter : AxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let intVal = Int(value)
        return String(intVal) + " "
    }
}

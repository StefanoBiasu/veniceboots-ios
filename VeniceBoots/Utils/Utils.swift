//
//  Utils.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 04/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation

class Utils {
    
    static let seaLevelServiceSateFormat = "yyyy-MM-dd HH:mm:ss"
    
    static func formatSeaLevelServiceDate(_ dt:Date?) -> String {
        guard var date = dt else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = seaLevelServiceSateFormat
        
        //Fix sea level response date time
        if TimeZone.current.isDaylightSavingTime() {
            date.addTimeInterval(3600)
        }
        return dateFormatter.string(from:date)
    }
    
    static func formatSeaLevel(seaLevel:Double?) -> String {
        var seaLevelString = ""
        if (seaLevel != nil) {
            var _seaLevel = seaLevel ?? 0
            _seaLevel = _seaLevel * 100
            seaLevelString = String(format: "%.0f", _seaLevel)
            
        }
        return seaLevelString
    }
}

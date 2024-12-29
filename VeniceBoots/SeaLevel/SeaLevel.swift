//
//  SeaLevel.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 15/03/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit
import SwiftSoup

struct SeaLevel : Codable {
    var date : Date
    var seaLevel : Double?
    var temperature : Double?
    
    init(date: Date, seaLevel: Double, temperature: Double) throws {
        self.date = date
        self.seaLevel = seaLevel
        self.temperature = temperature
    }
    
    init(items: Elements) {
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Utils.seaLevelServiceSateFormat
            let date = try items.get(0).text()
            self.date = dateFormatter.date (from: date)!
            
            let seaLevelEl = items.get(1)
            let temperatureEl = items.get(2)
            self.seaLevel = try Double(seaLevelEl.text())
            self.temperature = try Double(temperatureEl.text())
        } catch Exception.Error(_, let message) {
            print(message)
            self.date = Date.init()
            self.seaLevel = nil
            self.temperature = nil
        } catch {
            print("error")
            self.date = Date.init()
            self.seaLevel = nil
            self.temperature = nil
        }
    }
}


//
//  CurrentSeaLevelManager.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 15/03/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup
import CocoaLumberjack

class CurrentSeaLevelManager {
    
    fileprivate let SEA_LEVEL_URL = "https://www.comune.venezia.it/sites/default/files/publicCPSM2/stazioni/temporeale/Punta_Salute.html"
    
    public var currentSeaLevelPort = 443
    
    private static var sharedCSLM: CurrentSeaLevelManager = {
        let currentSeaLevelManager = CurrentSeaLevelManager()
        return currentSeaLevelManager
    }()
    
    class func shared() -> CurrentSeaLevelManager {
        return sharedCSLM
    }
    
    private var lastResult : SeaLevel?
    
    public func getLevel(forceRefresh : Bool , completion : @escaping (Bool, SeaLevel?) -> ()) {
        if (lastResult != nil && forceRefresh == false) {
            completion(true, lastResult)
        } else {
            get(completion: completion)
        }
    }
    
    private func get(completion : @escaping (Bool, SeaLevel?) -> ()) {
        AF.request(SEA_LEVEL_URL).responseString { response in
            do {
                if response.value == nil {
                    completion(false, nil)
                } else {
                    let doc: Document = try SwiftSoup.parse(response.value!)
                    let bodyTable = doc.body()
                    let table = try bodyTable?.getElementsByTag("table")
                    let bodyItems = try table?.get(0).getElementsByTag("tbody")
                    var seaLevels = [SeaLevel]()
                    for row in try (bodyItems?.select("tr"))! {
                        let columns = try! row.select("td")
                        seaLevels.append(SeaLevel(items: columns))
                    }
                    seaLevels.sort { (item1, item2) -> Bool in
                        return item1.date < item2.date
                    }
                    let pastSeaLevels = seaLevels.filter{$0.seaLevel != nil}
                    self.lastResult = pastSeaLevels.last
                    completion(true, pastSeaLevels.last)
                }
            } catch Exception.Error(_, let message) {
                DDLogError(message)
                completion(false, nil)
            } catch {
                completion(false, nil)
            }
        }
    }
}

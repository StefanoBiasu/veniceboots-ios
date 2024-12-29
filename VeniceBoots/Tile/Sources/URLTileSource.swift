//
//  URLTileSource.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 15/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import CocoaLumberjack
import Alamofire

class URLTileSource : TileSourceProtocol {
    
    private let dateFormatter = DateFormatter()
    private var _isDefault: Bool = true
    
    init(_ isDefault:Bool) {
        _isDefault = isDefault
    }
    
    let queue = DispatchQueue(label: "tiles.download.queue", qos: .userInitiated, attributes: .concurrent)
    
    func tile(withId id: TileID, path: String, completionClosure: @escaping (Tile?) -> ()) {
        
        var y = id.y
        if !_isDefault {
            y = Int(pow(2, Double(id.z)) - Double(id.y) - Double(1))
        }
        var urlString: String? = SLMapConfig.shared().TILE_SERVER_BASE_URL_DEFAULT
        if !_isDefault {
            urlString = SLMapConfig.shared().TILE_SERVER_BASE_URL_LOCAL
        }
        let tilePath = SLMapConfig.shared().TILE_SERVER_PATH
        let applicationName = SLMapConfig.shared().APPLICATION_NAME
        var urlTemplate = urlString!
        var port:Int
        if VBConstants.SEA_LEVELS_BASE.contains(path) {
            port = VBConstants.SEA_LEVELS_BASE_PORT
        } else {
            port = CurrentSeaLevelManager.shared().currentSeaLevelPort
        }
        if !_isDefault {
            urlTemplate = urlTemplate + ":\(port)/"
            urlTemplate = urlTemplate + applicationName + "/\(path)/" + tilePath
        }
        var type = "jpg"
        if _isDefault {
            type = "png"
        }
        let urlS = "\(urlTemplate)/\(y)/\(id.x)/\(id.z).\(type)"
        print(urlS)
        guard let url = URL(string:urlS) else {
            DDLogError("Resulting URL \(String(describing: urlString)) from template \(urlTemplate) is not an URL!")
            completionClosure(nil)
            return
        }
        
        // DDLogVerbose("Requesting tile with ID: \(id)")
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseData(queue:self.queue) {
            response in
            
            if response.value == nil {
                DDLogError("Impossible to load tile \(id) from url \(url)! Error: \(String(describing: response.error))")
                completionClosure(nil)
            } else {
                guard var data = response.data else {
//                    DDLogError("NULL tile returned from url \(url)! Tile id: \(id)")
                    completionClosure(nil)
                    return
                }
                
                var date = Date()
                if self._isDefault {
                    do {
                        let response = try JSONDecoder().decode(Response.self, from: data)
                        data = response.tile ?? Data()
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        date = self.dateFormatter.date(from:response.date)!
                    }
                    catch let e {
                        DDLogError("Failed to retrieve tile: \(e)")
                    }
                }
                
                // DDLogVerbose("Retrived Tile with ID: \(id)")
                let result = Tile(withId: id, data: data, date: date)
                completionClosure(result)
            }
        }
    }
}

struct Response: Codable {
    var date : String
    var tile : Data?
}

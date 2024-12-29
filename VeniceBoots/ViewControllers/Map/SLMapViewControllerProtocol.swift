//
//  SLMapViweControllerProtocol.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 13/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import UIKit

protocol SLMapViewControllerProtocol : UIViewController {
    
    func setInitialPosition()
    
    func refresh(_ levelRequestPath: String)
}

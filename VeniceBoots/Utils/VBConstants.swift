//
//  VBConstants.swift
//  VeniceBoots
//
//  Created by Stefano Biasutti on 14/04/2020.
//  Copyright © 2020 Stefano Biasutti. All rights reserved.
//

import Foundation
import UIKit

struct VBConstants {
    
    static let SEA_LEVEL_BACKGROUND = "background"
    static let SEA_LEVEL_FULL = "full"
    static let SEA_LEVEL_80 = "80"
    static let SEA_LEVEL_90 = "90"
    static let SEA_LEVEL_100 = "100"
    static let SEA_LEVEL_110 = "110"
    static let SEA_LEVEL_120 = "120"
    static let SEA_LEVEL_130 = "130"
    static let SEA_LEVEL_140 = "140"
    static let SEA_LEVEL_150 = "150"
    static let SEA_LEVEL_160 = "160"
    static let SEA_LEVEL_170 = "170"
    static let SEA_LEVEL_180 = "180"
    static let SEA_LEVEL_190 = "190"
    static let SEA_LEVEL_200 = "200"
    
    static let SEA_LEVELS: [String] = [SEA_LEVEL_BACKGROUND, SEA_LEVEL_80, SEA_LEVEL_90, SEA_LEVEL_100, SEA_LEVEL_110, SEA_LEVEL_120, SEA_LEVEL_130, SEA_LEVEL_140, SEA_LEVEL_150, SEA_LEVEL_160, SEA_LEVEL_170, SEA_LEVEL_180, SEA_LEVEL_190, SEA_LEVEL_200]
    
    static let SEA_LEVELS_BASE_PORT: Int = 8442 //5720
    
    static let SEA_LEVELS_BASE: [String] = [SEA_LEVEL_BACKGROUND, SEA_LEVEL_80, SEA_LEVEL_110, SEA_LEVEL_140,  SEA_LEVEL_170, SEA_LEVEL_200, SEA_LEVEL_FULL]
    
    static func getColor1(_ trait : UITraitCollection) -> UIColor {
        if trait.userInterfaceStyle == .light {
            return UIColor(red: 142.0/255.0, green: 220.0/255.0, blue: 255.0/255.0, alpha: 1) // LIGHT_BLUE
        } else {
            return .black
        }
    }
    
    static func getColor2(_ trait : UITraitCollection) -> UIColor {
        if trait.userInterfaceStyle == .light {
            return UIColor(red: 61.0/255.0, green: 137.0/255.0, blue: 169.0/255.0, alpha: 1) // DARK_BLUE
        } else {
            return UIColor(red: 61.0/255.0, green: 137.0/255.0, blue: 169.0/255.0, alpha: 1) // DARK_BLUE
        }
    }
    
    static let COLORS_BY_LABEL = [
        ColorByLabel("206 - 351", UIColor(red: 26.0/255.0, green: 150.0/255.0, blue: 65.0/255.0, alpha: 1)),
        ColorByLabel("186 - 206", UIColor(red: 62.0/255.0, green: 167.0/255.0, blue: 75.0/255.0, alpha: 1)),
        ColorByLabel("166 - 186", UIColor(red: 96.0/255.0, green: 184.0/255.0, blue: 85.0/255.0, alpha: 1)),
        ColorByLabel("155 - 166", UIColor(red: 131.0/255.0, green: 201.0/255.0, blue: 96.0/255.0, alpha: 1)),
        ColorByLabel("148 - 155", UIColor(red: 166.0/255.0, green: 217.0/255.0, blue: 106.0/255.0, alpha: 1)),
        ColorByLabel("143 - 148", UIColor(red: 188.0/255.0, green: 227.0/255.0, blue: 128.0/255.0, alpha: 1)),
        ColorByLabel("138 - 143", UIColor(red: 211.0/255.0, green: 236.0/255.0, blue: 149.0/255.0, alpha: 1)),
        ColorByLabel("133 - 138", UIColor(red: 233.0/255.0, green: 246.0/255.0, blue: 171.0/255.0, alpha: 1)),
        ColorByLabel("129 - 133", UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 192.0/255.0, alpha: 1)),
        ColorByLabel("126 - 129", UIColor(red: 255.0/255.0, green: 235.0/255.0, blue: 168.0/255.0, alpha: 1)),
        ColorByLabel("122 - 126", UIColor(red: 254.0/255.0, green: 215.0/255.0, blue: 145.0/255.0, alpha: 1)),
        ColorByLabel("119 - 122", UIColor(red: 254.0/255.0, green: 195.0/255.0, blue: 121.0/255.0, alpha: 1)),
        ColorByLabel("116 - 119", UIColor(red: 253.0/255.0, green: 174.0/255.0, blue: 97.0/255.0, alpha: 1)),
        ColorByLabel("112 - 116", UIColor(red: 244.0/255.0, green: 137.0/255.0, blue: 80.0/255.0, alpha: 1)),
        ColorByLabel("108 - 112", UIColor(red: 234.0/255.0, green: 99.0/255.0, blue: 62.0/255.0, alpha: 1)),
        ColorByLabel("102 - 108", UIColor(red: 225.0/255.0, green: 62.0/255.0, blue: 45.0/255.0, alpha: 1)),
        ColorByLabel("43 - 102", UIColor(red: 215.0/255.0, green: 25.0/255.0, blue: 28.0/255.0, alpha: 1))]
}

struct ColorByLabel {
    
    init(_ label:String, _ color:UIColor) {
        self.label = label
        self.color = color
    }
    
    var label: String
    var color: UIColor
}

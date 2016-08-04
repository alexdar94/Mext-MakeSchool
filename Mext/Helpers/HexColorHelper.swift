//
//  HexColorHelper.swift
//  Mext
//
//  Created by Alex Lee on 01/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation

class HexColorHelper {
    static let APPTHEME_PINK = HexColorHelper.hexStringToUIColor("#fe696a")
    static let APPTHEME_ORANGE = HexColorHelper.hexStringToUIColor("#f19f49")
    static let APPTHEME_GREEN = HexColorHelper.hexStringToUIColor("#24e0ab")
    static let APPTHEME_YELLOW = HexColorHelper.hexStringToUIColor("#ffe46e")
    static let APPTHEME_BLUE = HexColorHelper.hexStringToUIColor("#2a6cc4")
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
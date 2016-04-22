//
//  NSColorFromHex.swift
//  One Passwords
//
//  Created by Ghost on 3/14/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Foundation
import Cocoa

class NSColorUtil
{
    static func getColorFromString(webColorString : String) -> NSColor?
    {
        var result : NSColor? = nil
        var colorCode : UInt32 = 0
        var redByte, greenByte, blueByte : UInt8
        
        // these two lines are for web color strings that start with a #
        // -- as in #ABCDEF; remove if you don't have # in the string
        let index1 = webColorString.endIndex.advancedBy(-6)
        let substring1 = webColorString.substringFromIndex(index1)
        
        let scanner = NSScanner(string: substring1)
        let success = scanner.scanHexInt(&colorCode)
        
        if success == true {
            redByte = UInt8.init(truncatingBitPattern: (colorCode >> 16))
            greenByte = UInt8.init(truncatingBitPattern: (colorCode >> 8))
            blueByte = UInt8.init(truncatingBitPattern: colorCode) // masks off high bits
            
            result = NSColor(calibratedRed: CGFloat(redByte) / 0xff, green: CGFloat(greenByte) / 0xff, blue: CGFloat(blueByte) / 0xff, alpha: 1.0)
        }
        return result
    }
}
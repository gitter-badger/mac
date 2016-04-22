//
//  Pasteboard.swift
//  One Passwords
//
//  Created by Ghost on 2/7/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Foundation

#if os(iOS)
  import UIKit
#else
  import AppKit
#endif

/// Return string value currently on clipboard
func getPasteboardContents() -> String? {
  #if os(iOS)
    
    let pasteboard = UIPasteboard.generalPasteboard()
    return pasteboard.string
    
  #else
    
    let pasteboard = NSPasteboard.generalPasteboard()
    return pasteboard.stringForType(NSPasteboardTypeString)
    
  #endif
}

/// Write a string value to the pasteboard
func copyToPasteboard(text: String) {
  #if os(iOS)
    
    let pasteboard = UIPasteboard.generalPasteboard()
    pasteboard.string = text
    
  #else
    
    let pasteboard = NSPasteboard.generalPasteboard()
    pasteboard.clearContents()
    pasteboard.setString(text, forType: NSPasteboardTypeString)
    
  #endif
}

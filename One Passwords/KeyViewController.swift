//
//  KeyViewController.swift
//  One Passwords
//
//  Created by Ghost on 3/14/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Cocoa

class KeyViewController: NSViewController
{
    @IBOutlet weak var keySecureTextField: NSSecureTextField!

    let key = PersistableKey()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupView()
        
        self.keySecureTextField.stringValue = self.key.getKey()
    }
    
    @IBAction func dismiss(sender: AnyObject)
    {
        let newKey = self.keySecureTextField.stringValue
        
        if (!newKey.isEmpty && newKey.characters.count >= OnePasswords.MIN_KEY_LENGTH)
        {
            self.key.setkey(newKey);
            self.dismissController(self);
        }
        else
        {
            let alert = NSAlert()
            alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil)
            alert.messageText = "Your Key is too  short!"
            alert.informativeText = "Your Key has to be at least " + String(OnePasswords.MIN_KEY_LENGTH) + " characters"
            alert.addButtonWithTitle("Close")
            alert.alertStyle = NSAlertStyle.CriticalAlertStyle
        }
    }
    
    private func setupView()
    {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColorUtil.getColorFromString("#2196f3")?.CGColor
    }
}

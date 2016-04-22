//
//  NewLabelViewController.swift
//  One Passwords
//
//  Created by Ghost on 3/14/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Cocoa

class NewLabelViewController: NSViewController
{
    let labels = PersistableLabels()
    var onePasswordsViewController = OnePasswordsViewController()
    
    @IBOutlet weak var newLabelTextField: NSTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupView()
        self.labels.getAll()
    }
    
    @IBAction func dismiss(sender: AnyObject)
    {
        self.dismissController(self)
    }
    
    @IBAction func addLabel(sender: AnyObject)
    {
        self.labels.add(self.newLabelTextField.stringValue)
        self.dismissController(self)
        self.onePasswordsViewController.refreshLabels()
    }
    
    private func setupView()
    {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColorUtil.getColorFromString("#2196f3")?.CGColor
    }
}

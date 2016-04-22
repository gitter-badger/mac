//
//  ViewController.swift
//  One Passwords
//
//  Created by Ghost on 3/14/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Cocoa

class OnePasswordsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate
{
    @IBOutlet weak var labelsTableView: NSTableView!
    
    let labels = PersistableLabels()
    let key = PersistableKey()
    let onePasswords = OnePasswords()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setupView()
        self.labels.getAll()
        
        self.labelsTableView.setDelegate(self)
        self.labelsTableView.setDataSource(self)
        self.labelsTableView.target = self
        self.labelsTableView.doubleAction = "tableViewDoubleClick:"
    }
    
    @IBAction func deleteLabel(sender: AnyObject)
    {
        let labelToDelete = self.labelsTableView.selectedRow
        self.labels.deleteAt(labelToDelete)
        self.refreshLabels()
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
     
        self.labels.getAll()
        self.labelsTableView.reloadData()
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?)
    {
        let destinationViewController = segue.destinationController
        
        if (destinationViewController is NewLabelViewController)
        {
            (destinationViewController as! NewLabelViewController).onePasswordsViewController = self
        }
    }
    
    override var representedObject: AnyObject?
    {
        didSet
        {
            // Update the view, if already loaded.
        }
    }

    private func setupView()
    {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColorUtil.getColorFromString("#2196f3")?.CGColor
    }
    
    func refreshLabels()
    {
        self.labels.getAll()
        self.labelsTableView.reloadData()
    }
    
    //TableView Data Source
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return self.labels.count()
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        if let cell = tableView.makeViewWithIdentifier("LabelCellID", owner: nil) as? NSTableCellView
        {
            cell.textField?.stringValue = self.labels.getAt(row)
            return cell
        }
        
        return nil
    }
    
    func tableViewDoubleClick(sender: AnyObject)
    {
        if (self.labelsTableView.selectedRow >= 0)
        {
            let label = self.labels.getAt(self.labelsTableView.selectedRow)
            
            let d = self.onePasswords.computePassword(self.key.getKey(), st: label)
            copyToPasteboard(d);
            
            let alert = NSAlert()
            alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil)
            alert.messageText = "Password retrieved"
            alert.informativeText = "Your password for " + label + " is ready to be pasted!"
            alert.addButtonWithTitle("Awesome!")
            alert.alertStyle = NSAlertStyle.InformationalAlertStyle
        }
    }
}
//
//  Persistablelabels.swift
//  One Passwords
//
//  Created by Ghost on 3/2/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Foundation

let docsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String;

let labelsfilename = "/.service-tags";
let pathTolabelsFile = docsFolder.stringByAppendingString(labelsfilename);

internal class PersistableLabels
{
    var labels = [String]()
    
    internal func add(var serviceTag: String)
    {
        if (self.labels.contains(serviceTag))
        {
            return;
        }
        
        serviceTag = serviceTag.lowercaseString
        serviceTag = serviceTag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        self.labels.insert(serviceTag, atIndex: self.labels.count);
        self.labels.sortInPlace();
        savelabels();
    }
    
    internal func getAll() -> [String]
    {
        loadlabels();
        self.labels.sortInPlace();
        
        return self.labels;
    }
    
    internal func getAt(position: Int) -> String
    {
        var ret = "";
        
        for (i, serviceTag) in self.labels.enumerate()
        {
            if (i == position)
            {
                ret = serviceTag;
            }
        }
        
        return ret;
    }

    
    internal func deleteAt(position: Int) -> String
    {
        if (position < 0 || position >= self.labels.count)
        {
            return ""
        }
        
        let ret = self.labels.removeAtIndex(position);
        
        self.savelabels();
        
        return ret;
    }

    internal func count() -> Int
    {
        return self.labels.count;
    }
    
    private func savelabels()
    {
        var dump = "";
        
        for (_, serviceTag) in self.labels.enumerate()
        {
            dump += serviceTag + "\n";
        }
            
        do
        {
            try dump.writeToFile(pathTolabelsFile, atomically: false, encoding: NSUTF8StringEncoding);
        }
        catch
        {
        }
    }

    private func loadlabels()
    {
        do
        {
            self.labels.removeAll();
            
            let tags = try String(contentsOfFile: pathTolabelsFile, encoding: NSUTF8StringEncoding).characters.split("\n");
            
            for (_, tag) in tags.enumerate()
            {
                self.labels.insert(String(tag), atIndex: 0);
            }
            
            self.labels.sortInPlace();
        }
        catch
        {
        }
    }
}
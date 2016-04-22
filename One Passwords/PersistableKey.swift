//
//  PersistableKey.swift
//  One Passwords
//
//  Created by Ghost on 3/3/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Foundation

let keyFileName = "/.key";
let pathToKeyFile = docsFolder.stringByAppendingString(keyFileName);

internal class PersistableKey
{
    static var Key = "";
    
    internal func getKey() -> String
    {
        if (PersistableKey.Key != "")
        {
            return PersistableKey.Key;
        }
        
        loadKey();
        
        return PersistableKey.Key;
    }
    
    internal func setkey(key: String)
    {
        if (key != PersistableKey.Key)
        {
            PersistableKey.Key = key;
            saveKey();
        }
    }
    
    private func loadKey()
    {
        do
        {
            let encryptedKey = try String(contentsOfFile: pathToKeyFile, encoding: NSUTF8StringEncoding);
            PersistableKey.Key = try encryptedKey.aesDecrypt();
        }
        catch
        {
        }
    }
    
    private func saveKey()
    {
        do
        {
            let encryptedKey = try PersistableKey.Key.aesEncrypt();
            try encryptedKey.writeToFile(pathToKeyFile, atomically: false, encoding: NSUTF8StringEncoding);
        }
        catch
        {
        }
    }
}
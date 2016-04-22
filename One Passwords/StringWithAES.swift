//
//  StringWithAES.swift
//  One Passwords
//
//  Created by Ghost on 3/3/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

import Cocoa
import CryptoSwift

extension String
{
    func aesEncrypt() throws -> String
    {
        let key = String(self.macSerialNumber().characters.dropLast(4))
        let iv = String(self.macSerialNumber().characters.dropLast(20))
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let result = String(base64String)

        return result
    }
    
    func aesDecrypt() throws -> String
    {
        let key = String(self.macSerialNumber().characters.dropLast(4))
        let iv = String(self.macSerialNumber().characters.dropLast(20))
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
        
        return String(result!)
    }

    func macSerialNumber() -> String
    {
        // Get the platform expert
        let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
        
        // Get the serial number as a CFString ( actually as Unmanaged<AnyObject>! )
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey, kCFAllocatorDefault, 0);
        
        // Release the platform expert (we're responsible)
        IOObjectRelease(platformExpert);
        
        // Take the unretained value of the unmanaged-any-object
        // (so we're not responsible for releasing it)
        // and pass it back as a String or, if it fails, an empty string
        return (serialNumberAsCFString.takeUnretainedValue() as? String) ?? ""
    }
}
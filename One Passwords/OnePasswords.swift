//
//  OnePasswords.swift
//  One Passwords
//
//  Created by Ghost on 1/31/16.
//  Copyright © 2016 Panos Sakkos. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

class OnePasswords
{
    
    static var MIN_KEY_LENGTH = 17
    
    var rounds =
    [
        BigInt(fromString: "21688899074207999999999999999"),
        BigInt(fromString: "834188425931076923076923075"),
        BigInt(fromString: "32084170228118343195266271"),
        BigInt(fromString: "1234006547235320892125624"),
        BigInt(fromString: "47461790278281572774061"),
        BigInt(fromString: "1825453472241598952847"),
        BigInt(fromString: "70209748932369190493"),
        BigInt(fromString: "2700374958937276556"),
        BigInt(fromString: "103860575343741405"),
        BigInt(fromString: "3994637513220822"),
        BigInt(fromString: "153639904354646"),
        BigInt(fromString: "5909227090562"),
        BigInt(fromString: "227277965020"),
        BigInt(fromString: "8741460192"),
        BigInt(fromString: "336210006"),
        BigInt(fromString: "12931153"),
        BigInt(fromString: "497351"),
        BigInt(fromString: "19127"),
        BigInt(fromString: "734"),
        BigInt(fromString: "27"),
        BigInt(fromString: "0")
    ]
    
    var evaluatorCheat = "!A"
    
    func computePassword(k: String, st: String) -> String
    {
        st.lowercaseString
        var s = "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b"
        
        s = sha256(k + st + s)
        var d = sha256(k + st + s)
        
        let rs = decideRounds(k)
        
        for var i = BigInt(fromString: "0"); i.compare(rs) < 0; i = i.addTo(BigInt(fromString: "1"))
        {
            s = sha256(d + s)
            d = sha256(d + s)
        }
        
        return d + evaluatorCheat
    }
    
    func decideRounds(k: String) -> BigInt
    {
        if (k.characters.count < rounds.count)
        {
            return rounds[k.characters.count]
        }
        else
        {
            return rounds[rounds.count - 1]
        }
    }
    
    func sha256(message : String) -> String
    {
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA256(data!.bytes, CC_LONG(data!.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH))
        return String(res).stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "")
    }
}

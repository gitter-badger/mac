//
//  bigint.swift
//  bigint
//
//  Created by Jeremiah Kent on 6/15/14.
//  Copyright (c) 2014 Jeremiah Kent. All rights reserved.
//

#if os(iOS)
  import UIKit
#else
  import AppKit
#endif

class BigInt : CustomStringConvertible {
    
    // sets of four decimal digits, least significant set first
    var quads:Array<Int> = []
    var negative = false
    
    init(fromString s:String) {
        var first = true
        var digits:Array<Int> = []
        for c in s.characters {
            if first {
                first = false
                if c == "-" {
                    negative = true
                }
            } else {
                
            }
          let i = Int(String(c));
            if let d = i {
                digits.append(d)
            }
        }
        var quadCount = 0
        var quadDigits:Array<Int> = [0, 0, 0, 0]
        for d in digits.reverse() {
            quadDigits[quadCount++] = d
            if quadCount == 4 {
                quads.append(intFromDigits(quadDigits, withCount: quadCount))
                quadCount = 0
            }
        }
        if quadCount != 0 {
            quads.append(intFromDigits(quadDigits, withCount: quadCount))
        }
    }
    
    init(fromQuads:Array<Int>, isNegative:Bool=false) {
        for q in fromQuads {
            quads.append(q)
        }
        negative = isNegative
    }
    
    convenience init(copy:BigInt) {
        self.init(fromQuads:copy.quads, isNegative:copy.negative)
    }
    
    func intFromDigits(digits:Array<Int>, withCount count:Int) -> Int{
        var val  = 0
        var mult = 1
        for i in 0..<count {
            val += digits[i] * mult
            mult *= 10
        }
        return val
    }
    
    var description:String {
        get {
            var val = ""
            var first = true
            for q in quads.reverse() {
                var quadVal = String(q)
                let pad = 4 - quadVal.characters.count
                if first {
                    first = false
                } else {
                    for _ in 0..<pad {
                        quadVal = "0" + quadVal
                    }
                }
                let empty = (val.isEmpty || val == "-")
                if !empty || Int(quadVal) != 0 {
                    val += quadVal
                }
            }
            if val == "" {val = "0"}
            if negative && val != "0" { val = "-" + val }
            return val
        }
    }
    
    var positive:Bool {
        get {
            return !negative
        }
    }
    
    var nTerms:Int {
        get {
            return quads.count
        }
    }
    
    func normalize(value:Int) -> (Int, Int) {
        var overflow = 0 // negative for borrow
        var ret = value  // params are immutable...
        while ret > 9999 { overflow++; ret -= 10000 }
        while ret < 0    { overflow--; ret += 10000 }
        
        // first attempt at optimization: FAILED
//        println("old way: \(ret), \(overflow)")
//        (ret, overflow) = (ret % 10000, ret / 10000)
//        println("new way: \(ret), \(overflow)")
        
        return (ret, overflow)
    }
    
    func negate() -> BigInt {
        return BigInt(fromQuads: self.quads, isNegative:!self.negative)
    }
    
    func abs() -> BigInt {
        return BigInt(fromQuads: self.quads)
    }
    
    func addTo(other:BigInt) -> BigInt
    {
        switch (self.positive, other.positive) {
            case (true, true):
                var quads:Array<Int> = []
                var overflow = 0
                for i in 0..<max(self.nTerms, other.nTerms) {
                    var sum = ((i <  self.nTerms) ?  self.quads[i] : 0) +
                              ((i < other.nTerms) ? other.quads[i] : 0) +
                              overflow
                    (sum, overflow) = normalize(sum)
                    quads.append(sum)
                }
                if overflow > 0 { quads.append(overflow) }
                
                return BigInt(fromQuads:quads)
            case ( true, false): return self.subtract(-other)
            case (false,  true): return other.subtract(-self)
            case (false, false): return -((-self).addTo(-other))
        }
    }
    
    func subtract(other:BigInt) -> BigInt {
        switch (self.positive, other.positive) {
            case (true, true):
                if( self >= other ) {
                    // at this point, we're guaranteed to have positive larger minus positive smaller
                    
                    var quads:Array<Int> = []
                    var overflow = 0 // doubles as "borrow" since it can be negative
                    for i in 0..<max(self.nTerms, other.quads.count) {
                        var sum = ((i <  self.nTerms) ?  self.quads[i] : 0) -
                                  ((i < other.nTerms) ? other.quads[i] : 0) +
                                  overflow
                        (sum, overflow) = normalize(sum)
                        quads.append(sum)
                    }
                    if overflow > 0 { quads.append(overflow) }
                    
                    return BigInt(fromQuads:quads)
                }
                return -(other.subtract(self))
            case ( true, false): return self.addTo(-other)
            case (false,  true): return -((-self).addTo(other))
            case (false, false): return -((-self).subtract(-other))
        }
    }
    
    func multiplyBy(other:BigInt) -> BigInt {
        let negative = self.negative != other.negative
        let outputLen = self.nTerms + other.nTerms + 1
        var c:Array<Int> = []
        for _ in 0..<outputLen {c.append(0)}
        
        var overflow = 0
        for i in 0..<self.nTerms {
            for j in 0..<other.nTerms {
                c[i+j] += (self.quads[i] * other.quads[j])
            }
        }
        
        overflow = 0
        for i in 0..<c.count {
            (c[i], overflow) = normalize(c[i]) // this needs to be optimized; it's looping large numbers of times as it is
        }
        
        return BigInt(fromQuads: c, isNegative: negative)
    }

    var intVal:Int? {
        get {
          return Int(self.description);
        }
    }
    
    func compare(other:BigInt) -> Int {
        switch (self.positive, other.positive) {
        case (true, true):
            let c = self.nTerms, o = other.nTerms
            if c > o { return  1 }
            if c < o { return -1 }
            for i in 0..<c {
                let j = c-i-1
                if self.quads[j]  > other.quads[j] { return  1 }
                if self.quads[j]  < other.quads[j] { return -1 }
                return 0
            }
            return 2
        case ( true, false): return  1
        case (false,  true): return -1
        case (false, false): return (-self).compare(-other)
        default:             exit(1)
        }
    }
}

prefix func -  ( val: BigInt               ) -> BigInt { return val.negate()              }

 func +  (left: BigInt, right: BigInt) -> BigInt { return left.addTo(right)         }
func -  (left: BigInt, right: BigInt) -> BigInt { return left.subtract(right)      }
func *  (left: BigInt, right: BigInt) -> BigInt { return left.multiplyBy(right)    }

func == (left: BigInt, right: BigInt) -> Bool   { return left.compare(right) ==  0 }
func != (left: BigInt, right: BigInt) -> Bool   { return left.compare(right) !=  0 }

func >  (left: BigInt, right: BigInt) -> Bool   { return left.compare(right) ==  1 }
func <  (left: BigInt, right: BigInt) -> Bool   { return left.compare(right) == -1 }

func >= (left: BigInt, right: BigInt) -> Bool   { return left.compare(right) != -1 }
func <= (left: BigInt, right: BigInt) -> Bool   { return left.compare(right) !=  1 }




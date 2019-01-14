//
//  Constants.swift
//  Racer
//
//  Created by John Sudduth on 1/5/19.
//  Copyright © 2019 John Sudduth. All rights reserved.
//

struct Categories {
    static let biker  : UInt32          = 1 << 1
    static let obstacle: UInt32         = 1 << 2
    static let left_boder : UInt32      = 1 << 3
    static let right_border : UInt32    = 1 << 4
    static let puddle : UInt32          = 1 << 5
    static let car : UInt32             = 1 << 6
    static let speedBuff : UInt32       = 1 << 7
    static let healthBuff : UInt32      = 1 << 8
    static let resistBuff : UInt32      = 1 << 9
}

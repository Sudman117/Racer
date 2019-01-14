//
//  Constants.swift
//  Racer
//
//  Created by John Sudduth on 1/5/19.
//  Copyright © 2019 John Sudduth. All rights reserved.
//

struct Categories {
    static let biker  : UInt32          = 0x1 << 1
    static let obstacle: UInt32         = 0x1 << 2
    static let left_boder : UInt32      = 0x1 << 3
    static let right_border : UInt32    = 0x1 << 4
    static let puddle : UInt32          = 0x1 << 5
    static let car : UInt32             = 0x1 << 6
    static let speedBuff : UInt32       = 0x1 << 7
    static let healthBuff : UInt32      = 0x1 << 8
    static let resistBuff : UInt32       = 0x1 << 9
}

enum ObstacleType:Int {
    case Small = 0
    case Medium = 1
    case Large = 2
}

enum RowType:Int {
    case SSmall = 0
    case SMedium = 1
    case SLarge = 2
}
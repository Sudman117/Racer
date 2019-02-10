//
//  PowerUpDefinitions.swift
//  Racer
//
//  Created by John Sudduth on 2/3/19.
//  Copyright © 2019 John Sudduth. All rights reserved.
//

extension GameScene {
    
    func powerUpCombinations() {
        if speedUpNumber == 5 {
            /* Teleport  */
            rect6.isHidden = false
        } else if healUpNumber == 5 {
            /* Constant heal */
            rect6.isHidden = false
        } else if resistUpNumber == 5 {
            /* Shield */
            makeShield()
            rect6.isHidden = false
        }
        else if speedUpNumber == 4 && resistUpNumber == 1{
            /*  */
            rect6.isHidden = false
        } else if speedUpNumber == 4 && healUpNumber == 1{
            rect6.isHidden = false
        } else if speedUpNumber == 3 && resistUpNumber == 2{
            rect6.isHidden = false
        } else if speedUpNumber == 3 && healUpNumber == 2{
            rect6.isHidden = false
        } else if speedUpNumber == 3 && resistUpNumber == 1 && healUpNumber == 1 {
            rect6.isHidden = false
        } else if speedUpNumber == 2 && resistUpNumber == 3 {
            rect6.isHidden = false
        } else if speedUpNumber == 2 && resistUpNumber == 2 && healUpNumber == 1 {
            rect6.isHidden = false
        } else if speedUpNumber == 2 && resistUpNumber == 1 && healUpNumber == 2 {
            rect6.isHidden = false
        }else if speedUpNumber == 2 && healUpNumber == 3 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 4{
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 3 && healUpNumber == 1 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 2 && healUpNumber == 2 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 1 && healUpNumber == 3 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && healUpNumber == 4 {
            rect6.isHidden = false
        } else if healUpNumber == 2 && resistUpNumber == 3 {
            rect6.isHidden = false
        } else if healUpNumber == 3 && resistUpNumber == 2 {
            rect6.isHidden = false
        } else if healUpNumber == 4 && resistUpNumber == 1 {
            rect6.isHidden = false
        } else if resistUpNumber == 4 && healUpNumber == 1 {
            rect6.isHidden = false
        } else {
            rect6.isHidden = true
        }
    }
}

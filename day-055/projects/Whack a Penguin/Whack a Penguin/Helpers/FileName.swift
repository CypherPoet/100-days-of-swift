//
//  SoundFileName.swift
//  Whack a Penguin
//
//  Created by Brian Sipple on 4/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum FileName {
    enum Sound {
        static let whackGood = "whack.caf"
        static let whackBad = "whackBad.caf"
        static let gameOver = "game-over-mixed.mp3"
    }
    
    enum Emitter {
        static let goodHit = "hit-spark-good"
        static let badHit = "hit-spark-bad"
        static let mudDisplacement = "mud-displacement"
    }
    
    enum Image {
        static let background = "whackBackground"
        static let goodPenguin = "penguinGood"
        static let badPenguin = "penguinEvil"
        static let whackMask = "whackMask"
        static let slotOpening = "whackHole"
    }
}

//
//  Level.swift
//  Log
//
//  Created by Dmytro Shulzhenko on 4/25/19.
//  Copyright © 2019 Dmytro Shulzhenko. All rights reserved.
//

import Foundation

struct Level: Equatable {
    let description: String
    
    init(description: String) {
        self.description = description
    }
}

extension Level {
    static var debug: Level { return Level(description: "♡ DEBUG:") }
    static var info: Level { return Level(description: "💚 INFO:") }
    static var warning: Level { return Level(description: "💛 WARNING:") }
    static var error: Level { return Level(description: "💔 ERROR:") }
    static var fatal: Level { return Level(description: "‼️ FATAL ‼️:") }
}

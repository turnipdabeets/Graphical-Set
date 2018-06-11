//
//  Card.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import Foundation

/// hashable Card

struct Card: Hashable
{
    var number: Number
    var symbol: Symbol
    var shading: Shading
    var color: Color
    
    enum Number : Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all: [Number] {
            return [.one, .two, .three]
        }
    }
    
    enum Symbol: Int {
        case diamond
        case oval
        case squiggle
        
        static var all: [Symbol] {
            return [.diamond, .oval, .squiggle]
        }
    }
    
    enum Shading: Int {
        case solid
        case striped
        case open
        
        static var all: [Shading] {
            return [.solid, .striped, .open]
        }
    }
    
    enum Color: Int {
        case teal
        case pink
        case purple
        
        static var all: [Color] {
            return [.teal, .pink, .purple]
        }
    }
    
    var hashValue: Int { return identifier  }
    private(set) var identifier: Int
    private static var identifierFactory = 0
    
    /// always return a unique number incrementing by 1
    private static func generateUUID() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(number: Number, symbol: Symbol, shading: Shading, color: Color) {
        self.identifier = Card.generateUUID()
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
}

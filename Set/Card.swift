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
    var number: Int
    var symbol: Int
    var shading: Int
    var color: Int
    
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
    
    init(number: Int, symbol: Int, shading: Int, color: Int) {
        self.identifier = Card.generateUUID()
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
    
}

//
//  Set.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import Foundation

struct SetGame
{
    private(set) var cards = [Card]()
    private(set) var selectedCards = [Card]()
    
    init(){
        makeDeck()
//        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
//        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 1, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 2, symbol: 1, shading: 1, color: 1))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
//        cards.append(Card(number: 0, symbol: 1, shading: 1, color: 0))
        
    }
    
    mutating private func makeDeck(){
        let cardOptionRange = 0..<3
        for number in cardOptionRange {
            for symbol in cardOptionRange {
                for shading in cardOptionRange {
                    for color in cardOptionRange {
                        let card = Card(number: number, symbol: symbol, shading: shading, color: color)
                        cards.append(card)
                    }
                }
            }
        }
    }
    
    mutating func drawCard() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        }else {
            return nil
        }
    }
    
    mutating func clearSelectedCards(){
        selectedCards.removeAll()
    }
    
    mutating func matchedCards() -> [Card]? {
        var matchedCards = [Card]()
        if selectedCards.count == 3 {
            //check if match
            let hasMatch = evaluateSet()
            if hasMatch {
                matchedCards = selectedCards
            }
        }
        return matchedCards.isEmpty ? nil : matchedCards
    }
    
    mutating func select(card: Card) {
        // remove from selected if previously selected
        if let index = selectedCards.index(of: card){
            selectedCards.remove(at: index)
            return
        }
        // save 3 total selected cards
        if selectedCards.count < 3 {
            selectedCards.append(card)
        }
    }
    
    func evaluateSet() -> Bool {
        // get three selected cards
        let cardOne = selectedCards[0]
        let cardTwo = selectedCards[1]
        let cardThree = selectedCards[2]
        // get set cases
        let allTheSameNumber = allTheSame(itemOne: cardOne.number, itemTwo: cardTwo.number, itemThree: cardThree.number)
        let allDifferentNumber = allDifferent(itemOne: cardOne.number, itemTwo: cardTwo.number, itemThree: cardThree.number)
        let allTheSameColor = allTheSame(itemOne: cardOne.color, itemTwo: cardTwo.color, itemThree: cardThree.color)
        let allDifferentColor = allDifferent(itemOne: cardOne.color, itemTwo: cardTwo.color, itemThree: cardThree.color)
        let allTheSameSymbol = allTheSame(itemOne: cardOne.symbol, itemTwo: cardTwo.symbol, itemThree: cardThree.symbol)
        let allDifferentSymbol = allDifferent(itemOne: cardOne.symbol, itemTwo: cardTwo.symbol, itemThree: cardThree.symbol)
        let allTheSameShading = allTheSame(itemOne: cardOne.shading, itemTwo: cardTwo.shading, itemThree: cardThree.shading)
        let allDifferentShading = allDifferent(itemOne: cardOne.shading, itemTwo: cardTwo.shading, itemThree: cardThree.shading)
        // check set cases
        if allTheSameNumber || allDifferentNumber {
            if allTheSameColor || allDifferentColor {
                if allTheSameSymbol || allDifferentSymbol {
                    if allTheSameShading || allDifferentShading {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func allTheSame(itemOne: Int, itemTwo: Int, itemThree:Int) -> Bool {
        return itemOne == itemTwo && itemTwo == itemThree
    }
    
    private func allDifferent(itemOne: Int, itemTwo: Int, itemThree:Int) -> Bool {
        return itemOne != itemTwo && itemTwo != itemThree && itemThree != itemOne
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}

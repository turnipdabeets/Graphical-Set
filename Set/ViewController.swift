//
//  ViewController.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var game = SetGame()
    private var visibleCards = [Card]()
    private var allCardsMatched: Bool {
        let cards = visibleCards.filter({card in
            if let index = visibleCards.index(of: card){
                return cardButtons[index].isEnabled
            }
            return false
        })
        return cards.count == 3
    }
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var misMatched = [Card]() {
        didSet {
            if !misMatched.isEmpty {
                infoLabel.text = "try again..."
            }else {
                resetInfoLabel()
            }
        }
    }
    private var matched = [Card]() {
        didSet {
            if !matched.isEmpty {
                infoLabel.numberOfLines = 2
                infoLabel.lineBreakMode = .byWordWrapping
                matchLabel.text = allCardsMatched ? "YOU WIN!" : "MATCH!"
                if !game.cards.isEmpty {
                    infoLabel.text = "deal three more cards..."
                }else {
                    resetInfoLabel()
                }
            }else {
                resetMatchLabel()
                resetInfoLabel()
            }
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            // set up buttons with 12 cards
            initalDeal()
        }
    }
    @IBOutlet weak var dealMoreButton: UIButton!
    @IBAction func dealThreeMore(_ sender: UIButton) {
        // have a match and cards available to deal
        if !matched.isEmpty && !game.cards.isEmpty {
            clearAndDeal()
        } else {
            // deal three more cards
            //TODO: make sure no set exists before allow dealing more?
            deal()
        }
        // disable if we run out of cards
        if game.cards.isEmpty {
            disable(button: sender)
            resetInfoLabel()
        }
    }
    @IBAction func selectCard(_ sender: UIButton) {
        // must deal more cards if we have a match first
        if !matched.isEmpty && !game.cards.isEmpty { return }
        
        // deal no longer possible
        if !matched.isEmpty && game.cards.isEmpty { clearAndDeal()}
        
        // reset any mismatched card styles
        if !misMatched.isEmpty { resetMisMatchedStyle() }
        
        // select or deselect card
        if let index = cardButtons.index(of: sender) { toggleCardSelection(by: index)}
        
        // check for match
        checkIfCardsMatch()
    }
    @IBAction func newGame(_ sender: UIButton) {
        score = 0
        game = SetGame()
        visibleCards.removeAll()
        matched.removeAll()
        misMatched.removeAll()
        resetInfoLabel()
        resetMatchLabel()
        resetButtons()
        initalDeal()
    }
    
    private func resetButtons(){
        // reset cardButtons
        for button in cardButtons {
            button.isEnabled = true
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
        }
        // reset dealMoreButton
        dealMoreButton.isEnabled = true
        dealMoreButton.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.6, blue: 0.9882352941, alpha: 1)
        dealMoreButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
    
    private func initalDeal(){
        for index in 0..<12 {
            if let card = game.drawCard() {
                visibleCards.append(card)
                style(a: cardButtons[index], by: card)
            }
        }
    }
    
    private func resetInfoLabel() {
        let emptyDeck = "all cards are on the table!"
        infoLabel.numberOfLines = 2
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.text = game.cards.isEmpty ? emptyDeck : ""
    }
    
    private func resetMatchLabel(){
        matchLabel.text = ""
    }
    
    private func toggleCardSelection(by index: Int){
        if visibleCards.indices.contains(index) {
            if cardButtons[index].isEnabled {
                game.select(card: visibleCards[index])
                styleTouched(button: cardButtons[index], by: visibleCards[index])
            }
        }
    }
    
    private func disable(button sender: UIButton){
        sender.isEnabled = false
        sender.backgroundColor = #colorLiteral(red: 0.8000000119, green: 0.8000000119, blue: 0.8000000119, alpha: 1)
        sender.setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
    }
    
    private func removeStyleFrom(button: UIButton){
        button.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func clearAndDeal(){
        for card in matched {
            if let index = visibleCards.index(of: card){
                // remove matched styles
                removeStyleFrom(button: cardButtons[index])
                // draw new card
                if let newCard = game.drawCard() {
                    // swap with old card
                    replace(old: index, with: newCard)
                } else {
                    // ran out of cards in the deck!
                    hideButton(by: index)
                }
            }
        }
        matched.removeAll()
    }
    
    private func deal(){
        if visibleCards.count < cardButtons.count {
            let lastVisibleCardIndex = visibleCards.count
            for index in 0..<3 {
                if let card = game.drawCard() {
                    // add more visible cards
                    visibleCards.append(card)
                    style(a: cardButtons[index + lastVisibleCardIndex], by: card)
                } else {
                    print("ran out of cards in the deck!")
                }
            }
        } else {
            print("ran out of button space")
        }
    }
    
    private func resetMisMatchedStyle(){
        for card in misMatched {
            if let index = visibleCards.index(of: card){
                // remove style
                removeStyleFrom(button: cardButtons[index])
            }
        }
        misMatched.removeAll()
    }
    
    private func checkIfCardsMatch(){
        if let matchedCards = game.matchedCards() {
            matched = matchedCards
            game.clearSelectedCards()
            score += 3
            styleMatchedCards()
        }else {
            if game.selectedCards.count == 3 {
                misMatched = game.selectedCards
                game.clearSelectedCards()
                score -= 5
                styleMisMatchedCards()
            }
        }
    }
    
    private func styleMatchedCards(){
        for card in matched {
            if let index = visibleCards.index(of: card){
                let button = cardButtons[index]
                button.layer.backgroundColor = #colorLiteral(red: 0.6833661724, green: 0.942397684, blue: 0.7068206713, alpha: 1)
            }
        }
    }
    
    private func styleMisMatchedCards(){
        for card in misMatched {
            if let index = visibleCards.index(of: card){
                let button = cardButtons[index]
                button.layer.backgroundColor = #colorLiteral(red: 1, green: 0.8087172196, blue: 0.7614216844, alpha: 1)
            }
        }
    }
    
    private func replace(old index: Int, with newCard: Card){
        visibleCards[index] = newCard
        style(a: cardButtons[index], by: newCard)
    }
    
    private func hideButton(by index: Int){
        let button = cardButtons[index]
        button.setAttributedTitle(NSAttributedString(string:""), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.isEnabled = false
    }
    
    private func styleTouched(button: UIButton, by card: Card) {
        if game.selectedCards.contains(card) {
            button.layer.backgroundColor = #colorLiteral(red: 0.9848672538, green: 0.75109528, blue: 1, alpha: 1)
        }else {
            removeStyleFrom(button: button)
        }
    }
    
    private func style(a button: UIButton, by card: Card) {
        // with color
        let colorGroup = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)]
        let cardColor = colorGroup[card.color]
        // with symbol
        let symbolGroup = ["\u{25B2}", "\u{25AE}", "\u{25CF}"] // triangle, rectangle, circle
        // with shading
        var attribute: [NSAttributedStringKey: Any] = [:]
        if card.shading == 0 {
            // striped
            attribute[.foregroundColor] = cardColor.withAlphaComponent(0.15)
        } else if card.shading == 1 {
            // solid
            attribute[.foregroundColor] = cardColor.withAlphaComponent(1.0)
        } else {
            // open
            attribute[.strokeColor] = cardColor
            attribute[.strokeWidth] = 5.0
        }
        // with number
        var shape = ""
        for _ in 0...card.number {
            shape += symbolGroup[card.symbol]
        }
        // set attributes
        let attributedString = NSAttributedString(string: shape, attributes: attribute)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}


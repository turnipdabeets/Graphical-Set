//
//  ViewController.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ButtonDelegate {
    func onButtonTap(card: Card) {
        print("This button was clicked in the subview!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assigning the delegate DOES NOT WORK!
        CardView.delegate = self
    }
    // Game
    private var game = SetGame()
    private lazy var grid = CardTableView(frame: CardTable.bounds, cardsInPlay: visibleCards)
    // table to place all cards
    @IBOutlet weak var CardTable: UIView! {
        didSet {
            // set up buttons with 12 cards
            initalDeal()
        }
    }
    @IBAction func newGame(_ sender: UIButton) {
        score = 0
        game = SetGame()
        visibleCards.removeAll()
        matched.removeAll()
        misMatched.removeAll()
        dealMoreButton.isEnabled = true
        dealMoreButton.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.6, blue: 0.9882352941, alpha: 1), for: .normal)
        initalDeal()
        grid.cards = visibleCards
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // reset frame when device rotates
        grid.frame = CardTable.bounds
        
        // add cards to the card table
        CardTable.addSubview(grid)
    }
    // Cards
    private var visibleCards = [Card]()
    
    // Score
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Deal
    @IBOutlet weak var dealMoreButton: UIButton!
    @IBAction func deal(_ sender: UIButton) {
        // have a match and cards available to deal
        if !matched.isEmpty && !game.cards.isEmpty {
            //TODO: fix this for new UI
            clearAndDeal()
        } else {
            dealThreeMore()
        }
        // disable if we run out of cards
        if game.cards.isEmpty {
            disable(button: sender)
        }
        grid.cards = visibleCards
    }
    private func dealThreeMore(){
        if visibleCards.count < game.cardTotal {
            for _ in 0..<3 {
                if let card = game.drawCard() {
                    // add more visible cards
                    visibleCards.append(card)
                } else {
                    print("ran out of cards in the deck!")
                }
            }
        }
    }
    private func disable(button sender: UIButton){
        sender.isEnabled = false
        sender.setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
    }
    private func clearAndDeal(){
        //TODO: rewrite me
        for card in matched {
            if let index = visibleCards.index(of: card){
                // remove matched styles
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
    
    // Gestures
//    @IBAction func tapCard(recognizer:UITapGestureRecognizer) {
//        print("view")
//        if recognizer.state == .ended {
//            let location = recognizer.location(in: CardTable)
//            print("TAP", location)
//            if let cardView = CardTable.viewWithTag(100) {
//                print("cardView ",cardView)
//            }
////            if let tappedView = CardTable.hitTest(location, with: nil) {
////                print("tappedView", tappedView)
////                //                if let tableView = CardTable.viewWithTag(CardView) {
////                //                    print( tableView)
////                //                }
////                if let cardIndex = CardTable.subviews.index(of: tappedView) {
////                    print(cardIndex)
////                    //                    setGame.selectCard(at: cardIndex)
////                    //                    updateView()
////                }
////            }
//        }
//    }
    
    private var allCardsMatched: Bool {
        let cards = visibleCards.filter({card in
            //            if let index = visibleCards.index(of: card){
            ////                return cardButtons[index].isEnabled
            //            }
            return false
        })
        return cards.count == 3
    }
    private var misMatched = [Card]()
    private var matched = [Card]()
    
    @IBAction func selectCard(_ sender: UIButton) {
        // must deal more cards if we have a match first
        if !matched.isEmpty && !game.cards.isEmpty { return }
        
        // deal no longer possible
        if !matched.isEmpty && game.cards.isEmpty { clearAndDeal()}
        
        // reset any mismatched card styles
        if !misMatched.isEmpty { resetMisMatchedStyle() }
        
        // select or deselect card
        //        if let index = cardButtons.index(of: sender) { toggleCardSelection(by: index)}
        
        // check for match
        checkIfCardsMatch()
    }
    
    private func initalDeal(){
        for _ in 0..<12 {
            if let card = game.drawCard() {
                visibleCards.append(card)
                //                style(a: cardButtons[index], by: card)
            }
        }
    }
    
    private func toggleCardSelection(by index: Int){
        if visibleCards.indices.contains(index) {
            //            if cardButtons[index].isEnabled {
            //                game.select(card: visibleCards[index])
            //                styleTouched(button: cardButtons[index], by: visibleCards[index])
            //            }
        }
    }
    
    private func removeStyleFrom(button: UIButton){
        button.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func resetMisMatchedStyle(){
        for card in misMatched {
            if let index = visibleCards.index(of: card){
                // remove style
                //                removeStyleFrom(button: cardButtons[index])
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
                //                let button = cardButtons[index]
                //                button.layer.backgroundColor = #colorLiteral(red: 0.6833661724, green: 0.942397684, blue: 0.7068206713, alpha: 1)
            }
        }
    }
    
    private func styleMisMatchedCards(){
        for card in misMatched {
            if let index = visibleCards.index(of: card){
                //                let button = cardButtons[index]
                //                button.layer.backgroundColor = #colorLiteral(red: 1, green: 0.8087172196, blue: 0.7614216844, alpha: 1)
            }
        }
    }
    
    private func replace(old index: Int, with newCard: Card){
        visibleCards[index] = newCard
        //        style(a: cardButtons[index], by: newCard)
    }
    
    private func hideButton(by index: Int){
        //        let button = cardButtons[index]
        //        button.setAttributedTitle(NSAttributedString(string:""), for: .normal)
        //        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        //        button.isEnabled = false
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
        var cardColor: UIColor
        switch card.color {
        case .teal:
            cardColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        case .pink:
            cardColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1)
        case .purple:
            cardColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        }
        // with symbol
        let symbolGroup = ["\u{25B2}", "\u{25AE}", "\u{25CF}"] // triangle, rectangle, circle
        // with shading
        var attribute: [NSAttributedStringKey: Any] = [:]
        if card.shading.rawValue == 0 {
            // striped
            attribute[.foregroundColor] = cardColor.withAlphaComponent(0.15)
        } else if card.shading.rawValue == 1 {
            // solid
            attribute[.foregroundColor] = cardColor.withAlphaComponent(1.0)
        } else {
            // open
            attribute[.strokeColor] = cardColor
            attribute[.strokeWidth] = 5.0
        }
        // with number
        var shape = ""
        for _ in 0..<card.number.rawValue {
            shape += symbolGroup[card.symbol.rawValue]
        }
        // set attributes
        let attributedString = NSAttributedString(string: shape, attributes: attribute)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}


//
//  ViewController.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardTableViewDelegate {
    func delegateCardTap(card: Card){
        selectCard(card: card)
    }
    
    @IBOutlet var mainView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleDealGesture))
            swipe.direction = [.down, .up]
            mainView.addGestureRecognizer(swipe)
        }
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
    
    override func viewDidLoad() {
        grid.delegate = self
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
    @IBOutlet weak var scoreLabel: UILabel!
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Deal
    @IBOutlet weak var dealMoreButton: UIButton!
    @IBAction func deal(_ sender: UIButton) {
        handleDeal()
        // disable if we run out of cards
        if game.cards.isEmpty {
            disable(button: sender)
        }
        resetTable()
    }
    @objc private func handleDealGesture(){
        handleDeal()
        if !matched.isEmpty && game.cards.isEmpty {
            removeMatchedCards()
        }
        resetTable()
    }
    private func handleDeal(){
        // have a match and cards available to deal
        if !matched.isEmpty && !game.cards.isEmpty {
            for card in matched {
                if let index = visibleCards.index(of: card){
                    // draw new card
                    if let newCard = game.drawCard() {
                        // set old visibleCard index to newCard
                        visibleCards[index] = newCard
                    } else {
                        // ran out of cards in the deck!
                    }
                }
            }
            matched.removeAll()
        } else {
            // deal three more
            if visibleCards.count < game.cardTotal {
                for _ in 0..<3 {
                    if let card = game.drawCard() {
                        // add more visible cards
                        visibleCards.append(card)
                    }
                }
            }
        }
    }
    private func disable(button sender: UIButton){
        sender.isEnabled = false
        sender.setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
    }
    
    private var misMatched = [Card]()
    private var matched = [Card]()
    
    func selectCard(card: Card) {
        // must deal more cards if we have a match first
        if !matched.isEmpty && !game.cards.isEmpty {
            return
        }
        
        // deal no longer possible
        if !matched.isEmpty && game.cards.isEmpty {
            removeMatchedCards()
        }
        
        // reset any mismatched card styles
        if !misMatched.isEmpty {
            resetMisMatchedStyle()
        }
        
        // select or deselect card
        game.select(card: card)
        
        // check for match
        evaulate(card: card)
        // resetTable
        resetTable()
    }
    
    private func removeMatchedCards(){
        for card in matched {
            if let index = visibleCards.index(of: card){
                visibleCards.remove(at: index)
            }
        }
    }
    
    private func resetTable(){
        grid.removeFromSuperview()
        grid = CardTableView(frame: CardTable.bounds, cardsInPlay: visibleCards)
        grid.delegate = self
        CardTable.addSubview(grid)
    }
    
    private func evaulate(card: Card){
        if let matchedCards = game.matchedCards() {
            matched = matchedCards
            game.clearSelectedCards()
            score += 3
            // set visible cards to matched
            for card in matchedCards {
                if let idx = visibleCards.index(of: card){
                    visibleCards[idx].state = .matched
                }
            }
        }else {
            if game.selectedCards.count == 3 {
                misMatched = game.selectedCards
                game.clearSelectedCards()
                score -= 5
                for card in misMatched {
                    if let idx = visibleCards.index(of: card){
                        visibleCards[idx].state = .misMatched
                    }
                }
            }else {
                // toggle selected
                if let idx = visibleCards.index(of: card){
                    if visibleCards[idx].state == .selected {
                        visibleCards[idx].state = nil
                    }else {
                        visibleCards[idx].state = .selected
                    }
                }
            }
        }
    }
    
    private func initalDeal(){
        for _ in 0..<12 {
            if let card = game.drawCard() {
                visibleCards.append(card)
            }
        }
    }

    private func resetMisMatchedStyle(){
        for card in misMatched {
            if let idx = visibleCards.index(of: card){
                visibleCards[idx].state = nil
            }
        }
        misMatched.removeAll()
    }
}

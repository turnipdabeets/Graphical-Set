//
//  CardTableView.swift
//  Set
//
//  Created by Anna Garcia on 6/16/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class CardTableView: UIView {
    // TODO:// i probably need to set redraw for getting new cards
    private var cards = [Card]()
    
    
    init(frame: CGRect, cardsInPlay: [Card]) {
        super.init(frame: frame)
        self.cards = cardsInPlay
        //TODO: set this to clear
        backgroundColor = #colorLiteral(red: 0.9472620869, green: 0.1898318151, blue: 0.172613248, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 128)
//        #colorLiteral(red: 0.9472620869, green: 0.1898318151, blue: 0.172613248, alpha: 1).setFill()
//        path.fill()
//    }
    
    override func layoutSubviews() {
        print(cards)
        super.layoutSubviews()
        // add single card to cover whole bounds of table for testing, next try to get from array of cards and handle spacing between them with frame changes
        let card = CardView(frame: CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height), number: .three, symbol: .oval, shading: .open, color: .purple)
        addSubview(card)
    }

}

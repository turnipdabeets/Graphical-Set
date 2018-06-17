//
//  CardView.swift
//  Set
//
//  Created by Anna Garcia on 6/15/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit
class CardView: UIView {
    private var number: Card.Number? { didSet { setNeedsDisplay() }}
    private var symbol: Card.Symbol? { didSet { setNeedsDisplay() }}
    private var shading: Card.Shading? { didSet { setNeedsDisplay() }}
    private var color: Card.Color? { didSet { setNeedsDisplay() }}
    
    init(frame: CGRect, number: Card.Number, symbol: Card.Symbol, shading: Card.Shading, color: Card.Color) {
        super.init(frame: frame)
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawCardCanvas()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // draw any number of card objects on card
        if let number = number, let symbol = symbol, let shading = shading, let color = color, let objectFrame = objectFrame {
            for frame in 0..<number.rawValue {
                let object = CardObject(frame: objectFrame[frame], symbol: symbol, shading: shading, color: color)
                addSubview(object)
            }
        }
    }
    
    private func drawCardCanvas(){
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    /// get frames to init cardObject depending on number of cards
    private var objectFrame: [CGRect]? {
        var frames = [CGRect]()
        var space: CGFloat
        if let number = number {
            // get initial space
            switch number {
            case .one:
                space = initialSpaceForOneCard
            case .two:
                space = initialSpaceForTwoCards
            case .three:
                space = initialSpaceForThreeCard
            }
            for _ in 0..<number.rawValue {
                // TODO: figure out why this happens multiple times for one card
                let frame = CGRect(x: margin, y: space, width: widthOfObject, height: heightOfObject)
                frames.append(frame)
                space += oneRow + heightOfObject
            }
            return frames
        }
        return nil
    }
}

extension CardView {
    private var cornerRadius: CGFloat {
        return bounds.height * 0.03
    }
    private var oneRow: CGFloat {
        return bounds.height / 15
    }
    
    private var oneColumn: CGFloat {
        return bounds.width / 10
    }
    
    private var heightOfObject: CGFloat {
        return oneRow * 3
    }
    private var widthOfObject: CGFloat {
        return bounds.width - (oneColumn * 3 )
    }
    private var margin: CGFloat {
        return bounds.minX + (oneColumn * 1.5 )
    }
    private var initialSpaceForOneCard: CGFloat {
        return oneRow * 6
    }
    private var initialSpaceForTwoCards: CGFloat {
        return oneRow * 4
    }
    private var initialSpaceForThreeCard: CGFloat {
        return oneRow * 2
    }
}


//
//  CardView.swift
//  Set
//
//  Created by Anna Garcia on 6/15/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit
@IBDesignable
class CardView: UIView {
    @IBInspectable
    var number: Card.Number = .three { didSet { setNeedsDisplay() }}
    @IBInspectable
    var symbol: Card.Symbol = .squiggle
    @IBInspectable
    var shading: Card.Shading = .striped
    @IBInspectable
    var color: Card.Color = .purple
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawCardCanvas()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // draw any number of card objects on card
        for frame in 0..<number.rawValue {
            let object = CardObject(frame: objectFrame[frame], symbol: symbol, shading: shading, color: color)
            addSubview(object)
        }
    }
    
    private func drawCardCanvas(){
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    /// get frames to init cardObject depending on number of cards
    private var objectFrame: [CGRect] {
        var frames = [CGRect]()
        var space: CGFloat
        
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
            print("create total:", number.rawValue)
            let frame = CGRect(x: margin, y: space, width: widthOfObject, height: heightOfObject)
            frames.append(frame)
            space += oneRow + heightOfObject
        }
        return frames
    }
}

extension CardView {
    private var cornerRadius: CGFloat {
        return 16.0
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


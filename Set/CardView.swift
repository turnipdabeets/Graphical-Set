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
    var symbol: Card.Symbol = .oval
    @IBInspectable
    var shading: Card.Shading = .solid
    @IBInspectable
    var color: Card.Color = .pink
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawCard()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for frame in 0..<number.rawValue {
            let object = CardObject(frame: objectFrame[frame], symbol: symbol, shading: shading, color: color)
            addSubview(object)
        }
    }
    
    private var objectFrame: [CGRect] {
        var frames = [CGRect]()
        var space: CGFloat
        // y needs to change based on Card.number
        switch number {
        case .one:
            space = oneRow * 6
        case .two:
            space = oneRow * 4
        case .three:
            space = oneRow * 2
        }
        for _ in 0..<number.rawValue {
            print("create total:", number.rawValue)
            let frame = CGRect(x: margin, y: space, width: widthOfObject, height: heightOfObject)
            frames.append(frame)
            space += oneRow + heightOfObject
        }
        return frames
    }
    
    private func drawCard(){
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    
}

extension CardView {
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
}


//
//  Oval.swift
//  Set
//
//  Created by Anna Garcia on 6/15/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class CardObject: UIView {
    
    private var symbol: Card.Symbol?
    private var shading: Card.Shading?
    private var color: Card.Color?
    
    private var objectPath: UIBezierPath? {
        if let symbol = symbol {
            switch symbol {
            case .oval:
                return UIBezierPath(roundedRect: bounds, cornerRadius: 128)
            case .diamond:
                let path = UIBezierPath()
                path.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
                path.addLine(to: CGPoint(x: bounds.minX, y: bounds.height / 2))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
                path.addLine(to: CGPoint(x:bounds.maxX, y: bounds.height / 2))
                path.close()
                return path
            case .squiggle:
                return UIBezierPath(rect: bounds)
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, symbol: Card.Symbol, shading: Card.Shading, color: Card.Color) {
        self.init(frame: frame)
        self.symbol = symbol
        self.shading = shading
        self.color = color
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    
    override func draw(_ rect: CGRect) {
        if let shape = objectPath, let shading = shading, let cardColor = color {
            shape.addClip()
            let color = getColor(for: cardColor)
            
            switch shading {
            case .open:
                setOutline(color: color, shape: shape)
            case .solid:
                color.setFill()
                shape.fill()
            case .striped:
                setOutline(color: color, shape: shape)
                for x in stride(from: 0, to: bounds.width * 2, by: bounds.width / 40) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: x))
                    path.stroke()
                }
            }
        }
    }
    
    private func setOutline(color: UIColor, shape: UIBezierPath) {
        color.setStroke()
        shape.lineWidth = bounds.width / 60
        shape.stroke()
    }
    
    private func getColor(for color:Card.Color) -> UIColor {
        switch color {
        case .teal:
            return #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case .pink:
            return #colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1)
        }
    }
    
}

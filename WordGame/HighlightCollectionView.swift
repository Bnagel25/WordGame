//
//  HighlightCollectionView.swift
//  WordGame
//
//  Created by Ben Nagel on 3/5/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import UIKit

/**
 * Represents the top layer of the collection view that is transparent
 * and sends drag information through the swipe delegate
 */
class HighlightCollectionView: UICollectionView, ValidWordDelegate{
    
    var swipeDelegate: SwipeDelegate?
    private var lineStart: CGPoint?
    private var lines: [CGPoint] = []
    
    var lineColor: CGColor = UIColor.yellow.cgColor
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor(red:0.91, green:0.95, blue:0.96, alpha:1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func validWord(_ isTrue: Bool) {
        /* Checks if the word is valid and adjusts the line color */
        if(isTrue) {
            lineColor = UIColor(red:1.00, green:0.87, blue:0.15, alpha:1.0).cgColor
        }
        else {
            lineColor = UIColor(red:0.10, green:0.54, blue:0.67, alpha:1.0).cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first!
        lineStart = touch.location(in: self)
        swipeDelegate?.determineSwipePosition(sender: self, location: lineStart!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first!
        let touchPoint = touch.location(in: self)
        let row: Int = Int(touchPoint.y) / Int(frame.height / 16)
        let col: Int = Int(touchPoint.x) / Int(frame.width / 9)
        print(touchPoint)
        print("Row: \(row) col \(col)")
        //lines.append(touchPoint)
        lines.append(CGPoint(x: CGFloat(col) * frame.height / 16.0 + frame.height / 32.0, y: CGFloat(row) * frame.width / 9.0 + frame.width / 18.0))
        self.setNeedsDisplay()
        swipeDelegate?.determineSwipePosition(sender: self, location: touchPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines = []
        self.setNeedsDisplay()
        swipeDelegate?.swipeEnded(sender: self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setLineJoin(.round)
        context.setLineCap(.round)
        context.setStrokeColor(UIColor(red:0.10, green:0.54, blue:0.67, alpha:1.0).cgColor)
        context.setFillColor(UIColor(red:0.10, green:0.54, blue:0.67, alpha:1.0).cgColor)
        context.setLineWidth(3)
        // Draw the vertical lines
        for i in 0...10 {
            let num: CGFloat = CGFloat(i);
            context.move(to: CGPoint(x: num * bounds.width / 9.0, y: 0.0))
            context.addLine(to: CGPoint(x: num * bounds.width / 9.0, y: 12 * bounds.height / 16.0))
            context.strokePath()
        }
        
        // Draw the horizontal
        for i in 0...12 {
            let num: CGFloat = CGFloat(i);
            context.move(to: CGPoint(x: 0.0, y: num * bounds.height / 16.0))
            context.addLine(to: CGPoint(x: bounds.width, y: num * bounds.height / 16.0))
            context.strokePath()
        }
        /*
        context.setFillColor(UIColor.black.cgColor)
        for i in 0...10 {
            context.fillEllipse(in: CGRect(x: bounds.width / 9.0 + bounds.width / 108.0,
                                           y: bounds.height / 16.0 + bounds.height / 160.0,
                                          width: bounds.width / 10.5, height: bounds.width / 10.5))

        }
         */
        // Draw Score and Longest Word Elements
        let lowerBounds = 14 * bounds.height / 16.0
        let scoreString: NSString = NSString(string: "Score:")
        scoreString.draw(at: CGPoint(x: bounds.width / 10.0 ,
                                     y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        
        
        let score: NSString = NSString(string: "\(GameModel.score)")
        score.draw(at: CGPoint(x: 3 * bounds.width / 10.0 ,
                               y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        context.strokePath()
        
        let longestWordString: NSString = NSString(string: "Longest Word:")
        longestWordString.draw(at: CGPoint(x: 4 * bounds.width / 10.0 ,
                                           y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        
        let longestWord: NSString = NSString(string: "\(GameModel.longestWord)")
        longestWord.draw(at: CGPoint(x: 7 * bounds.width / 10.0 ,
                                     y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        
        // Draw line that traces the current swipe
        if let point = lineStart {
            context.move(to: point)
            context.setStrokeColor(lineColor)
            context.setLineWidth(10)
            
            for i in lines {
                context.addLine(to: i)
                context.strokePath()
                context.move(to: i)
            }
        }
    }
}

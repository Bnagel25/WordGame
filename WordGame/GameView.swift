//
//  GameView.swift
//  WordGame
//
//  Created by Ben Nagel on 2/27/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import UIKit


class GameView: UIView {
    
    private var score: NSString = "0"
    private var letters: [String: [Int]] = [:]
    private var context: CGContext?
    private var lineStart: CGPoint?
    private var lines: [CGPoint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setScore(_ score:Int) {
        self.score = NSString(string: "\(score)")
    }
    
    func setLineStart(row: Int, col: Int) {
        lineStart = CGPoint(x: CGFloat(col + 1) * bounds.width / 9.0 - bounds.width / 18.0, y: CGFloat(row + 1) * bounds.height / 16.0 + bounds.height / 19.0 + bounds.height / 32.0)
    }
    
    func startIsSet() -> Bool {
        if lineStart != nil {
            return true
        }
        return false
    }
    
    func appendtoLines(row: Int, col: Int) {
        let line = CGPoint(x: CGFloat(col + 1) * bounds.width / 9.0 - bounds.width / 18.0, y: CGFloat(row + 1) * bounds.height / 16.0 + bounds.height / 19.0 + bounds.height / 32.0)
        lines.append(line)
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        context = UIGraphicsGetCurrentContext()!
        context!.setStrokeColor(UIColor.lightGray.cgColor)
        context?.setLineWidth(3)
        
        // 9x12 grid
        for i in 1...10 {
            let num: CGFloat = CGFloat(i * 1);
            context!.move(to: CGPoint(x: num * bounds.width / 9.0, y: bounds.height / 16.0))
            context!.addLine(to: CGPoint(x: num * bounds.width / 9.0, y: 13 * bounds.height / 16.0 + bounds.height / 19.0))
            context!.strokePath()
        }
        
        for i in 1...13 {
            let num: CGFloat = CGFloat(i * 1);
            context!.move(to: CGPoint(x: 0.0, y: num * bounds.height / 16.0 + bounds.height / 19.0))
            context!.addLine(to: CGPoint(x: bounds.width, y: num * bounds.height / 16.0 + bounds.height / 19.0))
            context!.strokePath()
        }
        
        
        
        // Draw Score and Score String
        
        let lowerBounds = 12 * bounds.height / 12.0
        let scoreString: NSString = NSString(string: "Score:")
        scoreString.draw(at: CGPoint(x: bounds.width / 10.0 , y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        score.draw(at: CGPoint(x: bounds.width / 3.0 , y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        context?.strokePath()
 
        
        // Draw Line
        //let lineEnd: CGPoint = CGPoint(x: CGFloat(5 + 1) * bounds.width / 9.0 - bounds.width / 18.0, y: CGFloat(5 + 1) * bounds.height / 16.0 + bounds.height / 19.0 + bounds.height / 32.0)
        
        if let point = lineStart {
            context!.move(to: point)
            context?.setStrokeColor(UIColor.yellow.cgColor)
            context?.setLineWidth(10)
            
            for i in lines {
                context?.addLine(to: i)
                context?.strokePath()
                context?.move(to: i)
            }
        }
        
        /*
        for i in self.letters.keys {
            let letter: NSString = NSString(string: i)
            if let arr = self.letters[i] {
                for j in 0...arr.count - 1 {
                    let x: CGFloat = CGFloat(self.letters[i]![j] % 12)
                    let y: CGFloat = (CGFloat(self.letters[i]![j]) - CGFloat(x)) / 12
                    let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Thin", size: 24)!]
                    letter.draw(at: CGPoint(x: x * bounds.width / 9.0 + bounds.width / 27.0 , y: y * bounds.height / 16.0), withAttributes: attrs)
                }
            }
        }
        */
    }
    
    
}

//
//  ViewController.swift
//  WordGame
//
//  Created by Ben Nagel on 2/27/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import UIKit

protocol SwipeDelegate {
    func determineSwipePosition(sender: UIView, location: CGPoint)
    func swipeEnded(sender: UIView)
}

protocol ValidWordDelegate {
    func validWord(_ isTrue: Bool)
}

class GameViewController: UICollectionViewController,
UICollectionViewDelegateFlowLayout, SwipeDelegate {
    
    var validDelegate: ValidWordDelegate?
    private var lineStart: CGPoint = CGPoint(x: 0, y: 0)
    private var word: [String]  = []
    private var wordCells: [LetterCell] = []
    private var lastWordAdded: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        let highlightView = HighlightCollectionView(frame: view.frame, collectionViewLayout: layout)
        validDelegate = highlightView
        highlightView.swipeDelegate = self
        collectionView = highlightView
        collectionView?.allowsMultipleSelection = true
        collectionView?.register(LetterCell.self, forCellWithReuseIdentifier: "letterCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newGame))
    }
    
    func determineSwipePosition(sender: UIView, location: CGPoint) {
        /* Each block is about 35px away on Iphone 8, which is roughly
         its height(568) / 16.0 and its width(320) / 9 */
        let row: Int = Int(location.y) / Int(view.frame.height / 16)
        let col: Int = Int(location.x) / Int(view.frame.width / 9)
        if (row < 12 && col < 9) {
            let index = row * 9 + col
            let indexP = IndexPath(row: index, section: 0)
            let letterCell = collectionView?.cellForItem(at: indexP) as! LetterCell
            // Removes Duplicates
            if(letterCell.charPreviouslyAdded == false && self.lastWordAdded != letterCell.letterLabel.text!) {
                letterCell.letterLabel.textColor = UIColor.orange
                self.word.append(letterCell.letterLabel.text!)
                wordCells.append(letterCell)
                letterCell.charPreviouslyAdded = true
                self.lastWordAdded = letterCell.letterLabel.text!
            }
        
            else if (self.lastWordAdded != letterCell.letterLabel.text!) {
                letterCell.charPreviouslyAdded = false
                letterCell.letterLabel.textColor = UIColor.black
                self.word.popLast()
                self.wordCells.popLast()
                if (self.word.count > 0) {
                    self.lastWordAdded = self.word[self.word.count - 1]
                }
                else {
                    self.word = []
                }
                print(self.word)
            }
        }
        let str: String = self.word.joined()
        // Have to Check word validity here
        if(GameModel.checkValidWord(str)) {
            self.validDelegate?.validWord(true)
        }
        else {
            self.validDelegate?.validWord(false)
        }
    }
    
    func swipeEnded(sender: UIView) {
        // Check Word accuracy, delete and then reset
        let str: String = self.word.joined()
        if (GameModel.checkValidWord(str)) {
            self.validDelegate?.validWord(true)
            for i in wordCells {
                GameModel.removeLetter(row: i.row!, column: i.column!)
                //i.letterLabel.text = "_"
            }
        }
        else {
            self.validDelegate?.validWord(false)
        }
        
        print(self.word)
        self.word = []
        self.wordCells = []
        for i in 0...107 {
            let indexP = IndexPath(row: i, section: 0)
            let letterCell = collectionView?.cellForItem(at: indexP) as! LetterCell
            letterCell.letterLabel.textColor = UIColor.black
            letterCell.charPreviouslyAdded = false
            self.lastWordAdded = ""
        }
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return GameModel.getLetterCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 13.5 , height: view.frame.height / 22.0)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let letterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "letterCell", for: indexPath) as! LetterCell
        letterCell.column = indexPath.row % 9
        letterCell.row = (indexPath.row - letterCell.column!) / 9
        letterCell.letterLabel.text = GameModel.get(at: indexPath.row).rawValue
        return letterCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func newGame() {
        GameModel.buildBoard()
        //GameModel.checkWordsSelected()
        collectionView?.reloadData()
    }

}

class HighlightCollectionView: UICollectionView, ValidWordDelegate{
    
    var swipeDelegate: SwipeDelegate?
    private var lineStart: CGPoint?
    private var lines: [CGPoint] = []
    
    var lineColor: CGColor = UIColor.yellow.cgColor
    private var score = "0"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func validWord(_ isTrue: Bool) {
        if(isTrue) {
            lineColor = UIColor.lightGray.cgColor
        }
        else {
            lineColor = UIColor.yellow.cgColor
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
        lines.append(touchPoint)
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
        
        for i in 0...10 {
            let num: CGFloat = CGFloat(i);
            context.move(to: CGPoint(x: num * bounds.width / 9.0, y: 0.0))
            context.addLine(to: CGPoint(x: num * bounds.width / 9.0, y: 12 * bounds.height / 16.0))
            context.strokePath()
        }
        
        for i in 0...12 {
            let num: CGFloat = CGFloat(i);
            context.move(to: CGPoint(x: 0.0, y: num * bounds.height / 16.0))
            context.addLine(to: CGPoint(x: bounds.width, y: num * bounds.height / 16.0))
            context.strokePath()
        }
        
        let lowerBounds = 14 * bounds.height / 16.0
        let scoreString: NSString = NSString(string: "Score:")
        scoreString.draw(at: CGPoint(x: bounds.width / 10.0 , y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        score.draw(at: CGPoint(x: bounds.width / 3.0 , y: lowerBounds - bounds.height / 26.0), withAttributes: [:])
        context.strokePath()
        
        
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

class LetterCell: UICollectionViewCell {
    
    var row: Int?
    var column: Int?
    var charPreviouslyAdded: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let letterLabel: UILabel = {
        let letterLabel = UILabel()
        letterLabel.text = "A"
        letterLabel.font = letterLabel.font.withSize(18)
        letterLabel.textColor = UIColor.black
        letterLabel.adjustsFontSizeToFitWidth = true;
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        return letterLabel
    }()
    
    func setupViews() {
        addSubview(letterLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": letterLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": letterLabel]))
        
    }
 
}


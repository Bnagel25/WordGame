//
//  ViewController.swift
//  WordGame
//
//  Created by Ben Nagel on 2/27/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import UIKit

/**
  * Delegate for swipe actions
  */
protocol SwipeDelegate {
    func determineSwipePosition(sender: UIView, location: CGPoint)
    func swipeEnded(sender: UIView)
}

/**
  * Delegate for determining the validity of a submitted word
  */
protocol ValidWordDelegate {
    func validWord(_ isTrue: Bool)
}

/**
  * Controller that delgates between the HighlightCollectionView and the GameModel
  * comprised of Letter Cells
  */
class GameViewController: UICollectionViewController,
UICollectionViewDelegateFlowLayout, SwipeDelegate {
    
    var validDelegate: ValidWordDelegate?
    
    private var word: [String]  = []
    private var wordCells: [LetterCell] = []
    private var lastWordAdded: String = ""
    private var highlightedIndexs: [Int] = []
    private var firstLayout: Bool = false
    
    override func viewDidLoad() {
        /* On load register every cell and generate the highlighted numbers */
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        let highlightView = HighlightCollectionView(frame: view.frame, collectionViewLayout: layout)
        self.generateHighlitedIndexes()
        validDelegate = highlightView
        highlightView.swipeDelegate = self
        collectionView = highlightView
        collectionView?.allowsMultipleSelection = true
        collectionView?.register(LetterCell.self, forCellWithReuseIdentifier: "letterCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newGame))
    }
    
    func determineSwipePosition(sender: UIView, location: CGPoint) {
        /* Determines what letter is being played based on 'location' */
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
            // BackSwipe Logic
            else if (self.lastWordAdded != letterCell.letterLabel.text!) {
                letterCell.charPreviouslyAdded = false
                letterCell.letterLabel.textColor = UIColor.black
                let _ = self.word.popLast()
                let _ = self.wordCells.popLast()
                
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
        if(GameModel.checkValidWord(str)) {
            self.validDelegate?.validWord(true)
        }
        else {
            self.validDelegate?.validWord(false)
        }
    }
    
    func swipeEnded(sender: UIView) {
        /* When swipe has ended, submit the word to the GameModel and reset */
        // Check Word accuracy, delete and then reset
        let str: String = self.word.joined()
        if (GameModel.checkValidWord(str)) {
            self.validDelegate?.validWord(true)
            // Sort by row (needed for removal)
            self.wordCells.sort(by: {$0.row! < $1.row!})
            for i in wordCells {
                print("row: \(i.row!) col: \(i.column!)")
                GameModel.removeLetter(row: i.row!, column: i.column!,
                                       isHighlighted: i.highlightedLetter)
            }
        }
            
        else {
            self.validDelegate?.validWord(false)
        }
        
        print(self.word)
        self.word = []
        self.wordCells = []
        // Reset all cells back to default values
        for i in 0...107 {
            let indexP = IndexPath(row: i, section: 0)
            let letterCell = collectionView?.cellForItem(at: indexP) as! LetterCell
            letterCell.letterLabel.textColor = UIColor.black
            letterCell.charPreviouslyAdded = false
            self.lastWordAdded = ""
        }
        collectionView?.reloadData()
    }
    
    private func generateHighlitedIndexes(){
        /* Generate Random Indexes that are the highlighted letters*/
        var previousNumber: UInt32 = 0
        var randomNumber: UInt32 = 0
        for _ in 0...3 {
            randomNumber = arc4random_uniform(UInt32(GameModel.getLetterCount()))
            if (randomNumber != previousNumber) {
                self.highlightedIndexs.append(Int(randomNumber))
            }
            previousNumber = randomNumber
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        /* Amount of cells = 108 */
        return GameModel.getLetterCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        /* Each cell should be this size */
        return CGSize(width: view.frame.width / 13.5 , height: view.frame.height / 22.0)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /* Each cell is a new LetterCell with its label corresponding to GameModel  */
        let letterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "letterCell", for: indexPath) as! LetterCell
        
        //TODO: Probably have to move this to the controller. 
        if (highlightedIndexs.contains(indexPath.row)) {
            letterCell.highlightedLetter = true
            letterCell.letterLabel.textColor = UIColor.yellow
        }
        
        letterCell.column = indexPath.row % 9
        letterCell.row = (indexPath.row - letterCell.column!) / 9
        letterCell.letterLabel.text = GameModel.get(at: indexPath.row).rawValue
        letterCell.scoreLabel.text = "\(GameModel.getLetterScore(letterCell.letterLabel.text!))"
        return letterCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func newGame() {
        /* On a new game, remove highlighted indexes, reset all game defaults
         and rebuild board */
        for i in highlightedIndexs {
            let indexP = IndexPath(row: i, section: 0)
            let letterCell = collectionView?.cellForItem(at: indexP) as! LetterCell
            letterCell.letterLabel.textColor = UIColor.black
            letterCell.highlightedLetter = false
        }
        firstLayout = false
        self.highlightedIndexs.removeAll()
        self.generateHighlitedIndexes()
        GameModel.buildBoard()
        collectionView?.reloadData()
    }

}




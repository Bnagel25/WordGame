//
//  ViewController.swift
//  WordGame
//
//  Created by Ben Nagel on 2/27/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import UIKit

class GameViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var gameView: GameView = GameView()
    private var lineStart: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view = gameView
        collectionView?.backgroundView = gameView
        collectionView?.allowsMultipleSelection = true
        collectionView?.register(LetterCell.self, forCellWithReuseIdentifier: "letterCell")
        /*
        gameView.setScore(200)
        gameView.appendToLettersDict(char: Letters.A.rawValue, x: 5, y: 5)
        gameView.appendToLettersDict(char: Letters.B.rawValue, x: 1, y: 1)
        gameView.appendToLettersDict(char: Letters.E.rawValue, x: 2, y: 1)
        gameView.appendToLettersDict(char: Letters.N.rawValue, x: 3, y: 1)
        gameView.appendToLettersDict(char: Letters.R.rawValue, x: 4, y: 1)
        gameView.appendToLettersDict(char: Letters.U.rawValue, x: 5, y: 1)
        gameView.appendToLettersDict(char: Letters.L.rawValue, x: 6, y: 1)
        gameView.appendToLettersDict(char: Letters.E.rawValue, x: 7, y: 1)
        gameView.appendToLettersDict(char: Letters.S.rawValue, x: 8, y: 1)
         */
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newGame))
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row) // What item it is
        let index = indexPath.row
        let column = index % 9
        let row = (index - column) / 9
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.isSelected == true{
            
            if(gameView.startIsSet()) {
                gameView.appendtoLines(row: row, col: column)
            }
            else {
                gameView.setLineStart(row: row, col: column)
            }
            gameView.setNeedsDisplay()
        }
        else {
            cell?.backgroundColor = UIColor.clear
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let letterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "letterCell", for: indexPath) as! LetterCell
        
        letterCell.letterLabel.text = GameModel.get(at: indexPath.row).rawValue
        return letterCell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func newGame() {
        //GameModel.buildBoard()
        GameModel.checkWordsSelected()
        //collectionView?.reloadData()
    }

}

class LetterCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let letterLabel: UILabel = {
        let letterLabel = UILabel()
        letterLabel.text = "A"
        letterLabel.font = letterLabel.font.withSize(18)
        letterLabel.highlightedTextColor = UIColor.blue
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
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        let _: CGPoint = touch.location(in: self)
        letterLabel.textColor = UIColor.blue
        //GameModel.insertSelected(letter: letterLabel.text!)
        return
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //GameModel.insertSelected(letter: letterLabel.text!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //GameModel.checkWordsSelected()
        return
    }
 */
 
}


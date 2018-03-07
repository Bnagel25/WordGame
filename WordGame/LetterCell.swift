//
//  LetterCell.swift
//  WordGame
//
//  Created by Ben Nagel on 3/5/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import UIKit

/**
  * Reperesents a Cell in a collection view that has one unique element
  * in its letter label
  */
class LetterCell: UICollectionViewCell {
    
    var row: Int?
    var column: Int?
    var charPreviouslyAdded: Bool = false
    var highlightedLetter: Bool = false
    
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
        letterLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        letterLabel.textColor = UIColor.black
        letterLabel.adjustsFontSizeToFitWidth = true;
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        return letterLabel
    }()
    
    let scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.text = "0"
        scoreLabel.font = UIFont(name: "HelveticaNeue", size: 8)
        scoreLabel.textColor = UIColor.black
        scoreLabel.adjustsFontSizeToFitWidth = true;
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        return scoreLabel
    }()
    
    func setupViews() {
        addSubview(letterLabel)
        addSubview(scoreLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[v0]-1-[v1]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": letterLabel, "v1": scoreLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[v1]-1-[v0]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": letterLabel, "v1": scoreLabel]))
        
    }
    
}

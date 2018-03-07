//
//  Game.swift
//  WordGame
//
//  Created by Ben Nagel on 2/27/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import Foundation
/* Represents All Letters String representations */
enum Letters: String {
    case Blank = "-"
    case Clear = ""
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case I = "I"
    case J = "J"
    case K = "K"
    case L = "L"
    case M = "M"
    case N = "N"
    case O = "O"
    case P = "P"
    case Q = "Q"
    case R = "R"
    case S = "S"
    case T = "T"
    case U = "U"
    case V = "V"
    case W = "W"
    case X = "X"
    case Y = "Y"
    case Z = "Z"
}


class GameModel {
    // Letters available to be placed
    public static let letterBank: [Letters] = [.Blank, .A, .B, .C, .D, .E, .F, .G,
                                               .H, .I, .J, .K, .L, .M, .N, .O,
                                               .P, .Q, .R, .S, .T, .U, .V,
                                               .W, .X, .Y, .Z]
    // Each letters score value (scrabble rules)
    private static let wordScore: [String: Int] = ["": 0, "_": 0, "A": 1, "B": 3, "C": 3,
                                                   "D": 2, "E": 1, "F": 4, "G": 2,
                                                   "H": 4, "I": 1, "J": 8, "K": 5,
                                                   "L": 1, "M": 3, "N": 1, "O": 1,
                                                   "P": 3, "Q": 10, "R": 1, "S": 1,
                                                   "T": 1, "U": 1, "V": 4, "W": 4,
                                                   "X": 8, "Y": 4, "Z": 10]
    
    private static var board: [Letters] = []
    static var wordsOnBoard: [String] = []
    private static var wordsInDict: [String] = []
    private static let letterCount = 98
    static var score: Int = 0
    static var longestWord: String = ""
    
    private static var selectedLetters: [String] = []
    
    static func insert(char: Letters, x: Int, y: Int) {
        board.insert(char, at: (y  * 12) + x)
    }
    
    static func get(at indexPath: Int) -> Letters {
        return board[indexPath]
    }
    
    static func getLetterCount() -> Int {
        return board.count
    }
    
    static func buildBoard() {
        longestWord = ""
        wordsOnBoard = []
        getWordsFromDictFile()
        score = 0
        board = []
        /*
        for _ in 0...107 {
            board.append(Letters.Clear)
        }
        
        var blankCounter = 0
        while(blankCounter < 10) {
            let index = randomIndex()
            if board[index] == Letters.Clear {
                board[index] = Letters.Blank
                blankCounter += 1
            }
        }
        var index = 0 // Actual Index
        var previousIndex = 0 // Index of last placed letter
        var attempts = 0
        while(index < 98) {
            while(board[index] != Letters.Clear && index < 98) {
                index += 1
            }
            for word in wordsOnBoard {
                let strWord = String(word).uppercased()
                var wordIndex = 0
                previousIndex = index
                for letter in strWord {
                    print("Index: \(index) Letter: \(letter) Word: \(strWord)")
                    // Place the first letter of the word @ the actual index
                    if (wordIndex == 0) {
                        board[index] = Letters(rawValue: "\(letter)")!
                        index += 1
                        wordIndex += 1
                        continue
                    }
                    
                    var letterHasBeenPlaced = false
                    let indexColumn = previousIndex % 9
                    let indexRow = (previousIndex - indexColumn) / 9
                    
                    while(letterHasBeenPlaced == false) {
                        let direction = self.randomDirection()
                        switch direction {
                            /*
                             case 0:
                            if(indexRow > 0 && indexColumn > 1 && board[previousIndex - 10] == Letters.Clear) {
                                board[previousIndex - 10] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += -10
                            }*/
                            /*
                        case 1:
                            if(indexRow > 0 && board[previousIndex - 9] == Letters.Clear) {
                                board[previousIndex - 9] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += -9
                            }
                             */
                            /*
                             case 2:
                            if(indexRow > 0 && indexColumn < 9 && board[previousIndex - 8] == Letters.Clear) {
                                board[previousIndex - 8] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += -8
                            }
                             */
                            /*
                        case 3:
                            if(indexColumn > 0 && board[previousIndex - 1] == Letters.Clear) {
                                board[previousIndex - 1] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += -1
                            }
                            */
                        case 4:
                            if(indexColumn < 8 && board[previousIndex + 1] == Letters.Clear) {
                                board[previousIndex + 1] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += 1
                                index += 1
                            }
                            /*
                             case 5:
                            if(indexRow < 11 && indexColumn > 0 && board[previousIndex + 8] == Letters.Clear) {
                                board[previousIndex + 8] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += 8
                            }
                            */
                        case 6:
                            if(indexRow < 11 && board[previousIndex + 9] == Letters.Clear) {
                                board[previousIndex + 9] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += 9
                            }
                            /*
                             case 7:
                            if(indexRow < 11 && indexColumn < 8 && board[previousIndex + 10] == Letters.Clear) {
                                board[previousIndex + 10] = Letters(rawValue: "\(letter)")!
                                letterHasBeenPlaced = true
                                previousIndex += 10
                            }
                             */
                        default:
                            if(1 != 1) {
                                print("")
                            }
                        }
                    }
                    wordIndex += 1
                }
                index += 1
            }
        }
         */
        
        for word in wordsOnBoard {
            let strWord = String(word)
            for i in strWord.uppercased() {
                board.append(Letters(rawValue: "\(i)")!)
            }
        }
         
        /*
        for i in 0...107 {
            board.append()
        }
        */
    }
    
    static func removeLetter(row: Int, column: Int, isHighlighted: Bool) {
        var currentRow: Int = row
        var currrentColumn: Int = 9
        var currentIndex = row * 9 + column
        let scoreLetter = self.board[currentIndex]
        if let letterScore = self.wordScore[scoreLetter.rawValue] {
            self.score += letterScore
        }
        self.board[currentIndex] = Letters.Clear
        self.clearBanks(row: currentRow, col: column)
        
        if(isHighlighted) {
            while(currrentColumn > 0) {
                while(currentRow > 0) {
                    currentIndex = currentRow * 9 + currrentColumn
                    self.board[currentIndex] = self.board[currentIndex - 9]
                    currentRow -= 1
                }
                currentRow = row
                self.board[currrentColumn] = Letters.Clear
                currrentColumn -= 1
            }
            self.score += 10
        }
            
        else {
            while(currentRow > 0) {
                currentIndex = currentRow * 9 + column
                self.board[currentIndex] = self.board[currentIndex - 9]
                currentRow -= 1
                
            }
            self.board[column] = Letters.Clear
        }
    }
    
    private static func clearBanks(row: Int, col: Int) {
        let currentIndex = row * 9 + col
        
        if (col == 8) {
            if(self.board[currentIndex - 1] == Letters.Blank) {
                self.board[currentIndex - 1] = Letters.Clear
            }
        }
    
        else if (col == 0) {
            if (self.board[currentIndex + 1] == Letters.Blank) {
                self.board[currentIndex - 1] = Letters.Clear
            }
        }
            
        else {
            if(self.board[currentIndex - 1] == Letters.Blank) {
                self.board[currentIndex - 1] = Letters.Clear
            }
            
            else if (self.board[currentIndex + 1] == Letters.Blank) {
                self.board[currentIndex - 1] = Letters.Clear
            }
        }
        
        if (row == 11) {
            if(self.board[currentIndex - 9] == Letters.Blank) {
                self.board[currentIndex - 9] = Letters.Clear
            }
        }
        else if (row == 0) {
            if (self.board[currentIndex + 9] == Letters.Blank) {
                self.board[currentIndex + 9] = Letters.Clear
            }
        }
        else {
            if (self.board[currentIndex - 9] == Letters.Blank) {
                self.board[currentIndex - 9] = Letters.Clear
            }
            
            else if (self.board[currentIndex + 9] == Letters.Blank) {
                self.board[currentIndex + 9] = Letters.Clear
            }
        }
    }
    
    static func getWordsFromDictFile() {
        //TODO: ADD RELATIVE PATH
        let path = "/Users/bennagel/Documents/S18/cs4530/WordGame/WordGame/dict.txt"
        
        do {
            let contents = try? String(contentsOfFile: path, encoding: .ascii)
            if contents != nil {
                wordsInDict = (contents?.components(separatedBy: "\n"))!
            }
        }

        var currentLetterCount: Int = 0
        while(currentLetterCount < self.letterCount) {
            
            let randomIndex = Int(arc4random_uniform(UInt32(wordsInDict.count)))
            
            //print("Trying: \(wordsInDict[randomIndex].count)")
            print("CLC: \(currentLetterCount) + \(wordsInDict[randomIndex].count) =\(self.letterCount)")
            if(currentLetterCount + wordsInDict[randomIndex].count <= self.letterCount && currentLetterCount + wordsInDict[randomIndex].count != self.letterCount - 1) {
                
                //print("Count: \(currentLetterCount)")
                wordsOnBoard.append(wordsInDict[randomIndex])
                currentLetterCount += wordsInDict[randomIndex].count
            }
        }
    }
    
    static func checkValidWord(_ word: String) -> Bool {
        let lowerCaseWord = word.lowercased()
        if(wordsInDict.contains("_") || wordsInDict.contains("''")) {
            return false
        }
        for i in wordsInDict {
            if (i == lowerCaseWord) {
                
                if(lowerCaseWord.count > self.longestWord.count) {
                    self.longestWord = lowerCaseWord.uppercased()
                }
                
                return true
            }
        }
        return false
    }
    
    static func randomLetter() -> Letters {
        // pick and return a new value
        let rand = arc4random_uniform(UInt32(letterBank.count))
        return letterBank[Int(rand)]
    }
    
    static func randomIndex() -> Int {
        let rand = arc4random_uniform(UInt32(108))
        return Int(rand)
    }
    
    static func randomDirection() -> Int {
        let rand = arc4random_uniform(UInt32(8))
        return Int(rand)
    }
    
    static func getLetterScore(_ letter: String) -> Int {
        return self.wordScore[letter]!
    }
    
    static func insertSelected(letter: String) {
        selectedLetters.append(letter)
    }
    
    static func checkWordsSelected() {
        print(selectedLetters)
        selectedLetters = []
    }
    
}

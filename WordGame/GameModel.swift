//
//  Game.swift
//  WordGame
//
//  Created by Ben Nagel on 2/27/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import Foundation

enum Letters: String {
    case Blank = "''"
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
    // TODO: MAKE A SCORING BANK
    public static let letterBank: [Letters] = [.Blank, .A, .B, .C, .D, .E, .F, .G,
                                               .H, .I, .J, .K, .L, .M, .N, .O,
                                               .P, .Q, .R, .S, .T, .U, .V,
                                               .W, .X, .Y, .Z]
    
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
    private static let letterCount = 94
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
        getWordsFromDictFile()
        score = 0
        board = []
        for _ in 0...107 {
            board.append(randomLetter())
        }
    }
    
    static func removeLetter(row: Int, column: Int, isHighlighted: Bool) {
        var currentRow: Int = row
        var currrentColumn: Int = 9
        var currentIndex = row * 9 + column
        let scoreLetter = self.board[currentIndex]
        self.score += self.wordScore[scoreLetter.rawValue]!
        self.board[currentIndex] = Letters.Clear
        self.clearBanks(row: currentRow, col: column)
        
        if(isHighlighted) {
            while(currrentColumn >= 0) {
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
        
        if (col == 9) {
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
            
            if (self.board[currentIndex + 1] == Letters.Blank) {
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
            
            if (self.board[currentIndex + 9] == Letters.Blank) {
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
        /*
        var currentLetterCount: Int = 0
        while(currentLetterCount < letterCount) {
            let randomIndex = Int(arc4random_uniform(UInt32(wordsInDict.count)))
            if(currentLetterCount + wordsInDict[randomIndex].count <= letterCount &&
                wordsInDict[randomIndex].count > 0) {
                wordsOnBoard.append(wordsInDict[randomIndex])
                currentLetterCount += wordsInDict[randomIndex].count
            }
        }
         */
    }
    
    static func checkValidWord(_ word: String) -> Bool {
        let lowerCaseWord = word.lowercased()
        if(wordsInDict.contains("_") || wordsInDict.contains("''")) {
            return false
        }
        for i in wordsInDict {
            if (i == lowerCaseWord) {
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
    
    static func insertSelected(letter: String) {
        selectedLetters.append(letter)
    }
    
    static func checkWordsSelected() {
        print(selectedLetters)
        selectedLetters = []
    }
    
}

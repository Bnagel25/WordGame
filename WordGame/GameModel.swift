//
//  Game.swift
//  WordGame
//
//  Created by Ben Nagel on 2/27/18.
//  Copyright © 2018 Ben Nagel. All rights reserved.
//

import Foundation

enum Letters: String {
    case Blank = ""
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
    
    private static var board: [Letters] = []
    static var wordsOnBoard: [String] = []
    private static var wordsInDict: [String] = []
    private static let letterCount = 94
    
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
        board = []
        for _ in 0...107 {
            board.append(randomLetter())
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
        return wordsInDict.contains(lowerCaseWord)
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

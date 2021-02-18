//
//  Game.swift
//  Apple Pie
//
//  Created by Vasily Churbanov on 2021-02-18.
//

struct Game {
    
    var word: String
    var incorrectMovesRemaining: Int
    fileprivate var guessedLetters = [Character]()
    
    init(word: String, incorrectMovesRemaining: Int) {
        self.word = word
        self.incorrectMovesRemaining = incorrectMovesRemaining
    }
    
    var guessedWord: String {
    
        var wordToShow = String()
        for letter in word {
            if guessedLetters.contains(Character(letter.lowercased())) {
                wordToShow += String(letter)
            } else {
                wordToShow += "-"
            }
        }
        return wordToShow
    }
        
        
       
    
    mutating func playerGuessed(letter: Character) {
        let lowercasedLetter = Character(letter.lowercased())
        guessedLetters.append(lowercasedLetter)
        if !word.lowercased().contains(lowercasedLetter) {
            incorrectMovesRemaining -= 1
        }
    }
}
